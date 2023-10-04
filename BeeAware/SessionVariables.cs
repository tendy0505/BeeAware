namespace BeeAware
{
    public class SessionVariables
    {
        public const string? SessionKeyUserEmail = "no_user";
        public const string? SessionKeyUserGroup = "no_user";


        public enum SessionKeyEnum
        {
            SessionKeyUserEmail = 0,
            SessionKeyUserGroup = 1,
        }

    }
}
