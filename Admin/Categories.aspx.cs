using System;
using System.Web.UI.WebControls;

public partial class Admin_Categories : AdminPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack) return;
        ddlParent.DataSource = Db.Query("SELECT id, name FROM categories WHERE parent_id IS NULL ORDER BY name");
        ddlParent.DataBind();
        BindGrid();
    }

    private void BindGrid()
    {
        gvCat.DataSource = Db.Query(
            "SELECT c.id, c.name, c.description, pc.name AS parent_name, COUNT(p.id) AS product_count " +
            "FROM categories c LEFT JOIN categories pc ON pc.id = c.parent_id LEFT JOIN products p ON p.category_id = c.id " +
            "GROUP BY c.id, c.name, c.description, pc.name ORDER BY COALESCE(pc.name, c.name), c.parent_id IS NOT NULL, c.name");
        gvCat.DataBind();
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        string name = txtNewName.Text.Trim();
        object dup = Db.Scalar("SELECT COUNT(*) FROM categories WHERE name = @n", Db.P("@n", name));
        if (Convert.ToInt32(dup) > 0)
        {
            litMsg.Text = Alert("error", "A category with this name already exists.");
            return;
        }

        int parent = int.Parse(ddlParent.SelectedValue);
        Db.Execute("INSERT INTO categories (name, description, parent_id) VALUES (@n, @d, @p)",
            Db.P("@n", name), Db.P("@d", txtNewDesc.Text.Trim()), Db.P("@p", parent == 0 ? (object)DBNull.Value : parent));

        txtNewName.Text = "";
        txtNewDesc.Text = "";
        litMsg.Text = Alert("success", "Category added.");
        BindGrid();
    }

    protected void gvCat_RowEditing(object sender, GridViewEditEventArgs e)
    {
        gvCat.EditIndex = e.NewEditIndex;
        BindGrid();
    }

    protected void gvCat_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        gvCat.EditIndex = -1;
        BindGrid();
    }

    protected void gvCat_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        int id = Convert.ToInt32(gvCat.DataKeys[e.RowIndex].Value);
        string name = Convert.ToString(e.NewValues["name"]).Trim();
        string desc = Convert.ToString(e.NewValues["description"]).Trim();

        if (name.Length == 0)
        {
            litMsg.Text = Alert("error", "Category name cannot be empty.");
            return;
        }

        object dup = Db.Scalar("SELECT COUNT(*) FROM categories WHERE name = @n AND id <> @id",
            Db.P("@n", name), Db.P("@id", id));
        if (Convert.ToInt32(dup) > 0)
        {
            litMsg.Text = Alert("error", "Another category already uses this name.");
            return;
        }

        Db.Execute("UPDATE categories SET name=@n, description=@d WHERE id=@id",
            Db.P("@n", name), Db.P("@d", desc), Db.P("@id", id));

        gvCat.EditIndex = -1;
        litMsg.Text = Alert("success", "Category updated.");
        BindGrid();
    }

    protected void gvCat_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        int id = Convert.ToInt32(gvCat.DataKeys[e.RowIndex].Value);

        object count = Db.Scalar("SELECT COUNT(*) FROM products WHERE category_id = @id", Db.P("@id", id));
        if (Convert.ToInt32(count) > 0)
        {
            litMsg.Text = Alert("error", "This category still has products. Move or delete them first.");
            return;
        }

        object subs = Db.Scalar("SELECT COUNT(*) FROM categories WHERE parent_id = @id", Db.P("@id", id));
        if (Convert.ToInt32(subs) > 0)
        {
            litMsg.Text = Alert("error", "This category still has types under it. Delete those first.");
            return;
        }

        Db.Execute("DELETE FROM categories WHERE id = @id", Db.P("@id", id));
        litMsg.Text = Alert("success", "Category deleted.");
        BindGrid();
    }
}
