using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace TCM
{
    public class BancoDados
    {
        private readonly string connectionString;

        // Recebe a string de conexão
        public BancoDados()
        {
            connectionString = ConfigurationManager.ConnectionStrings["MinhaConexao"].ConnectionString;
        }

        // Executa INSERT, UPDATE, DELETE, CREATE, DROP etc.
        public int Executar(string sql, params SqlParameter[] parametros)
        {
            using (SqlConnection conexao = new SqlConnection(connectionString))
            {
                using (SqlCommand comando = new SqlCommand(sql, conexao))
                {
                    if (parametros != null)
                        comando.Parameters.AddRange(parametros);

                    conexao.Open();

                    return comando.ExecuteNonQuery();
                }
            }
        }

        // Executa SELECT e retorna uma tabela com os resultados
        public DataTable Consultar(string sql, params SqlParameter[] parametros)
        {
            using (SqlConnection conexao = new SqlConnection(connectionString))
            {
                using (SqlCommand comando = new SqlCommand(sql, conexao))
                {
                    if (parametros != null)
                        comando.Parameters.AddRange(parametros);

                    using (SqlDataAdapter adaptador = new SqlDataAdapter(comando))
                    {
                        DataTable tabela = new DataTable();

                        adaptador.Fill(tabela);

                        return tabela;
                    }
                }
            }
        }

        // Retorna apenas um valor (COUNT, SUM, MAX etc.)
        public object ConsultarValor(string sql, params SqlParameter[] parametros)
        {
            using (SqlConnection conexao = new SqlConnection(connectionString))
            {
                using (SqlCommand comando = new SqlCommand(sql, conexao))
                {
                    if (parametros != null)
                        comando.Parameters.AddRange(parametros);

                    conexao.Open();

                    return comando.ExecuteScalar();
                }
            }
        }

        // Facilita a criação de parâmetros
        public static SqlParameter Param(string nome, object valor)
        {
            return new SqlParameter(nome, valor ?? DBNull.Value);
        }
    }

}