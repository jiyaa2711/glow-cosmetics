using System;
using System.Data;

/// <summary>Cart ke saare database kaam.</summary>
public static class CartService
{
    public static void Add(int userId, int productId, int qty)
    {
        if (qty < 1) qty = 1;
        Db.Execute(
            "INSERT INTO cart (user_id, product_id, quantity) VALUES (@u, @p, @q) " +
            "ON DUPLICATE KEY UPDATE quantity = quantity + @q",
            Db.P("@u", userId), Db.P("@p", productId), Db.P("@q", qty));
    }

    public static int Count(int userId)
    {
        object o = Db.Scalar("SELECT COALESCE(SUM(quantity),0) FROM cart WHERE user_id=@u", Db.P("@u", userId));
        return Convert.ToInt32(o);
    }

    public static DataTable Items(int userId)
    {
        return Db.Query(
            "SELECT c.id AS cart_id, c.product_id, c.quantity, p.name, p.price, p.image, p.stock, " +
            "       (p.price * c.quantity) AS line_total " +
            "FROM cart c JOIN products p ON p.id = c.product_id " +
            "WHERE c.user_id = @u ORDER BY c.id",
            Db.P("@u", userId));
    }

    public static decimal Total(int userId)
    {
        object o = Db.Scalar(
            "SELECT COALESCE(SUM(p.price * c.quantity),0) FROM cart c " +
            "JOIN products p ON p.id = c.product_id WHERE c.user_id=@u",
            Db.P("@u", userId));
        return Convert.ToDecimal(o);
    }

    public static void SetQuantity(int userId, int cartId, int qty)
    {
        if (qty < 1)
            Remove(userId, cartId);
        else
            Db.Execute("UPDATE cart SET quantity=@q WHERE id=@id AND user_id=@u",
                Db.P("@q", qty), Db.P("@id", cartId), Db.P("@u", userId));
    }

    public static void Remove(int userId, int cartId)
    {
        Db.Execute("DELETE FROM cart WHERE id=@id AND user_id=@u", Db.P("@id", cartId), Db.P("@u", userId));
    }

    public static void Clear(int userId)
    {
        Db.Execute("DELETE FROM cart WHERE user_id=@u", Db.P("@u", userId));
    }
}
