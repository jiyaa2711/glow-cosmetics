using System;
using System.Data;
using MySql.Data.MySqlClient;

/// <summary>Order banana, payment mark karna, stock kam karna.</summary>
public static class OrderService
{
    /// <summary>
    /// Cart se order banata hai (transaction me). Order id return karta hai.
    /// COD ho to turant cart clear + stock kam; ONLINE ho to payment ke baad.
    /// </summary>
    public static int PlaceOrder(int userId, string name, string phone, string address,
                                 string city, string pincode, string method)
    {
        DataTable items = CartService.Items(userId);
        if (items.Rows.Count == 0) throw new Exception("Your cart is empty.");

        decimal total = 0;
        foreach (DataRow r in items.Rows)
        {
            int qty = Convert.ToInt32(r["quantity"]);
            if (qty > Convert.ToInt32(r["stock"]))
                throw new Exception("Not enough stock for " + r["name"] + ". Available: " + r["stock"]);
            total += Convert.ToDecimal(r["price"]) * qty;
        }

        int orderId;
        using (MySqlConnection con = Db.Open())
        using (MySqlTransaction tx = con.BeginTransaction())
        {
            try
            {
                MySqlCommand cmd = new MySqlCommand(
                    "INSERT INTO orders (user_id, total, ship_name, ship_phone, ship_address, ship_city, ship_pincode, payment_method, payment_status, order_status) " +
                    "VALUES (@u, @t, @n, @ph, @a, @c, @pin, @m, 'Pending', 'Placed')", con, tx);
                cmd.Parameters.AddWithValue("@u", userId);
                cmd.Parameters.AddWithValue("@t", total);
                cmd.Parameters.AddWithValue("@n", name);
                cmd.Parameters.AddWithValue("@ph", phone);
                cmd.Parameters.AddWithValue("@a", address);
                cmd.Parameters.AddWithValue("@c", city);
                cmd.Parameters.AddWithValue("@pin", pincode);
                cmd.Parameters.AddWithValue("@m", method);
                cmd.ExecuteNonQuery();
                orderId = (int)cmd.LastInsertedId;

                foreach (DataRow r in items.Rows)
                {
                    MySqlCommand ic = new MySqlCommand(
                        "INSERT INTO order_items (order_id, product_id, product_name, price, quantity) VALUES (@o, @p, @n, @pr, @q)", con, tx);
                    ic.Parameters.AddWithValue("@o", orderId);
                    ic.Parameters.AddWithValue("@p", r["product_id"]);
                    ic.Parameters.AddWithValue("@n", r["name"]);
                    ic.Parameters.AddWithValue("@pr", r["price"]);
                    ic.Parameters.AddWithValue("@q", r["quantity"]);
                    ic.ExecuteNonQuery();
                }
                tx.Commit();
            }
            catch
            {
                tx.Rollback();
                throw;
            }
        }

        if (method == "COD")
        {
            ReduceStock(orderId);
            CartService.Clear(userId);
        }
        return orderId;
    }

    public static void SetRazorpayOrderId(int orderId, string razorpayOrderId)
    {
        Db.Execute("UPDATE orders SET razorpay_order_id=@r WHERE id=@id",
            Db.P("@r", razorpayOrderId), Db.P("@id", orderId));
    }

    /// <summary>Online payment verify hone ke baad: order Paid, stock kam, cart clear.</summary>
    public static bool MarkPaid(int orderId, int userId, string razorpayPaymentId)
    {
        int rows = Db.Execute(
            "UPDATE orders SET payment_status='Paid', razorpay_payment_id=@pid " +
            "WHERE id=@id AND user_id=@u AND payment_status <> 'Paid'",
            Db.P("@pid", razorpayPaymentId), Db.P("@id", orderId), Db.P("@u", userId));
        if (rows > 0)
        {
            ReduceStock(orderId);
            CartService.Clear(userId);
            return true;
        }
        return false;
    }

    public static void MarkFailed(int orderId, int userId)
    {
        Db.Execute("UPDATE orders SET payment_status='Failed', order_status='Cancelled' " +
                   "WHERE id=@id AND user_id=@u AND payment_status='Pending' AND payment_method='ONLINE'",
            Db.P("@id", orderId), Db.P("@u", userId));
    }

    /// <summary>Purane adhoore online orders (payment nahi hui) band kar deta hai.</summary>
    public static void CancelPendingOnline(int userId)
    {
        Db.Execute("UPDATE orders SET payment_status='Failed', order_status='Cancelled' " +
                   "WHERE user_id=@u AND payment_method='ONLINE' AND payment_status='Pending'",
            Db.P("@u", userId));
    }

    public static void ReduceStock(int orderId)
    {
        Db.Execute(
            "UPDATE products p JOIN order_items oi ON oi.product_id = p.id " +
            "SET p.stock = GREATEST(p.stock - oi.quantity, 0) WHERE oi.order_id = @o",
            Db.P("@o", orderId));
    }

    /// <summary>Admin status badalta hai. Cancel par stock wapas (agar pehle kam hua tha).</summary>
    public static void SetStatus(int orderId, string newStatus)
    {
        DataTable dt = Db.Query("SELECT order_status, payment_method, payment_status FROM orders WHERE id=@id",
            Db.P("@id", orderId));
        if (dt.Rows.Count == 0) return;

        string oldStatus = dt.Rows[0]["order_status"].ToString();
        string method = dt.Rows[0]["payment_method"].ToString();
        string pay = dt.Rows[0]["payment_status"].ToString();

        Db.Execute("UPDATE orders SET order_status=@s WHERE id=@id", Db.P("@s", newStatus), Db.P("@id", orderId));

        // Stock tabhi kam hua tha jab COD tha ya online payment Paid tha
        bool stockWasReduced = (method == "COD") || (pay == "Paid");
        if (newStatus == "Cancelled" && oldStatus != "Cancelled" && stockWasReduced)
        {
            Db.Execute(
                "UPDATE products p JOIN order_items oi ON oi.product_id = p.id " +
                "SET p.stock = p.stock + oi.quantity WHERE oi.order_id = @o",
                Db.P("@o", orderId));
        }
        // COD delivered = paid
        if (newStatus == "Delivered" && method == "COD")
        {
            Db.Execute("UPDATE orders SET payment_status='Paid' WHERE id=@id", Db.P("@id", orderId));
        }
    }
}
