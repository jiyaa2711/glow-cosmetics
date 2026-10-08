<%@ Page Title="Products - Admin" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="Products.aspx.cs" Inherits="Admin_Products" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h1>Products</h1>
    <p class="page-sub">Add new products, edit details, upload images and control what customers can see.</p>

    <asp:Literal ID="litMsg" runat="server"></asp:Literal>

    <div class="panel">
        <h3><asp:Literal ID="litFormTitle" runat="server" Text="Add New Product"></asp:Literal></h3>

        <asp:HiddenField ID="hfEditId" runat="server" />

        <div class="form-row">
            <div class="form-group">
                <label for="<%= txtName.ClientID %>">Product Name</label>
                <asp:TextBox ID="txtName" runat="server" CssClass="form-control" MaxLength="150" ValidationGroup="prod"></asp:TextBox>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtName" ValidationGroup="prod"
                    Display="Dynamic" CssClass="validation" ErrorMessage="Name is required."></asp:RequiredFieldValidator>
            </div>
            <div class="form-group">
                <label for="<%= ddlBrand.ClientID %>">Brand</label>
                <asp:DropDownList ID="ddlBrand" runat="server" CssClass="form-control" AppendDataBoundItems="true"
                    DataTextField="name" DataValueField="id" ValidationGroup="prod">
                    <asp:ListItem Value="0">-- Select brand --</asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlBrand" InitialValue="0" ValidationGroup="prod"
                    Display="Dynamic" CssClass="validation" ErrorMessage="Please select a brand."></asp:RequiredFieldValidator>
            </div>
            <div class="form-group">
                <label for="<%= ddlCategory.ClientID %>">Type (Category &gt; Type)</label>
                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control" AppendDataBoundItems="true"
                    DataTextField="name" DataValueField="id" ValidationGroup="prod">
                    <asp:ListItem Value="0">-- Select type --</asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlCategory" InitialValue="0" ValidationGroup="prod"
                    Display="Dynamic" CssClass="validation" ErrorMessage="Please select a type."></asp:RequiredFieldValidator>
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label for="<%= txtPrice.ClientID %>">Price (&#8377;)</label>
                <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" MaxLength="10" ValidationGroup="prod"></asp:TextBox>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPrice" ValidationGroup="prod"
                    Display="Dynamic" CssClass="validation" ErrorMessage="Price is required."></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPrice" ValidationGroup="prod"
                    Display="Dynamic" CssClass="validation" ErrorMessage="Enter a valid price (e.g. 499 or 499.50)."
                    ValidationExpression="^\d{1,8}(\.\d{1,2})?$"></asp:RegularExpressionValidator>
            </div>
            <div class="form-group">
                <label for="<%= txtStock.ClientID %>">Stock Quantity</label>
                <asp:TextBox ID="txtStock" runat="server" CssClass="form-control" MaxLength="6" ValidationGroup="prod"></asp:TextBox>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtStock" ValidationGroup="prod"
                    Display="Dynamic" CssClass="validation" ErrorMessage="Stock is required."></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator runat="server" ControlToValidate="txtStock" ValidationGroup="prod"
                    Display="Dynamic" CssClass="validation" ErrorMessage="Enter a whole number."
                    ValidationExpression="^\d{1,6}$"></asp:RegularExpressionValidator>
            </div>
        </div>

        <div class="form-group">
            <label for="<%= txtDesc.ClientID %>">Description</label>
            <asp:TextBox ID="txtDesc" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" ValidationGroup="prod"></asp:TextBox>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label for="<%= fuImage.ClientID %>">Product Image (JPG, PNG, WEBP - max 2 MB)</label>
                <asp:FileUpload ID="fuImage" runat="server" CssClass="form-control" />
                <asp:Image ID="imgCurrent" runat="server" CssClass="thumb-sm" Visible="false" style="margin-top:8px" />
            </div>
            <div class="form-group">
                <label>&nbsp;</label>
                <asp:CheckBox ID="chkActive" runat="server" Checked="true" Text=" Visible to customers" />
            </div>
        </div>

        <div class="inline-form">
            <asp:Button ID="btnSave" runat="server" Text="Add Product" CssClass="btn btn-primary" ValidationGroup="prod" OnClick="btnSave_Click" />
            <asp:Button ID="btnCancel" runat="server" Text="Cancel Edit" CssClass="btn btn-outline" CausesValidation="false" Visible="false" OnClick="btnCancel_Click" />
        </div>
    </div>

    <div class="panel">
        <h3>All Products</h3>
        <div class="table-wrap" style="box-shadow:none">
            <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="False" DataKeyNames="id" CssClass="data" GridLines="None"
                OnRowCommand="gvProducts_RowCommand">
                <Columns>
                    <asp:TemplateField HeaderText="Image">
                        <ItemTemplate>
                            <img class="thumb-sm" src='<%# Helper.ImgUrl(Eval("image")) %>' alt="" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="name" HeaderText="Name" />
                    <asp:BoundField DataField="brand_name" HeaderText="Brand" NullDisplayText="-" />
                    <asp:BoundField DataField="category_name" HeaderText="Type" />
                    <asp:TemplateField HeaderText="Price">
                        <ItemTemplate><%# Helper.Money(Eval("price")) %></ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="stock" HeaderText="Stock" />
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='<%# Convert.ToInt32(Eval("is_active")) == 1 ? "badge badge-delivered" : "badge badge-cancelled" %>'>
                                <%# Convert.ToInt32(Eval("is_active")) == 1 ? "Visible" : "Hidden" %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <div class="row-actions">
                                <asp:LinkButton runat="server" CommandName="EditProduct" CommandArgument='<%# Eval("id") %>' CssClass="btn btn-outline btn-sm" CausesValidation="false">Edit</asp:LinkButton>
                                <asp:LinkButton runat="server" CommandName="ToggleProduct" CommandArgument='<%# Eval("id") %>' CssClass="btn btn-dark btn-sm" CausesValidation="false">Show/Hide</asp:LinkButton>
                                <asp:LinkButton runat="server" CommandName="DeleteProduct" CommandArgument='<%# Eval("id") %>' CssClass="btn btn-danger btn-sm" CausesValidation="false"
                                    OnClientClick="return confirm('Delete this product?');">Delete</asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>

</asp:Content>
