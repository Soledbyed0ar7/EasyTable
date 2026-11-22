<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="TCM.login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>

        <link rel="stylesheet" href="<%= ResolveUrl("~/Assets/css/cardapio.css") %>" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@7.3.1/css/all.min.css">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@200..700&display=swap" rel="stylesheet">


</head>
<body
    <form id="form1" runat="server">
        <div class="area">



            <p class="userSenha"> </p>
            <asp:TextBox ID="user" runat="server"></asp:TextBox>


            <p class="userSenha"> </p>
            <asp:TextBox ID="senha" runat="server"></asp:TextBox>


            <asp:Button ID="cadastrar" runat="server" Text="Cadastrar" class="btnCadastrar"/>

            </div>

        </form>
              <script src="<%= ResolveUrl("~/Scripts/jquery-3.7.1.min.js") %>"></script>
              <script src="<%= ResolveUrl("~/Scripts/jquery.signalR-2.4.3.min.js") %>"></script>
              <script src="<%= ResolveUrl("~/signalr/hubs") %>"></script>

    <script>

        $(function () {







        });




    </script>
</body>
</html>
