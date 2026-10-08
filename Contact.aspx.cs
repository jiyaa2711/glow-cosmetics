using System;
using System.Data;

public partial class ContactPage : ShopPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Login hai to naam aur email pehle se bhar do
        if (!IsPostBack && IsLoggedIn)
        {
            txtName.Text = Convert.ToString(Session["UserName"]);
            txtEmail.Text = Convert.ToString(Session["UserEmail"]);
        }
    }

    protected void btnSend_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        try
        {
            Db.Execute(
                "INSERT INTO contact_messages (name, email, phone, subject, message) VALUES (@n, @e, @p, @s, @m)",
                Db.P("@n", txtName.Text.Trim()),
                Db.P("@e", txtEmail.Text.Trim()),
                Db.P("@p", txtPhone.Text.Trim()),
                Db.P("@s", ddlSubject.SelectedValue),
                Db.P("@m", txtMessage.Text.Trim()));
        }
        catch (Exception)
        {
            litMsg.Text = Alert("error",
                "Sorry, your message could not be saved. (Admin: please run update_database.sql once to create the contact_messages table.)");
            return;
        }

        litMsg.Text = "<div class=\"alert alert-success\" data-autohide=\"1\">Thank you! Your message has been sent. We will get back to you soon.</div>";
        txtMessage.Text = "";
        txtPhone.Text = "";
        ddlSubject.SelectedIndex = 0;
    }
}
