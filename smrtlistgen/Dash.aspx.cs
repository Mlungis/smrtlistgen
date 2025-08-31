using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace smrtlistgen
{
    public partial class Dash : System.Web.UI.Page
    {
        // Database connection string
        private readonly string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\\smaertdata.mdf;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Clear previous data
                GridView1.DataSource = null;
                GridView1.DataBind();
                totalCost.InnerText = "";
                reportBtn.Visible = false;
                AddMoreBtn.Visible = false;
                AddMorePanel.Visible = false;
                addSearchBox.Text = "";
            }
        }

        protected void PreviewButton_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                totalCost.InnerText = "Please fix the input errors first.";
                return;
            }

            if (!decimal.TryParse(budget.Text, out decimal budgetAmount) || budgetAmount <= 0)
            {
                totalCost.InnerText = "Please enter a valid budget amount.";
                return;
            }

            string dietChoice = diet.SelectedValue;
            string allergyText = allergy.Text.Trim();

            // Split allergies manually and trim each entry
            string[] allergyList;
            if (string.IsNullOrEmpty(allergyText))
            {
                allergyList = new string[0];
            }
            else
            {
                string[] parts = allergyText.Split(',');
                allergyList = new string[parts.Length];
                for (int i = 0; i < parts.Length; i++)
                {
                    allergyList[i] = parts[i].Trim();
                }
            }

            DateTime now = DateTime.Now;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                try
                {
                    con.Open();

                    // Step 1: Save user preferences
                    string userQuery = "INSERT INTO [dbo].[User] (DietaryPreference, AllergyRestrictions) OUTPUT INSERTED.UserID VALUES (@Diet, @Allergy)";
                    int userId;
                    using (SqlCommand cmd = new SqlCommand(userQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@Diet", dietChoice);
                        cmd.Parameters.AddWithValue("@Allergy", string.IsNullOrEmpty(allergyText) ? (object)DBNull.Value : allergyText);

                        object result = cmd.ExecuteScalar();
                        if (result == null || result == DBNull.Value)
                        {
                            totalCost.InnerText = "Could not save user preferences.";
                            return;
                        }
                        userId = Convert.ToInt32(result);
                    }

                    // Step 2: Create shopping list
                    string shoppingListQuery = "INSERT INTO [dbo].[ShoppingList] (UserID, Budget, DateCreated) OUTPUT INSERTED.ListID VALUES (@UserID, @Budget, @DateCreated)";
                    int listId;
                    using (SqlCommand cmd = new SqlCommand(shoppingListQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.Parameters.AddWithValue("@Budget", budgetAmount);
                        cmd.Parameters.AddWithValue("@DateCreated", now);

                        listId = Convert.ToInt32(cmd.ExecuteScalar());
                    }

                    // Step 3: Generate shopping list
                    DataTable shoppingList = GenerateShoppingList(budgetAmount, dietChoice, allergyList, "", con, listId);

                    if (shoppingList.Rows.Count == 0)
                    {
                        totalCost.InnerText = "No items match your diet/allergy/budget choices.";
                        GridView1.DataSource = null;
                        GridView1.DataBind();
                        reportBtn.Visible = false;
                        AddMoreBtn.Visible = false;
                        return;
                    }

                    // Store in session for delete, add operations, and report
                    Session["ShoppingList"] = shoppingList;
                    Session["ListId"] = listId;
                    Session["DietChoice"] = dietChoice;
                    Session["AllergyList"] = allergyList;
                    Session["Budget"] = budgetAmount;
                    Session["AllergyText"] = allergyText; // Added for Report.aspx.cs

                    GridView1.DataSource = shoppingList;
                    GridView1.DataBind();

                    decimal total = CalculateTotal(shoppingList);
                    UpdateTotalDisplay(total, budgetAmount);

                    reportBtn.Visible = true;
                    AddMoreBtn.Visible = true;
                }
                catch (Exception ex)
                {
                    totalCost.InnerText = $"Error: {ex.Message}";
                }
            }
        }

        protected void GenerateReport_Click(object sender, EventArgs e)
        {
            try
            {
                // Ensure required session data is available
                if (Session["ShoppingList"] == null || Session["Budget"] == null || Session["DietChoice"] == null || Session["AllergyText"] == null)
                {
                    totalCost.InnerText = "Session data is missing. Please generate the shopping list first.";
                    return;
                }

                // Redirect to Report.aspx
                Response.Redirect("Report.aspx");
            }
            catch (Exception ex)
            {
                totalCost.InnerText = $"Error navigating to report: {ex.Message}";
            }
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteItem")
            {
                int productId = Convert.ToInt32(e.CommandArgument);
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    try
                    {
                        con.Open();
                        int listId = Session["ListId"] != null ? Convert.ToInt32(Session["ListId"]) : 0;

                        // Remove item from database
                        string deleteQuery = "UPDATE [dbo].[Product] SET ListID = NULL WHERE ProductID = @ProductID AND ListID = @ListID";
                        using (SqlCommand cmd = new SqlCommand(deleteQuery, con))
                        {
                            cmd.Parameters.AddWithValue("@ProductID", productId);
                            cmd.Parameters.AddWithValue("@ListID", listId);
                            cmd.ExecuteNonQuery();
                        }

                        // Update session and GridView
                        DataTable shoppingList = Session["ShoppingList"] as DataTable;
                        if (shoppingList != null)
                        {
                            DataRow[] rows = shoppingList.Select($"ProductID = {productId}");
                            foreach (DataRow row in rows)
                            {
                                shoppingList.Rows.Remove(row);
                            }

                            GridView1.DataSource = shoppingList;
                            GridView1.DataBind();

                            // Update total cost
                            decimal total = CalculateTotal(shoppingList);
                            decimal budget = (decimal)Session["Budget"];
                            UpdateTotalDisplay(total, budget);
                            reportBtn.Visible = shoppingList.Rows.Count > 0;
                            AddMoreBtn.Visible = shoppingList.Rows.Count > 0;
                        }
                    }
                    catch (Exception ex)
                    {
                        totalCost.InnerText = $"Error deleting item: {ex.Message}";
                    }
                }
            }
        }

        protected void SearchGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "AddItem")
            {
                int productId = Convert.ToInt32(e.CommandArgument);
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    try
                    {
                        con.Open();
                        int listId = (int)Session["ListId"];

                        // Update db
                        string updateQuery = "UPDATE [dbo].[Product] SET ListID = @ListID WHERE ProductID = @ProductID";
                        using (SqlCommand cmd = new SqlCommand(updateQuery, con))
                        {
                            cmd.Parameters.AddWithValue("@ListID", listId);
                            cmd.Parameters.AddWithValue("@ProductID", productId);
                            cmd.ExecuteNonQuery();
                        }

                        // Add to shoppingList
                        DataTable shoppingList = (DataTable)Session["ShoppingList"];
                        DataTable searchResults = (DataTable)Session["SearchResults"];

                        if (searchResults != null && shoppingList != null)
                        {
                            DataRow[] foundRows = searchResults.Select($"ProductID = {productId}");
                            if (foundRows.Length > 0)
                            {
                                DataRow newRow = shoppingList.NewRow();
                                newRow["ProductID"] = foundRows[0]["ProductID"];
                                newRow["ItemName"] = foundRows[0]["ItemName"];
                                newRow["Quantity"] = foundRows[0]["Quantity"];
                                newRow["Price"] = foundRows[0]["Price"];
                                shoppingList.Rows.Add(newRow);

                                // Remove from search
                                foundRows[0].Delete();

                                // Rebind search
                                SearchGrid.DataSource = searchResults;
                                SearchGrid.DataBind();

                                // Rebind main
                                GridView1.DataSource = shoppingList;
                                GridView1.DataBind();

                                // Update total
                                decimal total = CalculateTotal(shoppingList);
                                decimal budget = (decimal)Session["Budget"];
                                UpdateTotalDisplay(total, budget);
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        totalCost.InnerText = $"Error adding item: {ex.Message}";
                    }
                }
            }
        }

        protected void SearchMoreButton_Click(object sender, EventArgs e)
        {
            string searchTerm = addSearchBox.Text.Trim();
            string dietChoice = (string)Session["DietChoice"];
            string[] allergyList = (string[])Session["AllergyList"];
            int listId = (int)Session["ListId"];

            PopulateSearchGrid(searchTerm, dietChoice, allergyList, listId);
        }

        protected void AddMoreBtn_Click(object sender, EventArgs e)
        {
            AddMorePanel.Visible = true;
            addSearchBox.Text = ""; // Clear search term
            string dietChoice = (string)Session["DietChoice"];
            string[] allergyList = (string[])Session["AllergyList"];
            int listId = (int)Session["ListId"];

            // Populate SearchGrid with all available items not in the current list
            PopulateSearchGrid("", dietChoice, allergyList, listId);
        }

        protected void DoneButton_Click(object sender, EventArgs e)
        {
            AddMorePanel.Visible = false;
            addSearchBox.Text = "";
            SearchGrid.DataSource = null;
            SearchGrid.DataBind();
        }

        private DataTable GenerateShoppingList(decimal budget, string dietChoice, string[] allergyList, string searchTerm, SqlConnection con, int listId)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("ProductID", typeof(int));
            dt.Columns.Add("ItemName", typeof(string));
            dt.Columns.Add("Quantity", typeof(int));
            dt.Columns.Add("Price", typeof(decimal));

            // Step 1: Fetch available products
            string query = @"
                SELECT p.ProductID, p.Name AS ItemName, p.Price, c.Name AS CategoryName
                FROM [dbo].[Product] p
                INNER JOIN [dbo].[Category] c ON p.CategoryID = c.CategoryID
                WHERE p.Availability = 1
                AND (@Diet = 'Any' OR 
                     (@Diet = 'Vegetarian' AND c.Name IN ('Vegies', 'Fruits', 'Grains', 'Spices')) OR
                     (@Diet = 'Gluten-Free' AND c.Name NOT IN ('Grains')) OR
                     (@Diet = 'Low-Carb' AND c.Name IN ('Vegies', 'Meat', 'Dairy', 'Spices')))
                AND (@SearchTerm = '' OR p.Name LIKE '%' + @SearchTerm + '%')";

            DataTable rawProducts = new DataTable();
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@Diet", dietChoice);
                cmd.Parameters.AddWithValue("@SearchTerm", searchTerm);
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    da.Fill(rawProducts);
                }
            }

            // Step 2: Filter by allergies and budget, limit to 10 items
            decimal total = 0;
            int itemCount = 0;

            using (SqlCommand updateCmd = new SqlCommand("UPDATE [dbo].[Product] SET ListID = @ListID WHERE ProductID = @ProductID", con))
            {
                foreach (DataRow row in rawProducts.Rows)
                {
                    if (itemCount >= 10) break;

                    int productId = Convert.ToInt32(row["ProductID"]);
                    decimal price = Convert.ToDecimal(row["Price"]);
                    int quantity = 1;

                    // Skip products matching any allergy
                    bool skip = false;
                    foreach (string allergy in allergyList)
                    {
                        if (!string.IsNullOrWhiteSpace(allergy))
                        {
                            string lowAllergy = allergy.ToLower();
                            string itemName = row["ItemName"].ToString().ToLower();
                            string categoryName = row["CategoryName"].ToString().ToLower();

                            if (itemName.Contains(lowAllergy) || categoryName.Contains(lowAllergy))
                            {
                                skip = true;
                                break;
                            }
                        }
                    }
                    if (skip) continue;

                    // Skip if budget exceeded
                    if (total + (price * quantity) > budget) continue;

                    // Add product
                    dt.Rows.Add(productId, row["ItemName"], quantity, price);
                    total += price * quantity;
                    itemCount++;

                    // Update ListID
                    updateCmd.Parameters.Clear();
                    updateCmd.Parameters.AddWithValue("@ListID", listId);
                    updateCmd.Parameters.AddWithValue("@ProductID", productId);
                    updateCmd.ExecuteNonQuery();
                }
            }

            return dt;
        }

        private decimal CalculateTotal(DataTable shoppingList)
        {
            decimal total = 0;
            foreach (DataRow row in shoppingList.Rows)
            {
                total += (decimal)row["Price"] * (int)row["Quantity"];
            }
            return total;
        }

        private void UpdateTotalDisplay(decimal total, decimal budget)
        {
            totalCost.InnerText = $"Total Cost: {total:C}";
            if (total > budget)
            {
                totalCost.InnerText += " (Over Budget)";
                totalCost.Style["color"] = "#ff6b6b";
            }
            else
            {
                totalCost.Style["color"] = "#00ffb3";
            }
        }

        private void PopulateSearchGrid(string searchTerm, string dietChoice, string[] allergyList, int listId)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                try
                {
                    con.Open();

                    DataTable dt = new DataTable();
                    dt.Columns.Add("ProductID", typeof(int));
                    dt.Columns.Add("ItemName", typeof(string));
                    dt.Columns.Add("Quantity", typeof(int));
                    dt.Columns.Add("Price", typeof(decimal));

                    // Fetch available products not in current list
                    string query = @"
                        SELECT p.ProductID, p.Name AS ItemName, p.Price, c.Name AS CategoryName
                        FROM [dbo].[Product] p
                        INNER JOIN [dbo].[Category] c ON p.CategoryID = c.CategoryID
                        WHERE p.Availability = 1
                        AND (@Diet = 'Any' OR 
                             (@Diet = 'Vegetarian' AND c.Name IN ('Vegies', 'Fruits', 'Grains', 'Spices')) OR
                             (@Diet = 'Gluten-Free' AND c.Name NOT IN ('Grains')) OR
                             (@Diet = 'Low-Carb' AND c.Name IN ('Vegies', 'Meat', 'Dairy', 'Spices')))
                        AND (@SearchTerm = '' OR p.Name LIKE '%' + @SearchTerm + '%')
                        AND (p.ListID IS NULL OR p.ListID != @ListID)";

                    DataTable rawProducts = new DataTable();
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Diet", dietChoice);
                        cmd.Parameters.AddWithValue("@SearchTerm", searchTerm);
                        cmd.Parameters.AddWithValue("@ListID", listId);
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(rawProducts);
                        }
                    }

                    // Filter by allergies
                    foreach (DataRow row in rawProducts.Rows)
                    {
                        decimal price = Convert.ToDecimal(row["Price"]);
                        int quantity = 1;

                        // Skip products matching any allergy
                        bool skip = false;
                        foreach (string allergy in allergyList)
                        {
                            if (!string.IsNullOrWhiteSpace(allergy))
                            {
                                string lowAllergy = allergy.ToLower();
                                string itemName = row["ItemName"].ToString().ToLower();
                                string categoryName = row["CategoryName"].ToString().ToLower();

                                if (itemName.Contains(lowAllergy) || categoryName.Contains(lowAllergy))
                                {
                                    skip = true;
                                    break;
                                }
                            }
                        }
                        if (skip) continue;

                        // Add product
                        dt.Rows.Add(Convert.ToInt32(row["ProductID"]), row["ItemName"], quantity, price);
                    }

                    if (dt.Rows.Count == 0)
                    {
                        SearchGrid.DataSource = null;
                        SearchGrid.DataBind();
                    }
                    else
                    {
                        Session["SearchResults"] = dt;
                        SearchGrid.DataSource = dt;
                        SearchGrid.DataBind();
                    }
                }
                catch (Exception ex)
                {
                    totalCost.InnerText = $"Error searching items: {ex.Message}";
                }
            }
        }
    }
}