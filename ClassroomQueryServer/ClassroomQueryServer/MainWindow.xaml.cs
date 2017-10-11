using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Threading;

namespace Elecky.QueryServer
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
            UIDispatcher = System.Windows.Threading.Dispatcher.CurrentDispatcher;
            //subscribe events
            InfoRefresher.LogAdded += AddLog;
            InfoRefresher.RefreshFinished += EnableRefreshButton;
            Server.LogAdded += AddLog;
            Server.ClientChange += IncreaserClient;
            Server.ListenStateChange += OnServerChanged;
            //initialize timer
            oneSecond = new TimeSpan(0, 0, 1);
            timer = new System.Windows.Threading.DispatcherTimer();
            timer.Tick += onRefreshTick;
            resetTimer();
            //do first refresh
            Thread refresh = new Thread(InfoRefresher.UpdateIsFree) { IsBackground = true };
            refresh.Start();
            //start server
            server = new Thread(Server.ServerMain) { IsBackground = true };
            server.Start();
        }

        Thread server;
        private System.Windows.Threading.Dispatcher UIDispatcher;

        //not used
        public class LogAddedArgs : EventArgs
        {
            private string log;
            public string Log
            {
                get
                {
                    return log;
                }
            }
        }

        private void addLog(string newLog)
        {
            Log.AppendText(newLog);
        }
        public void AddLog(object sender, string NewLog)
        {
            UIDispatcher.Invoke(new Action<string>(addLog), NewLog);
        }

        /// <summary>
        /// manually start refresh
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void refreshButton_Click(object sender, RoutedEventArgs e)
        {
            startRefresh();
        }

        /// <summary>
        /// reset the timer and start it
        /// </summary>
        private void resetTimer()
        {
            timeBeforeRefresh = 30;
            timer.Interval = oneSecond;
            RefreshState.Text = "Time before next refresh:";
            timeLast.Text = "30s";
            timer.Start();
        }
        private System.Windows.Threading.DispatcherTimer timer;
        private int timeBeforeRefresh;
        private TimeSpan oneSecond;

        /// <summary>
        /// start refresh when timer tick
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="args"></param>
        private void onRefreshTick(object sender, EventArgs args)
        {
            if (timeBeforeRefresh == 0)
            {
                startRefresh();
            }
            else
            {
                --timeBeforeRefresh;
                timeLast.Text = string.Format("{0}s", timeBeforeRefresh);
                timer.Interval = oneSecond;
                timer.Start();
            }
        }
        private void startRefresh()
        {
            //disable refresh button and timer
            RefreshButton.IsEnabled = false;
            timer.Stop();
            RefreshState.Text = "Refreshing ...";
            timeLast.Text = "0";
            //refresh
            Thread refresh = new Thread(InfoRefresher.Refresher);
            refresh.Start();
        }

        //enable the refresh button
        private void enableRefreshButton()
        {
            RefreshButton.IsEnabled = true;
            resetTimer();
        }
        //event handler of enabling the refresh button
        public void EnableRefreshButton(object sender, EventArgs args)
        {
            UIDispatcher.Invoke(() => enableRefreshButton());
        }

        public void IncreaserClient(object sender, int offset)
        {
            UIDispatcher.Invoke(() => incrementClient(offset));
        }
        private void incrementClient(int offset)
        {
            if (offset ==1)
            {
                ++clientEver;
                count.Text = clientEver.ToString();
            }
            clientN += offset;
            clientCount.Text = clientN.ToString();
        }
        private int clientN = 0;
        private int clientEver = 0;

        //the button of change listener state
        private void changeListen(object sender, RoutedEventArgs e)
        {
            MessageBox.Show("not supported yet");
            /*
            if (listening)
            {
                listenOperate.IsEnabled = false;
                server.Suspend();
            }
            else
            {
                listenOperate.IsEnabled = false;
                server.Start();
            }*/
        }
        private bool listening;
        //the action of change listenOperate button UI element
        private void changeListenButton(ServerState state)
        {
            if (state == ServerState.started)
            {
                listening = true;
                listenState.Text = "Listen state: listening";
                listenOperate.Content = "Stop";
                listenOperate.IsEnabled = true;
            }
            else if (state == ServerState.stopped)
            {
                listening = false;
                listenState.Text = "Listen state: stopped";
                listenOperate.Content = "start";
                listenOperate.IsEnabled = true;
            }
        }
        private void OnServerChanged(object sender, Elecky.QueryServer.ServerStateArgs args)
        {
            UIDispatcher.Invoke(() => changeListenButton(args.CurrentState));
        }
    }
}
