<%@ Page Title="Orders - Admin" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="Orders.aspx.cs" Inherits="Admin_Orders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h1>Orders</h1>
    <p class="page-sub">View customer orders and update their delivery status.</p>

    <asp:Literal ID="litMsg" runat="server"></asp:Literal>

    <div class="inline-form" style="margin-bottom:20px">
        <label><b>Show:</b></label>
        <asp:DropDownList ID="ddlFilter" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlFilter_SelectedIndexChanged">
            <asp:ListItem Value="">All orders</asp:ListItem>
            <asp:ListItem Value="Placed">Placed (new)</asp:ListItem>
            <asp:ListItem Value="Shipped">Shipped</asp:ListItem>
            <asp:ListItem Value="Delivered">Delivered</asp:ListItem>
            <asp:ListItem Value="Cancelled">Cancelled</asp:ListItem>
        </asp:DropDownList>
    </div>

    <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="empty-box">
        <h3>No orders found</h3>
    </asp:Panel>

    <asp:Repeater ID="rptOrders" runat="server" OnItemDataBound="rptOrders_ItemDataBound" OnItemCommand="rptOrders_ItemCommand">
        <ItemTemplate>
            <div class="order-card">
                <div class="order-head">
                    <span>Order <b>#<%# Eval("id") %></b></span>
                    <span><%#: Eval("full_name") %> (<%#: Eval("email") %>)</span>
                    <span><%# Convert.ToDateTime(Eval("created_at")).ToString("dd MMM yyyy, hh:mm tt") %></span>
                    <span>Total: <b><%# Helper.Money(Eval("total")) %></b></span>
                </div>
                <div class="order-body">
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
                    <span>
                        <b>Ship to:</b> <%#: Eval("ship_name") %>, <%#: Eval("ship_phone") %><br />
                        <%#: Eval("ship_address") %>, <%#: Eval("ship_city") %> - <%#: Eval("ship_pincode") %>
                    </span>
                    <span>
                        <b>Payment:</b> <%# Eval("payment_method") %>
                        <span class='<%# Helper.StatusClass(Eval("payment_status")) %>'><%# Eval("payment_status") %></span>
                        <br /><br />
                        <span class="inline-form">
                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control">
                                <asp:ListItem>Placed</asp:ListItem>
                                <asp:ListItem>Shipped</asp:ListItem>
                                <asp:ListItem>Delivered</asp:ListItem>
                                <asp:ListItem>Cancelled</asp:ListItem>
                            </asp:DropDownList>
                            <asp:Button ID="btnUpdate" runat="server" Text="Update Status" CssClass="btn btn-dark btn-sm"
                                CommandName="update" CommandArgument='<%# Eval("id") %>' />
                        </span>
                    </span>
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>

</asp:Content>
