using System;
using System.Web.UI.WebControls;

public partial class HomePage : ShopPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) BindData();
    }

    private void BindData()
    {
        rptCategories.DataSource = Db.Query("SELECT id, name, description FROM categories WHERE parent_id IS NULL ORDER BY name");
        rptCategories.DataBind();

        // Brands section (sirf woh brands jinke products hain)
        rptBrands.DataSource = Db.Query(
            "SELECT b.id, b.name, b.description, COUNT(p.id) AS product_count " +
            "FROM brands b JOIN products p ON p.brand_id = b.id AND p.is_active = 1 " +
            "WHERE b.is_active = 1 GROUP BY b.id, b.name, b.description ORDER BY b.name");
        rptBrands.DataBind();

        rptProducts.DataSource = Db.Query(
            "SELECT p.id, p.name, p.description, p.price, p.stock, p.image, c.name AS category_name, b.name AS brand_name " +
            "FROM products p JOIN categories c ON c.id = p.category_id LEFT JOIN brands b ON b.id = p.brand_id " +
            "WHERE p.is_active = 1 ORDER BY p.created_at DESC, p.id DESC LIMIT 8");
        rptProducts.DataBind();
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
