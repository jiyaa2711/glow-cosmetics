using System;
using System.Configuration;
using System.Data;
using MySql.Data.MySqlClient;

/// <summary>
/// Simple MySQL helper - saari database calls yahi se hoti hain.
/// Hamesha parameters use karte hain (SQL injection se bachne ke liye).
/// </summary>
public static class Db
{
    public static string ConnStr
    {
        get { return ConfigurationManager.ConnectionStrings["CosmeticsDb"].ConnectionString; }
    }

    public static MySqlConnection Open()
    {
        MySqlConnection con = new MySqlConnection(ConnStr);
        con.Open();
        return con;
    }

    public static MySqlParameter P(string name, object value)
    {
        return new MySqlParameter(name, value ?? DBNull.Value);
    }

    /// <summary>SELECT query - DataTable return karta hai.</summary>
    public static DataTable Query(string sql, params MySqlParameter[] ps)
    {
        DataTable dt = new DataTable();
        using (MySqlConnection con = Open())
        using (MySqlCommand cmd = new MySqlCommand(sql, con))
        {
            if (ps != null) cmd.Parameters.AddRange(ps);
            using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
            {
                da.Fill(dt);
            }
        }
        return dt;
    }

    /// <summary>INSERT / UPDATE / DELETE - affected rows return karta hai.</summary>
    public static int Execute(string sql, params MySqlParameter[] ps)
    {
        using (MySqlConnection con = Open())
        using (MySqlCommand cmd = new MySqlCommand(sql, con))
        {
            if (ps != null) cmd.Parameters.AddRange(ps);
            return cmd.ExecuteNonQuery();
        }
    }

    /// <summary>Ek single value (COUNT, SUM etc.) return karta hai.</summary>
    public static object Scalar(string sql, params MySqlParameter[] ps)
    {
        using (MySqlConnection con = Open())
        using (MySqlCommand cmd = new MySqlCommand(sql, con))
        {
            if (ps != null) cmd.Parameters.AddRange(ps);
            return cmd.ExecuteScalar();
        }
    }

    /// <summary>INSERT ke baad naya auto-increment id return karta hai.</summary>
    public static long Insert(string sql, params MySqlParameter[] ps)
    {
        using (MySqlConnection con = Open())
        using (MySqlCommand cmd = new MySqlCommand(sql, con))
        {
            if (ps != null) cmd.Parameters.AddRange(ps);
            cmd.ExecuteNonQuery();
            return cmd.LastInsertedId;
        }
    }
}
