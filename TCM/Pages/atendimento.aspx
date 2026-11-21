
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
                <img src="<%= ResolveUrl("~/Assets/img/logocerta.png") %>" class="icone"/>
            </div>

            <div class="carouselOfertas">

            </div>

            <!-- Produtos -->

            <div class="linhaDeProdutos">

                <h1 id="nomeCategoriaDeOfertaTexto">

                </h1>

                <div id="slotsProdutos" class="slotsProdutoss">

                </div>

            </div>

            <!-- Modal do produto -->

            <div id="modalProduto">

                <div id="conteudoModal">

                    <button id="fecharModal" type="button">
                        <i class="fa-solid fa-circle-arrow-left"></i>
                    </button>

                    <div id="descricaoDoProduto"></div>

                    <div id="linhaSubProdutos"></div>

                    <button id="adicionarAoCarrinho" type="button" disabled>
                        Adicionar ao Carrinho
                    </button>

                </div>

            </div>

            <!-- Rodapé -->

            <div class="rodape">

            </div>

            <!-- Carrinho fixo -->

            <div class="carrinhoFixo">

                <div class="listaAtualCarrinho" id="listaAtualCarrinho">

                    <!-- Os produtos atuais serão criados pelo JavaScript -->

                </div>

                <div class="resumoCarrinho">

                    <div class="totalCarrinho">
                        <span>Total:</span>
                        <span id="valorTotalCarrinho">R$ 0,00</span>
                    </div>

                    <button type="button" id="abrirCarrinho">

                        <i class="fa-solid fa-cart-shopping"></i>

                        <span id="quantidadeCarrinho">0</span>

                    </button>

                </div>

            </div>

            <!-- Modal do carrinho -->

            <div id="modalCarrinho">

                <div id="conteudoModalCarrinho">

                    <div class="cabecalhoModalCarrinho">

                        <h2>Meu Carrinho</h2>

                        <button type="button" id="fecharCarrinho">
                            <i class="fa-solid fa-xmark"></i>
                        </button>

                    </div>

                    <div id="listaCompletaCarrinho">

                        <!-- Os produtos serão criados pelo JavaScript -->

                    </div>

                    <div class="rodapeModalCarrinho">

                        <div class="totalModalCarrinho">

                            <span>Total do pedido:</span>

                            <span id="valorTotalModal">R$ 0,00</span>

                        </div>

                        <button type="button" id="finalizarPedido">
                            Finalizar pedido
                        </button>

                    </div>

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

            let subprodutosDoModal = [];

            let produtoAtualNoModal = null;

            let subprodutosCarregados = false;

            let itensCarrinho = [];


            // ==========================================
            // CARRINHO
            // ==========================================


            function formatarMoeda(valor) {

                return Number(valor).toLocaleString("pt-BR", {
                    style: "currency",
                    currency: "BRL"
                });

            }


            function criarItemResumo(item) {

                let linha = document.createElement("div");

                linha.className = "itemResumoCarrinho";

                let nome = document.createElement("span");

                nome.textContent = item.quantidade + "x " + item.nome;

                let preco = document.createElement("span");

                preco.textContent = formatarMoeda(item.precoTotal);

                linha.appendChild(nome);

                linha.appendChild(preco);

                return linha;

            }


            function atualizarRodapeCarrinho() {

                let lista = document.getElementById("listaAtualCarrinho");

                let total = 0;

                let quantidadeTotal = 0;

                lista.innerHTML = "";

                itensCarrinho.forEach(function (item) {

                    lista.appendChild(criarItemResumo(item));

                    total += Number(item.precoTotal);

                    quantidadeTotal += Number(item.quantidade);

                });

                document.getElementById("valorTotalCarrinho").textContent =
                    formatarMoeda(total);

                document.getElementById("quantidadeCarrinho").textContent =
                    quantidadeTotal;

            }


            function criarItemCarrinho(item) {

                let caixa = document.createElement("div");

                caixa.className = "itemCarrinhoCompleto";


                let nome = document.createElement("h3");

                nome.textContent = item.nome;


                let precoUnitario = document.createElement("p");

                precoUnitario.textContent =
                    "Preço individual: " + formatarMoeda(item.precoUnitario);


                let modificacoes = document.createElement("div");

                modificacoes.className = "modificacoesCarrinho";


                (item.alteracoes || []).forEach(function (alteracao) {

                    let texto = document.createElement("p");

                    let sinal = alteracao.quantidade > 0 ? "+" : "";

                    texto.textContent =
                        sinal + alteracao.quantidade + "x " + alteracao.nome;

                    modificacoes.appendChild(texto);

                });


                let controles = document.createElement("div");

                controles.className = "controlesQuantidadeCarrinho";


                let diminuir = document.createElement("button");

                diminuir.type = "button";

                diminuir.textContent = "-";


                let quantidade = document.createElement("span");

                quantidade.textContent = item.quantidade;


                let aumentar = document.createElement("button");

                aumentar.type = "button";

                aumentar.textContent = "+";


                diminuir.addEventListener("click", function () {

                    atualizarQuantidadeItem(item.idPedidoProduto, -1);

                });


                aumentar.addEventListener("click", function () {

                    atualizarQuantidadeItem(item.idPedidoProduto, 1);

                });


                controles.appendChild(diminuir);

                controles.appendChild(quantidade);

                controles.appendChild(aumentar);


                let precoTotal = document.createElement("p");

                precoTotal.className = "precoTotalItemCarrinho";

                precoTotal.textContent =
                    "Total: " + formatarMoeda(item.precoTotal);


                caixa.appendChild(nome);

                caixa.appendChild(precoUnitario);

                caixa.appendChild(modificacoes);

                caixa.appendChild(controles);

                caixa.appendChild(precoTotal);


                return caixa;

            }


            function atualizarQuantidadeItem(idPedidoProduto, alteracao) {

                let item = itensCarrinho.find(function (produto) {

                    return produto.idPedidoProduto === idPedidoProduto;

                });

                if (!item) {

                    return;

                }


                item.quantidade += alteracao;


                if (item.quantidade <= 0) {

                    itensCarrinho = itensCarrinho.filter(function (produto) {

                        return produto.idPedidoProduto !== idPedidoProduto;

                    });

                } else {

                    item.precoTotal =
                        Number(item.precoUnitario) * Number(item.quantidade);

                }


                atualizarRodapeCarrinho();

                gerarListaCarrinho();

            }


            function gerarListaCarrinho() {

                let lista = document.getElementById("listaCompletaCarrinho");

                lista.innerHTML = "";


                if (itensCarrinho.length === 0) {

                    let mensagem = document.createElement("p");

                    mensagem.textContent = "Seu carrinho está vazio.";

                    lista.appendChild(mensagem);

                }


                itensCarrinho.forEach(function (item) {

                    lista.appendChild(criarItemCarrinho(item));

                });


                let total = itensCarrinho.reduce(function (soma, item) {

                    return soma + Number(item.precoTotal);

                }, 0);


                document.getElementById("valorTotalModal").textContent =
                    formatarMoeda(total);

            }



            // ==========================================
            // MODAL DO PRODUTO
            // ==========================================


            function abrirModalProduto(produto) {

                produtoAtualNoModal = produto;

                subprodutosCarregados = false;


                document.getElementById("adicionarAoCarrinho").disabled = true;

                document.getElementById("modalProduto").style.display = "flex";


                preencherModalProduto(produto);


                let espaco = document.getElementById("linhaSubProdutos");

                espaco.innerHTML = "Carregando subprodutos...";


                subprodutosDoModal = [];


                hub.server.listarSubprodutos(produto.idProduto)

                    .done(function (listaSubprodutos) {

                        console.log("Subprodutos recebidos:", listaSubprodutos);

                        gerarListaSubProdutos(listaSubprodutos);

                        subprodutosCarregados = true;

                        document.getElementById("adicionarAoCarrinho").disabled = false;

                    })

                    .fail(function (erro) {

                        console.error("Erro ao buscar subprodutos:", erro);

                        espaco.textContent =
                            "Não foi possível carregar os subprodutos.";

                    });

            }


            function fecharModalProduto() {

                document.getElementById("modalProduto").style.display = "none";

            }


            document.getElementById("fecharModal").addEventListener("click", fecharModalProduto);



            // ==========================================
            // ADICIONAR PRODUTO AO CARRINHO
            // ==========================================


            document.getElementById("adicionarAoCarrinho").addEventListener("click", function () {

                if (!produtoAtualNoModal || !subprodutosCarregados) {

                    return;

                }


                let botao = this;

                botao.disabled = true;


                let dados = {

                    idProduto: produtoAtualNoModal.idProduto,

                    quantidade: 1,

                    alteracoes: subprodutosDoModal.map(function (subproduto) {

                        return {

                            idSubProduto: subproduto.idSubProduto,

                            acao: subproduto.quantidadeSelecionada - subproduto.quantidade

                        };

                    }).filter(function (alteracao) {

                        return alteracao.acao !== 0;

                    })

                };


                console.log("Dados enviados:", dados);


                hub.server.salvarItemNoPedido(dados)

                    .done(function () {

                        console.log("Produto salvo com sucesso!");

                        console.log("Iniciando montagem do carrinho...");

                        hub.server.montarCarrinho()

                            .done(function (itensRecebidos) {

                                console.log("Carrinho recebido:", itensRecebidos);

                                itensCarrinho = itensRecebidos;

                                atualizarRodapeCarrinho();

                                fecharModalProduto();

                            })

                            .fail(function (erro) {

                                console.error("Erro ao montar carrinho:", erro);

                            });

                    })

                    .fail(function (erro) {

                        console.error("Erro ao salvar produto:", erro);

                    })

                    .always(function () {

                        botao.disabled = false;

                    });

            });



            // ==========================================
            // CRIAÇÃO DOS PRODUTOS DO CARDÁPIO
            // ==========================================


            function criarProduto(produto) {

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

                slot.appendChild(rodapezinho);

                rodapezinho.appendChild(valor);


                slot.addEventListener("click", function () {

                    abrirModalProduto(produto);

                });


                return slot;

            }


            function gerarCardapio(listaProdutos) {

                let guardar = document.getElementById("slotsProdutos");

                guardar.innerHTML = "";


                listaProdutos.forEach(function (produto) {

                    let slot = criarProduto(produto);

                    guardar.appendChild(slot);

                });

            }



            // ==========================================
            // CONEXÃO SIGNALR
            // ==========================================


            $.connection.hub.start()

                .done(function () {

                    hub.server.listarTodosProdutos()

                        .done(function (listaProdutos) {

                            console.log("Produtos recebidos:", listaProdutos);

                            gerarCardapio(listaProdutos);

                        })

                        .fail(function (erro) {

                            console.error("Erro ao buscar produtos:", erro);

                        });

                })

                .fail(function (erro) {

                    console.error("Erro ao conectar ao SignalR:", erro);

                });



            // ==========================================
            // PREENCHER MODAL DO PRODUTO
            // ==========================================


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



            // ==========================================
            // SUBPRODUTOS
            // ==========================================


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

                valor.textContent =
                    "R$ " + Number(subproduto.valor).toFixed(2).replace(".", ",");


                let quantidade = document.createElement("span");

                quantidade.textContent = subproduto.quantidadeSelecionada;


                let diminuir = document.createElement("button");

                diminuir.type = "button";

                diminuir.textContent = "-";


                let aumentar = document.createElement("button");

                aumentar.type = "button";

                aumentar.textContent = "+";


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


                esquerda.appendChild(nome);

                esquerda.appendChild(valor);


                direita.appendChild(diminuir);

                direita.appendChild(quantidade);

                direita.appendChild(aumentar);


                linha.appendChild(esquerda);

                linha.appendChild(direita);


                return linha;

            }



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



            // ==========================================
            // ABRIR E FECHAR CARRINHO
            // ==========================================


            function abrirCarrinho() {

                gerarListaCarrinho();

                document.getElementById("modalCarrinho").style.display = "flex";

            }


            function fecharCarrinho() {

                document.getElementById("modalCarrinho").style.display = "none";

            }


            document.getElementById("abrirCarrinho").addEventListener("click", abrirCarrinho);


            document.getElementById("fecharCarrinho").addEventListener("click", fecharCarrinho);


            document.getElementById("modalCarrinho").addEventListener("click", function (evento) {

                if (evento.target === this) {

                    fecharCarrinho();

                }

            });



            // ==========================================
            // FINALIZAR PEDIDO
            // ==========================================


            document.getElementById("finalizarPedido").addEventListener("click", function () {

                if (itensCarrinho.length === 0) {

                    alert("Seu carrinho está vazio!");

                    return;

                }


                alert("Pedido preparado! A integração para enviar a solicitação ao garçom será implementada posteriormente.");

            });


        });

    </script>

</body>
</html>
