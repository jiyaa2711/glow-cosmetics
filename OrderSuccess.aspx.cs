using System;
using System.Data;
using System.Web;

public partial class OrderSuccessPage : UserPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        int id;
        int.TryParse(Request.QueryString["id"], out id);

        DataTable dt = Db.Query(
            "SELECT id, total, payment_method, payment_status, ship_name, ship_address, ship_city, ship_pincode " +
            "FROM orders WHERE id = @id AND user_id = @u",
            Db.P("@id", id), Db.P("@u", UserId));

        // Adhoori online payment wale order par "Thank you" nahi dikhana
        bool unpaidOnline = dt.Rows.Count > 0 &&
            dt.Rows[0]["payment_method"].ToString() == "ONLINE" &&
            dt.Rows[0]["payment_status"].ToString() != "Paid";

        if (dt.Rows.Count == 0 || unpaidOnline)
        {
            pnlOrder.Visible = false;
            pnlNotFound.Visible = true;
            return;
        }

        DataRow r = dt.Rows[0];
        litOrderId.Text = r["id"].ToString();
        litTotal.Text = Helper.Money(r["total"]);

        string method = r["payment_method"].ToString();
        litPayment.Text = (method == "COD")
            ? "Cash on Delivery"
            : "Online - " + HttpUtility.HtmlEncode(r["payment_status"].ToString());

        litAddress.Text = HttpUtility.HtmlEncode(
            r["ship_name"] + ", " + r["ship_address"] + ", " + r["ship_city"] + " - " + r["ship_pincode"]);
    }
}
