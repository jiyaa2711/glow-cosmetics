using System;
using System.Data;
using System.Web;

public partial class Admin_Dashboard : AdminPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack) return;

        litAdmin.Text = HttpUtility.HtmlEncode(Convert.ToString(Session["UserName"]));

        litRevenue.Text = Helper.Money(Db.Scalar("SELECT COALESCE(SUM(total),0) FROM orders WHERE payment_status='Paid'"));
        litOrders.Text = Db.Scalar("SELECT COUNT(*) FROM orders").ToString();
        litNewOrders.Text = Db.Scalar("SELECT COUNT(*) FROM orders WHERE order_status='Placed'").ToString();
        litProducts.Text = Db.Scalar("SELECT COUNT(*) FROM products").ToString();
        litUsers.Text = Db.Scalar("SELECT COUNT(*) FROM users WHERE role='user'").ToString();

        try { litMessages.Text = Db.Scalar("SELECT COUNT(*) FROM contact_messages WHERE is_read = 0").ToString(); }
        catch (Exception) { litMessages.Text = "-"; }   // table abhi bana nahi (update_database.sql)

        DataTable recent = Db.Query(
            "SELECT o.id, o.total, o.payment_method, o.payment_status, o.order_status, o.created_at, u.full_name " +
            "FROM orders o JOIN users u ON u.id = o.user_id ORDER BY o.id DESC LIMIT 8");
        rptRecent.DataSource = recent;
        rptRecent.DataBind();
        lblNoOrders.Visible = recent.Rows.Count == 0;

        DataTable low = Db.Query(
            "SELECT p.name, p.stock, c.name AS category_name FROM products p " +
            "JOIN categories c ON c.id = p.category_id WHERE p.stock <= 5 ORDER BY p.stock, p.name LIMIT 10");
        rptLow.DataSource = low;
        rptLow.DataBind();
        lblNoLow.Visible = low.Rows.Count == 0;
    }
}
