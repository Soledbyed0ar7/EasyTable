
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="cozinha.aspx.cs" Inherits="TCM.cozinha" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Painel da Cozinha</title>

    <link rel="stylesheet" href="<%= ResolveUrl("~/Assets/css/cuzinho.css") %>" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@7.3.1/css/all.min.css">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@200..700&display=swap" rel="stylesheet">
</head>
<body>
    <form id="form1" runat="server">

        <div class="containerCozinha">

            <h1 class="tituloCozinha">Pedidos da cozinha</h1>

            <div id="areaPedidos"></div>

        </div>

    </form>

    <script src="<%= ResolveUrl("~/Scripts/jquery-3.7.1.min.js") %>"></script>
    <script src="<%= ResolveUrl("~/Scripts/jquery.signalR-2.4.3.min.js") %>"></script>
    <script src="<%= ResolveUrl("~/signalr/hubs") %>"></script>

    <script>

        $(function () {

            var hub = $.connection.hubs;

            hub.client.mostrarNovoPedido = function (lista, mesa) {
                criarPedido(lista, mesa);
            };


            function criarPedido(lista, mesa) {

                let card = document.createElement("div");
                card.className = "cardPedido";

                card.dataset.mesa = mesa;

                let cabecalho = document.createElement("div");
                cabecalho.className = "cabecalhoPedido";

                let titulo = document.createElement("h2");
                titulo.textContent = "Mesa " + mesa;

                cabecalho.appendChild(titulo);

                let conteudo = document.createElement("div");
                conteudo.className = "conteudoPedido";

                lista.forEach(function (produto) {

                    let linha = document.createElement("div");
                    linha.className = "linhaProduto";

                    let nome = document.createElement("h3");
                    nome.textContent = produto.nome;

                    let quantidade = document.createElement("span");
                    quantidade.className = "quantidadeProduto";
                    quantidade.textContent = produto.quantidade + "x";

                    let informacoes = document.createElement("div");
                    informacoes.className = "informacoesProduto";

                    informacoes.appendChild(nome);
                    informacoes.appendChild(quantidade);

                    linha.appendChild(informacoes);

                    if (produto.alteracoes && produto.alteracoes.length > 0) {

                        let alteracoes = document.createElement("div");
                        alteracoes.className = "alteracoesProduto";

                        produto.alteracoes.forEach(function (alteracao) {

                            let itemAlteracao = document.createElement("p");

                            if (alteracao.quantidade > 0) {

                                itemAlteracao.textContent =
                                    "+ Adicionar " + alteracao.nome +
                                    " (" + alteracao.quantidade + ")";

                                itemAlteracao.className = "alteracaoAdicionar";

                            }
                            else if (alteracao.quantidade < 0) {

                                itemAlteracao.textContent =
                                    "- Retirar " + alteracao.nome +
                                    " (" + Math.abs(alteracao.quantidade) + ")";

                                itemAlteracao.className = "alteracaoRetirar";

                            }

                            if (alteracao.quantidade !== 0) {
                                alteracoes.appendChild(itemAlteracao);
                            }

                        });

                        linha.appendChild(alteracoes);
                    }

                    conteudo.appendChild(linha);

                });

                let botaoPronto = document.createElement("button");

                botaoPronto.type = "button";
                botaoPronto.className = "botaoPedidoPronto";
                botaoPronto.innerHTML = '<i class="fa-solid fa-check"></i> Pedido pronto';

                botaoPronto.addEventListener("click", function () {

                    botaoPronto.disabled = true;
                    botaoPronto.textContent = "Pedido finalizado!";

                    setTimeout(function () {

                        card.style.maxHeight = card.scrollHeight + "px";

                        card.offsetHeight;

                        card.classList.add("removendoPedido");

                        card.addEventListener("transitionend", function (evento) {

                            if (evento.propertyName === "max-height") {
                                card.remove();
                            }

                        });

                    }, 1500);

                });

                card.appendChild(cabecalho);
                card.appendChild(conteudo);
                card.appendChild(botaoPronto);

                document.getElementById("areaPedidos").appendChild(card);
            }


            $.connection.hub.start().done(function () {

                hub.server.configCozinha();

            });

            hub.client.tomarBan = function () {

                window.location.href = "<%=ResolveUrl("~/Pages/login.aspx")%>";
                        };

        });

    </script>

</body>
</html>
