using System;
using System.Data.SqlClient;

namespace smrtlistgen
{
    public partial class login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void BtnLogin_Click(object sender, EventArgs e)
        {
            string username = "smartList";
            string password = "smList";

            string adminuser = "admin";
            string adminpass = "adminpass";

            if (txtEmail.Text == adminuser && txtPassword.Text == adminpass)
            {
                Response.Redirect("Admin.aspx");
                return;
            }

            if (txtEmail.Text == username && txtPassword.Text == password)
            {
                Response.Redirect("Dash.aspx");
                return;
            }

            lblMessage.Text = "Invalid username or password";
        }

    }
}
