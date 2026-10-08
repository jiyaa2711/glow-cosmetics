using System;
using System.Data;

public partial class Admin_Users : AdminPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack) return;

        DataTable dt = Db.Query(
            "SELECT u.id, u.full_name, u.email, u.phone, u.created_at, COUNT(o.id) AS order_count, " +
            "       COALESCE(SUM(CASE WHEN o.payment_status = 'Paid' THEN o.total END), 0) AS spent " +
            "FROM users u LEFT JOIN orders o ON o.user_id = u.id " +
            "WHERE u.role = 'user' " +
            "GROUP BY u.id, u.full_name, u.email, u.phone, u.created_at ORDER BY u.id DESC");

        rptUsers.DataSource = dt;
        rptUsers.DataBind();
        lblEmpty.Visible = dt.Rows.Count == 0;
    }
}
