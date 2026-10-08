using System;
using System.Data;
using System.Web;

public partial class ProductDetailsPage : ShopPage
{
    private int ProductId
    {
        get
        {
            int id;
            return int.TryParse(Request.QueryString["id"], out id) ? id : 0;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) LoadProduct();
    }

    private void LoadProduct()
    {
        DataTable dt = Db.Query(
            "SELECT p.id, p.category_id, p.brand_id, p.name, p.description, p.price, p.stock, p.image, " +
            "       c.name AS category_name, b.name AS brand_name " +
            "FROM products p JOIN categories c ON c.id = p.category_id LEFT JOIN brands b ON b.id = p.brand_id " +
            "WHERE p.id = @id AND p.is_active = 1",
            Db.P("@id", ProductId));

        if (dt.Rows.Count == 0)
        {
            pnlProduct.Visible = false;
            pnlNotFound.Visible = true;
            return;
        }

        DataRow r = dt.Rows[0];
        string name = r["name"].ToString();
        int stock = Convert.ToInt32(r["stock"]);
        int catId = Convert.ToInt32(r["category_id"]);

        Page.Title = name + " - Glow Cosmetics";
        litName.Text = HttpUtility.HtmlEncode(name);
        litCrumbName.Text = HttpUtility.HtmlEncode(name);
        litCategory.Text = Helper.Tag(r["brand_name"], r["category_name"]);
        if (r["brand_id"] != DBNull.Value)
        {
            // Brand ke andar us type ke products: Lakme > Lipstick
            lnkBrand.Text = HttpUtility.HtmlEncode(r["brand_name"].ToString());
            lnkBrand.NavigateUrl = "~/BrandDetails.aspx?id=" + r["brand_id"];
            lnkCategory.NavigateUrl = "~/BrandDetails.aspx?id=" + r["brand_id"] + "&sub=" + catId;
        }
        else
        {
            lnkBrand.Visible = false;
            litBrandSep.Visible = false;
            lnkCategory.NavigateUrl = "~/Products.aspx?cat=" + catId;
        }
        lnkCategory.Text = HttpUtility.HtmlEncode(r["category_name"].ToString());
        litPrice.Text = Helper.Money(r["price"]);
        imgProduct.ImageUrl = Helper.ImgUrl(r["image"]);
        imgProduct.AlternateText = name;

        // Description: encode karke line breaks <br> banao
        string desc = HttpUtility.HtmlEncode(r["description"] == DBNull.Value ? "" : r["description"].ToString());
        litDesc.Text = desc.Replace("\r\n", "<br />").Replace("\n", "<br />");

        if (stock > 0)
        {
            litStock.Text = "<span class=\"stock-in\">In stock (" + stock + " available)</span>";
            int max = Math.Min(stock, 10);
            for (int i = 1; i <= max; i++) ddlQty.Items.Add(i.ToString());
            pnlBuy.Visible = true;
        }
        else
        {
            litStock.Text = "<span class=\"stock-out\">Out of stock</span>";
            pnlBuy.Visible = false;
        }

        DataTable related = Db.Query(
            "SELECT id, name, price, image FROM products " +
            "WHERE category_id = @c AND id <> @id AND is_active = 1 ORDER BY (brand_id <=> @b) DESC, created_at DESC LIMIT 4",
            Db.P("@c", catId), Db.P("@id", ProductId), Db.P("@b", r["brand_id"]));
        rptRelated.DataSource = related;
        rptRelated.DataBind();
        pnlRelated.Visible = related.Rows.Count > 0;
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        int qty = 1;
        int.TryParse(ddlQty.SelectedValue, out qty);

        string error = TryAddToCart(ProductId, qty);
        if (error == null)
            litMsg.Text = "<div class=\"alert alert-success\">Added to your cart! <a href=\"" +
                          ResolveUrl("~/Cart.aspx") + "\"><b>View Cart</b></a></div>";
        else
            litMsg.Text = Alert("error", error);
    }
}
