<%@ Page Title="Categories - Admin" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="Categories.aspx.cs" Inherits="Admin_Categories" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h1>Categories</h1>
    <p class="page-sub">Main categories (Makeup, Skincare ...) and their types (Lipstick, Foundation ...). Products are added under a type.</p>

    <asp:Literal ID="litMsg" runat="server"></asp:Literal>

    <div class="panel">
        <h3>Add New Category</h3>
        <div class="inline-form">
            <div>
                <asp:DropDownList ID="ddlParent" runat="server" CssClass="form-control" AppendDataBoundItems="true"
                    DataTextField="name" DataValueField="id">
                    <asp:ListItem Value="0">-- Main category --</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div>
                <asp:TextBox ID="txtNewName" runat="server" CssClass="form-control" placeholder="Name (e.g. Lipstick)" MaxLength="100" ValidationGroup="addcat"></asp:TextBox>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtNewName" ValidationGroup="addcat"
                    Display="Dynamic" CssClass="validation" ErrorMessage="Name is required."></asp:RequiredFieldValidator>
            </div>
            <div>
                <asp:TextBox ID="txtNewDesc" runat="server" CssClass="form-control" placeholder="Short description" MaxLength="255" Width="320" ValidationGroup="addcat"></asp:TextBox>
            </div>
            <asp:Button ID="btnAdd" runat="server" Text="Add" CssClass="btn btn-primary" ValidationGroup="addcat" OnClick="btnAdd_Click" />
        </div>
    </div>

    <div class="panel">
        <h3>All Categories</h3>
        <div class="table-wrap" style="box-shadow:none">
            <asp:GridView ID="gvCat" runat="server" AutoGenerateColumns="False" DataKeyNames="id" CssClass="data" GridLines="None"
                OnRowEditing="gvCat_RowEditing" OnRowCancelingEdit="gvCat_RowCancelingEdit"
                OnRowUpdating="gvCat_RowUpdating" OnRowDeleting="gvCat_RowDeleting">
                <Columns>
                    <asp:BoundField DataField="id" HeaderText="ID" ReadOnly="True" />
                    <asp:BoundField DataField="name" HeaderText="Name" ControlStyle-CssClass="form-control" />
                    <asp:BoundField DataField="parent_name" HeaderText="Under" ReadOnly="True" NullDisplayText="(Main category)" />
                    <asp:BoundField DataField="description" HeaderText="Description" ControlStyle-CssClass="form-control" />
                    <asp:BoundField DataField="product_count" HeaderText="Products" ReadOnly="True" />
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <div class="row-actions">
                                <asp:LinkButton runat="server" CommandName="Edit" CssClass="btn btn-outline btn-sm">Edit</asp:LinkButton>
                                <asp:LinkButton runat="server" CommandName="Delete" CssClass="btn btn-danger btn-sm"
                                    OnClientClick="return confirm('Delete this category?');">Delete</asp:LinkButton>
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
