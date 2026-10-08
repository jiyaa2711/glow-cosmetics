<%@ Page Title="About Us - Glow Cosmetics" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="About.aspx.cs" Inherits="AboutPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <section class="page-banner">
        <div class="container">
            <div class="crumbs"><a href="~/Default.aspx" runat="server">Home</a> / About Us</div>
            <h1>About Glow</h1>
            <p>A beauty store built on one simple idea: feel good in your own skin.</p>
        </div>
    </section>

    <%-- ================= OUR STORY ================= --%>
    <section class="container section">
        <div class="about-grid">
            <div class="about-art reveal">
                <img src="~/images/about.svg" runat="server" alt="Glow beauty products on a shelf" />
            </div>
            <div class="about-text reveal d1">
                <span class="product-cat">OUR STORY</span>
                <h2>Beauty that feels good, every single day</h2>
                <p>Glow started with a small shelf of favourite skincare and makeup products and a big wish: to make good beauty products easy to find and simple to buy online.</p>
                <p>Today we bring together skincare, makeup, haircare and fragrance in one friendly place, so you can browse by category, read clear descriptions and check out in minutes.</p>
                <ul class="check-list">
                    <li>Carefully selected products in every category</li>
                    <li>Clear descriptions and honest prices</li>
                    <li>Secure checkout with UPI, cards or Cash on Delivery</li>
                    <li>Order tracking from placed to delivered</li>
                </ul>
                <p style="margin-top:22px">
                    <a href="~/Products.aspx" runat="server" class="btn btn-primary">Explore Products</a>
                    <a href="~/Contact.aspx" runat="server" class="btn btn-outline">Get in Touch</a>
                </p>
            </div>
        </div>
    </section>

    <%-- ================= STATS ================= --%>
    <section class="stats-band">
        <div class="container">
            <div class="stats-grid">
                <div class="reveal"><div class="stat-num"><span data-count="500" data-suffix="+">0</span></div><div class="stat-lbl">Happy Customers</div></div>
                <div class="reveal d1"><div class="stat-num"><span data-count="50" data-suffix="+">0</span></div><div class="stat-lbl">Beauty Products</div></div>
                <div class="reveal d2"><div class="stat-num"><span data-count="4" data-suffix="">0</span></div><div class="stat-lbl">Categories</div></div>
                <div class="reveal d3"><div class="stat-num"><span data-count="24" data-suffix="/7">0</span></div><div class="stat-lbl">Online Store</div></div>
            </div>
        </div>
    </section>

    <%-- ================= VALUES ================= --%>
    <section class="container section">
        <div class="section-head reveal">
            <h2 class="section-title">What We Stand For</h2>
            <p class="section-sub">The values behind every product we sell</p>
        </div>
        <div class="feature-grid">
            <div class="feature-card reveal">
                <div class="feature-ico">&#127775;</div>
                <h3>Quality First</h3>
                <p>We pick products that work well and feel good, and we would happily use them ourselves.</p>
            </div>
            <div class="feature-card reveal d1">
                <div class="feature-ico">&#127807;</div>
                <h3>Gentle on Skin</h3>
                <p>Friendly, skin-loving ingredients for daily use, for every skin type and every hair type.</p>
            </div>
            <div class="feature-card reveal d2">
                <div class="feature-ico">&#129309;</div>
                <h3>Customer First</h3>
                <p>Questions, feedback or a problem with an order? Our team is one message away.</p>
            </div>
            <div class="feature-card reveal d3">
                <div class="feature-ico">&#128176;</div>
                <h3>Honest Pricing</h3>
                <p>No hidden charges and no confusing offers. Simple prices you can trust.</p>
            </div>
        </div>
    </section>

    <%-- ================= HOW IT WORKS ================= --%>
    <section class="container section">
        <div class="section-head reveal">
            <h2 class="section-title">How It Works</h2>
            <p class="section-sub">From browsing to your doorstep in four easy steps</p>
        </div>
        <div class="steps">
            <div class="step-card reveal">
                <div class="step-no">1</div>
                <h3>Browse</h3>
                <p>Explore products by category and read the full details.</p>
            </div>
            <div class="step-card reveal d1">
                <div class="step-no">2</div>
                <h3>Add to Cart</h3>
                <p>Pick your favourites and set the quantity you need.</p>
            </div>
            <div class="step-card reveal d2">
                <div class="step-no">3</div>
                <h3>Pay Securely</h3>
                <p>Choose UPI, card, netbanking or Cash on Delivery.</p>
            </div>
            <div class="step-card reveal d3">
                <div class="step-no">4</div>
                <h3>Get Delivered</h3>
                <p>Track your order until it reaches your door.</p>
            </div>
        </div>
    </section>

    <%-- ================= ABOUT THE PROJECT ================= --%>
    <section class="container section">
        <div class="project-box reveal">
            <h3>About this website</h3>
            <p style="color:#4d4256">Glow Cosmetics is an academic e-commerce project with a customer storefront and a full admin panel for managing categories, products, orders and customer messages.</p>
            <div class="tech-tags">
                <span>ASP.NET Web Forms</span>
                <span>C#</span>
                <span>MySQL</span>
                <span>Master Pages</span>
                <span>HTML &amp; CSS</span>
                <span>JavaScript</span>
                <span>Razorpay</span>
            </div>
        </div>
    </section>

    <section class="container section">
        <div class="cta-banner reveal">
            <h2>Have a question for us?</h2>
            <p>We would love to hear from you. Send us a message and we will get back to you soon.</p>
            <a href="~/Contact.aspx" runat="server" class="btn btn-light">Contact Us</a>
        </div>
    </section>

    <div style="height:50px"></div>
</asp:Content>
