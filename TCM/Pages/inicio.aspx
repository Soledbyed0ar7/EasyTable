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
        <div id="inicio" class="centralizar">
        </div>


    </form>

    <script src="<%= ResolveUrl("~/Scripts/jquery-3.7.1.min.js") %>"></script>
    <script src="<%= ResolveUrl("~/Scripts/jquery.signalR-2.4.3.min.js") %>"></script>
    <script src="<%= ResolveUrl("~/signalr/hubs") %>"></script>
    <script>

        let box = document.getElementById("inicio");

        
        let botaoIniciar = document.createElement("button");
        botaoIniciar.id = "btnInicial";
        botaoIniciar.className = "btnIniciar centralizar"
        botaoIniciar.textContent = "Iniciar"
        botaoIniciar.type = "button";



        box.appendChild(botaoIniciar);

        document.getElementById("btnInicial").onclick = function () {
            window.location.href = src="<%=ResolveUrl("~/Pages/EscolheMesa.aspx")%>";
        };

    </script>
</body>
</html>
