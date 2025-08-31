<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Report.aspx.cs" Inherits="smrtlistgen.Report" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Smart Shopping List Report</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Roboto', sans-serif;
            color: #333;
            min-height: 100vh;
            background: linear-gradient(135deg, #f8f8f8, #e8e8e8);
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 120px 60px; /* Increased for larger page */
        }

        body::before {
            content: "";
            position: fixed;
            inset: 0;
            background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" opacity="0.05"><circle cx="50" cy="50" r="40" fill="none" stroke="%23cccccc" stroke-width="2"/><circle cx="20" cy="20" r="10" fill="none" stroke="%23bbbbbb" stroke-width="1"/><circle cx="80" cy="80" r="15" fill="none" stroke="%23aaaaaa" stroke-width="1.5"/></svg>') repeat;
            z-index: 0;
        }

        header {
            background: #d3d3d3;
            color: #333;
            padding: 25px 60px; /* Increased padding */
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 100;
        }

        header svg { 
            width: 56px; /* Larger icon */
            height: 56px; 
            fill: #666; 
            margin-right: 20px; /* Increased margin */
            transition: transform 0.3s ease; 
        }
        header svg:hover { transform: scale(1.1); }
        header h1 { 
            font-family: 'Playfair Display', serif; 
            font-size: 2.5rem; /* Larger font */
            font-weight: 700; 
            color: #555; 
        }

        .main-wrapper { 
            flex: 1; 
            display: flex; 
            justify-content: center; 
            align-items: center; 
            padding: 120px 60px 100px; /* Increased for larger page */
            z-index: 1; 
        }

        .report-container {
            max-width: 1600px; /* Significantly increased for larger flexbox */
            width: 100%;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px; /* Larger border radius */
            padding: 50px; /* Increased padding */
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(200, 200, 200, 0.5);
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            animation: fadeIn 0.5s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .report-header { 
            margin-bottom: 40px; /* Increased margin */
            position: relative; 
        }
        .report-header h2 { 
            font-family: 'Playfair Display', serif; 
            font-size: 3.5rem; /* Larger font */
            font-weight: 700; 
            color: #888; 
            text-shadow: 0 0 3px rgba(136, 136, 136, 0.3); 
        }
        .report-header::after { 
            content: ""; 
            display: block; 
            width: 150px; /* Wider underline */
            height: 3px; /* Slightly thicker */
            background: #ccc; 
            margin: 20px auto; /* Increased margin */
        }

        .report-details { 
            width: 100%; 
            margin-bottom: 30px; /* Increased margin */
        }
        .report-details p { 
            font-size: 1.4rem; /* Larger font */
            margin: 12px 0; /* Increased margin */
            color: #333; 
        }
        .report-details span { 
            font-weight: 700; 
            color: #777; 
        }

        .report-table-container {
            width: 100%;
            max-width: 1200px; /* Increased for larger table */
            position: relative;
            margin-bottom: 30px; /* Increased margin */
        }

        .sort-info {
            font-size: 1.3rem; /* Larger font */
            font-weight: 500;
            color: #777;
            text-align: left;
            margin-bottom: 15px; /* Increased margin */
        }

        .report-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin: 20px 0;
            border-radius: 8px;
            overflow: hidden;
            position: relative;
        }

        .report-table th {
            background: #d3d3d3;
            color: #333;
            font-weight: 700;
            padding: 20px; /* Increased padding */
            text-align: left;
            font-size: 1.3rem; /* Larger font */
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .report-table th:first-child { border-top-left-radius: 8px; }
        .report-table th:last-child { border-top-right-radius: 8px; }

        .report-table td {
            padding: 20px; /* Increased padding */
            border-bottom: 1px solid rgba(0,0,0,0.05);
            color: #333;
            position: relative;
            font-size: 1.2rem; /* Larger font */
        }

        .report-table td:hover::after {
            content: attr(data-tooltip);
            position: absolute;
            bottom: 100%;
            left: 50%;
            transform: translateX(-50%);
            background: #333;
            color: #fff;
            padding: 6px 12px; /* Slightly larger tooltip */
            border-radius: 4px;
            font-size: 1rem; /* Larger tooltip font */
            white-space: nowrap;
            z-index: 20;
        }

        .report-table tr:nth-child(even) { background: rgba(200,200,200,0.05); }
        .report-table tr:hover { background: rgba(150,150,150,0.1); transition: background 0.3s ease; }

        .total-cost, .error-message { 
            font-size: 1.6rem; /* Larger font */
            font-weight: 700; 
            color: #777; 
            margin: 25px 0; /* Increased margin */
        }
        .error-message { color: #ff6b6b; }

        .date-time-container {
            width: 100%;
            max-width: 1200px; /* Match table width */
            text-align: right;
            margin: 30px 0; /* Increased margin */
        }
        .date-time-container p {
            font-size: 1.3rem; /* Larger font */
            font-weight: 500;
            color: #777;
            margin: 8px 0; /* Increased margin */
        }

        footer { 
            position: fixed; 
            bottom: 0; 
            left: 0; 
            right: 0; 
            background: #d3d3d3; 
            color: #333; 
            padding: 20px; /* Increased padding */
            text-align: center; 
            font-size: 1rem; /* Larger font */
            z-index: 100; 
        }
        footer::before { 
            content: "Smart Shopping Solutions"; 
            position: absolute; 
            top: 50%; 
            left: 50%; 
            transform: translate(-50%, -50%); 
            font-family: 'Playfair Display', serif; 
            font-size: 1.6rem; /* Larger font */
            color: rgba(100, 100, 100, 0.3); 
        }

        @media print {
            body { background: white; color: black; padding: 20px; }
            body::before, header, footer { display: none; }
            .report-container { box-shadow: none; border: none; padding: 20px; background: white; max-width: 100%; }
            .report-header h2 { color: black; text-shadow: none; }
            .report-header::after { background: black; }
            .report-details p, .report-details span { color: black; }
            .report-table th { background: #e0e0e0; color: black; border-bottom: 2px solid #000; }
            .report-table td { color: black; border-bottom: 1px solid #000; }
            .report-table td:hover::after { display: none; }
            .report-table tr:nth-child(even) { background: #f5f5f5; }
            .total-cost, .error-message, .sort-info, .date-time-container p { color: black; }
            .date-time-container { text-align: center; }
        }

        @media (max-width: 600px) {
            .report-container { padding: 20px; max-width: 100%; }
            .report-header h2 { font-size: 2.2rem; }
            .report-details p { font-size: 1.1rem; }
            .report-table th, .report-table td { padding: 12px; font-size: 1rem; }
            .sort-info, .date-time-container p { font-size: 1rem; }
            .date-time-container { text-align: center; }
            .report-table-container { max-width: 100%; }
            .total-cost, .error-message { font-size: 1.2rem; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <header role="banner">
            <div style="display: flex; align-items: center;">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" aria-hidden="true" focusable="false" role="img" aria-label="Shopping cart icon">
                    <path d="M22 54a4 4 0 1 0 0-8 4 4 0 0 0 0 8zm24 0a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM10 12h8l6 24h28l6-18H22v-4h36a2 2 0 0 1 2 2l-6 18a2 2 0 0 1-2 1H24a2 2 0 0 1-2-1l-6-24H10a2 2 0 0 1-2-2V6H4a2 2 0 0 0 0 4h4v4a2 2 0 0 0 2 2z"/>
                </svg>
                <h1>Smart Shopping List</h1>
            </div>
        </header>

        <div class="main-wrapper">
            <div class="report-container" role="main">
                <div class="report-header">
                    <h2>Smart Shopping List</h2>
                </div>
                <div class="report-details">
                    <p><span>Budget:</span> <asp:Label ID="lblBudget" runat="server" /></p>
                    <p><span>Dietary Preference:</span> <asp:Label ID="lblDiet" runat="server" /></p>
                    <p><span>Allergies:</span> <asp:Label ID="lblAllergies" runat="server" /></p>
                </div>
                <div class="report-table-container">
                    <p class="sort-info"><span>Sorted By:</span> <asp:Label ID="lblSortCriteria" runat="server" Text="Item Name" /></p>
                    <asp:GridView ID="ReportGrid" runat="server" CssClass="report-table" AutoGenerateColumns="False">
                        <Columns>
                            <asp:BoundField DataField="ItemName" HeaderText="Item" ItemStyle-CssClass="item-cell" />
                            <asp:BoundField DataField="Quantity" HeaderText="Quantity" ItemStyle-CssClass="quantity-cell" />
                            <asp:BoundField DataField="Price" HeaderText="Price (R)" DataFormatString="{0:C}" ItemStyle-CssClass="price-cell" />
                        </Columns>
                    </asp:GridView>
                </div>
                <p class="total-cost"><span>Total Cost:</span> <asp:Label ID="lblTotalCost" runat="server" /></p>
                <p class="error-message"><asp:Label ID="lblErrorMessage" runat="server" /></p>
                <div class="date-time-container">
                    <p><span>Date:</span> <asp:Label ID="lblGeneratedDate" runat="server" Text="<%: TimeZoneInfo.ConvertTime(DateTime.Now, TimeZoneInfo.FindSystemTimeZoneById('South Africa Standard Time')).ToString('MMMM dd yyyy') %>" /></p>
                    <p><span>Time:</span> <asp:Label ID="lblGeneratedTime" runat="server" Text="<%: TimeZoneInfo.ConvertTime(DateTime.Now, TimeZoneInfo.FindSystemTimeZoneById('South Africa Standard Time')).ToString('hh:mm tt') %>" /></p>
                </div>
            </div>
        </div>

        <footer role="contentinfo">
            <span class="page-number">Page 1</span>
        </footer>
    </form>
</body>
</html>