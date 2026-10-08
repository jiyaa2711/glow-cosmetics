<%@ Page Title="Login - Glow Cosmetics" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="LoginPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container page-wrap">
        <div class="auth-wrap">
            <h1>Welcome back</h1>
            <p class="page-sub">Login to continue shopping.</p>

            <div class="form-card">
                <asp:Literal ID="litMsg" runat="server"></asp:Literal>

                <div class="form-group">
                    <label for="<%= txtEmail.ClientID %>">Email</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" MaxLength="150"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail" Display="Dynamic"
                        CssClass="validation" ErrorMessage="Please enter your email."></asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label for="<%= txtPassword.ClientID %>">Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" MaxLength="50"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPassword" Display="Dynamic"
                        CssClass="validation" ErrorMessage="Please enter your password."></asp:RequiredFieldValidator>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-primary btn-block" OnClick="btnLogin_Click" />

                <p class="form-foot">New to Glow?
                    <asp:HyperLink ID="lnkRegister" runat="server" NavigateUrl="~/Register.aspx"><b>Create an account</b></asp:HyperLink>
                </p>
            </div>
        </div>
    </div>
</asp:Content>
