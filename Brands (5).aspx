<%@ Page Title="Brands - Glow Cosmetics" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Brands.aspx.cs" Inherits="BrandsPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <section class="page-banner">
        <div class="container">
            <div class="crumbs"><a href="~/Default.aspx" runat="server">Home</a> / Brands</div>
            <h1>Shop by Brand</h1>
            <p>Choose your favourite brand and see exactly what it offers: lipsticks, foundations, skincare and more.</p>
        </div>
    </section>

    <section class="container section">
        <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="empty-box">
            <h3>No brands yet</h3>
            <p>Please check back soon.</p>
        </asp:Panel>

        <div class="brand-grid big">
            <asp:Repeater ID="rptBrands" runat="server">
                <ItemTemplate>
                    <a class="brand-card reveal" href='<%# ResolveUrl("~/BrandDetails.aspx?id=" + Eval("id")) %>'>
                        <span class="brand-logo" style='<%# Helper.BrandStyle(Eval("name")) %>'><%# Helper.BrandInitial(Eval("name")) %></span>
                        <h3><%#: Eval("name") %></h3>
                        <p class="brand-desc"><%#: Eval("description") %></p>
                        <span class="brand-count"><%# Eval("product_count") %> products &middot; <%# Eval("type_count") %> types</span>
                    </a>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </section>

    <div style="height:50px"></div>
</asp:Content>
