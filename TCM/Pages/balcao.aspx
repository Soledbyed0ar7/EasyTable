
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="balcao.aspx.cs" Inherits="TCM.balcao" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Painel do Balconista</title>

    <link rel="stylesheet" href="<%= ResolveUrl("~/Assets/css/balcao.css") %>" />

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@200..700&display=swap" rel="stylesheet">
</head>
<body>

    <form id="form1" runat="server">

        <div class="tudo">

            <h1>Consultar comanda</h1>

            <div class="areaConsulta">

                <asp:TextBox
                    ID="numMesa"
                    runat="server"
                    ClientIDMode="Static"
                    TextMode="Number"
                    min="1"
                    placeholder="Número da mesa">
                </asp:TextBox>

                <button type="button" id="verConta">
                    Ver Extrato
                </button>

            </div>

        </div>

        <div id="modalExtrato" class="modal">

            <div class="conteudoModal">

                <div class="cabecalhoModal">

                    <h2 id="tituloExtrato">Extrato da mesa</h2>

                    <button type="button" id="fecharModal">
                        <i class="fa-solid fa-xmark"></i>
                    </button>

                </div>

                <div id="listaProdutos"></div>

                <div class="resumoComanda">

                    <h3>Total da comanda</h3>

                    <span id="valorTotalComanda">R$ 0,00</span>

                </div>

                <button type="button" id="fecharComanda">
                    Fechar Comanda
                </button>

            </div>

        </div>

    </form>

    <script src="<%= ResolveUrl("~/Scripts/jquery-3.7.1.min.js") %>"></script>
    <script src="<%= ResolveUrl("~/Scripts/jquery.signalR-2.4.3.min.js") %>"></script>
    <script src="<%= ResolveUrl("~/signalr/hubs") %>"></script>

    <script>

        $(function () {

            var hub = $.connection.hubs;

            let idMesaAtual = null;

            const formatarPreco = new Intl.NumberFormat("pt-BR", {
                style: "currency",
                currency: "BRL"
            });

            function criarPedido(lista, mesa) {

                let area = document.getElementById("listaProdutos");

                area.innerHTML = "";

                let totalComanda = 0;

                document.getElementById("tituloExtrato").textContent =
                    "Extrato da mesa " + mesa;

                lista.forEach(function (produto) {

                    let valorTotal = Number(produto.valorTotal) || 0;
                    let quantidade = Number(produto.quantidade) || 0;

                    totalComanda += valorTotal;

                    let card = document.createElement("div");
                    card.className = "produtoExtrato";

                    let cabecalho = document.createElement("div");
                    cabecalho.className = "cabecalhoProduto";

                    let nome = document.createElement("h3");
                    nome.textContent = produto.nome;

                    let qtd = document.createElement("span");
                    qtd.textContent = quantidade + "x";

                    cabecalho.appendChild(nome);
                    cabecalho.appendChild(qtd);

                    let valores = document.createElement("div");
                    valores.className = "valoresProduto";

                    let precoUnitario = document.createElement("p");

                    let valorUnitarioFinal = quantidade > 0
                        ? valorTotal / quantidade
                        : 0;

                    precoUnitario.textContent =
                        "Preço unitário final: " +
                        formatarPreco.format(valorUnitarioFinal);

                    let precoTotal = document.createElement("p");

                    precoTotal.textContent =
                        "Total do produto: " +
                        formatarPreco.format(valorTotal);

                    valores.appendChild(precoUnitario);
                    valores.appendChild(precoTotal);

                    card.appendChild(cabecalho);
                    card.appendChild(valores);

                    if (produto.alteracoes && produto.alteracoes.length > 0) {

                        let alteracoes = document.createElement("div");
                        alteracoes.className = "alteracoesProduto";

                        let tituloAlteracoes = document.createElement("h4");
                        tituloAlteracoes.textContent = "Modificações";

                        alteracoes.appendChild(tituloAlteracoes);

                        produto.alteracoes.forEach(function (alteracao) {

                            let item = document.createElement("p");

                            if (alteracao.quantidade > 0) {

                                item.textContent =
                                    "+ Adicionar " + alteracao.nome +
                                    " (" + alteracao.quantidade + ")";

                                item.className = "alteracaoAdicionar";

                            }
                            else if (alteracao.quantidade < 0) {

                                item.textContent =
                                    "- Retirar " + alteracao.nome +
                                    " (" + Math.abs(alteracao.quantidade) + ")";

                                item.className = "alteracaoRetirar";

                            }

                            if (alteracao.quantidade !== 0) {
                                alteracoes.appendChild(item);
                            }

                        });

                        card.appendChild(alteracoes);

                    }

                    area.appendChild(card);

                });

                document.getElementById("valorTotalComanda").textContent =
                    formatarPreco.format(totalComanda);

                document.getElementById("modalExtrato").style.display = "flex";

            }

            document.getElementById("verConta").addEventListener("click", function () {

                let mesa = document.getElementById("numMesa").value;

                if (!mesa || Number(mesa) < 1) {

                    alert("Informe um número de mesa válido!");
                    return;

                }

                idMesaAtual = Number(mesa);

                hub.server.visualizarComanda(idMesaAtual)

                    .done(function (lista) {

                        if (!lista || lista.length === 0) {

                            alert("Essa mesa não possui itens na comanda.");
                            return;

                        }

                        criarPedido(lista, idMesaAtual);

                    })

                    .fail(function (erro) {

                        console.error("Erro ao consultar comanda:", erro);
                        alert("Não foi possível consultar a comanda.");

                    });

            });

            document.getElementById("fecharComanda").addEventListener("click", function () {

                if (idMesaAtual === null) {
                    return;
                }

                let confirmar = confirm(
                    "Deseja realmente fechar a comanda da mesa " + idMesaAtual + "?"
                );

                if (!confirmar) {
                    return;
                }

                hub.server.fecharComanda(idMesaAtual)

                    .done(function () {

                        alert("Comanda fechada com sucesso!");

                        document.getElementById("modalExtrato").style.display = "none";

                        document.getElementById("listaProdutos").innerHTML = "";

                        document.getElementById("valorTotalComanda").textContent =
                            formatarPreco.format(0);

                        document.getElementById("numMesa").value = "";

                        idMesaAtual = null;

                    })

                    .fail(function (erro) {

                        console.error("Erro ao fechar comanda:", erro);
                        alert("Não foi possível fechar a comanda.");

                    });

            });

            document.getElementById("fecharModal").addEventListener("click", function () {

                document.getElementById("modalExtrato").style.display = "none";

            });

            $.connection.hub.start()

                .done(function () {
                    console.log("Conexão com o SignalR estabelecida!");
                })

                .fail(function (erro) {
                    console.error("Erro na conexão com SignalR:", erro);
                });

        });

    </script>

</body>
</html>
