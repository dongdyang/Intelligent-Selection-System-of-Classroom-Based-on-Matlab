using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net.Sockets;
using System.Threading.Tasks.Dataflow;
using System.Xml;
using System.Windows;

namespace Elecky.QueryServer
{
    static class Server
    {
        /// <summary>
        /// create connection, listen and wait for coming in connection,
        /// </summary>
        static public void ServerMain()
        {
            try
            {
                listener = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
                listener.Bind(new System.Net.IPEndPoint(System.Net.IPAddress.Any, 8880));
                listener.Listen(5);
                ListenStateChange(null, new ServerStateArgs(ServerState.started));
                //fire new log
                LogAdded(null, "listening port opened at 8880\r\n");
                while (true)
                {
                    Socket newConnection = listener.Accept();
                    Task.Run(() => holdUser(newConnection));
                }
            }
            finally
            {
                if (ListenStateChange != null)
                {
                    ListenStateChange(null, new ServerStateArgs(ServerState.stopped));
                }
            }
        }

        /// <summary>
        /// holderUser, control the whole flow of reacting to one user
        /// </summary>
        /// <param name="filterInfo"> one string contains the filter information sent by user </param>
        static private void holdUser(Socket connection)
        {
            if (LogAdded != null)
            {
                LogAdded(null, string.Format("one user connected, IP: {0}\r\n", connection.RemoteEndPoint.ToString()));
            }
            if (ClientChange != null)
            {
                ClientChange(null, 1);
            }
            QueryInfo parsedInfo;
            string filterInfo;
            bool conditionRequired;
            //set time out
            connection.ReceiveTimeout = 2000;
            connection.SendTimeout = 5000;
            //receive filter information from client
            byte[] receivedBytes = new Byte[1024];
            int bytesGet = connection.Receive(receivedBytes);
            filterInfo = Encoding.UTF8.GetString(receivedBytes, 0, bytesGet);
            //create a XML writer
            XmlWriterSettings settings = new XmlWriterSettings() { Encoding = Encoding.UTF8 };
            NetworkStream targetStream = new NetworkStream(connection);
            XmlWriter writer = XmlWriter.Create(targetStream, settings);
            try
            {
                parsedInfo = parseInfo(filterInfo, out conditionRequired);

                if (conditionRequired)
                {
                    InfoRefresher.SendConditionAsXML(writer, parsedInfo.RoomName);
                }
                else
                {
                    /*
                    *var filter = new System.Threading.Tasks.Dataflow.TransformBlock<QueryInfo, IEnumerable<RoomInfo>>(
                    *    (info) => Query.Filter(info));
                    *var transform = new System.Threading.Tasks.Dataflow.ActionBlock<IEnumerable<RoomInfo>>(
                    *    (rooms) => TransferResult(rooms, writer));
                    *filter.LinkTo(transform, new DataflowLinkOptions());
                    *
                    *filter.Post(parsedInfo);*/
                    RoomInfo[] results = Query.Filter(parsedInfo);
                    TransferResult(results, writer);
                    writer.Flush();
                }
            }
            catch (FormatException ex)
            {
                writer.WriteStartDocument();
                writer.WriteElementString("Error", ex.Message.ToString());
                writer.Flush();
                //To-do: requirement sent from user is in wrong syntax, handle this
            }
            catch (ArgumentNullException ex)
            {
                writer.WriteStartDocument();
                writer.WriteElementString("Error", ex.Message.ToString());
                writer.Flush();
            }
            catch (TimeoutException ex)
            {
                writer.WriteStartDocument();
                writer.WriteElementString("Error", "time out");
                writer.Flush();
            }
            catch (System.IO.FileNotFoundException ex)
            {
                writer.WriteStartDocument();
                writer.WriteElementString("Error", "the condition has not been parsed");
                writer.Flush();
            }
            catch (System.IO.IOException)
            {
                //the remote host closed connection
            }
            finally
            {
                if (LogAdded != null)
                {
                    LogAdded(null, string.Format("user {0} disconnected\r\n", connection.RemoteEndPoint.ToString()));
                }
                if (ClientChange != null)
                {
                    ClientChange(null, -1);
                }
                writer.Close();
                connection.Close();
            }
        }

        /// <summary>
        /// parseInfo, parse the information string from user
        /// </summary>
        /// <param name="filterInfo"> user's requirement,
        /// , format: different elements are divided by commas
        /// , three different types of string in total, distinguished by the first element, which is an integer
        /// . type one: the second element is the name of classroom, third one is a boolean indicates whether the current condition is required
        /// . type two: second element is bit string indicates the time needed, third one indicates the acceptable crowd rate
        /// . type three: type indicator immediately followed with four integers, represents time span in the order of SH SM EH EM
        /// , fifth element indicates the crowd rate acceptable.
        /// </param>
        /// <returns> QueryInfo get by parsing the user's requirement </returns>
        static private QueryInfo parseInfo(string filterInfo, out bool conditionRequired)
        {
            QueryInfo filter;
            try
            {
                string[] infos = filterInfo.Split(',');
                switch (infos[0])
                {
                    case "1":
                        filter = new QueryInfo(infos[1]);
                        conditionRequired = bool.Parse(infos[2]);
                        break;
                    case "2":
                        filter = new QueryInfo(int.Parse(infos[1]), null, (CrowdRate)int.Parse(infos[2]));
                        conditionRequired = false;
                        break;
                    case "3":
                        TimeSpan start, end;
                        start = new TimeSpan(int.Parse(infos[1]), int.Parse(infos[2]), 0);
                        end = new TimeSpan(int.Parse(infos[3]), int.Parse(infos[4]), 0);
                        filter = new QueryInfo(start, end, null, (CrowdRate)int.Parse(infos[5]));
                        conditionRequired = false;
                        break;
                    default:
                        filter = null;
                        conditionRequired = false;
                        break;
                }
                return filter;
            }
            catch (IndexOutOfRangeException exception)
            {
                //To-do: the string user sent is in wrong syntax, handle this by sending back error message
                throw new FormatException("lacking information or syntax error", exception);
            }
            catch (OverflowException tooBig)
            {
                throw new FormatException("some parameter is out of range", tooBig);
            }
            catch (FormatException formatEx)
            {
                throw new FormatException("query information syntax error", formatEx);
            }
        }

        static void TransferResult(IEnumerable<RoomInfo> roomSet, XmlWriter writer)
        {
            writer.WriteStartDocument();
            //start writing XML
            writer.WriteStartElement("QueryResults");
            foreach (var room in roomSet)
            {
                room.WriteToXml(writer);
            }
            writer.WriteStartElement("End");
            writer.WriteEndElement();
            writer.WriteEndElement();
        }

        /// <summary>
        /// listener, create a connection and listen to the coming in TCP connection on port 8880
        /// </summary>
        static private Socket listener;

        static public void Dispose()
        {
            if (listener != null)
            {
                listener.Close();
            }
        }

        static public event EventHandler<string> LogAdded;
        static public event EventHandler<int> ClientChange;
        static public event EventHandler<ServerStateArgs> ListenStateChange;

    }

    public enum ServerState { started, stopped };
    public class ServerStateArgs : EventArgs
    {
        private ServerState currentState;
        public ServerState CurrentState
        {
            get
            {
                return currentState;
            }
        }
        public ServerStateArgs(ServerState state)
        {
            currentState = state;
        }
    }
}
