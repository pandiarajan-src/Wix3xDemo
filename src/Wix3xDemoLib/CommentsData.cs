using System;
using System.Collections.Generic;
using System.Data.SQLite;
using System.Text;
using System.Diagnostics;

namespace Wix3xDemoLib
{
    public class CommentsData
    {
        private List<string> CommentsList = new List<string>();
        private SQLiteConnection SQLiteConn;
        private string ConnectionString = "Data Source=wix3xdemodb.db; Version=3;New=True;Compress=True;";
        public CommentsData()
        {
            InitTraceListener();
            ConnectDB();
        }
        ~CommentsData()
        {
            SQLiteConn.Close();
        }

        public bool Add(string comment)
        {
            try
            {
                SQLiteCommand sql_cmd = SQLiteConn.CreateCommand();
                StringBuilder command = new StringBuilder();
                command.AppendFormat("INSERT INTO CommentsTable (Comments) VALUES (%s);", comment);
                sql_cmd.CommandText = command.ToString();                
                sql_cmd.ExecuteNonQuery();
            }
            catch (SQLiteException ex)
            {
                Trace.WriteLine(ex.Message);
                Trace.Indent();
                Trace.WriteLine(ex.ErrorCode + ex.HelpLink);
            }
            CommentsList.Add(comment);
            return true;
        }

        public List<string> GetAllComments()
        {
            try
            {
                CommentsList.Clear();
                SQLiteCommand sql_cmd = SQLiteConn.CreateCommand();
                sql_cmd.CommandText = "SELECT * From CommentsTable";
                SQLiteDataReader sql_data_reader = sql_cmd.ExecuteReader();
                while (sql_data_reader.Read())
                {
                    CommentsList.Add(sql_data_reader.GetString(0));
                }
            }
            catch (SQLiteException ex)
            {
                Trace.WriteLine(ex.Message);
                Trace.Indent();
                Trace.WriteLine(ex.ErrorCode + ex.HelpLink);
            }
            return CommentsList;
        }

        private bool ConnectDB()
        {
            bool status = true;
            try
            {
                SQLiteConn = new SQLiteConnection(ConnectionString);
                SQLiteConn.Open();
            }
            catch (SQLiteException ex)
            {
                Trace.WriteLine(ex.Message);
                Trace.Indent();
                Trace.WriteLine(ex.ErrorCode + ex.HelpLink);
            }
            return status;
        }

        private void InitTraceListener()
        {
            Trace.Listeners.Add(new TextWriterTraceListener("CommentsDB.log"));
            Trace.AutoFlush = true;
        }

    }
}
