using System;
using System.IO;
using System.Web;
using System.Web.UI;

public partial class SiteMaster : MasterPage
{
    // PreRender me taaki button click ke baad bhi cart count sahi dikhe
    protected void Page_PreRender(object sender, EventArgs e)
    {
        bool loggedIn = Session["UserId"] != null;
        pnlGuest.Visible = !loggedIn;
        pnlUser.Visible = loggedIn;
        lnkMyOrders.Visible = loggedIn;

        if (loggedIn)
        {
            string fullName = Convert.ToString(Session["UserName"]);
            string first = fullName.Split(' ')[0];
            lblUserName.Text = HttpUtility.HtmlEncode(first);
            lnkAdmin.Visible = Convert.ToString(Session["Role"]) == "admin";
            lblCartCount.Text = CartService.Count(Convert.ToInt32(Session["UserId"])).ToString();
        }
        else
        {
            lblCartCount.Text = "0";
        }

        // Jo page khula hai uska menu link highlight karo
        string page = Path.GetFileName(Request.Path).ToLower();
        if (page == "" || page == "default.aspx") navHome.CssClass = "active";
        else if (page == "brands.aspx" || page == "branddetails.aspx") navBrands.CssClass = "active";
        else if (page == "products.aspx" || page == "productdetails.aspx") navShop.CssClass = "active";
        else if (page == "about.aspx") navAbout.CssClass = "active";
        else if (page == "contact.aspx") navContact.CssClass = "active";
        else if (page == "myorders.aspx") lnkMyOrders.CssClass = "active";
    }
}
