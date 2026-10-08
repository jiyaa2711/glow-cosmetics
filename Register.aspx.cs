using System;
using System.Web;

public partial class RegisterPage : ShopPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsLoggedIn) Response.Redirect("~/Default.aspx");

        string back = Request.QueryString["returnUrl"];
        if (!string.IsNullOrEmpty(back))
            lnkLogin.NavigateUrl = "~/Login.aspx?returnUrl=" + Server.UrlEncode(back);
    }

    protected void btnRegister_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        string name = txtName.Text.Trim();
        string email = txtEmail.Text.Trim().ToLower();
        string phone = txtPhone.Text.Trim();
        string password = txtPassword.Text;

        object exists = Db.Scalar("SELECT COUNT(*) FROM users WHERE email=@e", Db.P("@e", email));
        if (Convert.ToInt32(exists) > 0)
        {
            litMsg.Text = Alert("error", "This email is already registered. Please login.");
            return;
        }

        long id = Db.Insert(
            "INSERT INTO users (full_name, email, phone, password_hash, role) VALUES (@n, @e, @p, @h, 'user')",
            Db.P("@n", name), Db.P("@e", email), Db.P("@p", phone), Db.P("@h", Helper.HashPassword(password)));

        // Register ke turant baad login kara do
        SignIn((int)id, name, email, "user");

        string back = SafeReturnUrl();
        Response.Redirect(back ?? "~/Default.aspx");
    }
}
