<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="smrtlistgen.login" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Smart Shopping List - Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet" />
    <style>
        * {
            padding: 0;
            box-sizing: border-box;
            margin: 0;
        }

        body {
            font-family: 'Poppins', sans-serif;
            color: white;
            min-height: 100vh;
            background: url('https://images.unsplash.com/photo-1600891964599-f61ba0e24092?auto=format&fit=crop&w=1600&q=80') no-repeat center center/cover;
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
            max-width: 800px;
            width: 100%;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.7);
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
            background: rgba(0, 0, 0, 0.2);
            backdrop-filter: blur(10px);
        }

        .form-card {
            max-width: 600px;
            width: 100%;
            background: rgba(255, 255, 255, 0.12);
            backdrop-filter: blur(12px);
            padding: 40px 50px;
            border-radius: 18px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.5);
            display: flex;
            flex-direction: column;
        }

        .form-card h2 {
            text-align: center;
            margin-bottom: 25px;
            font-size: 2em;
            font-weight: 600;
        }

        .asp-input {
            border-radius: 10px;
            border: none;
            font-size: 1.1em;
            padding: 14px 16px;
            background: rgba(255, 255, 255, 0.2);
            color: white;
            flex: 1 1 200px;
            min-width: 180px;
            margin-bottom: 15px;
            width: 100%;
        }

        .asp-input::placeholder {
            color: rgba(255, 255, 255, 0.8);
        }

        .asp-btn {
            background: linear-gradient(90deg, #ff7e5f, #feb47b);
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
            width: 100%;
        }

        .asp-btn:hover {
            transform: scale(1.05);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.5);
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
                background: rgba(255, 255, 255, 0.1);
                backdrop-filter: blur(6px);
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.4);
            }
            h3{
               color:black;
            }
        }
    </style>
</head>
<body>

<header>
    <!-- SVG shopping basket -->
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" aria-hidden="true">
        <path d="M54 18H36V13a6 6 0 0 0-12 0v5H10a3 3 0 0 0-3 3v3a3 3 0 0 0 3 3h1l5 19a5 5 0 0 0 4.9 3.7h21.2a5 5 0 0 0 4.9-3.7l5-19h1a3 3 0 0 0 3-3v-3a3 3 0 0 0-3-3zM26 13a4 4 0 0 1 8 0v5H26zm25 14-4.8 18.3a1 1 0 0 1-1 .7H19.8a1 1 0 0 1-1-.7L14 27z" />
    </svg>
    <h1>Smart Shopping List</h1>
</header>

<div class="main-wrapper">
    <div class="container">
        <div class="left-section">
            <h1>Welcome Back!</h1>
            <p>Sign in to manage your shopping list, budget, and preferences.</p>
            <br />
            <h3>Usename: smartList 
                Password :smList
            </h3>
        </div>
        <div class="right-section">
            <div class="form-card">
                <h2>Login</h2>

                <form id="form1" runat="server">
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="asp-input" Placeholder="Enter your Username" ></asp:TextBox>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="asp-input" Placeholder="Enter your password" TextMode="Password"></asp:TextBox>
                    <asp:Button ID="BtnLogin" runat="server" Text="Submit" CssClass="asp-btn" OnClick="BtnLogin_Click" />
                    <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
                </form>

            </div>
        </div>
    </div>
</div>

</body>
</html>
