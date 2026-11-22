using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using TCM.DAL;
namespace TCM.DAL
{   
    public class FuncionarioDAL
    {
        private static readonly BancoDados bd = new BancoDados();
        public static bool existeGarcom(String nome,String senha)
        {
            int dt = Convert.ToInt32(bd.ConsultarValor("select count(*) from Funcionario where usuario = @nome and senha = @senha and tipo = 'G' ",
                BancoDados.Param("@nome", nome),
                BancoDados.Param("@senha",senha)));
            if (dt == 0) return false;
            return true;
        }
        public static bool existeCosinha(String nome, String senha)
        {
            int dt = Convert.ToInt32(bd.ConsultarValor("select count(*) from Funcionario where usuario = @nome and senha = @senha and tipo = 'C' ",
                BancoDados.Param("@nome", nome),
                BancoDados.Param("@senha", senha)));
            if (dt == 0) return false;
            return true;
        }
        public static bool existeBalcao(String nome, String senha)
        {
            int dt = Convert.ToInt32(bd.ConsultarValor("select count(*) from Funcionario where usuario = @nome and senha = @senha and tipo = 'B' ",
                BancoDados.Param("@nome", nome),
                BancoDados.Param("@senha", senha)));
            if (dt == 0) return false;
            return true;
        }
    }
}