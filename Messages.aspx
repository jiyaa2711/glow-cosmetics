<%@ Page Title="Messages - Admin" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="Messages.aspx.cs" Inherits="Admin_Messages" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h1>Messages</h1>
    <p class="page-sub">Messages sent by visitors from the Contact Us page.</p>

    <asp:Literal ID="litMsg" runat="server"></asp:Literal>

    <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="empty-box">
        <h3>No messages yet</h3>
        <p>When someone uses the Contact page, the message will appear here.</p>
    </asp:Panel>

    <asp:Repeater ID="rptMessages" runat="server" OnItemCommand="rptMessages_ItemCommand">
        <ItemTemplate>
            <div class='<%# Convert.ToInt32(Eval("is_read")) == 0 ? "msg-card unread" : "msg-card" %>'>
                <div class="msg-head">
                    <span><b><%#: Eval("name") %></b> &lt;<%#: Eval("email") %>&gt;<%# Eval("phone") == DBNull.Value || Eval("phone").ToString() == "" ? "" : " &middot; " + HttpUtility.HtmlEncode(Eval("phone").ToString()) %></span>
                    <span class="msg-meta"><%# Convert.ToDateTime(Eval("created_at")).ToString("dd MMM yyyy, hh:mm tt") %></span>
                </div>
                <div class="msg-meta" style="margin-bottom:8px">Subject: <b><%#: Eval("subject") %></b></div>
                <p><%# Helper.Multiline(Eval("message")) %></p>
                <p style="margin-top:12px">
                    <asp:LinkButton ID="btnRead" runat="server" CssClass="btn btn-dark btn-sm" CommandName="read" CommandArgument='<%# Eval("id") %>'
                        Visible='<%# Convert.ToInt32(Eval("is_read")) == 0 %>'>Mark as read</asp:LinkButton>
                    <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn btn-outline btn-sm" CommandName="delete" CommandArgument='<%# Eval("id") %>'
                        OnClientClick="return confirm('Delete this message?');">Delete</asp:LinkButton>
                </p>
            </div>
        </ItemTemplate>
    </asp:Repeater>

</asp:Content>
