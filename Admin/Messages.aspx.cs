using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Admin_Messages : AdminPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) BindMessages();
    }

    private void BindMessages()
    {
        try
        {
            DataTable dt = Db.Query(
                "SELECT id, name, email, phone, subject, message, is_read, created_at FROM contact_messages ORDER BY id DESC");
            rptMessages.DataSource = dt;
            rptMessages.DataBind();
            pnlEmpty.Visible = dt.Rows.Count == 0;
        }
        catch (Exception)
        {
            litMsg.Text = Alert("error", "The messages table is missing. Please run update_database.sql once in phpMyAdmin.");
        }
    }

    protected void rptMessages_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int id = Convert.ToInt32(e.CommandArgument);
        if (e.CommandName == "read")
            Db.Execute("UPDATE contact_messages SET is_read = 1 WHERE id = @i", Db.P("@i", id));
        else if (e.CommandName == "delete")
            Db.Execute("DELETE FROM contact_messages WHERE id = @i", Db.P("@i", id));
        BindMessages();
    }
}
