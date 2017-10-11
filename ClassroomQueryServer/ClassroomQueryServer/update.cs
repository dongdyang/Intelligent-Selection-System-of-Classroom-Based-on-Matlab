using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Classroom;
using Elecky.QueryServer;

namespace project
{
    class Update
    {
        public static void UpdateTimer()
        {
            while (true)
            {
                UpdateIsFree();
                Console.WriteLine("update once");
                System.Threading.Thread.Sleep(10000);
            }
        }
        //每天更新数据库
        public static int UpdateIsFree()
        {
            DateTime time_now=DateTime.Now;
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
                            one.is_free = 0x3f;
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
                    Console.WriteLine("{0}",ex.Message);
                }
            }

            return 0;
        }

        //实时更新教室人数
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
                if (Tools.GetBit(one.is_free, time_now) == 0)
                {
                    Console.WriteLine("classrooom {0} is in class!", classroom_to_update);
                    return 1;
                }
                db.Tables.DeleteOnSubmit(one);
                one.now = num;
                CrowdRate state;
                double proportion = (double)num/one.max;
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
                one.state = (int)state;
                one.update_time = update_time;
                db.Tables.InsertOnSubmit(one);
                db.SubmitChanges();
            }
            return 0;
        }

        //教室临时变动

    }

}

