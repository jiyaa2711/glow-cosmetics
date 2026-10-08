<%@ Page Title="Brand - Glow Cosmetics" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="BrandDetails.aspx.cs" Inherits="BrandDetailsPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Panel ID="pnlNotFound" runat="server" Visible="false">
        <div class="container page-wrap">
            <div class="empty-box">
                <h3>Brand not found</h3>
                <p style="margin-top:14px"><a href="~/Brands.aspx" runat="server" class="btn btn-primary">See all brands</a></p>
            </div>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlBrand" runat="server">

        <section class="page-banner">
            <div class="container brand-banner">
                <span class="brand-logo lg" id="bannerLogo" runat="server"><asp:Literal ID="litInitial" runat="server"></asp:Literal></span>
                <div>
                    <div class="crumbs"><a href="~/Default.aspx" runat="server">Home</a> / <a href="~/Brands.aspx" runat="server">Brands</a> / <asp:Literal ID="litCrumb" runat="server"></asp:Literal></div>
                    <h1><asp:Literal ID="litBrandName" runat="server"></asp:Literal></h1>
                    <p><asp:Literal ID="litBrandDesc" runat="server"></asp:Literal></p>
                </div>
            </div>
        </section>

        <div class="container page-wrap">

            <%-- Is brand ke sub-categories (sirf jo is brand ke paas hain) --%>
            <h2 class="sub-title">What <asp:Literal ID="litBrandName2" runat="server"></asp:Literal> offers</h2>
            <div class="sub-grid">
                <a id="lnkAll" runat="server" class="sub-card">
                    <span class="sub-ico">&#10024;</span>
                    <b>All</b>
                    <small><asp:Literal ID="litAllCount" runat="server"></asp:Literal> products</small>
                </a>
                <asp:Repeater ID="rptSubs" runat="server">
                    <ItemTemplate>
                        <a class='<%# Convert.ToInt32(Eval("id")) == SelectedSub ? "sub-card active" : "sub-card" %>'
                           href='<%# ResolveUrl("~/BrandDetails.aspx?id=" + BrandId + "&sub=" + Eval("id")) %>'>
                            <span class="sub-ico"><%# Helper.CatIcon(Eval("main_name")) %></span>
                            <b><%#: Eval("name") %></b>
                            <small><%# Eval("product_count") %> products</small>
                        </a>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <asp:Literal ID="litMsg" runat="server"></asp:Literal>

            <h2 class="sub-title"><asp:Literal ID="litGridTitle" runat="server"></asp:Literal></h2>
            <div class="product-grid">
                <asp:Repeater ID="rptProducts" runat="server" OnItemCommand="rptProducts_ItemCommand">
                    <ItemTemplate>
                        <div class="product-card">
                            <a class="product-img" href='<%# ResolveUrl("~/ProductDetails.aspx?id=" + Eval("id")) %>'>
                                <img src='<%# Helper.ImgUrl(Eval("image")) %>' alt='<%#: Eval("name") %>' />
                            </a>
                            <div class="product-body">
                                <span class="product-cat"><%# Helper.Tag(Eval("brand_name"), Eval("category_name")) %></span>
                                <h3 class="product-name"><a href='<%# ResolveUrl("~/ProductDetails.aspx?id=" + Eval("id")) %>'><%#: Eval("name") %></a></h3>
                                <p class="product-desc"><%#: Helper.ShortText(Eval("description"), 70) %></p>
                                <div class="product-price"><%# Helper.Money(Eval("price")) %></div>
                                <div class="product-actions">
                                    <a class="btn btn-outline" href='<%# ResolveUrl("~/ProductDetails.aspx?id=" + Eval("id")) %>'>View</a>
                                    <asp:LinkButton ID="btnAdd" runat="server" CssClass="btn btn-primary"
                                        CommandName="add" CommandArgument='<%# Eval("id") %>'
                                        Visible='<%# Convert.ToInt32(Eval("stock")) > 0 %>'>Add to Cart</asp:LinkButton>
                                    <asp:Label ID="lblOut" runat="server" CssClass="out-tag"
                                        Visible='<%# Convert.ToInt32(Eval("stock")) <= 0 %>'>Out of stock</asp:Label>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="empty-box">
                <h3>No products here yet</h3>
                <p>Try another type from this brand.</p>
            </asp:Panel>
        </div>
    </asp:Panel>
</asp:Content>
