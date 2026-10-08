<%@ Page Title="Register - Glow Cosmetics" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="RegisterPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container page-wrap">
        <div class="auth-wrap">
            <h1>Create your account</h1>
            <p class="page-sub">Join Glow to save your cart and track your orders.</p>

            <div class="form-card">
                <asp:Literal ID="litMsg" runat="server"></asp:Literal>

                <div class="form-group">
                    <label for="<%= txtName.ClientID %>">Full Name</label>
                    <asp:TextBox ID="txtName" runat="server" CssClass="form-control" MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtName" Display="Dynamic"
                        CssClass="validation" ErrorMessage="Please enter your name."></asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label for="<%= txtEmail.ClientID %>">Email</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" MaxLength="150"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail" Display="Dynamic"
                        CssClass="validation" ErrorMessage="Please enter your email."></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail" Display="Dynamic"
                        CssClass="validation" ErrorMessage="Enter a valid email address."
                        ValidationExpression="^[\w\.\-\+]+@([\w\-]+\.)+[\w\-]{2,}$"></asp:RegularExpressionValidator>
                </div>

                <div class="form-group">
                    <label for="<%= txtPhone.ClientID %>">Mobile Number</label>
                    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" MaxLength="10"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPhone" Display="Dynamic"
                        CssClass="validation" ErrorMessage="Please enter your mobile number."></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPhone" Display="Dynamic"
                        CssClass="validation" ErrorMessage="Enter a valid 10 digit mobile number."
                        ValidationExpression="^[6-9]\d{9}$"></asp:RegularExpressionValidator>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="<%= txtPassword.ClientID %>">Password</label>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" MaxLength="50"></asp:TextBox>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPassword" Display="Dynamic"
                            CssClass="validation" ErrorMessage="Please enter a password."></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPassword" Display="Dynamic"
                            CssClass="validation" ErrorMessage="Minimum 6 characters."
                            ValidationExpression="^.{6,50}$"></asp:RegularExpressionValidator>
                    </div>
                    <div class="form-group">
                        <label for="<%= txtConfirm.ClientID %>">Confirm Password</label>
                        <asp:TextBox ID="txtConfirm" runat="server" CssClass="form-control" TextMode="Password" MaxLength="50"></asp:TextBox>
                        <asp:CompareValidator runat="server" ControlToValidate="txtConfirm" ControlToCompare="txtPassword"
                            Display="Dynamic" CssClass="validation" ErrorMessage="Passwords do not match."></asp:CompareValidator>
                    </div>
                </div>

                <asp:Button ID="btnRegister" runat="server" Text="Create Account" CssClass="btn btn-primary btn-block" OnClick="btnRegister_Click" />

                <p class="form-foot">Already have an account?
                    <asp:HyperLink ID="lnkLogin" runat="server" NavigateUrl="~/Login.aspx"><b>Login</b></asp:HyperLink>
                </p>
            </div>
        </div>
    </div>
</asp:Content>
