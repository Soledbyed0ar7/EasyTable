using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace TCM.DAL
{
    public class PedidoDAL
    {
        private static readonly BancoDados bd = new BancoDados();
        public static int criarNovoPedido(int idMesa)
        {
            object resultado = bd.ConsultarValor(
            @"INSERT INTO Pedido (idMesa, estadoPedido, desconto)
              OUTPUT INSERTED.idPedido
              VALUES (@idMesa, @estadoPedido, @desconto)",
            BancoDados.Param("@idMesa", idMesa),
            BancoDados.Param("@estadoPedido", "N"),
            BancoDados.Param("@desconto", Convert.ToDecimal(10.00))
            );
            return Convert.ToInt32(resultado);
        }
        public static int checarExistePedido(int IdMesa)
        {
            object objidPedido = bd.ConsultarValor("select idPedido from Pedido where idMesa = @idMesa and estadoPedido ='N'",
                BancoDados.Param("@idMesa", IdMesa));
            if (objidPedido == null)
            {
                return -1;
            }
            int idPedido = Convert.ToInt32(objidPedido);
            return idPedido;
        }
        public static void Npv(int idMesa)
        {
            bd.Executar(
                @"UPDATE Pedido
                  SET estadoPedido = 'V'
                  WHERE idMesa = @idMesa
                  AND estadoPedido = 'N'",
                BancoDados.Param("@idMesa", idMesa)
            );
        }
        public static void VpP(int idMesa)
        {
            bd.Executar(
                @"UPDATE Pedido
                  SET estadoPedido = 'P'
                  WHERE idMesa = @idMesa
                  AND estadoPedido = 'V'",
                BancoDados.Param("@idMesa", idMesa)
            );
        }
        public static void VpC(int idMesa)
        {
            bd.Executar(
                @"UPDATE Pedido
                  SET estadoPedido = 'C'
                  WHERE idMesa = @idMesa
                  AND estadoPedido = 'V'",
                BancoDados.Param("@idMesa", idMesa)
            );
        }
    }
}