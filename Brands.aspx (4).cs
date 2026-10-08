using System;
using System.Data;

public partial class BrandsPage : ShopPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack) return;

        DataTable dt = Db.Query(
            "SELECT b.id, b.name, b.description, COUNT(p.id) AS product_count, COUNT(DISTINCT p.category_id) AS type_count " +
            "FROM brands b JOIN products p ON p.brand_id = b.id AND p.is_active = 1 " +
            "WHERE b.is_active = 1 GROUP BY b.id, b.name, b.description ORDER BY b.name");
        rptBrands.DataSource = dt;
        rptBrands.DataBind();
        pnlEmpty.Visible = dt.Rows.Count == 0;
    }
}
