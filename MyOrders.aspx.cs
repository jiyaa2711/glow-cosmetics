using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class MyOrdersPage : UserPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack) return;

        DataTable dt = Db.Query(
            "SELECT id, total, payment_method, payment_status, order_status, created_at, " +
            "       ship_name, ship_address, ship_city, ship_pincode " +
            "FROM orders WHERE user_id = @u ORDER BY id DESC",
            Db.P("@u", UserId));

        rptOrders.DataSource = dt;
        rptOrders.DataBind();
        pnlEmpty.Visible = dt.Rows.Count == 0;
    }

    protected void rptOrders_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;

        DataRowView row = (DataRowView)e.Item.DataItem;
        Repeater inner = (Repeater)e.Item.FindControl("rptItems");
        inner.DataSource = Db.Query(
            "SELECT product_name, quantity, (price * quantity) AS line_total FROM order_items WHERE order_id = @o",
            Db.P("@o", row["id"]));
        inner.DataBind();
    }
}
