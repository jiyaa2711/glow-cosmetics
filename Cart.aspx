<%@ Page Title="My Cart - Glow Cosmetics" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Cart.aspx.cs" Inherits="CartPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container page-wrap">

        <h1 class="page-title">Shopping Cart</h1>
        <p class="page-sub">Review your items before checkout.</p>

        <asp:Literal ID="litMsg" runat="server"></asp:Literal>

        <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="empty-box">
            <h3>Your cart is empty</h3>
            <p>Looks like you have not added anything yet.</p>
            <p style="margin-top:14px"><a href="~/Products.aspx" runat="server" class="btn btn-primary">Start Shopping</a></p>
        </asp:Panel>

        <asp:Panel ID="pnlCart" runat="server">
            <div class="cart-layout">

                <div class="table-wrap">
                    <table class="data">
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Price</th>
                                <th>Quantity</th>
                                <th>Total</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptCart" runat="server" OnItemCommand="rptCart_ItemCommand">
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <div class="cart-item">
                                                <img class="cart-thumb" src='<%# Helper.ImgUrl(Eval("image")) %>' alt='<%#: Eval("name") %>' />
                                                <a href='<%# ResolveUrl("~/ProductDetails.aspx?id=" + Eval("product_id")) %>'><b><%#: Eval("name") %></b></a>
                                            </div>
                                        </td>
                                        <td><%# Helper.Money(Eval("price")) %></td>
                                        <td>
                                            <div class="qty-ctrl">
                                                <asp:LinkButton ID="btnMinus" runat="server" CommandName="minus" CommandArgument='<%# Eval("cart_id") %>'>&#8722;</asp:LinkButton>
                                                <span><%# Eval("quantity") %></span>
                                                <asp:LinkButton ID="btnPlus" runat="server" CommandName="plus" CommandArgument='<%# Eval("cart_id") %>'>+</asp:LinkButton>
                                            </div>
                                        </td>
                                        <td><b><%# Helper.Money(Eval("line_total")) %></b></td>
                                        <td>
                                            <asp:LinkButton ID="btnRemove" runat="server" CssClass="btn btn-danger btn-sm"
                                                CommandName="remove" CommandArgument='<%# Eval("cart_id") %>'>Remove</asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>

                <div class="summary-card">
                    <h3>Order Summary</h3>
                    <div class="summary-row"><span>Items</span><span><asp:Literal ID="litItems" runat="server"></asp:Literal></span></div>
                    <div class="summary-row"><span>Subtotal</span><span><asp:Literal ID="litSubtotal" runat="server"></asp:Literal></span></div>
                    <div class="summary-row"><span>Delivery</span><span style="color:#1f9d6b"><b>FREE</b></span></div>
                    <div class="summary-total"><span>Total</span><span><asp:Literal ID="litTotal" runat="server"></asp:Literal></span></div>
                    <br />
                    <a href="~/Checkout.aspx" runat="server" class="btn btn-primary btn-block">Proceed to Checkout</a>
                    <p style="text-align:center; margin-top:12px"><a href="~/Products.aspx" runat="server">Continue shopping</a></p>
                </div>

            </div>
        </asp:Panel>

    </div>
</asp:Content>
