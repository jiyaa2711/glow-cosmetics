using System;
using System.Web.UI;

public partial class AdminMaster : MasterPage
{
    // Jo page khula hai uska menu item highlight karo
    protected void Page_PreRender(object sender, EventArgs e)
    {
        string path = Request.Path.ToLower();
        if (path.EndsWith("/admin/default.aspx") || path.EndsWith("/admin/")) mDash.Attributes["class"] = "menu active";
        else if (path.EndsWith("/brands.aspx")) mBrand.Attributes["class"] = "menu active";
        else if (path.EndsWith("/categories.aspx")) mCat.Attributes["class"] = "menu active";
        else if (path.EndsWith("/products.aspx")) mProd.Attributes["class"] = "menu active";
        else if (path.EndsWith("/orders.aspx")) mOrd.Attributes["class"] = "menu active";
        else if (path.EndsWith("/users.aspx")) mUsers.Attributes["class"] = "menu active";
        else if (path.EndsWith("/messages.aspx")) mMsg.Attributes["class"] = "menu active";
    }
}
