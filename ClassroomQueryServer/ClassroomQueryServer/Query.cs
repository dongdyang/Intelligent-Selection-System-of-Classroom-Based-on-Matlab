using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using Classroom;
using boproject;

namespace Elecky.QueryServer
{
    /// <summary>
    /// enumerate type CrowdRate, providing five classes of crowd state
    /// , supports bitwise OR
    /// </summary>
    [Flags]
    enum CrowdRate { empty = 0x1, slight = 0x2, medium = 0x4, heavy = 0x8, full = 0x10, unknown = 0x20 };

    /// <summary>
    /// representing the start and end time of courses of an college
    /// </summary>
    class College
    {
        public string CollegeName;
        public readonly TimeSpan[,] course;

        public College(string name, int[,] time)
        {
            CollegeName = name;
            course = new TimeSpan[time.GetLength(0) / 2, 2];
            for (int i = 0; i < time.GetLength(0); ++i)
            {
                course[i / 2, i % 2] = new TimeSpan(time[i, 0], time[i, 1], 0);
            }
        }
    }

    /// <summary>
    /// presenting the information of one classroom
    /// </summary>
    class RoomInfo
    {
        private string name;
        private int currentPeople;
        private CrowdRate state;
        private int avaliableTime;

        //constructor
        public RoomInfo(string name, int current, CrowdRate state, int avaliable)
        {
            this.name = name;
            this.currentPeople = current;
            this.avaliableTime = avaliable;
            this.state = state;
        }

        override public string ToString()
        {
            return string.Format("name {0}, current people {1}, state {2}, available time {3}",
                                    name, currentPeople, state.ToString(), avaliableTime);
        }

        public void WriteToXml(XmlWriter writer)
        {
            writer.WriteStartElement("classroom");
            writer.WriteAttributeString("RoomName", name);
            writer.WriteElementString("CrowdRate", state.ToString());
            writer.WriteElementString("AvaliableTime", avaliableTime.ToString());
            writer.WriteElementString("CurrentPeople", currentPeople.ToString());
            writer.WriteEndElement();
        }
    }

    class QueryInfo
    {
        /// <summary>
        /// roomNeed, present the time of room needed by user in binary bit
        /// representing corresponding class
        /// one class is not in need if corresponding bit is 1
        /// </summary>
        private int timeNeed;

        public int TimeNeed
        {
            get { return timeNeed; }
            //set { timeNeed = value; }
        }
        private bool timeSpecified;

        public bool TimeSpecified
        {
            get { return timeSpecified; }
            //set { timeSpecified = value; }
        }

        /// <summary>
        /// array building specifies the building in which the room should be in
        /// when building is not null, this filter takes effect
        /// </summary>
        private string[] building;

        /// <summary>
        /// roomName specifies the class room's name
        /// when roomName not null, this filter takes effect
        /// </summary>
        private string roomName;

        public string RoomName
        {
            get { return roomName; }
            //set { roomName = value; }
        }

        /// <summary>
        /// state(CrowdRate), specifies the crowd rate acceptable
        /// when stateSpecified is true, this filter takes effect
        /// </summary>
        private CrowdRate state;

        internal CrowdRate State
        {
            get { return state; }
            //set { state = value; }
        }
        private bool stateSpecified;

        public bool StateSpecified
        {
            get { return stateSpecified; }
            //set { stateSpecified = value; }
        }

        //constructors
        public QueryInfo(int timeNeed, string[] building, CrowdRate stateRequired)
        {
            Setup(timeNeed, building, stateRequired, null);
        }

        /// <summary>
        /// constructor of only one parameter, namely, room name
        /// used to query the information of one specified classroom
        /// </summary>
        /// <param name="roomName"></param>
        public QueryInfo(string roomName)
        {
            timeSpecified = false;
            stateSpecified = false;

            this.roomName = roomName;
        }

        //testing or Demo data, the class of BUAA
        private College BUAA = new College("BUAA", new int[10, 2] { { 8, 10 }, { 10, 0 }, { 10, 10 }, { 12, 0 }, { 13, 30 }, 
                                                                      { 15, 20 }, { 15, 30 }, { 17, 20 }, { 18, 20 }, { 20, 10 } });

        public QueryInfo(TimeSpan start, TimeSpan end, string[] building, CrowdRate state)
        {
            int startNo = 0, endNo = BUAA.course.GetLength(0)-1;
            //calculate the start and end number of course among the required time span
            while ((start >= BUAA.course[startNo, 1] || end <= BUAA.course[startNo, 0]) && startNo <= BUAA.course.GetLength(0))
            {
                ++startNo;
            }
            while ((start >= BUAA.course[endNo, 1] || end <= BUAA.course[endNo, 0]) && endNo >=0)
            {
                --endNo;
            }
            int timeNeed = 0;
            for (int k = startNo; k <= endNo && k < BUAA.course.GetLength(0); ++k)
            {
                timeNeed = timeNeed | (1 << k);
            }
            Setup(timeNeed, building, state, null);
        }

        private void Setup(int timeNeed, string[] building, CrowdRate stateRequired, string name)
        {
            this.timeNeed = timeNeed;
            timeSpecified = true;

            this.building = building;

            this.roomName = null;

            state = stateRequired;
            stateSpecified = true;
        }

        public override string ToString()
        {
            return string.Format("time string:{0:x}, state string:{1:x}, name{2}", timeNeed, state, roomName);
        }
    }

    static class Query
    {
        static public RoomInfo[] Filter(QueryInfo info)
        {
            if (info == null)
            {
                throw new ArgumentNullException("QueryInfo sent is null, perhaps the type indicator is wrong");
            }
            try
            {
                InfoRefresher.sync.TryEnterReadLock(2000);
                using (DataClasses1DataContext db = new DataClasses1DataContext() { CommandTimeout = 5000 })
                {
                    var results = (from c in db.Tables
                                   where info.RoomName == null || c.classroom == info.RoomName
                                   where !info.TimeSpecified || (c.is_free & info.TimeNeed) == info.TimeNeed
                                   //where info.BuildingSatify(c)
                                   where !info.StateSpecified || (c.state & (int)info.State) != 0
                                   select new RoomInfo(c.classroom, c.now, (CrowdRate)c.state, c.is_free)).ToArray();
                    return results;
                }
            }
            finally
            {
                InfoRefresher.sync.ExitReadLock();
            }
        }
    }
}
