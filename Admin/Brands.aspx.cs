using System;
using System.Web.UI.WebControls;

public partial class Admin_Brands : AdminPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) BindGrid();
    }

    private void BindGrid()
    {
        gvBrands.DataSource = Db.Query(
            "SELECT b.id, b.name, b.description, COUNT(p.id) AS product_count " +
            "FROM brands b LEFT JOIN products p ON p.brand_id = b.id " +
            "GROUP BY b.id, b.name, b.description ORDER BY b.name");
        gvBrands.DataBind();
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        string name = txtNewName.Text.Trim();
        object dup = Db.Scalar("SELECT COUNT(*) FROM brands WHERE name = @n", Db.P("@n", name));
        if (Convert.ToInt32(dup) > 0)
        {
            litMsg.Text = Alert("error", "A brand with this name already exists.");
            return;
        }

        Db.Execute("INSERT INTO brands (name, description) VALUES (@n, @d)",
            Db.P("@n", name), Db.P("@d", txtNewDesc.Text.Trim()));

        txtNewName.Text = "";
        txtNewDesc.Text = "";
        litMsg.Text = Alert("success", "Brand added.");
        BindGrid();
    }

    protected void gvBrands_RowEditing(object sender, GridViewEditEventArgs e)
    {
        gvBrands.EditIndex = e.NewEditIndex;
        BindGrid();
    }

    protected void gvBrands_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        gvBrands.EditIndex = -1;
        BindGrid();
    }

    protected void gvBrands_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        int id = Convert.ToInt32(gvBrands.DataKeys[e.RowIndex].Value);
        string name = Convert.ToString(e.NewValues["name"]).Trim();
        string desc = Convert.ToString(e.NewValues["description"]).Trim();

        if (name.Length == 0)
        {
            litMsg.Text = Alert("error", "Brand name cannot be empty.");
            return;
        }

        object dup = Db.Scalar("SELECT COUNT(*) FROM brands WHERE name = @n AND id <> @id",
            Db.P("@n", name), Db.P("@id", id));
        if (Convert.ToInt32(dup) > 0)
        {
            litMsg.Text = Alert("error", "Another brand already uses this name.");
            return;
        }

        Db.Execute("UPDATE brands SET name=@n, description=@d WHERE id=@id",
            Db.P("@n", name), Db.P("@d", desc), Db.P("@id", id));

        gvBrands.EditIndex = -1;
        litMsg.Text = Alert("success", "Brand updated.");
        BindGrid();
    }

    protected void gvBrands_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        int id = Convert.ToInt32(gvBrands.DataKeys[e.RowIndex].Value);

        object count = Db.Scalar("SELECT COUNT(*) FROM products WHERE brand_id = @id", Db.P("@id", id));
        if (Convert.ToInt32(count) > 0)
        {
            litMsg.Text = Alert("error", "This brand still has products. Move or delete them first.");
            return;
        }

        Db.Execute("DELETE FROM brands WHERE id = @id", Db.P("@id", id));
        litMsg.Text = Alert("success", "Brand deleted.");
        BindGrid();
    }
}
