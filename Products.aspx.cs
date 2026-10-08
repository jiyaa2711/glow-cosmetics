using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class ProductsPage : ShopPage
{
    /// <summary>Query string se chuni hui category (0 = sab).</summary>
    protected int SelectedCategory
    {
        get
        {
            int id;
            return int.TryParse(Request.QueryString["cat"], out id) ? id : 0;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtSearch.Text = Request.QueryString["q"];

            ddlBrand.DataSource = Db.Query("SELECT id, name FROM brands WHERE is_active = 1 ORDER BY name");
            ddlBrand.DataBind();
            int brandId;
            if (int.TryParse(Request.QueryString["brand"], out brandId) && ddlBrand.Items.FindByValue(brandId.ToString()) != null)
                ddlBrand.SelectedValue = brandId.ToString();

            BindData();
        }
    }

    private void BindData()
    {
        chipAll.Attributes["class"] = SelectedCategory == 0 ? "chip active" : "chip";

        rptChips.DataSource = Db.Query("SELECT id, name FROM categories WHERE parent_id IS NULL ORDER BY name");
        rptChips.DataBind();

        string sql =
            "SELECT p.id, p.name, p.description, p.price, p.stock, p.image, c.name AS category_name, b.name AS brand_name " +
            "FROM products p JOIN categories c ON c.id = p.category_id LEFT JOIN brands b ON b.id = p.brand_id " +
            "WHERE p.is_active = 1 ";
        System.Collections.Generic.List<MySql.Data.MySqlClient.MySqlParameter> ps =
            new System.Collections.Generic.List<MySql.Data.MySqlClient.MySqlParameter>();

        if (SelectedCategory > 0)
        {
            // Main category chuni ho to uski saari sub-categories ke products bhi aayenge
            sql += "AND (p.category_id = @cat OR c.parent_id = @cat) ";
            ps.Add(Db.P("@cat", SelectedCategory));
        }

        if (ddlBrand.SelectedValue != "0")
        {
            sql += "AND p.brand_id = @brand ";
            ps.Add(Db.P("@brand", int.Parse(ddlBrand.SelectedValue)));
        }

        string q = txtSearch.Text.Trim();
        if (q.Length > 0)
        {
            sql += "AND (p.name LIKE @q OR p.description LIKE @q) ";
            ps.Add(Db.P("@q", "%" + q + "%"));
        }
        switch (ddlSort.SelectedValue)
        {
            case "low": sql += "ORDER BY p.price ASC, p.name"; break;
            case "high": sql += "ORDER BY p.price DESC, p.name"; break;
            case "new": sql += "ORDER BY p.id DESC"; break;
            default: sql += "ORDER BY p.name"; break;
        }

        DataTable dt = Db.Query(sql, ps.ToArray());
        rptProducts.DataSource = dt;
        rptProducts.DataBind();
        pnlEmpty.Visible = dt.Rows.Count == 0;
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindData();
    }

    protected void ddlSort_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindData();
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
