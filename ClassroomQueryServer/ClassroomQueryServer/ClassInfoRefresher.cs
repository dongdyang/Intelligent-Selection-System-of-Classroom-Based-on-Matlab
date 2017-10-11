using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Threading;
using System.Xml;
using Classroom;
using boproject;
using System.Transactions;

namespace Elecky.QueryServer
{
    static class InfoRefresher
    {
        /// <summary>
        /// classroom Refresher
        /// </summary>
        /// <param name="GetRoomPersonN"></param>
        /// <returns> return the number of people in a given classroom name </returns>
        static public int GetRoomPersonN(string classroom)
        {
            if (File.Exists(@"C:\Users\yangdongdong\Forever\projects\ClassroomQuery\" + classroom + ".txt"))
            {
                int nPeople = 0;
                FileStream infoFile = null;
                StreamReader reader = null;
                try
                {
                    infoFile = new FileStream(@"C:\Users\yangdongdong\Forever\projects\ClassroomQuery\" + classroom + ".txt", FileMode.Open, FileAccess.Read, FileShare.Read);
                    reader = new StreamReader(infoFile);
                    string info;
                    info = reader.ReadLine();
                    nPeople = int.Parse(info);
                    reader.Close();
                    infoFile.Close();
                    return nPeople;
                }
                finally
                {
                    if (reader != null)
                        reader.Close();
                    if (infoFile != null)
                        infoFile.Close();
                }
            }
            return -1;
        }

        /// <summary>
        /// calculate the current CrowRate of one classroom
        /// </summary>
        /// <param name="now"> current people in this classroom </param>
        /// <param name="capacity"> capacity of current classroom </param>
        /// <returns> corresponding CrowRate </returns>
        public static CrowdRate GetRate(int now, int capacity)
        {
            CrowdRate state;
            if (now == -1)
            {
                state = CrowdRate.unknown;
            }
            else
            {
                double proportion = (double)now / capacity;
                if (proportion < 0.1)
                {
                    state = CrowdRate.empty;
                }
                else if (proportion < 0.4)
                {
                    state = CrowdRate.slight;
                }
                else if (proportion < 0.6)
                {
                    state = CrowdRate.medium;
                }
                else if (proportion < 0.9)
                {
                    state = CrowdRate.heavy;
                }
                else
                {
                    state = CrowdRate.full;
                }
            }
            return state;
        }

        /// <summary>
        /// refresh the information everyday
        /// </summary>
        /// <returns></returns>
        public static void UpdateIsFree()
        {
            try
            {
                sync.TryEnterWriteLock(2000);
                LogAdded(null, "first refresh started\r\n");
                DateTime time_now = DateTime.Now;
                int week = Tools.DateToWeek(time_now);
                int weekday = 1;
                int parity = week % 2;
                using (var scope = new System.Transactions.TransactionScope())
                {
                    try
                    {
                        using (DataClasses1DataContext db = new DataClasses1DataContext())
                        {
                            // db.Log = Console.Out;
                            //全部教室、全部时段is_free置1
                            var query = from c in db.Tables
                                        select c;
                            foreach (var one in query)
                            {
                                db.Tables.DeleteOnSubmit(one);
                                one.now = 0;
                                one.is_free = 0x1f;
                                db.Tables.InsertOnSubmit(one);
                                db.SubmitChanges();
                            }

                            //查询本天课表
                            var new_query = from q in db.Totals
                                            where q.week_start <= week
                                            where q.week_end >= week
                                            where q.parity == parity || q.parity == -1
                                            where q.weekday == weekday
                                            select q;
                            //更新信息(效率低，待优化)
                            foreach (var new_one in new_query)
                            {
                                var old_query = from c in db.Tables
                                                where c.classroom == new_one.classroom
                                                select c;
                                var old_one = old_query.First();
                                db.Tables.DeleteOnSubmit(old_one);
                                old_one.is_free = Tools.ChangeBit(old_one.is_free, new_one.time);
                                db.Tables.InsertOnSubmit(old_one);
                                db.SubmitChanges();
                            }

                        }
                        scope.Complete();
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("{0}", ex.Message);
                    }
                }
                LogAdded(null, "first refresh done\r\n");
            }
            catch (TimeoutException ex)
            {
                LogAdded(null, "first refresh failed\r\n");
            }
            finally
            {
                sync.ExitWriteLock();
            }
        }

        /// <summary>
        /// refresher the information of classrooms each 5 minutes
        /// </summary>
        static public void Refresher()
        {
            try
            {
                sync.TryEnterWriteLock(5000);
                LogAdded(null, "regular refresh started\r\n");
                using (DataClasses1DataContext db = new DataClasses1DataContext())
                {
                    var query = from c in db.Tables
                                select c.classroom;
                    foreach (var q in query)
                    {
                        UpdateNumOfStu(q, GetRoomPersonN(q), DateTime.Now);
                    }
                }
                LogAdded(null, "regular refresh done\r\n");
            }
            catch (TimeoutException ex)
            {
                LogAdded(null, "regular refresh failed\r\n");
            }
            finally
            {
                sync.ExitWriteLock();
                RefreshFinished(null, null);
            }
        }

        public static int UpdateNumOfStu(string classroom_to_update, int num, DateTime update_time)
        {
            int time_now = Tools.TimeToClass(update_time);
            using (DataClasses1DataContext db = new DataClasses1DataContext())
            {
                // db.Log = Console.Out;
                var query = from c in db.Tables
                            where c.classroom == classroom_to_update
                            select c;
                var one = query.First();
           //     if (Tools.GetBit(one.is_free, time_now) == 0)
           //     {
           //         Console.WriteLine("classrooom {0} is in class!", classroom_to_update);
           //         return 1;
           //     }
                db.Tables.DeleteOnSubmit(one);
                one.now = num;
                CrowdRate state = GetRate(num, one.max);
                one.state = (int)state;
                one.update_time = update_time;
                db.Tables.InsertOnSubmit(one);
                db.SubmitChanges();
            }

            return 0;
        }

        public static ReaderWriterLockSlim sync = new ReaderWriterLockSlim();

        public static void SendConditionAsXML(XmlWriter writer, string roomName)
        {
            if (!File.Exists(@"C:\Users\yangdongdong\Forever\projects\ClassroomQuery\" + roomName + ".txt"))
                throw new FileNotFoundException(string.Format("file {0}.txt not found", roomName));
            FileStream conditionFile = null;
            StreamReader reader = null;
            try
            {
                conditionFile = new FileStream(@"C:\Users\yangdongdong\Forever\projects\ClassroomQuery\" + roomName + ".txt", FileMode.Open, FileAccess.Read, FileShare.Read);
                reader = new StreamReader(conditionFile);
                reader.ReadLine();  //omit the first line

                writer.WriteStartDocument();
                writer.WriteStartElement("RoomCondition");

                writer.WriteStartElement("RoomCapacity");
                string[] capa = reader.ReadLine().Split(' ');
                writer.WriteAttributeString("TotalColumn", capa[0]);
                writer.WriteAttributeString("TotalRow", capa[1]);
                writer.WriteEndElement();

                string line;
                int row = 0;
                //scan each row, once a '1' is found, write to the XML one new element
                while ((line = reader.ReadLine()) != null)
                {
                    ++row;
                    for (int col = 0; col < line.Length; ++col)
                    {
                        if (line[col] == '1')
                        {
                            writer.WriteStartElement("Occupied");
                            writer.WriteAttributeString("Row", row.ToString());
                            writer.WriteAttributeString("Column", (col + 1).ToString());
                            writer.WriteEndElement();
                        }
                    }
                }
                writer.WriteStartElement("end");
                writer.WriteEndElement();
                writer.WriteEndElement();
            }
            finally
            {
                if (reader != null)
                    reader.Close();
                if (conditionFile != null)
                    conditionFile.Close();
            }
        }

        static public event EventHandler<string> LogAdded;
        static public event EventHandler<EventArgs> RefreshFinished;
    }
}
