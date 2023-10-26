using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;
using Microsoft.Extensions.Configuration;
using BeeAware.Models;
using System.Reflection.PortableExecutable;
using Microsoft.AspNetCore.Session;
using Microsoft.AspNetCore.Http;
using static BeeAware.SessionVariables;
using System.Text.Json;

namespace BeeAware.Controllers
{


    public static class BeeAware_Core 
    {
        
        private static HttpContext _httpContext => new HttpContextAccessor().HttpContext;
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
        public static bool AddAwards(SqlConnection con, int RespUserID, int Points, string? PostUserID = null, string? PlugIn = null, string? Reference = null)
        {
            SqlCommand cmd = new SqlCommand("UPDATE [dbo].[glb_Users]\r\n   SET [UserPoints] =  [UserPoints] + " + Points + "\r\n WHERE [glb_Users].UserID = " + RespUserID, con);
            con.Open();
            int i = cmd.ExecuteNonQuery(); 
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
            SqlCommand cmd2 = new SqlCommand("INSERT INTO [dbo].[glb_Awards]\r\n           ([PostUserID]\r\n           ,[RespUserID]\r\n           ,[Points]\r\n           ,[PlugIn]\r\n           ,[Reference]\r\n           ,[PostDate])\r\n     VALUES\r\n           (" + PostUserID + "," + RespUserID + "," + Points + "," + PlugIn + "," + Reference + ",'" + DateTime.Today + "')", con);
            con.Open();
            int i2 = cmd2.ExecuteNonQuery(); 
            con.Close();
            if (i2 <= 0)
            {
                return false;
            }
            return true;
        }
        /// <summary>
        /// Assess user permission to a module
        /// </summary>
        /// <param name="Username">the connection string</param>
        /// <param name="Module">the userID who gives award (string)</param>
        /// <returns>The user have permission or not</returns>
        public static  bool IsPermitted(SqlConnection con, string Username, string Module)
        {
            if (_httpContext.Session.GetString(SessionVariables.SessionKeyUserGroup) == "Superuser")
            {
                return true;
            }
            SqlCommand cmd = new SqlCommand("SELECT * from glb_SecMod \r\n\r\nleft join \r\n( SELECT * FROM glb_SecUser WHERE glb_SecUser.SecUserID \r\nIN (SELECT MAX(glb_SecUser.SecUserID) FROM glb_SecUser GROUP BY glb_SecUser.SecModID, glb_SecUser.UserID)) AS a\r\non a.SecModID = glb_SecMod.ModuleCode\r\n\r\nLEFT join glb_Users \r\non glb_Users.UserID = a.UserID\r\n\r\n\r\nwhere (glb_SecMod.SecurityLevel <= a.SecurityLevel and glb_Users.UserName = '" + Username + "')\r\nor( a.SecurityLevel  is null and glb_SecMod.SecurityLevel<=2) and glb_SecMod.module = '" + Module + "'", con);
            con.Open();
            SqlDataReader read = cmd.ExecuteReader();
            bool permitted = false;
            while (read.Read())
            {
                permitted = true;
            };
            read.Close();
            con.Close();
            return permitted;
        }
        public static bool IsSuperuser(SqlConnection con, string Username, string Module)
        {
            if (_httpContext.Session.GetString(SessionVariables.SessionKeyUserGroup) == "Superuser")
            {
                return true;
            }
            SqlCommand cmd = new SqlCommand("SELECT * from glb_SecMod \r\n\r\nleft join \r\n( SELECT * FROM glb_SecUser WHERE glb_SecUser.SecUserID \r\nIN (SELECT MAX(glb_SecUser.SecUserID) FROM glb_SecUser GROUP BY glb_SecUser.SecModID, glb_SecUser.UserID)) AS a\r\non a.SecModID = glb_SecMod.ModuleCode\r\n\r\nLEFT join glb_Users \r\non glb_Users.UserID = a.UserID\r\n\r\n\r\nwhere (8 <= a.SecurityLevel and glb_Users.UserName = '" + Username + "') and glb_SecMod.module = '" + Module + "'", con);
                con.Open();
                SqlDataReader read = cmd.ExecuteReader();
                bool permitted = false;
                while (read.Read())
                {
                    permitted = true;
                };
                read.Close();
                con.Close();
                return permitted;
            
        }
    }
}
