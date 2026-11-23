
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="garcom.aspx.cs" Inherits="TCM.garcom" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Painel do Garçom</title>

    <link href="<%= ResolveUrl("~/Assets/css/garcom.css") %>" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">

        <div class="containerMesas">

            <div id="modalNotificacao" class="modal">

    <div class="conteudoModal">

        <h2>Novo pedido</h2>

        <p id="textoNotificacao"></p>

        <button onclick="abrirModalLiberacao()" type="button">
            Visualizar pedido
        </button>

    </div>

</div>




<div id="modalLiberacao" class="modal">

    <div class="conteudoModal">

        <h2>Confirmar pedido</h2>

        <p id="textoLiberacao"></p>

        <button onclick="responderPedido(true)" type="button">
            Confirmar
        </button>

        <button onclick="responderPedido(false)" type="button">
            Recusar
        </button>

    </div>

</div>

            <h1 class="textoMesa">Mesas</h1>

            <div id="areaDasMesas"></div>

        </div>

    </form>

    <script src="<%= ResolveUrl("~/Scripts/jquery-3.7.1.min.js") %>"></script>
    <script src="<%= ResolveUrl("~/Scripts/jquery.signalR-2.4.3.min.js") %>"></script>
    <script src="<%= ResolveUrl("~/signalr/hubs") %>"></script>

    <script>

        var hub = $.connection.hubs;

        let mesaNotificada = null;

        hub.client.avisarGarcons = function (idMesa) {

            mesaNotificada = idMesa;

            avisarGarcons(idMesa);

        };

        function gerarMesas(numMesas) {

            let area = document.getElementById("areaDasMesas");

            area.innerHTML = "";

            for (let i = 1; i <= numMesas; i++) {

                let mesa = document.createElement("div");

                mesa.className = "mesa";
                mesa.id = "mesa" + i;
                mesa.textContent = i;

                area.appendChild(mesa);

            }

        }

        $(function () {

            $.connection.hub.start().done(function () {

                hub.server.configGarcom().done(function () {

                    hub.server.mesaQtde().done(function (quantidade) {

                        gerarMesas(quantidade);

                    });

                });

            });

        });


        function avisarGarcons(idMesa) {

            document.getElementById("textoNotificacao").textContent =
                "A mesa " + idMesa + " enviou um pedido.";

            document.getElementById("modalNotificacao").style.display = "flex";

        }


        function abrirModalLiberacao() {

            document.getElementById("textoLiberacao").textContent =
                "Deseja liberar o pedido da mesa " + mesaNotificada + "?";

            document.getElementById("modalNotificacao").style.display = "none";

            document.getElementById("modalLiberacao").style.display = "flex";

        }


        function responderPedido(liberado) {

            if (mesaNotificada === null) {

                return;

            }

            let idMesa = mesaNotificada;

            hub.server.avisarLiberacao(idMesa, liberado)

                .done(function () {

                    console.log("Resposta enviada:", idMesa, liberado);

                    document.getElementById("modalLiberacao").style.display = "none";

                    document.getElementById("modalNotificacao").style.display = "none";

                    mesaNotificada = null;

                })

                .fail(function (erro) {

                    console.error("Erro ao enviar resposta:", erro);

                });

           

        }
        hub.client.tomarBan = function () {

            window.location.href = "<%=ResolveUrl("~/Pages/login.aspx")%>";
         };

    </script>

</body>
</html>
