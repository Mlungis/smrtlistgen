using System;
using System.Web.UI;

namespace smrtlistgen
{
    public class Global : System.Web.HttpApplication
    {
        protected void Application_Start(object sender, EventArgs e)
        {
            // Register jQuery for unobtrusive validation
            ScriptManager.ScriptResourceMapping.AddDefinition("jquery", new ScriptResourceDefinition
            {
                Path = "https://code.jquery.com/jquery-3.6.0.min.js",
                CdnPath = "https://code.jquery.com/jquery-3.6.0.min.js",
                CdnDebugPath = "https://code.jquery.com/jquery-3.6.0.js",
                CdnSupportsSecureConnection = true
            });
        }
    }
}