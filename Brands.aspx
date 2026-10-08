<%@ Page Title="Brands - Admin" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="Brands.aspx.cs" Inherits="Admin_Brands" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h1>Brands</h1>
    <p class="page-sub">Add brands like Lakme or Maybelline. Products are then added under a brand from the Products page.</p>

    <asp:Literal ID="litMsg" runat="server"></asp:Literal>

    <div class="panel">
        <h3>Add New Brand</h3>
        <div class="inline-form">
            <div>
                <asp:TextBox ID="txtNewName" runat="server" CssClass="form-control" placeholder="Brand name" MaxLength="100" ValidationGroup="addbrand"></asp:TextBox>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtNewName" ValidationGroup="addbrand"
                    Display="Dynamic" CssClass="validation" ErrorMessage="Name is required."></asp:RequiredFieldValidator>
            </div>
            <div>
                <asp:TextBox ID="txtNewDesc" runat="server" CssClass="form-control" placeholder="Short tagline" MaxLength="255" Width="320" ValidationGroup="addbrand"></asp:TextBox>
            </div>
            <asp:Button ID="btnAdd" runat="server" Text="Add Brand" CssClass="btn btn-primary" ValidationGroup="addbrand" OnClick="btnAdd_Click" />
        </div>
    </div>

    <div class="panel">
        <h3>All Brands</h3>
        <div class="table-wrap" style="box-shadow:none">
            <asp:GridView ID="gvBrands" runat="server" AutoGenerateColumns="False" DataKeyNames="id" CssClass="data" GridLines="None"
                OnRowEditing="gvBrands_RowEditing" OnRowCancelingEdit="gvBrands_RowCancelingEdit"
                OnRowUpdating="gvBrands_RowUpdating" OnRowDeleting="gvBrands_RowDeleting">
                <Columns>
                    <asp:BoundField DataField="id" HeaderText="ID" ReadOnly="True" />
                    <asp:BoundField DataField="name" HeaderText="Name" ControlStyle-CssClass="form-control" />
                    <asp:BoundField DataField="description" HeaderText="Tagline" ControlStyle-CssClass="form-control" />
                    <asp:BoundField DataField="product_count" HeaderText="Products" ReadOnly="True" />
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <div class="row-actions">
                                <asp:LinkButton runat="server" CommandName="Edit" CssClass="btn btn-outline btn-sm">Edit</asp:LinkButton>
                                <asp:LinkButton runat="server" CommandName="Delete" CssClass="btn btn-danger btn-sm"
                                    OnClientClick="return confirm('Delete this brand?');">Delete</asp:LinkButton>
                            </div>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <div class="row-actions">
                                <asp:LinkButton runat="server" CommandName="Update" CssClass="btn btn-primary btn-sm">Save</asp:LinkButton>
                                <asp:LinkButton runat="server" CommandName="Cancel" CssClass="btn btn-outline btn-sm">Cancel</asp:LinkButton>
                            </div>
                        </EditItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>

</asp:Content>
