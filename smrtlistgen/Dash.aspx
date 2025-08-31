<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dash.aspx.cs" Inherits="smrtlistgen.Dash" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Smart Shopping List</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet" media="print" onload="this.media='all'" />
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            color: white;
            min-height: 100vh;
            background: url('https://images.unsplash.com/photo-1600891964599-f61ba0e24092?auto=format&fit=crop&w=800&q=60') no-repeat center center/cover;
            position: relative;
            display: flex;
            flex-direction: column;
        }

        body::before {
            content: "";
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.6);
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
            user-select: none;
        }

        header svg {
            width: 36px;
            height: 36px;
            fill: #feb47b;
            filter: drop-shadow(0 0 4px #ff7e5f);
        }

        header h1 {
            font-size: 1.5rem;
            font-weight: 700;
            color: #feb47b;
            text-shadow: 0 0 6px #ff7e5f;
        }

        .main-wrapper {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
            z-index: 2;
            position: relative;
        }

        .container {
            display: flex;
            max-width: 1200px;
            width: 100%;
            background: rgba(255,255,255,0.05);
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 15px 40px rgba(0,0,0,0.7);
        }

        .left-section {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 50px 40px;
            backdrop-filter: blur(2px);
        }

        .left-section h1 {
            font-size: 3em;
            margin-bottom: 20px;
            line-height: 1.2;
        }

        .left-section p {
            font-size: 1.2em;
            max-width: 500px;
            opacity: 0.9;
        }

        .right-section {
            flex: 1.3;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 30px 40px;
            position: relative;
            background: rgba(0,0,0,0.2);
            backdrop-filter: blur(10px);
        }

        .form-card {
            max-width: 600px;
            width: 100%;
            background: rgba(255, 255, 255, 0.12);
            backdrop-filter: blur(12px);
            padding: 40px 50px;
            border-radius: 18px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.5);
            display: flex;
            flex-direction: column;
        }

        .form-card h2 {
            text-align: center;
            margin-bottom: 25px;
            font-size: 2em;
            font-weight: 600;
        }

        form {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            justify-content: center;
        }

        label {
            font-size: 1.1em;
            color: rgba(255, 255, 255, 0.9);
            margin-bottom: 5px;
            width: 100%;
        }

        input, select {
            border-radius: 10px;
            border: none;
            font-size: 1.1em;
            padding: 14px 16px;
            background: rgba(255, 255, 255, 0.2);
            color: white;
            flex: 1 1 200px;
            min-width: 180px;
            transition: border 0.3s ease;
        }

        select option {
            color: #000000; /* Black text for visibility */
            background: #ffffff; /* White background for contrast */
        }

        input:focus, select:focus {
            outline: none;
            border: 2px solid #feb47b;
        }

        input::placeholder {
            color: rgba(255,255,255,0.8);
        }

        button {
            color: white;
            font-weight: 700;
            cursor: pointer;
            padding: 14px 0;
            flex: 1 1 100px;
            max-width: 220px;
            border-radius: 10px;
            border: none;
            font-size: 1.1em;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        button:hover {
            transform: scale(1.05);
            box-shadow: 0 6px 20px rgba(0,0,0,0.5);
        }

        .preview-btn {
            background: linear-gradient(90deg, #4facfe, #00f2fe); /* Blue gradient for PreviewButton */
        }

        .preview-btn:hover {
            background: linear-gradient(90deg, #3e8e41, #00c4b4);
        }

        .add-more-btn {
            background: linear-gradient(90deg, #667eea, #764ba2); /* Purple gradient for AddMoreBtn */
        }

        .add-more-btn:hover {
            background: linear-gradient(90deg, #5a67d8, #653a8f);
        }

        .done-btn {
            background: linear-gradient(90deg, #00b4db, #0083b0); /* Teal gradient for DoneButton */
        }

        .done-btn:hover {
            background: linear-gradient(90deg, #009fc2, #006d8f);
        }

        .report-btn {
            background: linear-gradient(90deg, #f7971e, #ffd200); /* Orange gradient for reportBtn */
            max-width: 320px;
            margin-left: auto;
            margin-right: auto;
            display: block;
        }

        .report-btn:hover {
            background: linear-gradient(90deg, #e0881b, #e6bc00);
        }

        .delete-btn {
            background: linear-gradient(90deg, #e52d27, #b31217); /* Red gradient for DeleteButton */
            padding: 8px;
            max-width: 80px;
        }

        .delete-btn:hover {
            background: linear-gradient(90deg, #c91b15, #8f0e12);
        }

        .add-btn {
            background: linear-gradient(90deg, #00c9a7, #008b74); /* Green-blue gradient for AddButton */
            padding: 8px;
            max-width: 80px;
        }

        .add-btn:hover {
            background: linear-gradient(90deg, #00a88a, #006b58);
        }

        .search-container {
            width: 100%;
            margin-bottom: 20px;
            position: relative;
        }

        .search-container input {
            width: 100%;
            padding-right: 40px;
        }

        .search-icon {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: rgba(255,255,255,0.8);
        }

        .validation-error {
            color: #ff6b6b;
            font-size: 0.9em;
            margin-top: 5px;
            width: 100%;
        }

        .styled-grid {
            width: 100%;
            margin-top: 30px;
            border-collapse: collapse;
            border-radius: 12px;
            overflow: hidden;
            background: rgba(255, 255, 255, 0.1);
            box-shadow: 0 8px 30px rgba(0,0,0,0.4);
        }

        .styled-grid th {
            background: rgba(0, 0, 0, 0.3);
            font-weight: 600;
            color: #ffd27f;
            cursor: pointer;
            position: relative;
            padding-right: 30px;
        }

        .styled-grid th:hover {
            background: rgba(0, 0, 0, 0.5);
        }

        .styled-grid th, .styled-grid td {
            padding: 14px 16px;
            text-align: left;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
        }

        .styled-grid tbody tr:nth-child(odd) {
            background: rgba(255,255,255,0.05);
        }

        .styled-grid tr:hover {
            background: rgba(255, 255, 255, 0.15);
        }

        .styled-grid td {
            color: white;
        }

        .sort-icon {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 0.8em;
        }

        .styled-grid th .sort-icon::after {
            content: ' ↕';
        }

        .styled-grid th.sort-asc .sort-icon::after {
            content: ' ↑';
        }

        .styled-grid th.sort-desc .sort-icon::after {
            content: ' ↓';
        }

        #totalCost {
            margin-top: 20px;
            font-weight: 700;
            font-size: 1.5em;
            text-align: center;
            letter-spacing: 0.05em;
            user-select: none;
        }

        #reportBtn {
            margin-top: 25px;
            box-shadow: 0 6px 20px rgba(247,151,30,0.6);
            transition: background 0.3s ease, transform 0.2s;
        }

        #loading {
            display: none;
            text-align: center;
            color: #feb47b;
            margin-top: 20px;
            font-size: 1.2em;
        }

        .add-more-panel {
            margin-top: 30px;
            background: rgba(255, 255, 255, 0.08);
            padding: 20px;
            border-radius: 12px;
        }

        .add-more-panel h3 {
            text-align: center;
            margin-bottom: 15px;
        }

        @media (max-width: 900px) {
            .container {
                flex-direction: column;
                border-radius: 0;
                box-shadow: none;
            }

            .right-section {
                flex: none;
                padding: 20px;
                background: none;
                backdrop-filter: none;
            }

            .form-card {
                max-width: 100%;
                padding: 25px 30px;
                background: rgba(255,255,255,0.1);
                backdrop-filter: blur(6px);
                box-shadow: 0 6px 20px rgba(0,0,0,0.4);
            }

            .styled-grid th, .styled-grid td {
                padding: 10px;
            }
        }
    </style>
</head>
<body>
    <header>
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" aria-hidden="true" focusable="false">
            <path d="M54 18H36V13a6 6 0 0 0-12 0v5H10a3 3 0 0 0-3 3v3a3 3 0 0 0 3 3h1l5 19a5 5 0 0 0 4.9 3.7h21.2a5 5 0 0 0 4.9-3.7l5-19h1a3 3 0 0 0 3-3v-3a3 3 0 0 0-3-3zM26 13a4 4 0 0 1 8 0v5H26zm25 14-4.8 18.3a1 1 0 0 1-1 .7H19.8a1 1 0 0 1-1-.7L14 27z" />
        </svg>
        <h1>Smart Shopping List</h1>
    </header>

    <div class="main-wrapper">
        <div class="container">
            <div class="left-section">
                <h1>Shop Smarter, Eat Better</h1>
                <p>Plan your grocery shopping with a list tailored to your budget, diet, and allergies. Search, sort, and manage your items with ease.</p>
            </div>
            <div class="right-section">
                <div class="form-card">
                    <h2>Shopping List Preview</h2>
                    <form id="previewForm" runat="server">
                        <label for="budget">Budget (R):</label>
                        <asp:TextBox ID="budget" runat="server" placeholder="Enter your budget (e.g., 100.00)" required />
                        <asp:RegularExpressionValidator ID="BudgetValidator" runat="server" ControlToValidate="budget"
                            ValidationExpression="^\d+(\.\d{1,2})?$" ErrorMessage="Enter a valid amount (e.g., 100.00)" CssClass="validation-error" Display="Dynamic" />
                        
                        <label for="diet">Dietary Preference:</label>
                        <asp:DropDownList ID="diet" runat="server" AutoPostBack="false" CssClass="asp-input">
                            <asp:ListItem Value="" Text="Select dietary preference" Selected="True" />
                            <asp:ListItem Value="Any" Text="Any" />
                            <asp:ListItem Value="Vegetarian" Text="Vegetarian" />
                            <asp:ListItem Value="Gluten-Free" Text="Gluten-Free" />
                            <asp:ListItem Value="Low-Carb" Text="Low-Carb" />
                        </asp:DropDownList>
                        
                        <label for="allergy">Allergies (comma-separated):</label>
                        <asp:TextBox ID="allergy" runat="server" placeholder="e.g., peanuts, dairy" />
                        
                        <asp:Button ID="PreviewButton" runat="server" Text="Preview List" OnClick="PreviewButton_Click" CssClass="preview-btn" OnClientClick="showLoading();" />
                        
                        <asp:GridView ID="GridView1" runat="server" CssClass="styled-grid" AutoGenerateColumns="false" Caption="Shopping List Preview"
                            DataKeyNames="ProductID" OnRowCommand="GridView1_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="ItemName" HeaderText="Item" SortExpression="ItemName" />
                                <asp:BoundField DataField="Quantity" HeaderText="Quantity" SortExpression="Quantity" />
                                <asp:BoundField DataField="Price" HeaderText="Price (R)" DataFormatString="{0:C}" SortExpression="Price" />
                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <asp:Button ID="DeleteButton" runat="server" Text="Delete" CommandName="DeleteItem" 
                                            CommandArgument='<%# Eval("ProductID") %>' CssClass="delete-btn" 
                                            OnClientClick="return confirm('Are you sure you want to delete this item?');" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        
                        <div id="totalCost" runat="server"></div>
                        <asp:Button ID="reportBtn" runat="server" Text="Generate Report" Visible="false" OnClick="GenerateReport_Click" CssClass="report-btn" />
                        <asp:Button ID="AddMoreBtn" runat="server" Text="Add More Items" Visible="false" OnClick="AddMoreBtn_Click" CssClass="add-more-btn" />
                        
                        <asp:Panel ID="AddMorePanel" runat="server" Visible="false" CssClass="add-more-panel">
                            <h3>Add More Items</h3>
                            <div class="search-container">
                                <asp:TextBox ID="addSearchBox" runat="server" placeholder="Search for items to add..." ClientIDMode="Static" AutoPostBack="true" OnTextChanged="SearchMoreButton_Click" />
                                <span class="search-icon">🔍</span>
                            </div>
                            
                            <asp:GridView ID="SearchGrid" runat="server" CssClass="styled-grid" AutoGenerateColumns="false" 
                                DataKeyNames="ProductID" OnRowCommand="SearchGrid_RowCommand">
                                <Columns>
                                    <asp:BoundField DataField="ItemName" HeaderText="Item" />
                                    <asp:BoundField DataField="Quantity" HeaderText="Quantity" />
                                    <asp:BoundField DataField="Price" HeaderText="Price (R)" DataFormatString="{0:C}" />
                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                            <asp:Button ID="AddButton" runat="server" Text="Add" CommandName="AddItem" 
                                                CommandArgument='<%# Eval("ProductID") %>' CssClass="add-btn" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            
                            <asp:Button ID="DoneButton" runat="server" Text="Done Adding" OnClick="DoneButton_Click" CssClass="done-btn" />
                        </asp:Panel>
                        
                        <div id="loading">Generating your list...</div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>