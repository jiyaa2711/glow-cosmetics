<%@ Page Title="My Orders - Glow Cosmetics" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="MyOrders.aspx.cs" Inherits="MyOrdersPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <section class="page-banner">
        <div class="container">
            <div class="crumbs"><a href="~/Default.aspx" runat="server">Home</a> / My Orders</div>
            <h1>My Orders</h1>
            <p>Track all your past and current orders.</p>
        </div>
    </section>

    <div class="container page-wrap">

        <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="empty-box">
            <h3>No orders yet</h3>
            <p>When you place an order, it will show up here.</p>
            <p style="margin-top:14px"><a href="~/Products.aspx" runat="server" class="btn btn-primary">Start Shopping</a></p>
        </asp:Panel>

        <asp:Repeater ID="rptOrders" runat="server" OnItemDataBound="rptOrders_ItemDataBound">
            <ItemTemplate>
                <div class="order-card">
                    <div class="order-head">
                        <span>Order <b>#<%# Eval("id") %></b></span>
                        <span><%# Convert.ToDateTime(Eval("created_at")).ToString("dd MMM yyyy, hh:mm tt") %></span>
                        <span>Total: <b><%# Helper.Money(Eval("total")) %></b></span>
                        <span class='<%# Helper.StatusClass(Eval("order_status")) %>'><%# Eval("order_status") %></span>
                    </div>
                    <div class="order-body">
                        <%# Helper.IsCancelled(Eval("order_status")) ? "<div class=\"cancel-note\">This order was cancelled.</div>" : "" %>
                        <div class='<%# Helper.IsCancelled(Eval("order_status")) ? "tracker cancelled" : "tracker" %>'>
                            <div class='<%# Helper.Step(Eval("order_status"), 1) %>'><div class="dot">&#128221;</div>Placed</div>
                            <div class='<%# Helper.Step(Eval("order_status"), 2) %>'><div class="dot">&#128666;</div>Shipped</div>
                            <div class='<%# Helper.Step(Eval("order_status"), 3) %>'><div class="dot">&#127873;</div>Delivered</div>
                        </div>
                        <asp:Repeater ID="rptItems" runat="server">
                            <ItemTemplate>
                                <div class="order-line">
                                    <span><%#: Eval("product_name") %> &times; <%# Eval("quantity") %></span>
                                    <span><%# Helper.Money(Eval("line_total")) %></span>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                    <div class="order-foot">
                        <span>Payment: <b><%# Eval("payment_method").ToString() == "COD" ? "Cash on Delivery" : "Online" %></b>
                            <span class='<%# Helper.StatusClass(Eval("payment_status")) %>'><%# Eval("payment_status") %></span></span>
                        <span>Deliver to: <%#: Eval("ship_name") %>, <%#: Eval("ship_address") %>, <%#: Eval("ship_city") %> - <%#: Eval("ship_pincode") %></span>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

    </div>
</asp:Content>
