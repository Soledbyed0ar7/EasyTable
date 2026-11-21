<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="atendimento.aspx.cs" Inherits="TCM.atendimento" %>

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
<body>
    <form id="form1" runat="server">
        <div id="tudo">
            <div class="header">
                <img src="<%= ResolveUrl("~/Assets/img/logocerta.png") %>" class="icone"/>;
            </div>
            <div class="carouselOfertas">

            </div>



            <!-- produtos e os caraio tudo -->

            <div class="linhaDeProdutos">
                <h1 id="nomeCategoriaDeOfertaTexto"> <!-- tem que lembrar aq de fazer o esquema de categoria e a pora toda -->

                </h1>

                
                <div id="slotsProdutos" class="slotsProdutoss">
                    <div class="rodapeProduto">

                    </div>

                </div>
            </div>

            <!-- modais (produto-->

                <div id="modalProduto">
                    <div id="conteudoModal">


                        <button id="fecharModal" type="button">  
                            <i class="fa-solid fa-circle-arrow-left"></i> 

                        </button> <!-- ver direito aq -->



                        <div id="descricaoDoProduto"> </div>


                        <div id="linhaSubProdutos"> </div>

                    </div>
                </div>

            <!-- fim dos produtos-->

            <div class="rodape">

            </div>

            <div class="carrinhoFixo">
                <!-- tem que meter o icone do carrinho aq -->
                <div class="listaAtualCarrinho">
                    <button onclick="abrirCarrinho()">Ver pedido</button>
                </div>

                

                
            </div>
        </div>
    </form>

    <script src="<%= ResolveUrl("~/Scripts/jquery-3.7.1.min.js") %>"></script>
    <script src="<%= ResolveUrl("~/Scripts/jquery.signalR-2.4.3.min.js") %>"></script>
    <script src="<%= ResolveUrl("~/signalr/hubs") %>"></script>
    <script>
        $(function () {

            var hub = $.connection.hubs;

            let subprodutosDoModal = []; // ???

            function abrirModalProduto(produto) {

                document.getElementById("modalProduto").style.display = "flex";

                preencherModalProduto(produto);

                let espaco = document.getElementById("linhaSubProdutos");
                espaco.innerHTML = "Carregando subprodutos...";

                subprodutosDoModal = [];

                hub.server.listarSubprodutos(produto.idProduto)
                    .done(function (listaSubprodutos) {

                        console.log("Subprodutos recebidos:", listaSubprodutos);

                        gerarListaSubProdutos(listaSubprodutos);

                    })
                    .fail(function (erro) {

                        console.error("Erro ao buscar subprodutos:", erro);

                        espaco.textContent = "Não foi possível carregar os subprodutos.";

                    });
            }

            function fecharModalProduto() {
                document.getElementById("modalProduto").style.display = "none";
            }

            document.getElementById("fecharModal").addEventListener("click", fecharModalProduto);






            function criarProduto(produto) { // recebe aqui as info dos produtos e cria os elementos das caixas dos pedidos


                let slot = document.createElement("div");
                slot.className = "slotProduto";



                let nome = document.createElement("h3");
                nome.textContent = produto.nome;
                nome.className = "nomeProduto";

                let foto = document.createElement("img");
                foto.src = "/Assets/img/" + produto.imagem + ".jpg";
                foto.className = "imagemProduto";

                let rodapezinho = document.createElement("div");
                rodapezinho.className = "rodapeProduto";

                let valor = document.createElement("p");
                valor.textContent = "R$ " + produto.valor;

                slot.appendChild(nome);
                slot.appendChild(foto);
                slot.appendChild(rodapezinho)
                rodapezinho.appendChild(valor);


                slot.addEventListener("click", function () { // aq é a função pra abrir o modal lá do produto
                    abrirModalProduto(produto);

                });

                return slot;

            };


                function gerarCardapio(listaProdutos) {

                    let guardar = document.getElementById("slotsProdutos"); // falta organizar aonde gerar o cardápio (tipo, se ele vai ser gerado como promoção, como dias da semana, etc)

                    guardar.innerHTML = ""; //aproveita aq pra limpar qualquer coisa que tenha anterior

                    listaProdutos.forEach(function (produto) { // vai pegar cada produto que vai tar guardado no array listaProdutos, ai vai criar a pora toda ali com o método de cima de criarProdutos (que vaig erar o negócio certinho)

                        let slot = criarProduto(produto);

                        guardar.appendChild(slot);

                    });

                }


            $.connection.hub.start().done(function () { // aq começa o signal R


                hub.server.listarTodosProdutos().done(function (listaProdutos) {

                    console.log("Produtos recebidos:", listaProdutos); // temporário

                    gerarCardapio(listaProdutos);

                    

                });
                                
            })
            .fail(function (erro) { // recomendado, pra avisar se nao conectar direito

                console.error("Erro ao conectar ao SignalR:", erro);

            });
            
            

                // daqui pra baixo é outra coisa

            /*
                function preencherModalProduto(produto) {

                    let area = document.getElementById("descricaoDoProduto");

                    let foto = document.createElement("img");
                    foto.src = produto.imagem;

                    let nome = document.createElement("h2");
                    nome.textContent = produto.nome;

                    let descricao = document.createElement("p");
                    descricao.textContent = produto.descricao;

                    area.appendChild(foto);
                    area.appendChild(nome);
                    area.appendChild(descricao);
                }

                function criarLinhaSubProduto(subproduto) {
                    let espaco = document.getElementById("linhaSubProdutos");

                }

            function gerarListaSubProdutos(listaSubprodutos) {

                let espaco = document.getElementById("listaSubprodutos");

                listarSubprodutos.forEach(function (subproduto) {

                    let linha = criarLinhaSubProduto(subproduto);

                    linha.dataset.id = subproduto.id;

                    espaco.appendChild(linha);

                });
            }

            */
            function preencherModalProduto(produto) {

                let area = document.getElementById("descricaoDoProduto");

                area.innerHTML = "";

                let foto = document.createElement("img");
                foto.src = "/Assets/img/" + produto.imagem + ".jpg";

                let nome = document.createElement("h2");
                nome.textContent = produto.nome;

                let descricao = document.createElement("p");
                descricao.textContent = produto.descricao;

                area.appendChild(foto);
                area.appendChild(nome);
                area.appendChild(descricao);
            }

            function criarLinhaSubProduto(subproduto) {

                let linha = document.createElement("div");

                let esquerda = document.createElement("div");

                let direita = document.createElement("div");

                linha.className = "linhaSubProduto";
                linha.dataset.idSubProduto = subproduto.idSubProduto;

                esquerda.className = "esquerdaSubProduto";
                direita.className = "direitaSubProduto";

                let nome = document.createElement("span");
                nome.textContent = subproduto.nome;

                let valor = document.createElement("span");
                valor.textContent = "R$ " + Number(subproduto.valor).toFixed(2).replace(".", ",");

                let quantidade = document.createElement("span");
                quantidade.textContent = subproduto.quantidadeSelecionada;

                let diminuir = document.createElement("button");
                diminuir.type = "button";
                diminuir.textContent = "-";

                let aumentar = document.createElement("button");
                aumentar.type = "button";
                aumentar.textContent = "+";


                let avancar = document.createElement("button");
                avancar.type = "button";
                avancar.textContent = "Adicionar ao Carrinho";
                avancar.className = "avancarAoCarrinho";


                diminuir.addEventListener("click", function () {

                    if (subproduto.quantidadeSelecionada > 0) {

                        subproduto.quantidadeSelecionada--;

                        quantidade.textContent = subproduto.quantidadeSelecionada;

                    }

                });

                aumentar.addEventListener("click", function () {

                    subproduto.quantidadeSelecionada++;

                    quantidade.textContent = subproduto.quantidadeSelecionada;

                });

                avancar.addEventListener("click", function () {

                    fecharModalProduto(produto);

                    // TEM QUE FAZER ESSA JOMBA AQUI PRA MANDAR PRO CARRINHO MANO

                });

                esquerda.appendChild(nome);
                esquerda.appendChild(valor);

                direita.appendChild(diminuir);
                direita.appendChild(quantidade);
                direita.appendChild(aumentar);

                linha.appendChild(esquerda);
                linha.appendChild(direita);

                return linha;
            }

                adicionarAoCarrinho //

            function gerarListaSubProdutos(listaSubprodutos) {

                let espaco = document.getElementById("linhaSubProdutos");

                espaco.innerHTML = "";

                subprodutosDoModal = listaSubprodutos.map(function (subproduto) {

                    return {
                        idSubProduto: subproduto.idSubProduto,
                        nome: subproduto.nome,
                        valor: subproduto.valor,
                        quantidade: subproduto.quantidade,
                        quantidadeSelecionada: subproduto.quantidade
                    };

                });

                subprodutosDoModal.forEach(function (subproduto) {

                    let linha = criarLinhaSubProduto(subproduto);

                    espaco.appendChild(linha);

                });
            }



                function abrirCarrinho() {
                    //tem que fazer aq ainda, mas a ideia é daí ele abrir o modal, e vai ter que pegar os dados, puxar os dados lá pra atualizaar as listas já no modal do carrinho depois
                }



        });

        
    </script>
</body>
</html>
