<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="smrtlistgen.Admin" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Dashboard - Smart Shopping List</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet" />
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            color: white;
            min-height: 100vh;
            background: url('https://images.unsplash.com/photo-1600891964599-f61ba0e24092?auto=format&fit=crop&w=1200&q=80') no-repeat center center/cover;
            margin: 0;
        }
        body::before {
            content: "";
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.65);
            z-index: 0;
        }
        header {
            position: fixed;
            top: 20px;
            left: 30px;
            display: flex;
            align-items: center;
            gap: 12px;
            z-index: 10;
        }
        header h1 {
            font-size: 1.6rem;
            font-weight: 700;
            color: #feb47b;
            text-shadow: 0 0 6px #ff7e5f;
        }
        .main-wrapper {
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding: 100px 20px 40px;
            position: relative;
            z-index: 2;
        }
        .admin-container {
            max-width: 1200px;
            width: 100%;
            background: rgba(255,255,255,0.08);
            border-radius: 20px;
            padding: 30px;
            backdrop-filter: blur(10px);
            box-shadow: 0 10px 35px rgba(0,0,0,0.6);
        }
        .tab-buttons {
            display: flex;
            gap: 12px;
            margin-bottom: 25px;
            flex-wrap: wrap;
        }
        .tab-buttons button {
            flex: 1;
            min-width: 180px;
            padding: 12px;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            color: white;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .tab-buttons button:hover {
            transform: scale(1.05);
            box-shadow: 0 6px 18px rgba(0,0,0,0.5);
        }
        .categories-btn { background: linear-gradient(90deg, #00c9a7, #008b74); }
        .products-btn   { background: linear-gradient(90deg, #667eea, #764ba2); }
        .users-btn      { background: linear-gradient(90deg, #f7971e, #ffd200); }
        .diet-btn       { background: linear-gradient(90deg, #4facfe, #00f2fe); }
        .tab-content { display: none; animation: fadeIn 0.5s ease-in-out; }
        .tab-content.active { display: block; }
        .styled-grid {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
            overflow: hidden;
        }
        .styled-grid th, .styled-grid td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid rgba(255,255,255,0.2);
            color: white;
        }
        .styled-grid th { background: rgba(0,0,0,0.4); font-weight: 600; color: #ffd27f; }
        .styled-grid tr:hover { background: rgba(255,255,255,0.15); }
        .crud-btn { padding: 8px 14px; margin-right: 6px; border: none; border-radius: 8px; cursor: pointer; font-weight: 600; color: white; }
        .add-btn { background: linear-gradient(90deg, #00c9a7, #008b74); }
        .edit-btn { background: linear-gradient(90deg, #4facfe, #00f2fe); }
        .delete-btn { background: linear-gradient(90deg, #e52d27, #b31217); }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <header><h1>Admin Dashboard</h1></header>
        <div class="main-wrapper">
            <div class="admin-container">
                <div class="tab-buttons">
                    <button type="button" class="categories-btn" onclick="showTab('categories')">Manage Categories</button>
                    <button type="button" class="products-btn" onclick="showTab('products')">Manage Products</button>
                    <button type="button" class="users-btn" onclick="showTab('users')">Manage Users</button>
                    <button type="button" class="diet-btn" onclick="showTab('diet')">Manage Diet Types</button>
                </div>

                <!-- Categories Section -->
                <div id="categories" class="tab-content active">
                    <h2>Categories</h2>
                    <asp:GridView ID="CategoriesGrid" runat="server" CssClass="styled-grid" AutoGenerateColumns="false"
                        OnRowEditing="CategoriesGrid_RowEditing"
                        OnRowCancelingEdit="CategoriesGrid_RowCancelingEdit"
                        OnRowUpdating="CategoriesGrid_RowUpdating"
                        OnRowCommand="CategoriesGrid_RowCommand"
                        DataKeyNames="CategoryID">
                        <Columns>
                            <asp:BoundField DataField="CategoryID" HeaderText="ID" ReadOnly="true" />
                            <asp:BoundField DataField="Name" HeaderText="Category Name" />
                            <asp:CommandField ShowEditButton="true" HeaderText="Actions" />
                            <asp:TemplateField HeaderText="Delete">
                                <ItemTemplate>
                                    <asp:Button runat="server" Text="Delete" CssClass="crud-btn delete-btn"
                                        CommandName="DeleteCategory" CommandArgument='<%# Eval("CategoryID") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:Button ID="AddCategoryBtn" runat="server" Text="Add Category" CssClass="crud-btn add-btn"
    OnClick="AddCategoryBtn_Click" />
                </div>

                <!-- Products Section -->
                <div id="products" class="tab-content">
                    <h2>Products</h2>
                    <asp:GridView ID="ProductsGrid" runat="server" CssClass="styled-grid" AutoGenerateColumns="false"
                        OnRowEditing="ProductsGrid_RowEditing"
                        OnRowCancelingEdit="ProductsGrid_RowCancelingEdit"
                        OnRowUpdating="ProductsGrid_RowUpdating"
                        OnRowCommand="ProductsGrid_RowCommand"
                        DataKeyNames="ProductID">
                        <Columns>
                            <asp:BoundField DataField="ProductID" HeaderText="ID" ReadOnly="true" />
                            <asp:BoundField DataField="ItemName" HeaderText="Product Name" />
                            <asp:BoundField DataField="CategoryName" HeaderText="Category" />
                            <asp:BoundField DataField="Price" HeaderText="Price (R)" DataFormatString="{0:C}" />
                            <asp:BoundField DataField="Availability" HeaderText="Available" />
                            <asp:CommandField ShowEditButton="true" HeaderText="Actions" />
                            <asp:TemplateField HeaderText="Delete">
                                <ItemTemplate>
                                    <asp:Button runat="server" Text="Delete" CssClass="crud-btn delete-btn"
                                        CommandName="DeleteProduct" CommandArgument='<%# Eval("ProductID") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                   <asp:Button ID="AddProductBtn" runat="server" Text="Add Product" CssClass="crud-btn add-btn"
    OnClick="AddProductBtn_Click" />
                </div>

                <!-- Users Section -->
                <div id="users" class="tab-content">
    <h2>Users</h2>
    <asp:GridView ID="UsersGrid" runat="server" CssClass="styled-grid" AutoGenerateColumns="false"
        OnRowEditing="UsersGrid_RowEditing"
        OnRowCancelingEdit="UsersGrid_RowCancelingEdit"
        OnRowUpdating="UsersGrid_RowUpdating"
        OnRowCommand="UsersGrid_RowCommand"
        DataKeyNames="UserID">
        <Columns>
            <asp:BoundField DataField="UserID" HeaderText="ID" ReadOnly="true" />
            <asp:BoundField DataField="DietaryPreference" HeaderText="Dietary Preference" />
            <asp:BoundField DataField="AllergyRestrictions" HeaderText="Allergy Restrictions" />
            <asp:CommandField ShowEditButton="true" HeaderText="Actions" />
            <asp:TemplateField HeaderText="Delete">
                <ItemTemplate>
                    <asp:Button runat="server" Text="Delete" CssClass="crud-btn delete-btn"
                        CommandName="DeleteUser" CommandArgument='<%# Eval("UserID") %>' />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

                <!-- Diet Types Section -->
                <div id="diet" class="tab-content">
                    <h2>Diet Types</h2>
                    <asp:GridView ID="DietGrid" runat="server" CssClass="styled-grid" AutoGenerateColumns="false"
                        OnRowEditing="DietGrid_RowEditing"
                        OnRowCancelingEdit="DietGrid_RowCancelingEdit"
                        OnRowUpdating="DietGrid_RowUpdating"
                        OnRowCommand="DietGrid_RowCommand"
                        DataKeyNames="DietTypeID">
                        <Columns>
                            <asp:BoundField DataField="DietTypeID" HeaderText="ID" ReadOnly="true" />
                            <asp:BoundField DataField="Name" HeaderText="Diet Name" />
                            <asp:CommandField ShowEditButton="true" HeaderText="Actions" />
                            <asp:TemplateField HeaderText="Delete">
                                <ItemTemplate>
                                    <asp:Button runat="server" Text="Delete" CssClass="crud-btn delete-btn"
                                        CommandName="DeleteDiet" CommandArgument='<%# Eval("DietTypeID") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:Button ID="AddDietBtn" runat="server" Text="Add Diet Type" CssClass="crud-btn add-btn" />
                </div>
            </div>
        </div>
    </form>

    <script>
        function showTab(tabId) {
            document.querySelectorAll(".tab-content").forEach(tab => tab.classList.remove("active"));
            document.getElementById(tabId).classList.add("active");
        }
    </script>
</body>
</html>