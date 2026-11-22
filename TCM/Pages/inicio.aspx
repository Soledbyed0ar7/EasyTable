<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="inicio.aspx.cs" Inherits="TCM.inicio" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link rel="stylesheet" href="<%= ResolveUrl("~/Assets/css/inicio.css") %>">
</head>
<body>
    <form id="form1" runat="server">

        <div class="telaInicial">

            <img src="<%= ResolveUrl("~/Assets/img/logocerta.png") %>" class="logoInicial" />

        </div>
        <div id="inicio">
            <asp:Button ID="btnInicial" runat="server" Text="Iniciar" type="button" class="btnIniciar centralizar"/>
        </div>


    </form>

    <script src="<%= ResolveUrl("~/Scripts/jquery-3.7.1.min.js") %>"></script>
    <script src="<%= ResolveUrl("~/Scripts/jquery.signalR-2.4.3.min.js") %>"></script>
    <script src="<%= ResolveUrl("~/signalr/hubs") %>"></script>
    <script>


        window.addEventListener("scroll", function () {

            let botao = document.getElementById("btnInicial");

            if (window.scrollY > 30) {

                botao.classList.add("aparecer");

            }
            else {

                botao.classList.remove("aparecer");

            }

        });
    </script>
</body>
</html>
