using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TCM.DAL;

namespace TCM.BLL
{
    public class FuncionarioBLL
    {
        public static bool LogarGarcom(String nome, String senha)
        {
            if (FuncionarioDAL.existeGarcom(nome,senha))
            {
                return true;
            }
            return false;
        }
        public static bool LogarCosinha(String nome, String senha)
        {
            if (FuncionarioDAL.existeCosinha(nome, senha))
            {
                return true;
            }
            return false;
        }
        public static bool LogarBalcao(String nome, String senha)
        {
            if (FuncionarioDAL.existeCosinha(nome, senha))
            {
                return true;
            }
            return false;
        }
    }
}