using System;
using System.Web;
using System.Web.UI;

/// <summary>Sab pages ka base - login ki info yahan milti hai.</summary>
public class ShopPage : Page
{
    public bool IsLoggedIn { get { return Session["UserId"] != null; } }

    public int UserId
    {
        get { return IsLoggedIn ? Convert.ToInt32(Session["UserId"]) : 0; }
    }

    public bool IsAdmin
    {
        get { return IsLoggedIn && Convert.ToString(Session["Role"]) == "admin"; }
    }

    /// <summary>Bootstrap-jaisa alert box ka HTML (text encode karke).</summary>
    public static string Alert(string type, string text)
    {
        return "<div class=\"alert alert-" + type + "\">" + HttpUtility.HtmlEncode(text) + "</div>";
    }

    /// <summary>
    /// Product cart me daalta hai. Login nahi hai to login page par bhejta hai.
    /// Success par null, error par message return karta hai.
    /// </summary>
    protected string TryAddToCart(int productId, int qty)
    {
        if (!IsLoggedIn) RedirectToLogin();
        if (qty < 1) qty = 1;

        System.Data.DataTable dt = Db.Query(
            "SELECT p.name, p.stock, COALESCE(c.quantity,0) AS in_cart " +
            "FROM products p LEFT JOIN cart c ON c.product_id = p.id AND c.user_id = @u " +
            "WHERE p.id = @p AND p.is_active = 1",
            Db.P("@u", UserId), Db.P("@p", productId));

        if (dt.Rows.Count == 0) return "This product is not available.";

        int stock = Convert.ToInt32(dt.Rows[0]["stock"]);
        int inCart = Convert.ToInt32(dt.Rows[0]["in_cart"]);
        string name = dt.Rows[0]["name"].ToString();

        if (stock <= 0) return name + " is out of stock.";
        if (inCart + qty > stock)
            return "Only " + stock + " unit(s) of " + name + " available (you already have " + inCart + " in your cart).";

        CartService.Add(UserId, productId, qty);
        return null;
    }

    /// <summary>Login/Register ke baad session me user ki info rakhta hai.</summary>
    protected void SignIn(int id, string fullName, string email, string role)
    {
        Session["UserId"] = id;
        Session["UserName"] = fullName;
        Session["UserEmail"] = email;
        Session["Role"] = role;
    }

    /// <summary>returnUrl query string sirf tab valid jab wo isi site ka path ho (open redirect se bachav).</summary>
    protected string SafeReturnUrl()
    {
        string r = Request.QueryString["returnUrl"];
        if (string.IsNullOrEmpty(r)) return null;
        if (!r.StartsWith("/") || r.StartsWith("//") || r.StartsWith("/\\")) return null;
        return r;
    }

    /// <summary>Login ke baad wapas isi page par aane ke liye.</summary>
    protected void RedirectToLogin()
    {
        string back = Server.UrlEncode(Request.Url.PathAndQuery);
        Response.Redirect("~/Login.aspx?returnUrl=" + back);
    }
}

/// <summary>Jo pages login maangte hain (Cart, Checkout, MyOrders) - unka base.</summary>
public class UserPage : ShopPage
{
    protected override void OnInit(EventArgs e)
    {
        if (!IsLoggedIn) RedirectToLogin();
        base.OnInit(e);
    }
}

/// <summary>Admin panel ke pages ka base - sirf admin role wale aa sakte hain.</summary>
public class AdminPage : ShopPage
{
    protected override void OnInit(EventArgs e)
    {
        if (!IsLoggedIn) RedirectToLogin();
        if (!IsAdmin) Response.Redirect("~/Default.aspx");
        base.OnInit(e);
    }
}
