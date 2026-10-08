<%@ Page Title="Glow Cosmetics - Beauty that feels good" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="HomePage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <%-- ================= HERO ================= --%>
    <section class="hero2">
        <div class="container hero2-grid">
            <div>
                <span class="hero-tag fade-up">NEW COLLECTION 2026</span>
                <h1 class="fade-up d1">Discover your <span>natural glow</span></h1>
                <p class="lead fade-up d2">Skincare, makeup, haircare and fragrance picked with love. Shop your favourite beauty products at honest prices, delivered to your door.</p>
                <div class="hero-btns fade-up d3">
                    <a href="~/Products.aspx" runat="server" class="btn btn-primary">Shop Now</a>
                    <a href="~/About.aspx" runat="server" class="btn btn-light">Our Story</a>
                </div>
                <div class="hero-mini fade-up d3">
                    <div><b>10+</b>Products</div>
                    <div><b>4</b>Categories</div>
                    <div><b>Free</b>Delivery</div>
                </div>
            </div>
            <div class="hero-visual">
                <img src="~/images/hero.svg" runat="server" alt="Glow cosmetics products" />
                <span class="float-chip c1">&#10004; 100% Authentic</span>
                <span class="float-chip c2">&#128666; Free Delivery</span>
                <span class="float-chip c3">&#10084; Customer Favourite</span>
            </div>
        </div>
    </section>

    <%-- ================= INFO STRIP ================= --%>
    <div class="container">
        <div class="info-strip">
            <div class="info-item reveal">
                <div class="info-ico">&#128666;</div>
                <div><b>Free Delivery</b><span>On every order</span></div>
            </div>
            <div class="info-item reveal d1">
                <div class="info-ico">&#128274;</div>
                <div><b>Secure Payments</b><span>UPI, Cards &amp; COD</span></div>
            </div>
            <div class="info-item reveal d2">
                <div class="info-ico">&#10024;</div>
                <div><b>Genuine Products</b><span>Carefully selected</span></div>
            </div>
            <div class="info-item reveal d3">
                <div class="info-ico">&#128172;</div>
                <div><b>Friendly Support</b><span>We reply quickly</span></div>
            </div>
        </div>
    </div>

    <%-- ================= BRANDS ================= --%>
    <section class="container section">
        <div class="section-head reveal">
            <h2 class="section-title">Shop by Brand</h2>
            <p class="section-sub">Pick a brand to see its lipsticks, foundations and more</p>
        </div>
        <div class="brand-grid">
            <asp:Repeater ID="rptBrands" runat="server">
                <ItemTemplate>
                    <a class="brand-card reveal" href='<%# ResolveUrl("~/BrandDetails.aspx?id=" + Eval("id")) %>'>
                        <span class="brand-logo" style='<%# Helper.BrandStyle(Eval("name")) %>'><%# Helper.BrandInitial(Eval("name")) %></span>
                        <h3><%#: Eval("name") %></h3>
                        <p><%# Eval("product_count") %> products</p>
                    </a>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <p style="text-align:center; margin-top:24px;">
            <a href="~/Brands.aspx" runat="server" class="btn btn-outline">View All Brands</a>
        </p>
    </section>

    <%-- ================= CATEGORIES ================= --%>
    <section class="container section">
        <div class="section-head reveal">
            <h2 class="section-title">Shop by Category</h2>
            <p class="section-sub">Find exactly what your skin and style need</p>
        </div>
        <div class="cat-grid">
            <asp:Repeater ID="rptCategories" runat="server">
                <ItemTemplate>
                    <a class="cat-card reveal" href='<%# ResolveUrl("~/Products.aspx?cat=" + Eval("id")) %>'>
                        <div class="cat-icon"><%# Helper.CatIcon(Eval("name")) %></div>
                        <h3><%#: Eval("name") %></h3>
                        <p><%#: Eval("description") %></p>
                    </a>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </section>

    <%-- ================= NEW ARRIVALS ================= --%>
    <section class="container section">
        <div class="section-head reveal">
            <h2 class="section-title">New Arrivals</h2>
            <p class="section-sub">Fresh picks our customers love</p>
        </div>

        <asp:Literal ID="litMsg" runat="server"></asp:Literal>

        <div class="product-grid">
            <asp:Repeater ID="rptProducts" runat="server" OnItemCommand="rptProducts_ItemCommand">
                <ItemTemplate>
                    <div class="product-card">
                        <a class="product-img" href='<%# ResolveUrl("~/ProductDetails.aspx?id=" + Eval("id")) %>'>
                            <img src='<%# Helper.ImgUrl(Eval("image")) %>' alt='<%#: Eval("name") %>' />
                        </a>
                        <div class="product-body">
                            <span class="product-cat"><%# Helper.Tag(Eval("brand_name"), Eval("category_name")) %></span>
                            <h3 class="product-name"><a href='<%# ResolveUrl("~/ProductDetails.aspx?id=" + Eval("id")) %>'><%#: Eval("name") %></a></h3>
                            <p class="product-desc"><%#: Helper.ShortText(Eval("description"), 70) %></p>
                            <div class="product-price"><%# Helper.Money(Eval("price")) %></div>
                            <div class="product-actions">
                                <a class="btn btn-outline" href='<%# ResolveUrl("~/ProductDetails.aspx?id=" + Eval("id")) %>'>View</a>
                                <asp:LinkButton ID="btnAdd" runat="server" CssClass="btn btn-primary"
                                    CommandName="add" CommandArgument='<%# Eval("id") %>'
                                    Visible='<%# Convert.ToInt32(Eval("stock")) > 0 %>'>Add to Cart</asp:LinkButton>
                                <asp:Label ID="lblOut" runat="server" CssClass="out-tag"
                                    Visible='<%# Convert.ToInt32(Eval("stock")) <= 0 %>'>Out of stock</asp:Label>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <p style="text-align:center; margin-top:30px;">
            <a href="~/Products.aspx" runat="server" class="btn btn-dark">View All Products</a>
        </p>
    </section>

    <%-- ================= WHY GLOW (information cards) ================= --%>
    <section class="container section">
        <div class="section-head reveal">
            <h2 class="section-title">Why Choose Glow?</h2>
            <p class="section-sub">Beauty shopping made simple, safe and joyful</p>
        </div>
        <div class="feature-grid">
            <div class="feature-card reveal">
                <div class="feature-ico">&#127807;</div>
                <h3>Skin-friendly Picks</h3>
                <p>Every product is chosen for gentle, effective ingredients that suit everyday Indian skin and hair.</p>
            </div>
            <div class="feature-card reveal d1">
                <div class="feature-ico">&#128176;</div>
                <h3>Honest Pricing</h3>
                <p>Fair prices with no hidden charges. What you see on the product page is what you pay.</p>
            </div>
            <div class="feature-card reveal d2">
                <div class="feature-ico">&#128230;</div>
                <h3>Track Every Order</h3>
                <p>Follow your order from placed to shipped to delivered right from your My Orders page.</p>
            </div>
            <div class="feature-card reveal d3">
                <div class="feature-ico">&#128179;</div>
                <h3>Flexible Payment</h3>
                <p>Pay online with UPI, card or netbanking, or simply choose Cash on Delivery.</p>
            </div>
        </div>
    </section>

    <%-- ================= STATS BAND ================= --%>
    <section class="stats-band">
        <div class="container">
            <div class="stats-grid">
                <div class="reveal"><div class="stat-num"><span data-count="500" data-suffix="+">0</span></div><div class="stat-lbl">Happy Customers</div></div>
                <div class="reveal d1"><div class="stat-num"><span data-count="50" data-suffix="+">0</span></div><div class="stat-lbl">Beauty Products</div></div>
                <div class="reveal d2"><div class="stat-num"><span data-count="4.9">0</span></div><div class="stat-lbl">Average Rating</div></div>
                <div class="reveal d3"><div class="stat-num"><span data-count="100" data-suffix="%">0</span></div><div class="stat-lbl">Secure Checkout</div></div>
            </div>
        </div>
    </section>

    <%-- ================= TESTIMONIALS ================= --%>
    <section class="container section">
        <div class="section-head reveal">
            <h2 class="section-title">What Our Customers Say</h2>
            <p class="section-sub">Sample reviews for the demo</p>
        </div>
        <div class="testi-wrap reveal">
            <div class="testi-slides" id="testiSlider">
                <div class="testi-slide">
                    <div class="testi-stars">&#9733;&#9733;&#9733;&#9733;&#9733;</div>
                    <p class="testi-quote">"The vitamin C serum suits my skin perfectly. Delivery was quick and the packaging was lovely!"</p>
                    <div class="testi-name">Priya S.</div>
                    <div class="testi-role">Skincare lover</div>
                </div>
                <div class="testi-slide">
                    <div class="testi-stars">&#9733;&#9733;&#9733;&#9733;&#9733;</div>
                    <p class="testi-quote">"I love how easy the website is. Ordering, paying and tracking my order took just a few clicks."</p>
                    <div class="testi-name">Neha P.</div>
                    <div class="testi-role">Regular customer</div>
                </div>
                <div class="testi-slide">
                    <div class="testi-stars">&#9733;&#9733;&#9733;&#9733;&#9734;</div>
                    <p class="testi-quote">"Great range of makeup at honest prices. The matte lipstick has become my everyday favourite."</p>
                    <div class="testi-name">Ritu M.</div>
                    <div class="testi-role">Makeup enthusiast</div>
                </div>
            </div>
            <div class="testi-dots" id="testiDots"></div>
        </div>
    </section>

    <%-- ================= CTA ================= --%>
    <section class="container section">
        <div class="cta-banner reveal">
            <h2>Ready to glow?</h2>
            <p>Create a free account to save your cart and track your orders, or say hello if you need any help.</p>
            <a href="~/Register.aspx" runat="server" class="btn btn-light">Create Account</a>
            <a href="~/Contact.aspx" runat="server" class="btn btn-outline" style="color:#fff;border-color:#fff">Contact Us</a>
        </div>
    </section>

    <div style="height:50px"></div>
</asp:Content>
