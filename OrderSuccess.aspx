<%@ Page Title="Order Placed - Glow Cosmetics" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="OrderSuccess.aspx.cs" Inherits="OrderSuccessPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container page-wrap">

        <asp:Panel ID="pnlNotFound" runat="server" Visible="false" CssClass="empty-box">
            <h3>Order not found</h3>
            <p style="margin-top:14px"><a href="~/MyOrders.aspx" runat="server" class="btn btn-primary">Go to My Orders</a></p>
        </asp:Panel>

        <asp:Panel ID="pnlOrder" runat="server" CssClass="success-box">
            <div class="tick">&#10003;</div>
            <h1>Thank you for your order!</h1>
            <p class="page-sub">
                Order <b>#<asp:Literal ID="litOrderId" runat="server"></asp:Literal></b> has been placed successfully.
            </p>

            <div class="form-card" style="text-align:left">
                <div class="summary-row"><span>Total amount</span><b><asp:Literal ID="litTotal" runat="server"></asp:Literal></b></div>
                <div class="summary-row"><span>Payment</span><span><asp:Literal ID="litPayment" runat="server"></asp:Literal></span></div>
                <div class="summary-row"><span>Deliver to</span><span style="text-align:right"><asp:Literal ID="litAddress" runat="server"></asp:Literal></span></div>
            </div>

            <p style="margin-top:24px">
                <a href="~/MyOrders.aspx" runat="server" class="btn btn-primary">View My Orders</a>
                <a href="~/Products.aspx" runat="server" class="btn btn-outline">Continue Shopping</a>
            </p>
        </asp:Panel>

    </div>
</asp:Content>
