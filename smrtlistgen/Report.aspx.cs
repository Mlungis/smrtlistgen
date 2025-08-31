using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace smrtlistgen
{
    public partial class Report : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Only execute on initial page load (not postbacks)
            if (!IsPostBack)
            {
                try
                {
                    // Retrieve session data for the shopping list and user preferences
                    DataTable shoppingList = Session["ShoppingList"] as DataTable;
                    string budget = Session["Budget"]?.ToString() ?? "Not specified";
                    string dietChoice = Session["DietChoice"]?.ToString() ?? "Not specified";
                    string allergyText = Session["AllergyText"]?.ToString() ?? "None";
                    string sortCriteria = Session["SortCriteria"]?.ToString() ?? "ItemName";

                    // Set user preference labels with proper formatting
                    lblBudget.Text = decimal.TryParse(budget, out decimal budgetAmount)
                        ? budgetAmount.ToString("C")
                        : "Not specified";
                    lblDiet.Text = Server.HtmlEncode(dietChoice);
                    lblAllergies.Text = Server.HtmlEncode(allergyText);
                    lblSortCriteria.Text = GetFriendlySortCriteria(sortCriteria);
                    lblGeneratedDate.Text = TimeZoneInfo.ConvertTime(DateTime.Now, TimeZoneInfo.FindSystemTimeZoneById("South Africa Standard Time")).ToString("MMMM dd yyyy");
                    lblGeneratedTime.Text = TimeZoneInfo.ConvertTime(DateTime.Now, TimeZoneInfo.FindSystemTimeZoneById("South Africa Standard Time")).ToString("hh:mm tt");

                    // Validate and process the shopping list
                    if (shoppingList != null && shoppingList.Rows.Count > 0)
                    {
                        // Verify required columns exist
                        if (!ValidateShoppingListColumns(shoppingList))
                        {
                            lblErrorMessage.Text = "The shopping list data is not in the expected format.";
                            return;
                        }

                        // Sort the DataTable based on the sort criteria
                        shoppingList.DefaultView.Sort = GetSortExpression(sortCriteria);
                        DataTable sortedShoppingList = shoppingList.DefaultView.ToTable();

                        // Calculate total cost
                        decimal grandTotal = CalculateGrandTotal(sortedShoppingList);

                        // Add tooltips to GridView cells
                        ReportGrid.DataSource = sortedShoppingList;
                        ReportGrid.DataBind();

                        // Add tooltips after binding
                        AddTooltipsToGridView(sortedShoppingList);

                        lblTotalCost.Text = grandTotal.ToString("C");
                    }
                    else
                    {
                        // Handle empty or missing shopping list
                        lblTotalCost.Text = "No items in the shopping list.";
                        lblErrorMessage.Text = "Your shopping list is empty. Please add items to generate a report.";
                        ReportGrid.DataSource = null;
                        ReportGrid.DataBind();
                    }
                }
                catch (Exception ex)
                {
                    // Display a user-friendly error message and log the exception
                    lblErrorMessage.Text = "Oops! Something went wrong while loading your shopping list. Please try again later.";
                    LogError(ex);
                }
            }
        }

        // Validates that the shopping list DataTable has the required columns
        private bool ValidateShoppingListColumns(DataTable shoppingList)
        {
            return shoppingList.Columns.Contains("ItemName") &&
                   shoppingList.Columns.Contains("Quantity") &&
                   shoppingList.Columns.Contains("Price");
        }

        // Calculates the total cost of all items in the shopping list
        private decimal CalculateGrandTotal(DataTable shoppingList)
        {
            decimal grandTotal = 0;
            foreach (DataRow row in shoppingList.Rows)
            {
                if (decimal.TryParse(row["Price"].ToString(), out decimal price) &&
                    int.TryParse(row["Quantity"].ToString(), out int quantity))
                {
                    grandTotal += price * quantity;
                }
            }
            return grandTotal;
        }

        // Maps sort criteria to a user-friendly display name
        private string GetFriendlySortCriteria(string sortCriteria)
        {
            switch (sortCriteria.ToLower())
            {
                case "itemname":
                    return "Item Name";
                case "quantity":
                    return "Quantity";
                case "price":
                    return "Price";
                default:
                    return "Item Name";
            }
        }

        // Returns the sort expression for the DataTable
        private string GetSortExpression(string sortCriteria)
        {
            switch (sortCriteria.ToLower())
            {
                case "itemname":
                    return "ItemName ASC";
                case "quantity":
                    return "Quantity DESC";
                case "price":
                    return "Price DESC";
                default:
                    return "ItemName ASC";
            }
        }

        // Adds tooltips to GridView cells for additional context
        private void AddTooltipsToGridView(DataTable shoppingList)
        {
            foreach (GridViewRow row in ReportGrid.Rows)
            {
                if (row.RowType == DataControlRowType.DataRow)
                {
                    // Add tooltip to ItemName cell (index 0)
                    row.Cells[0].Attributes["data-tooltip"] = $"Item: {row.Cells[0].Text}";
                    // Add tooltip to Quantity cell (index 1)
                    row.Cells[1].Attributes["data-tooltip"] = $"Quantity: {row.Cells[1].Text} units";
                    // Add tooltip to Price cell (index 2)
                    row.Cells[2].Attributes["data-tooltip"] = $"Price per unit: {row.Cells[2].Text}";
                }
            }
        }

        // Logs exceptions for debugging (e.g., to a file, database, or monitoring service)
        private void LogError(Exception ex)
        {
            System.Diagnostics.Debug.WriteLine($"Error: {ex.Message}\nStack Trace: {ex.StackTrace}");
        }
    }
}