<%@ Page Title="Contact Us - Glow Cosmetics" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Contact.aspx.cs" Inherits="ContactPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <section class="page-banner">
        <div class="container">
            <div class="crumbs"><a href="~/Default.aspx" runat="server">Home</a> / Contact Us</div>
            <h1>Contact Us</h1>
            <p>Questions, feedback or need help with an order? Send us a message.</p>
        </div>
    </section>

    <section class="container section">
        <div class="contact-grid">

            <%-- ---------- Info cards ---------- --%>
            <div class="contact-cards">
                <div class="contact-card reveal">
                    <div class="info-ico">&#128205;</div>
                    <div><b>Visit Us</b><span>Glow Cosmetics, Ahmedabad,<br />Gujarat, India</span></div>
                </div>
                <div class="contact-card reveal d1">
                    <div class="info-ico">&#128222;</div>
                    <div><b>Call Us</b><span>+91 98765 43210</span></div>
                </div>
                <div class="contact-card reveal d2">
                    <div class="info-ico">&#9993;</div>
                    <div><b>Email Us</b><span>hello@glowcosmetics.example</span></div>
                </div>
                <div class="contact-card reveal d3">
                    <div class="info-ico">&#128337;</div>
                    <div><b>Working Hours</b><span>Mon - Sat: 10:00 AM - 7:00 PM<br />Sunday: Closed</span></div>
                </div>
            </div>

            <%-- ---------- Form ---------- --%>
            <div class="form-card reveal d1">
                <h3 style="font-size:26px; margin-bottom:4px">Send us a message</h3>
                <p class="page-sub" style="margin-bottom:18px">We usually reply within one working day.</p>

                <asp:Literal ID="litMsg" runat="server"></asp:Literal>

                <div class="form-row">
                    <div class="form-group">
                        <label for="<%= txtName.ClientID %>">Your Name</label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control" MaxLength="100" ValidationGroup="contact"></asp:TextBox>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtName" Display="Dynamic" ValidationGroup="contact"
                            CssClass="validation" ErrorMessage="Please enter your name."></asp:RequiredFieldValidator>
                    </div>
                    <div class="form-group">
                        <label for="<%= txtEmail.ClientID %>">Email</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" MaxLength="150" ValidationGroup="contact"></asp:TextBox>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail" Display="Dynamic" ValidationGroup="contact"
                            CssClass="validation" ErrorMessage="Please enter your email."></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail" Display="Dynamic" ValidationGroup="contact"
                            CssClass="validation" ErrorMessage="Enter a valid email address."
                            ValidationExpression="^[\w\.\-\+]+@([\w\-]+\.)+[\w\-]{2,}$"></asp:RegularExpressionValidator>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="<%= txtPhone.ClientID %>">Mobile (optional)</label>
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" MaxLength="10" ValidationGroup="contact"></asp:TextBox>
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPhone" Display="Dynamic" ValidationGroup="contact"
                            CssClass="validation" ErrorMessage="Enter a valid 10 digit mobile number."
                            ValidationExpression="^[6-9]\d{9}$"></asp:RegularExpressionValidator>
                    </div>
                    <div class="form-group">
                        <label for="<%= ddlSubject.ClientID %>">Subject</label>
                        <asp:DropDownList ID="ddlSubject" runat="server" CssClass="form-control" ValidationGroup="contact">
                            <asp:ListItem>General question</asp:ListItem>
                            <asp:ListItem>Order help</asp:ListItem>
                            <asp:ListItem>Product information</asp:ListItem>
                            <asp:ListItem>Feedback</asp:ListItem>
                            <asp:ListItem>Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="form-group">
                    <label for="<%= txtMessage.ClientID %>">Message</label>
                    <asp:TextBox ID="txtMessage" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="5" MaxLength="1000" ValidationGroup="contact"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtMessage" Display="Dynamic" ValidationGroup="contact"
                        CssClass="validation" ErrorMessage="Please write your message."></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtMessage" Display="Dynamic" ValidationGroup="contact"
                        CssClass="validation" ErrorMessage="Message is too long (maximum 1000 characters)."
                        ValidationExpression="^[\s\S]{0,1000}$"></asp:RegularExpressionValidator>
                </div>

                <asp:Button ID="btnSend" runat="server" Text="Send Message" CssClass="btn btn-primary btn-block"
                    ValidationGroup="contact" OnClick="btnSend_Click" />
            </div>
        </div>
    </section>

    <%-- ================= FAQ ================= --%>
    <section class="container section">
        <div class="section-head reveal">
            <h2 class="section-title">Frequently Asked Questions</h2>
            <p class="section-sub">Quick answers to common questions</p>
        </div>
        <div class="faq-list">
            <div class="faq-item reveal">
                <button type="button" class="faq-q">How long does delivery take?</button>
                <div class="faq-a">Most orders are delivered within 3 to 7 working days, depending on your city. Delivery is free on every order.</div>
            </div>
            <div class="faq-item reveal d1">
                <button type="button" class="faq-q">Which payment methods can I use?</button>
                <div class="faq-a">You can pay online with UPI, debit or credit card and netbanking through Razorpay, or choose Cash on Delivery at checkout.</div>
            </div>
            <div class="faq-item reveal d2">
                <button type="button" class="faq-q">How can I track my order?</button>
                <div class="faq-a">Login and open My Orders. Each order shows a tracker that moves from Placed to Shipped to Delivered.</div>
            </div>
            <div class="faq-item reveal d3">
                <button type="button" class="faq-q">Can I cancel my order?</button>
                <div class="faq-a">Yes, as long as it has not been shipped. Send us a message here with your order number and we will cancel it for you.</div>
            </div>
            <div class="faq-item reveal d3">
                <button type="button" class="faq-q">Do I need an account to shop?</button>
                <div class="faq-a">You can browse everything without an account. To add items to your cart and place an order, please create a free account.</div>
            </div>
        </div>
    </section>

    <div style="height:50px"></div>
</asp:Content>
