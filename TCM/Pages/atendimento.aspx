<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="atendimento.aspx.cs" Inherits="TCM.atendimento" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>

    <link rel="stylesheet" href="<%= ResolveUrl("~/Assets/css/cardapio.css") %>" />
</head>
<body>
    <form id="form1" runat="server">
        <div id="tudo">
            <div class="header">
                <img src="<%= ResolveUrl("~/Assets/img/logo.png") %>" class="icone"/>;
            </div>
            <div class="carouselOfertas">

            </div>



            <!-- produtos e os caraio tudo -->

            <div class="linhaDeProdutos">
                <h1 id="nomeCategoriaDeOfertaTexto"> <!-- tem que lembrar aq de fazer o esquema de categoria e a pora toda -->

                </h1>

                
                <div class="slotsProdutos">

                </div>
            </div>

            <!-- modais (produto-->

                <div id="modalProduto">
                    <div id="conteudoModal">


                        <button id="fecharModal"> <- </button>



                        <div class="descricaoDoProduto"> </div>


                        <div id="linhaSubProdutos"> </div>

                    </div>
                </div>

            <!-- fim dos produtos-->

            <div class="rodape">

            </div>

            <div class="carrinhoFixo">
                <!-- tem que meter o icone do carrinho aq -->
                <div class="listaAtualCarrinho">

                </div>

                <button onclick="abrirCarrinho()">Ver pedido</button>

                
            </div>
        </div>
    </form>

    <script src="<%= ResolveUrl("~/Scripts/jquery-3.7.1.min.js") %>"></script>
    <script src="<%= ResolveUrl("~/Scripts/jquery.signalR-2.4.3.min.js") %>"></script>
    <script src="<%= ResolveUrl("~/signalr/hubs") %>"></script>
    <script>
        $(function () {

            var hub = $.connection.hubs;

            $.connection.hub.start().done(function () {

                gerarCardapio(hub.server.listarTodosProdutos());

                                
            });

                function criarProdutos(produtos) { // recebe aqui as info dos produtos e cria os elementos das caixas dos pedidos


                    function abrirModalProduto() {
                        document.getElementById("modalProduto").style.display = "flex";
                    }

                    function fecharModalProduto() {
                        document.getElementById("modalProduto").style.display = "none";
                    }



                    let slot = document.createElement("div");
                    slot.className = "slotProduto";

                    slot.addEventListener("click", function () { // aq é a função pra abrir o modal lá do produto
                        abrirModalProduto();

                    });

                    document.getElementById("fecharModal").addEventListener("click", fecharModalProduto);

                    let nome = document.createElement("h3");
                    nome.textContent = produto.nome;
                    nome.className = "nomeProduto";



                    let foto = document.createElement("img");
                    foto.src = produto.imagem;
                    foto.className = "imagemProduto";



                    let preco = document.createElement("p");
                    preco.textContent = "R$ " + produto.preco;

                    slot.appendChild(foto);
                    slot.appendChild(nome);
                    slot.appendChild(preco);

                    return slot;

                }



                function gerarCardapio(listaProdutos) {

                    let guardar = document.getElementById("slotsProdutos"); // falta organizar aonde gerar o cardápio (tipo, se ele vai ser gerado como promoção, como dias da semana, etc)

                    listaProdutos.forEach(function (produto) { // vai pegar cada produto que vai tar guardado no array listaProdutos, ai vai criar a pora toda ali com o método de cima de criarProdutos (que vaig erar o negócio certinho)

                        let slot = criarProduto(produto);

                        guardar.appendChild(slot);

                    });

                }




                function preencherModalProduto(produto) {

                    let area = document.getElementById("descricaoDoProduto");

                    let foto = document.createElement("img");
                    foto.src = "/Assets/img/" + produto.img;

                    let nome = document.createElement("h2");
                    nome.textContent = produto.nome;

                    let descricao = document.createElement("p");
                    descricao.textContent = produto.descricao;

                    area.appendChild(nome);
                    area.appendChild(descricao);
                }

                function criarLinhaSubProduto(subproduto) {
                    let espaco = document.getElementById("linhaSubProdutos");


                }

                function gerarListaSubProdutos() {

                    let espaco = document.getElementById("listaSubprodutos");
                    listarSubprodutos.forEach(function (subproduto) {

                        let linha = criarLinhaSubProduto(subproduto);
                        linha.dataset.id = subproduto.id;

                        espaco.appendChild(linha);
             )
                };



                function abrirCarrinho() {
                    //tem que fazer aq ainda, mas a ideia é daí ele abrir o modal, e vai ter que pegar os dados, puxar os dados lá pra atualizaar as listas já no modal do carrinho depois
                }





        });
    </script>
</body>
</html>
