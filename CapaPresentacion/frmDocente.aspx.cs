using System;
using System.Data;
using System.Web.UI;
using CapaEntidad;
using CapaNegocio;

namespace CapaPresentacion
{
    public partial class frmDocente : System.Web.UI.Page
    {
        private void Listar()
        {
            DocenteBL docenteBL = new DocenteBL();
            gvDocente.DataSource = docenteBL.Listar();
            gvDocente.DataBind();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
                Listar();
        }

        protected void btnAgregar_Click(object sender, EventArgs e)
        {
            Docente docente = new Docente
            {
                CodDocente = txtCodDocente.Text.Trim(),
                APaterno = txtAPaterno.Text.Trim(),
                AMaterno = txtAMaterno.Text.Trim(),
                Nombres = txtNombres.Text.Trim(),
                CodUsuario = txtCodUsuario.Text.Trim(),
                Contrasena = txtContrasena.Text.Trim()
            };

            DocenteBL docenteBL = new DocenteBL();
            if (docenteBL.Agregar(docente))
            {
                Listar();
                lblMensaje.Text = "Docente agregado correctamente.";
            }
            else
            {
                lblMensaje.Text = "Error al agregar el docente.";
            }
        }

        protected void btnEliminar_Click(object sender, EventArgs e)
        {
            string codDocente = txtCodDocente.Text.Trim();

            DocenteBL docenteBL = new DocenteBL();
            if (docenteBL.Eliminar(codDocente))
            {
                Listar();
                lblMensaje.Text = "Docente eliminado correctamente.";
            }
            else
            {
                lblMensaje.Text = "Error al eliminar el docente.";
            }
        }

        protected void btnActualizar_Click(object sender, EventArgs e)
        {
            Docente docente = new Docente
            {
                CodDocente = txtCodDocente.Text.Trim(),
                APaterno = txtAPaterno.Text.Trim(),
                AMaterno = txtAMaterno.Text.Trim(),
                Nombres = txtNombres.Text.Trim(),
                CodUsuario = txtCodUsuario.Text.Trim(),
                Contrasena = txtContrasena.Text.Trim()
            };

            DocenteBL docenteBL = new DocenteBL();
            if (docenteBL.Actualizar(docente))
            {
                Listar();
                lblMensaje.Text = "Docente actualizado correctamente.";
            }
            else
            {
                lblMensaje.Text = "Error al actualizar el docente.";
            }
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            string codDocente = txtBuscarCodDocente.Text.Trim();

            DocenteBL docenteBL = new DocenteBL();
            DataTable dt = docenteBL.Buscar(codDocente);
            if (dt.Rows.Count > 0)
            {
                DataRow docente = dt.Rows[0];
                txtCodDocente.Text = docente["CodDocente"].ToString();
                txtAPaterno.Text = docente["APaterno"].ToString();
                txtAMaterno.Text = docente["AMaterno"].ToString();
                txtNombres.Text = docente["Nombres"].ToString();
                txtCodUsuario.Text = docente["CodUsuario"].ToString();
                txtContrasena.Text = docente["Contrasena"].ToString();
                lblMensaje.Text = "Docente encontrado.";
            }
            else
            {
                lblMensaje.Text = "Docente no encontrado.";
            }
        }
    }
}
