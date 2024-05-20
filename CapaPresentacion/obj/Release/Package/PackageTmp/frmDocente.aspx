<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="frmDocente.aspx.cs" Inherits="CapaPresentacion.frmDocente" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <p>Mantenimiento de la tabla Docente</p>
    <p>
        CodDocente <asp:TextBox runat="server" ID="txtCodDocente"></asp:TextBox>
    </p>
    <p>
        APaterno <asp:TextBox runat="server" ID="txtAPaterno"></asp:TextBox>
    </p>
    <p>
        AMaterno <asp:TextBox runat="server" ID="txtAMaterno"></asp:TextBox>
    </p>
    <p>
        Nombres <asp:TextBox runat="server" ID="txtNombres"></asp:TextBox>
    </p>
    <p>
        CodUsuario <asp:TextBox runat="server" ID="txtCodUsuario"></asp:TextBox>
    </p>
    <p>
        Contraseña <asp:TextBox runat="server" ID="txtContrasena" TextMode="Password"></asp:TextBox>
    </p>
    <p>
        Confirmar Contraseña <asp:TextBox runat="server" ID="txtConfirmarContrasena" TextMode="Password"></asp:TextBox>
    </p>
    <p>
        <asp:Button runat="server" Text="Agregar" OnClick="btnAgregar_Click" />
        <asp:Button runat="server" Text="Eliminar" OnClick="btnEliminar_Click" />
        <asp:Button runat="server" Text="Actualizar" OnClick="btnActualizar_Click" />
    </p>
    <p>
        Buscar por CodDocente: <asp:TextBox runat="server" ID="txtBuscarCodDocente"></asp:TextBox>
        <asp:Button runat="server" Text="Buscar" OnClick="btnBuscar_Click" />
    </p>
    <asp:GridView runat="server" ID="gvDocente" AutoGenerateColumns="true"></asp:GridView>
    <p>
        <asp:Label runat="server" ID="lblMensaje" ForeColor="Red"></asp:Label>
    </p>
    <asp:Button runat="server" Text="Agregar" OnClick="btnAgregar_Click" OnClientClick="return validarContrasena();" />

<script>
    function validarContrasena() {
        var contrasena = document.getElementById('<%=txtContrasena.ClientID%>').value;
        var confirmarContrasena = document.getElementById('<%=txtConfirmarContrasena.ClientID%>').value;

        if (contrasena !== confirmarContrasena) {
            alert("Las contraseñas no coinciden.");
            return false;
        }
        return true;
    }
</script>
</asp:Content>
