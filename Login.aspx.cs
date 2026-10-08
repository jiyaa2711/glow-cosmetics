using System;
using System.Data;

public partial class LoginPage : ShopPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack && IsLoggedIn)
            Response.Redirect(IsAdmin ? "~/Admin/Default.aspx" : "~/Default.aspx");

        string back = Request.QueryString["returnUrl"];
        if (!string.IsNullOrEmpty(back))
            lnkRegister.NavigateUrl = "~/Register.aspx?returnUrl=" + Server.UrlEncode(back);
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        string email = txtEmail.Text.Trim().ToLower();
        DataTable dt = Db.Query(
            "SELECT id, full_name, email, password_hash, role FROM users WHERE email = @e",
            Db.P("@e", email));

        if (dt.Rows.Count == 0 || !Helper.VerifyPassword(txtPassword.Text, dt.Rows[0]["password_hash"].ToString()))
        {
            litMsg.Text = Alert("error", "Invalid email or password.");
            return;
        }

        DataRow r = dt.Rows[0];
        string role = r["role"].ToString();
        SignIn(Convert.ToInt32(r["id"]), r["full_name"].ToString(), r["email"].ToString(), role);

        if (role == "admin")
        {
            Response.Redirect("~/Admin/Default.aspx");
            return;
        }

        string back = SafeReturnUrl();
        Response.Redirect(back ?? "~/Default.aspx");
    }
}
