using System;
using System.Data;
using System.Globalization;
using System.IO;
using System.Web.UI.WebControls;

public partial class Admin_Products : AdminPage
{
    private static readonly string[] AllowedExt = { ".jpg", ".jpeg", ".png", ".gif", ".webp" };

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack) return;

        ddlBrand.DataSource = Db.Query("SELECT id, name FROM brands ORDER BY name");
        ddlBrand.DataBind();

        // Sirf types (sub-categories) dikhao: "Makeup > Lipstick". Product hamesha ek type ke andar aata hai.
        ddlCategory.DataSource = Db.Query(
            "SELECT c.id, CONCAT(m.name, ' > ', c.name) AS name FROM categories c " +
            "JOIN categories m ON m.id = c.parent_id ORDER BY m.name, c.name");
        ddlCategory.DataBind();
        BindGrid();
    }

    private void BindGrid()
    {
        gvProducts.DataSource = Db.Query(
            "SELECT p.id, p.name, p.price, p.stock, p.image, p.is_active, c.name AS category_name, b.name AS brand_name " +
            "FROM products p JOIN categories c ON c.id = p.category_id LEFT JOIN brands b ON b.id = p.brand_id ORDER BY p.id DESC");
        gvProducts.DataBind();
    }

    private void ResetForm()
    {
        hfEditId.Value = "";
        txtName.Text = "";
        txtPrice.Text = "";
        txtStock.Text = "";
        txtDesc.Text = "";
        ddlCategory.SelectedValue = "0";
        ddlBrand.SelectedValue = "0";
        chkActive.Checked = true;
        imgCurrent.Visible = false;
        litFormTitle.Text = "Add New Product";
        btnSave.Text = "Add Product";
        btnCancel.Visible = false;
    }

    /// <summary>Image save karta hai. Naya file name return karta hai (ya null agar file nahi di).</summary>
    private string SaveImage(out string error)
    {
        error = null;
        if (!fuImage.HasFile) return null;

        string ext = Path.GetExtension(fuImage.FileName).ToLower();
        if (Array.IndexOf(AllowedExt, ext) < 0)
        {
            error = "Only JPG, PNG, GIF or WEBP images are allowed.";
            return null;
        }
        if (fuImage.PostedFile.ContentLength > 2 * 1024 * 1024)
        {
            error = "Image is too large. Maximum size is 2 MB.";
            return null;
        }

        string folder = Server.MapPath("~/images/products/");
        if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);

        string fileName = Guid.NewGuid().ToString("N") + ext;
        fuImage.SaveAs(Path.Combine(folder, fileName));
        return fileName;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        string error;
        string newImage = SaveImage(out error);
        if (error != null)
        {
            litMsg.Text = Alert("error", error);
            return;
        }

        decimal price = decimal.Parse(txtPrice.Text.Trim(), CultureInfo.InvariantCulture);
        int stock = int.Parse(txtStock.Text.Trim());
        int active = chkActive.Checked ? 1 : 0;
        int catId = int.Parse(ddlCategory.SelectedValue);
        int brandId = int.Parse(ddlBrand.SelectedValue);

        if (hfEditId.Value == "")
        {
            Db.Execute(
                "INSERT INTO products (brand_id, category_id, name, description, price, stock, image, is_active) " +
                "VALUES (@b, @c, @n, @d, @p, @s, @i, @a)",
                Db.P("@b", brandId), Db.P("@c", catId), Db.P("@n", txtName.Text.Trim()), Db.P("@d", txtDesc.Text.Trim()),
                Db.P("@p", price), Db.P("@s", stock), Db.P("@i", newImage ?? "placeholder.svg"), Db.P("@a", active));
            litMsg.Text = Alert("success", "Product added.");
        }
        else
        {
            int id = int.Parse(hfEditId.Value);

            if (newImage != null)
            {
                DeleteImageFile(Db.Scalar("SELECT image FROM products WHERE id=@id", Db.P("@id", id)));
                Db.Execute("UPDATE products SET image=@i WHERE id=@id", Db.P("@i", newImage), Db.P("@id", id));
            }

            Db.Execute(
                "UPDATE products SET brand_id=@b, category_id=@c, name=@n, description=@d, price=@p, stock=@s, is_active=@a WHERE id=@id",
                Db.P("@b", brandId), Db.P("@c", catId), Db.P("@n", txtName.Text.Trim()), Db.P("@d", txtDesc.Text.Trim()),
                Db.P("@p", price), Db.P("@s", stock), Db.P("@a", active), Db.P("@id", id));
            litMsg.Text = Alert("success", "Product updated.");
        }

        ResetForm();
        BindGrid();
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ResetForm();
    }

    protected void gvProducts_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int id;
        if (!int.TryParse(Convert.ToString(e.CommandArgument), out id)) return;

        switch (e.CommandName)
        {
            case "EditProduct":
                LoadForEdit(id);
                break;

            case "ToggleProduct":
                Db.Execute("UPDATE products SET is_active = 1 - is_active WHERE id = @id", Db.P("@id", id));
                BindGrid();
                break;

            case "DeleteProduct":
                DeleteImageFile(Db.Scalar("SELECT image FROM products WHERE id=@id", Db.P("@id", id)));
                Db.Execute("DELETE FROM products WHERE id = @id", Db.P("@id", id));
                litMsg.Text = Alert("success", "Product deleted.");
                if (hfEditId.Value == id.ToString()) ResetForm();
                BindGrid();
                break;
        }
    }

    private void LoadForEdit(int id)
    {
        DataTable dt = Db.Query(
            "SELECT brand_id, category_id, name, description, price, stock, image, is_active FROM products WHERE id = @id",
            Db.P("@id", id));
        if (dt.Rows.Count == 0) return;

        DataRow r = dt.Rows[0];
        hfEditId.Value = id.ToString();
        txtName.Text = r["name"].ToString();
        txtDesc.Text = r["description"] == DBNull.Value ? "" : r["description"].ToString();
        txtPrice.Text = Convert.ToDecimal(r["price"]).ToString("0.00", CultureInfo.InvariantCulture);
        txtStock.Text = r["stock"].ToString();
        chkActive.Checked = Convert.ToInt32(r["is_active"]) == 1;
        // Purane product jinka brand/type set nahi hai unke liye "Select" dikhao
        string catVal = r["category_id"].ToString();
        ddlCategory.SelectedValue = ddlCategory.Items.FindByValue(catVal) != null ? catVal : "0";
        string brandVal = r["brand_id"] == DBNull.Value ? "0" : r["brand_id"].ToString();
        ddlBrand.SelectedValue = ddlBrand.Items.FindByValue(brandVal) != null ? brandVal : "0";
        imgCurrent.ImageUrl = Helper.ImgUrl(r["image"]);
        imgCurrent.Visible = true;

        litFormTitle.Text = "Edit Product #" + id;
        btnSave.Text = "Update Product";
        btnCancel.Visible = true;
    }

    /// <summary>Purani image file delete karta hai (placeholder ko nahi chhedta).</summary>
    private void DeleteImageFile(object imageName)
    {
        if (imageName == null || imageName == DBNull.Value) return;
        string name = Path.GetFileName(imageName.ToString());
        if (name.Length == 0 || name == "placeholder.svg") return;

        string path = Path.Combine(Server.MapPath("~/images/products/"), name);
        try { if (File.Exists(path)) File.Delete(path); }
        catch { /* file lock etc. - ignore */ }
    }
}
