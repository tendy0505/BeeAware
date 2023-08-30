using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.Data.SqlClient;
using System.Text.Json;

namespace BeeAware.Controllers
{
    public static class BeeAware_Core
    {

       
        /// <summary>
        /// Add awards to user
        /// </summary>
        /// <param name="con">the connection string</param>
        /// <param name="PostUserID">the userID who gives award (string)</param>
        /// <param name="RespUserID">the userID who recived award (string)</param>
        /// <param name="Points">the award point</param>
        /// <param name="PlugIn">the module of award happend</param>
        /// <param name="Reference">reference</param>
        /// <returns>Operation successful or not</returns>
        public static bool AddAwards(SqlConnection con, int RespUserID, int Points, string? PostUserID = null,  string? PlugIn = null, string? Reference = null)
        {
            SqlCommand cmd = new SqlCommand("UPDATE [dbo].[glb_Users]\r\n   SET [UserPoints] =  [UserPoints] + "+ Points + "\r\n WHERE [glb_Users].UserID = "+ RespUserID , con);
            con.Open();//连接数据库
            int i = cmd.ExecuteNonQuery(); //执行数据库指令
            con.Close();
            if (i <= 0)
            {
                return false;
            }
            if (PostUserID == null)
            {
                PostUserID = "NULL";
            }
            if (PlugIn == null)
            {
                PlugIn = "NULL";
            }
            if (Reference == null)
            {
                Reference = "NULL";
            }
            SqlCommand cmd2 = new SqlCommand("INSERT INTO [dbo].[glb_Awards]\r\n           ([PostUserID]\r\n           ,[RespUserID]\r\n           ,[Points]\r\n           ,[PlugIn]\r\n           ,[Reference]\r\n           ,[PostDate])\r\n     VALUES\r\n           ("+ PostUserID+","+ RespUserID + ","+ Points + ","+ PlugIn + ","+Reference+",'"+DateTime.Today+"')", con);
            con.Open();//连接数据库
            int i2 = cmd2.ExecuteNonQuery(); //执行数据库指令
            con.Close();
            if (i2 <= 0)
            {
                return false;
            }
            return true;
        }
    }
}
