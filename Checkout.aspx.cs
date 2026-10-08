using System;
using System.Data;
using System.Web.Script.Serialization;

public partial class CheckoutPage : UserPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        DataTable items = CartService.Items(UserId);

        if (!IsPostBack)
        {
            if (items.Rows.Count == 0) Response.Redirect("~/Cart.aspx");

            txtName.Text = Convert.ToString(Session["UserName"]);
            object phone = Db.Scalar("SELECT phone FROM users WHERE id=@u", Db.P("@u", UserId));
            txtPhone.Text = (phone == null || phone == DBNull.Value) ? "" : phone.ToString();
        }

        rptSummary.DataSource = items;
        rptSummary.DataBind();
        litTotal.Text = Helper.Money(CartService.Total(UserId));
    }

    protected void btnPlace_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        string method = rblPayment.SelectedValue == "ONLINE" ? "ONLINE" : "COD";
        int orderId = 0;

        try
        {
            if (method == "ONLINE") OrderService.CancelPendingOnline(UserId);

            orderId = OrderService.PlaceOrder(UserId, txtName.Text.Trim(), txtPhone.Text.Trim(),
                txtAddress.Text.Trim(), txtCity.Text.Trim(), txtPincode.Text.Trim(), method);
        }
        catch (Exception ex)
        {
            litMsg.Text = Alert("error", ex.Message);
            return;
        }

        if (method == "COD")
        {
            Response.Redirect("~/OrderSuccess.aspx?id=" + orderId);
            return;
        }

        // ---------- Online payment: Razorpay ----------
        decimal total = CartService.Total(UserId);
        string rzpOrderId;
        try
        {
            rzpOrderId = Razorpay.CreateOrder(total, "order_" + orderId);
            OrderService.SetRazorpayOrderId(orderId, rzpOrderId);
        }
        catch (Exception ex)
        {
            OrderService.MarkFailed(orderId, UserId);
            litMsg.Text = Alert("error",
                "Online payment could not be started. Please check the Razorpay keys in Web.config. (" + ex.Message + ")");
            return;
        }

        hfOrderId.Value = orderId.ToString();
        long paise = (long)Math.Round(total * 100m, 0);

        string script =
            "var paid = false;" +
            "var options = {" +
            "  key: " + JsStr(Razorpay.KeyId) + "," +
            "  amount: " + paise + "," +
            "  currency: 'INR'," +
            "  name: 'Glow Cosmetics'," +
            "  description: 'Order #" + orderId + "'," +
            "  order_id: " + JsStr(rzpOrderId) + "," +
            "  prefill: { name: " + JsStr(txtName.Text.Trim()) + ", email: " + JsStr(Convert.ToString(Session["UserEmail"])) +
            "            , contact: " + JsStr(txtPhone.Text.Trim()) + " }," +
            "  theme: { color: '#e0457b' }," +
            "  handler: function (response) {" +
            "    paid = true;" +
            "    document.getElementById('" + hfPaymentId.ClientID + "').value = response.razorpay_payment_id;" +
            "    document.getElementById('" + hfSignature.ClientID + "').value = response.razorpay_signature;" +
            "    document.getElementById('" + btnVerify.ClientID + "').click();" +
            "  }," +
            "  modal: { ondismiss: function () {" +
            "    if (!paid) { document.getElementById('" + btnCancelPay.ClientID + "').click(); }" +
            "  } }" +
            "};" +
            "var rzp = new Razorpay(options);" +
            "rzp.open();";

        ClientScript.RegisterStartupScript(this.GetType(), "openRazorpay", script, true);
    }

    /// <summary>Payment ke baad server par signature verify karke order Paid mark karta hai.</summary>
    protected void btnVerify_Click(object sender, EventArgs e)
    {
        int orderId;
        if (!int.TryParse(hfOrderId.Value, out orderId)) { litMsg.Text = Alert("error", "Invalid order."); return; }

        // Razorpay order id hidden field se nahi, database se lete hain (safe)
        DataTable dt = Db.Query("SELECT razorpay_order_id FROM orders WHERE id=@id AND user_id=@u",
            Db.P("@id", orderId), Db.P("@u", UserId));
        if (dt.Rows.Count == 0) { litMsg.Text = Alert("error", "Order not found."); return; }

        string rzpOrderId = Convert.ToString(dt.Rows[0]["razorpay_order_id"]);

        if (Razorpay.VerifySignature(rzpOrderId, hfPaymentId.Value, hfSignature.Value))
        {
            OrderService.MarkPaid(orderId, UserId, hfPaymentId.Value);
            Response.Redirect("~/OrderSuccess.aspx?id=" + orderId);
        }
        else
        {
            OrderService.MarkFailed(orderId, UserId);
            litMsg.Text = Alert("error", "Payment verification failed. If money was deducted, it will be refunded by your bank. Please try again.");
        }
    }

    /// <summary>User ne payment window band kar di.</summary>
    protected void btnCancelPay_Click(object sender, EventArgs e)
    {
        int orderId;
        if (int.TryParse(hfOrderId.Value, out orderId))
            OrderService.MarkFailed(orderId, UserId);

        litMsg.Text = Alert("info", "Payment was cancelled. Your cart is still saved - you can try again.");
    }

    /// <summary>C# string ko safe JavaScript string literal me badalta hai.</summary>
    private static string JsStr(string value)
    {
        return new JavaScriptSerializer().Serialize(value ?? "").Replace("<", "\\u003c");
    }
}
