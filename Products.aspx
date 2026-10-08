<%@ Page Title="Shop - Glow Cosmetics" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Products.aspx.cs" Inherits="ProductsPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <section class="page-banner">
        <div class="container">
            <div class="crumbs"><a href="~/Default.aspx" runat="server">Home</a> / Products</div>
            <h1>Our Products</h1>
            <p>Browse by category, search or sort to find your favourite beauty product.</p>
        </div>
    </section>

    <div class="container page-wrap">

        <div class="filter-bar">
            <div class="chips">
                <a class="chip" id="chipAll" runat="server" href="~/Products.aspx">All</a>
                <asp:Repeater ID="rptChips" runat="server">
                    <ItemTemplate>
                        <a class='<%# Convert.ToInt32(Eval("id")) == SelectedCategory ? "chip active" : "chip" %>'
                           href='<%# ResolveUrl("~/Products.aspx?cat=" + Eval("id")) %>'><%#: Eval("name") %></a>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            <div class="filter-tools">
                <asp:DropDownList ID="ddlBrand" runat="server" CssClass="form-control sort-select" AutoPostBack="true" AppendDataBoundItems="true"
                    DataTextField="name" DataValueField="id" OnSelectedIndexChanged="ddlSort_SelectedIndexChanged">
                    <asp:ListItem Value="0">All Brands</asp:ListItem>
                </asp:DropDownList>
                <asp:DropDownList ID="ddlSort" runat="server" CssClass="form-control sort-select" AutoPostBack="true" OnSelectedIndexChanged="ddlSort_SelectedIndexChanged">
                    <asp:ListItem Value="name">Sort: Name (A-Z)</asp:ListItem>
                    <asp:ListItem Value="low">Price: Low to High</asp:ListItem>
                    <asp:ListItem Value="high">Price: High to Low</asp:ListItem>
                    <asp:ListItem Value="new">Newest first</asp:ListItem>
                </asp:DropDownList>
                <div class="search-box">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search products..." MaxLength="60"></asp:TextBox>
                    <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary btn-sm" OnClick="btnSearch_Click" />
                </div>
            </div>
        </div>

        <asp:Literal ID="litMsg" runat="server"></asp:Literal>

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
            <h3>No products found</h3>
            <p>Try a different category or search word.</p>
        </asp:Panel>

    </div>
</asp:Content>
