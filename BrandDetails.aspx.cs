using System;
using System.Data;
using System.Web;
using System.Web.UI.WebControls;

public partial class BrandDetailsPage : ShopPage
{
    /// <summary>Query string ka brand id (aspx me bhi use hota hai).</summary>
    protected int BrandId
    {
        get
        {
            int id;
            return int.TryParse(Request.QueryString["id"], out id) ? id : 0;
        }
    }

    /// <summary>Chuni hui sub-category (0 = brand ke saare products).</summary>
    protected int SelectedSub
    {
        get
        {
            int id;
            return int.TryParse(Request.QueryString["sub"], out id) ? id : 0;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) BindData();
    }

    private void BindData()
    {
        DataTable brand = Db.Query("SELECT id, name, description FROM brands WHERE id = @id AND is_active = 1", Db.P("@id", BrandId));
        if (brand.Rows.Count == 0)
        {
            pnlBrand.Visible = false;
            pnlNotFound.Visible = true;
            return;
        }

        string name = brand.Rows[0]["name"].ToString();
        string desc = brand.Rows[0]["description"] == DBNull.Value ? "" : brand.Rows[0]["description"].ToString();

        Page.Title = name + " - Glow Cosmetics";
        litBrandName.Text = HttpUtility.HtmlEncode(name);
        litBrandName2.Text = HttpUtility.HtmlEncode(name);
        litCrumb.Text = HttpUtility.HtmlEncode(name);
        litBrandDesc.Text = HttpUtility.HtmlEncode(desc);
        litInitial.Text = Helper.BrandInitial(name);
        bannerLogo.Attributes["style"] = Helper.BrandStyle(name);

        lnkAll.HRef = "~/BrandDetails.aspx?id=" + BrandId;
        lnkAll.Attributes["class"] = SelectedSub == 0 ? "sub-card active" : "sub-card";

        // Sirf wahi sub-categories jinke products is brand ke paas hain
        DataTable subs = Db.Query(
            "SELECT c.id, c.name, COALESCE(m.name, c.name) AS main_name, COUNT(p.id) AS product_count " +
            "FROM products p JOIN categories c ON c.id = p.category_id LEFT JOIN categories m ON m.id = c.parent_id " +
            "WHERE p.brand_id = @b AND p.is_active = 1 GROUP BY c.id, c.name, m.name ORDER BY c.name",
            Db.P("@b", BrandId));
        rptSubs.DataSource = subs;
        rptSubs.DataBind();

        int total = 0;
        foreach (DataRow r in subs.Rows) total += Convert.ToInt32(r["product_count"]);
        litAllCount.Text = total.ToString();

        string sql =
            "SELECT p.id, p.name, p.description, p.price, p.stock, p.image, c.name AS category_name, b.name AS brand_name " +
            "FROM products p JOIN categories c ON c.id = p.category_id JOIN brands b ON b.id = p.brand_id " +
            "WHERE p.is_active = 1 AND p.brand_id = @b ";
        DataTable dt;
        string title = "All " + name + " products";
        if (SelectedSub > 0)
        {
            dt = Db.Query(sql + "AND p.category_id = @c ORDER BY p.name", Db.P("@b", BrandId), Db.P("@c", SelectedSub));
            foreach (DataRow r in subs.Rows)
                if (Convert.ToInt32(r["id"]) == SelectedSub) title = name + " " + r["name"];
        }
        else
        {
            dt = Db.Query(sql + "ORDER BY c.name, p.name", Db.P("@b", BrandId));
        }

        litGridTitle.Text = HttpUtility.HtmlEncode(title);
        rptProducts.DataSource = dt;
        rptProducts.DataBind();
        pnlEmpty.Visible = dt.Rows.Count == 0;
    }

    protected void rptProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "add")
        {
            string error = TryAddToCart(Convert.ToInt32(e.CommandArgument), 1);
            litMsg.Text = (error == null)
                ? Alert("success", "Added to your cart!")
                : Alert("error", error);
        }
    }
}
