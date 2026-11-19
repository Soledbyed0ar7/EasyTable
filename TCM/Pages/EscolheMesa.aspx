<%@ Page Language="C#" AutoEventWireup="true"  CodeBehind="EscolheMesa.aspx.cs" Inherits="TCM.index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link rel="stylesheet" href="<%= ResolveUrl("~/Assets/css/escolherMesa.css") %>">
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" />
        <div>
            <div id="areaDasMesas">

            </div>

        </div>

    </form>


    <script src="<%= ResolveUrl("~/Scripts/jquery-3.7.1.min.js") %>"></script>
    <script src="<%= ResolveUrl("~/Scripts/jquery.signalR-2.4.3.min.js") %>"></script>
    <script src="<%= ResolveUrl("~/signalr/hubs") %>"></script>

    </script> <!-- toda tela vai ter que ter esses 3 ai // pega a quantidade, cria a quantidade de botoes conforme a quantidade de botoes forem recebidas-->
    <script>
        $(function () {




            var hub = $.connection.hubs;

            hub.client.mesaReservadaAgora = function (num) {

                let botao = document.getElementById("btnMesa" + num);

                botao.disabled = true;
                botao.classList.add("trancada");

            };
            hub.client.mesaLiberadaAgora = function (num) {

                let botao = document.getElementById("btnMesa" + num);

                botao.disabled = false;
                botao.classList.remove("trancada");

            };



            function gerarMesas(numMesas) {

                let container = document.getElementById("areaDasMesas");

                for (let i = 1; i <= numMesas; i++) {
                    let botao = document.createElement("button");
                    botao.type = "button";
                    botao.id = "btnMesa" + i;
                    botao.textContent = "" + i;
                    botao.className = "mesa";
                    botao.onclick = function () {
                        let numero = Number(botao.textContent);
                        hub.server.reservarMesa(numero).done(function () {
                            console.log("a");
                            PageMethods.SelecionarMesa(numero);
                            console.log("b");
                            window.location.href = '<%= ResolveUrl("~/Pages/atendimento.aspx") %>';
                        });
 };

                    container.appendChild(botao);


                }
            }

            /*elementos */
            let txtBas1 = document.createElement("label");
            txtBas1.className = "textoMesa";
            txtBas1.textContent = "Escolha sua mesa";
            /* */

            function trancarMesas(array) {

                let tamanhoArray = array.length;

                for (let i = 0; i < tamanhoArray; i++) {

                    let botao = document.getElementById("btnMesa" + array[i]);
                    botao.disabled = true;
                    botao.classList.add("trancada");
                }

            }

            



            $.connection.hub.start().done(function () {

                hub.server.configurarTelaReservarMesa().done(function () {
                    limparMesaQuandousada().done(function () {

                        hub.server.mesaQtde().done(function (quantidade) {

                            gerarMesas(quantidade);

                            hub.server.mesasUsadas().done(function (array) {
                                trancarMesas(array);
                            });

                        });

                    });


                });

            });


            function limparMesaQuandousada() {
                
                return hub.server.mesaCookie().done(function (mesa) {
                    
                    if (mesa != -1) {
                        
                        hub.server.liberarMesa(Number(mesa)).done(function () {
                            
                            PageMethods.DeselecionarMesa(mesa);
                        });
                    }
                 });

                return $.Deferred().resolve().promise();
            }

            /*window.addEventListener("pageshow", function (event) {

                

                    limparMesaQuandousada()

                

            });*/

        });

        

        

    </script>


</body>
</html>
