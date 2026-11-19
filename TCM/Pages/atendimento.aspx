<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="atendimento.aspx.cs" Inherits="TCM.atendimento" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>

    <link rel="stylesheet" href="<%= ResolveUrl("~/Assets/css/cardapio.css") %>"
</head>
<body>
    <form id="form1" runat="server">
        <div id="tudo">
            <div class="header">

            </div>
            <div class="carouselOfertas">

            </div>


            <div class="linhaDeProdutos">
                <h1 id="nomeCategoriaDeOfertaTexto">

                </h1>
                <div class="slotsProdutos">

                </div>
            </div>

            <div class="rodape">

            </div>
        </div>
    </form>

    <script src="<%= ResolveUrl("~/Scripts/jquery-3.7.1.min.js") %>"></script>
    <script src="<%= ResolveUrl("~/Scripts/jquery.signalR-2.4.3.min.js") %>"></script>
    <script src="<%= ResolveUrl("~/signalr/hubs") %>"></script>
    <script>
        $(function () {

            var hub = $.connection.hubs;

            function criarProdutos(produtos) { // recebe aqui as info dos produtos e cria os elementos das caixas dos pedidos


                let slot = document.createElement("div");
                slot.className = "slotProduto";

                let nome = document.createElement("h3");
                nome.textContent = produto.nome;
                nome.className = "nomeProduto"

                let imagem = document.createElement("img");
                imagem.src = produto.imagem;
                imagem.className = "imagemProduto";


                let preco = document.createElement("p");
                preco.textContent = "R$ " + produto.preco;


                slot.appendChild(nome);
                slot.appendChild(preco);

                return slot;

            }
            


            function gerarCardapio(listaProdutos) {

                let guardar = document.getElementById("slotsProdutos"); // falta organizar aonde gerar o cardápio (tipo, se ele vai ser gerado como promoção, como dias da semana, etc)

                listaProdutos.forEach(function (produto) { // vai pegar cada produto que vai tar guardado no array listaProdutos, ai vai criar a pora toda ali com o método de cima de criarProdutos (que vaig erar o negócio certinho)

                    let slot = criarProduto(produto);

                    guardar.appendChild(card);

                });

            }



        });
    </script>
</body>
</html>
