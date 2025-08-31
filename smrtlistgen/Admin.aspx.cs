using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace smrtlistgen
{
    public partial class Admin : System.Web.UI.Page
    {
        private readonly string connectionString =
            "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\\smaertdata.mdf;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCategories();
                BindProducts();
                BindUsers();
                BindDietTypes();
            }
        }

        #region Bind Methods
        private void BindCategories()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT CategoryID, Name FROM Category", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                CategoriesGrid.DataSource = dt;
                CategoriesGrid.DataBind();
            }
        }

        private void BindProducts()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT p.ProductID, p.Name AS ItemName, c.Name AS CategoryName, p.Price, p.Availability
                                 FROM Product p
                                 INNER JOIN Category c ON p.CategoryID = c.CategoryID";
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                ProductsGrid.DataSource = dt;
                ProductsGrid.DataBind();
            }
        }

        private void BindUsers()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT UserID, DietaryPreference, AllergyRestrictions FROM [User]", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                UsersGrid.DataSource = dt;
                UsersGrid.DataBind();
            }
        }

        private void BindDietTypes()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT DietTypeID, Name FROM DietType", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                DietGrid.DataSource = dt;
                DietGrid.DataBind();
            }
        }
        #endregion

        #region Add Buttons
        protected void AddCategoryBtn_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("INSERT INTO Category (Name) VALUES (@Name)", con);
                    cmd.Parameters.Add("@Name", SqlDbType.NVarChar, 100).Value = "New Category";
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
                BindCategories();
            }
            catch (Exception ex) { ShowError(ex); }
        }

        protected void AddProductBtn_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand(@"INSERT INTO Product (Name, CategoryID, Price, Availability) 
                                                      VALUES (@Name, @CategoryID, @Price, @Availability)", con);
                    cmd.Parameters.Add("@Name", SqlDbType.NVarChar, 100).Value = "New Product";
                    cmd.Parameters.Add("@CategoryID", SqlDbType.Int).Value = 1;
                    cmd.Parameters.Add("@Price", SqlDbType.Decimal).Value = 0.0;
                    cmd.Parameters.Add("@Availability", SqlDbType.Bit).Value = true;
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
                BindProducts();
            }
            catch (Exception ex) { ShowError(ex); }
        }

        protected void AddUserBtn_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand(@"INSERT INTO [User] (DietaryPreference, AllergyRestrictions)
                                                      VALUES (@Diet, @Allergy)", con);
                    cmd.Parameters.Add("@Diet", SqlDbType.NVarChar, 100).Value = "None";
                    cmd.Parameters.Add("@Allergy", SqlDbType.NVarChar, 100).Value = "None";
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
                BindUsers();
            }
            catch (Exception ex) { ShowError(ex); }
        }

        protected void AddDietBtn_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("INSERT INTO DietType (Name) VALUES (@Name)", con);
                    cmd.Parameters.Add("@Name", SqlDbType.NVarChar, 100).Value = "New Diet";
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
                BindDietTypes();
            }
            catch (Exception ex) { ShowError(ex); }
        }

        private void ShowError(Exception ex)
        {
            // Simple error message
            Response.Write("<script>alert('Error: " + ex.Message + "');</script>");
        }
        #endregion

        #region GridView Edit/Update/Delete
        // Categories
        protected void CategoriesGrid_RowEditing(object sender, GridViewEditEventArgs e)
        {
            CategoriesGrid.EditIndex = e.NewEditIndex;
            BindCategories();
        }

        protected void CategoriesGrid_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            CategoriesGrid.EditIndex = -1;
            BindCategories();
        }

        protected void CategoriesGrid_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int id = Convert.ToInt32(CategoriesGrid.DataKeys[e.RowIndex].Value);
            string name = ((TextBox)CategoriesGrid.Rows[e.RowIndex].Cells[1].Controls[0]).Text;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("UPDATE Category SET Name=@Name WHERE CategoryID=@ID", con);
                cmd.Parameters.AddWithValue("@Name", name);
                cmd.Parameters.AddWithValue("@ID", id);
                con.Open();
                cmd.ExecuteNonQuery();
            }
            CategoriesGrid.EditIndex = -1;
            BindCategories();
        }

        protected void CategoriesGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteCategory")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("DELETE FROM Category WHERE CategoryID=@ID", con);
                    cmd.Parameters.AddWithValue("@ID", id);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
                BindCategories();
            }
        }

        // Users
        protected void UsersGrid_RowEditing(object sender, GridViewEditEventArgs e)
        {
            UsersGrid.EditIndex = e.NewEditIndex;
            BindUsers();
        }

        protected void UsersGrid_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            UsersGrid.EditIndex = -1;
            BindUsers();
        }

        protected void UsersGrid_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int id = Convert.ToInt32(UsersGrid.DataKeys[e.RowIndex].Value);
            string diet = ((TextBox)UsersGrid.Rows[e.RowIndex].Cells[1].Controls[0]).Text;
            string allergy = ((TextBox)UsersGrid.Rows[e.RowIndex].Cells[2].Controls[0]).Text;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("UPDATE [User] SET DietaryPreference=@Diet, AllergyRestrictions=@Allergy WHERE UserID=@ID", con);
                cmd.Parameters.AddWithValue("@Diet", diet);
                cmd.Parameters.AddWithValue("@Allergy", allergy);
                cmd.Parameters.AddWithValue("@ID", id);
                con.Open();
                cmd.ExecuteNonQuery();
            }
            UsersGrid.EditIndex = -1;
            BindUsers();
        }

        protected void UsersGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteUser")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();
                    SqlCommand cmd1 = new SqlCommand("DELETE FROM ShoppingList WHERE UserID=@ID", con);
                    cmd1.Parameters.AddWithValue("@ID", id);
                    cmd1.ExecuteNonQuery();

                    SqlCommand cmd2 = new SqlCommand("DELETE FROM [User] WHERE UserID=@ID", con);
                    cmd2.Parameters.AddWithValue("@ID", id);
                    cmd2.ExecuteNonQuery();
                }
                BindUsers();
            }
        }

        // Products
        protected void ProductsGrid_RowEditing(object sender, GridViewEditEventArgs e)
        {
            ProductsGrid.EditIndex = e.NewEditIndex;
            BindProducts();
        }

        protected void ProductsGrid_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            ProductsGrid.EditIndex = -1;
            BindProducts();
        }

        protected void ProductsGrid_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int id = Convert.ToInt32(ProductsGrid.DataKeys[e.RowIndex].Value);
            string name = ((TextBox)ProductsGrid.Rows[e.RowIndex].Cells[1].Controls[0]).Text;
            string priceText = ((TextBox)ProductsGrid.Rows[e.RowIndex].Cells[3].Controls[0]).Text;
            decimal price = decimal.TryParse(priceText, out decimal p) ? p : 0;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("UPDATE Product SET Name=@Name, Price=@Price WHERE ProductID=@ID", con);
                cmd.Parameters.AddWithValue("@Name", name);
                cmd.Parameters.AddWithValue("@Price", price);
                cmd.Parameters.AddWithValue("@ID", id);
                con.Open();
                cmd.ExecuteNonQuery();
            }
            ProductsGrid.EditIndex = -1;
            BindProducts();
        }

        protected void ProductsGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteProduct")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("DELETE FROM Product WHERE ProductID=@ID", con);
                    cmd.Parameters.AddWithValue("@ID", id);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
                BindProducts();
            }
        }

        // Diet
        protected void DietGrid_RowEditing(object sender, GridViewEditEventArgs e)
        {
            DietGrid.EditIndex = e.NewEditIndex;
            BindDietTypes();
        }

        protected void DietGrid_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            DietGrid.EditIndex = -1;
            BindDietTypes();
        }

        protected void DietGrid_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int id = Convert.ToInt32(DietGrid.DataKeys[e.RowIndex].Value);
            string name = ((TextBox)DietGrid.Rows[e.RowIndex].Cells[1].Controls[0]).Text;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("UPDATE DietType SET Name=@Name WHERE DietTypeID=@ID", con);
                cmd.Parameters.AddWithValue("@Name", name);
                cmd.Parameters.AddWithValue("@ID", id);
                con.Open();
                cmd.ExecuteNonQuery();
            }
            DietGrid.EditIndex = -1;
            BindDietTypes();
        }

        protected void DietGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteDiet")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("DELETE FROM DietType WHERE DietTypeID=@ID", con);
                    cmd.Parameters.AddWithValue("@ID", id);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
                BindDietTypes();
            }
        }
        #endregion
    }
}
