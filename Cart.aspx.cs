using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class CartPage : UserPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) BindCart();
    }

    private void BindCart()
    {
        DataTable dt = CartService.Items(UserId);
        rptCart.DataSource = dt;
        rptCart.DataBind();

        bool has = dt.Rows.Count > 0;
        pnlCart.Visible = has;
        pnlEmpty.Visible = !has;

        if (has)
        {
            litItems.Text = CartService.Count(UserId).ToString();
            string total = Helper.Money(CartService.Total(UserId));
            litSubtotal.Text = total;
            litTotal.Text = total;
        }
    }

    protected void rptCart_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int cartId = Convert.ToInt32(e.CommandArgument);

        DataTable dt = Db.Query(
            "SELECT c.quantity, p.stock, p.name FROM cart c JOIN products p ON p.id = c.product_id " +
            "WHERE c.id = @id AND c.user_id = @u",
            Db.P("@id", cartId), Db.P("@u", UserId));
        if (dt.Rows.Count == 0) { BindCart(); return; }

        int qty = Convert.ToInt32(dt.Rows[0]["quantity"]);
        int stock = Convert.ToInt32(dt.Rows[0]["stock"]);

        switch (e.CommandName)
        {
            case "plus":
                if (qty < stock)
                    CartService.SetQuantity(UserId, cartId, qty + 1);
                else
                    litMsg.Text = Alert("error", "Only " + stock + " unit(s) of " + dt.Rows[0]["name"] + " available.");
                break;
            case "minus":
                CartService.SetQuantity(UserId, cartId, qty - 1);
                break;
            case "remove":
                CartService.Remove(UserId, cartId);
                break;
        }
        BindCart();
    }
}
