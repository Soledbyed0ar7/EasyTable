<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="featuresAtendimento.aspx.cs" Inherits="TCM.Tests.featuresAtendimento" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>

        </div>
    </form>
    <script src="<%= ResolveUrl("~/Scripts/jquery-3.7.1.min.js") %>"></script>
    <script src="<%= ResolveUrl("~/Scripts/jquery.signalR-2.4.3.min.js") %>"></script>
    <script src="<%= ResolveUrl("~/signalr/hubs") %>"></script>

    <script>
        $(function () {
            var str = ["idProduto", "valor", "nome", "categoria", "descricao", "imagem"]
            var str2 = ["idSubProduto", "nome", "nome", "valor", "quantidade"]
            var hub = $.connection.hubs;
            $.connection.hub.start().done(function () {
                hub.server.listarTodosProdutos().done(function (dic) {
                    escreverConsole(dic, str);
                });
                console.log("----------------------------")
                hub.server.listarSubprodutos(1).done(function (dic) {
                    escreverConsole(dic, str2);
                });
            });
        });

        function escreverConsole(dados, chaves) {
            console.log(chaves.join("\t"));

            dados.forEach(item => {
                console.log(
                    chaves.map(chave => String(item[chave] ?? "")).join("\t")
                );
            });
        }
    </script>
</body>
</html>
