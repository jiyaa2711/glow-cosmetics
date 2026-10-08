using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Admin_Orders : AdminPage
{
    private static readonly string[] Statuses = { "Placed", "Shipped", "Delivered", "Cancelled" };

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) BindOrders();
    }

    private void BindOrders()
    {
        string sql =
            "SELECT o.id, o.total, o.payment_method, o.payment_status, o.order_status, o.created_at, " +
            "       o.ship_name, o.ship_phone, o.ship_address, o.ship_city, o.ship_pincode, u.full_name, u.email " +
            "FROM orders o JOIN users u ON u.id = o.user_id ";

        DataTable dt;
        if (ddlFilter.SelectedValue != "")
            dt = Db.Query(sql + "WHERE o.order_status = @s ORDER BY o.id DESC", Db.P("@s", ddlFilter.SelectedValue));
        else
            dt = Db.Query(sql + "ORDER BY o.id DESC");

        rptOrders.DataSource = dt;
        rptOrders.DataBind();
        pnlEmpty.Visible = dt.Rows.Count == 0;
    }

    protected void ddlFilter_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindOrders();
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

        DropDownList ddl = (DropDownList)e.Item.FindControl("ddlStatus");
        ddl.SelectedValue = row["order_status"].ToString();
    }

    protected void rptOrders_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName != "update") return;

        int orderId = Convert.ToInt32(e.CommandArgument);
        string status = ((DropDownList)e.Item.FindControl("ddlStatus")).SelectedValue;

        if (Array.IndexOf(Statuses, status) < 0) return;

        OrderService.SetStatus(orderId, status);
        litMsg.Text = Alert("success", "Order #" + orderId + " marked as " + status + ".");
        BindOrders();
    }
}
