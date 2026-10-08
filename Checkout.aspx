<%@ Page Title="Checkout - Glow Cosmetics" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Checkout.aspx.cs" Inherits="CheckoutPage" %>

<asp:Content ID="Content0" ContentPlaceHolderID="head" runat="server">
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container page-wrap">

        <h1 class="page-title">Checkout</h1>
        <p class="page-sub">Enter your delivery details and choose how you want to pay.</p>

        <asp:Literal ID="litMsg" runat="server"></asp:Literal>

        <div class="checkout-layout">

            <div class="form-card">
                <h3 style="margin-bottom:16px">Delivery Details</h3>

                <div class="form-row">
                    <div class="form-group">
                        <label for="<%= txtName.ClientID %>">Full Name</label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control" MaxLength="100"></asp:TextBox>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtName" Display="Dynamic" ValidationGroup="checkout"
                            CssClass="validation" ErrorMessage="Name is required."></asp:RequiredFieldValidator>
                    </div>
                    <div class="form-group">
                        <label for="<%= txtPhone.ClientID %>">Mobile Number</label>
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" MaxLength="10"></asp:TextBox>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPhone" Display="Dynamic" ValidationGroup="checkout"
                            CssClass="validation" ErrorMessage="Mobile number is required."></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPhone" Display="Dynamic" ValidationGroup="checkout"
                            CssClass="validation" ErrorMessage="Enter a valid 10 digit number." ValidationExpression="^[6-9]\d{9}$"></asp:RegularExpressionValidator>
                    </div>
                </div>

                <div class="form-group">
                    <label for="<%= txtAddress.ClientID %>">Full Address</label>
                    <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" MaxLength="300"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtAddress" Display="Dynamic" ValidationGroup="checkout"
                        CssClass="validation" ErrorMessage="Address is required."></asp:RequiredFieldValidator>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="<%= txtCity.ClientID %>">City</label>
                        <asp:TextBox ID="txtCity" runat="server" CssClass="form-control" MaxLength="80"></asp:TextBox>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCity" Display="Dynamic" ValidationGroup="checkout"
                            CssClass="validation" ErrorMessage="City is required."></asp:RequiredFieldValidator>
                    </div>
                    <div class="form-group">
                        <label for="<%= txtPincode.ClientID %>">Pincode</label>
                        <asp:TextBox ID="txtPincode" runat="server" CssClass="form-control" MaxLength="6"></asp:TextBox>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPincode" Display="Dynamic" ValidationGroup="checkout"
                            CssClass="validation" ErrorMessage="Pincode is required."></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPincode" Display="Dynamic" ValidationGroup="checkout"
                            CssClass="validation" ErrorMessage="Enter a valid 6 digit pincode." ValidationExpression="^\d{6}$"></asp:RegularExpressionValidator>
                    </div>
                </div>

                <h3 style="margin:10px 0 12px">Payment Method</h3>
                <div class="form-group">
                    <asp:RadioButtonList ID="rblPayment" runat="server" RepeatLayout="Flow" RepeatDirection="Vertical" CssClass="radio-list">
                        <asp:ListItem Value="COD" Selected="True">Cash on Delivery</asp:ListItem>
                        <asp:ListItem Value="ONLINE">Pay Online (UPI / Card / Netbanking via Razorpay)</asp:ListItem>
                    </asp:RadioButtonList>
                </div>

                <asp:Button ID="btnPlace" runat="server" Text="Place Order" CssClass="btn btn-primary btn-block"
                    ValidationGroup="checkout" OnClick="btnPlace_Click" />
            </div>

            <div class="summary-card">
                <h3>Your Order</h3>
                <asp:Repeater ID="rptSummary" runat="server">
                    <ItemTemplate>
                        <div class="mini-item">
                            <span><%#: Eval("name") %> &times; <%# Eval("quantity") %></span>
                            <span><%# Helper.Money(Eval("line_total")) %></span>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <div class="summary-row"><span>Delivery</span><span style="color:#1f9d6b"><b>FREE</b></span></div>
                <div class="summary-total"><span>Total</span><span><asp:Literal ID="litTotal" runat="server"></asp:Literal></span></div>
                <p style="text-align:center; margin-top:14px"><a href="~/Cart.aspx" runat="server">Edit cart</a></p>
            </div>

        </div>

        <%-- Razorpay ke liye hidden fields aur buttons (JavaScript inhe use karta hai) --%>
        <asp:HiddenField ID="hfOrderId" runat="server" />
        <asp:HiddenField ID="hfPaymentId" runat="server" />
        <asp:HiddenField ID="hfSignature" runat="server" />
        <asp:Button ID="btnVerify" runat="server" Text="verify" style="display:none" CausesValidation="false" OnClick="btnVerify_Click" />
        <asp:Button ID="btnCancelPay" runat="server" Text="cancel" style="display:none" CausesValidation="false" OnClick="btnCancelPay_Click" />

    </div>
</asp:Content>
