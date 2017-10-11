using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace boproject
{
    class Tools
    {

        public static int GetBit(int input,int index)
        {
            var temp = input << (32-index);
            temp >>= 31;
            return temp;
        }

        public static int ChangeBit(int input,int index)
        {
            int i, j;
            for (i = 1,  j = 1; i < index; i++, j *= 2) ;
            return input ^ j;
        }

        public static int TimeComp(DateTime time,int hour,int min)
        {

            return (time.Hour < hour || (time.Hour == hour && time.Minute <= min)) ? 1 : 0;
            
        }

        public static int TimeToClass(DateTime time)
        {

            int[,] class_time=new int[,] {{10,0},{12,0},{15,20},{17,20},{20,10}};
            for (int i = 0; i < 5;i++ )
            {
                if (TimeComp(time, class_time[i, 0], class_time[i, 1]) == 1)
                    return i + 1;
            }
            return 6;
        }

        public static int DateToWeek(DateTime time)
        {
            /*DateTime date_start=new DateTime(time.Year,3,3);
            System.TimeSpan diff = time.Subtract(date_start);
            return (int)diff.TotalDays/7+1;*/
            return 1;
        }

    }
}
