<%@ Page Title="Product - Glow Cosmetics" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="ProductDetails.aspx.cs" Inherits="ProductDetailsPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container page-wrap">

        <asp:Panel ID="pnlNotFound" runat="server" Visible="false" CssClass="empty-box">
            <h3>Product not found</h3>
            <p>This product may have been removed.</p>
            <p style="margin-top:14px"><a href="~/Products.aspx" runat="server" class="btn btn-primary">Back to Shop</a></p>
        </asp:Panel>

        <asp:Panel ID="pnlProduct" runat="server">

            <div class="breadcrumb">
                <a href="~/Default.aspx" runat="server">Home</a> /
                <a href="~/Brands.aspx" runat="server">Brands</a> /
                <asp:HyperLink ID="lnkBrand" runat="server"></asp:HyperLink><asp:Literal ID="litBrandSep" runat="server"> / </asp:Literal>
                <asp:HyperLink ID="lnkCategory" runat="server"></asp:HyperLink> /
                <asp:Literal ID="litCrumbName" runat="server"></asp:Literal>
            </div>

            <div class="details">
                <div class="details-img">
                    <asp:Image ID="imgProduct" runat="server" />
                </div>
                <div class="details-info">
                    <span class="product-cat"><asp:Literal ID="litCategory" runat="server"></asp:Literal></span>
                    <h1><asp:Literal ID="litName" runat="server"></asp:Literal></h1>
                    <div class="price-lg"><asp:Literal ID="litPrice" runat="server"></asp:Literal></div>
                    <asp:Literal ID="litStock" runat="server"></asp:Literal>

                    <p class="details-desc"><asp:Literal ID="litDesc" runat="server"></asp:Literal></p>

                    <asp:Literal ID="litMsg" runat="server"></asp:Literal>

                    <asp:Panel ID="pnlBuy" runat="server" CssClass="qty-row">
                        <label for="<%= ddlQty.ClientID %>"><b>Quantity</b></label>
                        <asp:DropDownList ID="ddlQty" runat="server" CssClass="form-control"></asp:DropDownList>
                        <asp:Button ID="btnAdd" runat="server" Text="Add to Cart" CssClass="btn btn-primary" OnClick="btnAdd_Click" />
                    </asp:Panel>
                </div>
            </div>

            <asp:Panel ID="pnlRelated" runat="server">
                <div class="section-head" style="margin-top:50px">
                    <h2 class="section-title">You may also like</h2>
                </div>
                <div class="product-grid">
                    <asp:Repeater ID="rptRelated" runat="server">
                        <ItemTemplate>
                            <div class="product-card">
                                <a class="product-img" href='<%# ResolveUrl("~/ProductDetails.aspx?id=" + Eval("id")) %>'>
                                    <img src='<%# Helper.ImgUrl(Eval("image")) %>' alt='<%#: Eval("name") %>' />
                                </a>
                                <div class="product-body">
                                    <h3 class="product-name"><a href='<%# ResolveUrl("~/ProductDetails.aspx?id=" + Eval("id")) %>'><%#: Eval("name") %></a></h3>
                                    <div class="product-price"><%# Helper.Money(Eval("price")) %></div>
                                    <a class="btn btn-outline" href='<%# ResolveUrl("~/ProductDetails.aspx?id=" + Eval("id")) %>'>View Details</a>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </asp:Panel>

        </asp:Panel>
    </div>
</asp:Content>
