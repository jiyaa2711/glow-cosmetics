<%@ Page Title="Dashboard - Admin" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Admin_Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h1>Dashboard</h1>
    <p class="page-sub">Welcome, <asp:Literal ID="litAdmin" runat="server"></asp:Literal>. Here is how the store is doing.</p>

    <div class="stat-grid">
        <div class="stat-card"><div class="num"><asp:Literal ID="litRevenue" runat="server"></asp:Literal></div><div class="lbl">Revenue (paid orders)</div></div>
        <div class="stat-card"><div class="num"><asp:Literal ID="litOrders" runat="server"></asp:Literal></div><div class="lbl">Total orders</div></div>
        <div class="stat-card"><div class="num"><asp:Literal ID="litNewOrders" runat="server"></asp:Literal></div><div class="lbl">New (not shipped yet)</div></div>
        <div class="stat-card"><div class="num"><asp:Literal ID="litProducts" runat="server"></asp:Literal></div><div class="lbl">Products</div></div>
        <div class="stat-card"><div class="num"><asp:Literal ID="litUsers" runat="server"></asp:Literal></div><div class="lbl">Customers</div></div>
        <div class="stat-card"><div class="num"><asp:Literal ID="litMessages" runat="server"></asp:Literal></div><div class="lbl">Unread messages</div></div>
    </div>

    <div class="panel">
        <h3>Recent Orders</h3>
        <div class="table-wrap" style="box-shadow:none">
            <table class="data">
                <thead>
                    <tr><th>Order</th><th>Customer</th><th>Total</th><th>Payment</th><th>Status</th><th>Date</th></tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptRecent" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td><b>#<%# Eval("id") %></b></td>
                                <td><%#: Eval("full_name") %></td>
                                <td><%# Helper.Money(Eval("total")) %></td>
                                <td><%# Eval("payment_method") %> <span class='<%# Helper.StatusClass(Eval("payment_status")) %>'><%# Eval("payment_status") %></span></td>
                                <td><span class='<%# Helper.StatusClass(Eval("order_status")) %>'><%# Eval("order_status") %></span></td>
                                <td><%# Convert.ToDateTime(Eval("created_at")).ToString("dd MMM yyyy") %></td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>
        <asp:Label ID="lblNoOrders" runat="server" Visible="false" Text="No orders yet." CssClass="page-sub"></asp:Label>
    </div>

    <div class="panel">
        <h3>Low Stock (5 or fewer)</h3>
        <div class="table-wrap" style="box-shadow:none">
            <table class="data">
                <thead><tr><th>Product</th><th>Category</th><th>Stock left</th></tr></thead>
                <tbody>
                    <asp:Repeater ID="rptLow" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td><%#: Eval("name") %></td>
                                <td><%#: Eval("category_name") %></td>
                                <td><b style="color:#d64545"><%# Eval("stock") %></b></td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>
        <asp:Label ID="lblNoLow" runat="server" Visible="false" Text="All products are well stocked." CssClass="page-sub"></asp:Label>
    </div>

</asp:Content>
