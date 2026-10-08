<%@ Page Title="Customers - Admin" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="Users.aspx.cs" Inherits="Admin_Users" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h1>Customers</h1>
    <p class="page-sub">All registered customers of your store.</p>

    <div class="panel">
        <div class="table-wrap" style="box-shadow:none">
            <table class="data">
                <thead>
                    <tr><th>#</th><th>Name</th><th>Email</th><th>Mobile</th><th>Joined</th><th>Orders</th><th>Total Paid</th></tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptUsers" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td><%# Eval("id") %></td>
                                <td><b><%#: Eval("full_name") %></b></td>
                                <td><%#: Eval("email") %></td>
                                <td><%#: Eval("phone") %></td>
                                <td><%# Convert.ToDateTime(Eval("created_at")).ToString("dd MMM yyyy") %></td>
                                <td><%# Eval("order_count") %></td>
                                <td><%# Helper.Money(Eval("spent")) %></td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>
        <asp:Label ID="lblEmpty" runat="server" Visible="false" Text="No customers have registered yet." CssClass="page-sub"></asp:Label>
    </div>

</asp:Content>
