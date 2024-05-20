using System;
using System.Data;
using System.Web.UI;
using CapaEntidad;
using CapaNegocio;

namespace CapaPresentacion
{
    public partial class frmAlumno : System.Web.UI.Page
    {
        private void Listar()
        {
            AlumnoBL alumnoBL = new AlumnoBL();
            gvAlumno.DataSource = alumnoBL.Listar();
            gvAlumno.DataBind();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
                Listar();
        }

        protected void btnAgregar_Click(object sender, EventArgs e)
        {
            Alumno alumno = new Alumno
            {
                CodAlumno = txtCodAlumno.Text.Trim(),
                APaterno = txtAPaterno.Text.Trim(),
                AMaterno = txtAMaterno.Text.Trim(),
                Nombres = txtNombres.Text.Trim(),
                CodUsuario = txtCodUsuario.Text.Trim(),
                Contrasena = txtContrasena.Text.Trim(),
                CodEscuela = txtCodEscuela.Text.Trim()
            };

            AlumnoBL alumnoBL = new AlumnoBL();
            if (alumnoBL.Agregar(alumno))
            {
                Listar();
                lblMensaje.Text = "Alumno agregado correctamente.";
            }
            else
            {
                lblMensaje.Text = "Error al agregar el alumno.";
            }
        }

        protected void btnEliminar_Click(object sender, EventArgs e)
        {
            string codAlumno = txtCodAlumno.Text.Trim();

            AlumnoBL alumnoBL = new AlumnoBL();
            if (alumnoBL.Eliminar(codAlumno))
            {
                Listar();
                lblMensaje.Text = "Alumno eliminado correctamente.";
            }
            else
            {
                lblMensaje.Text = "Error al eliminar el alumno.";
            }
        }

        protected void btnActualizar_Click(object sender, EventArgs e)
        {
            Alumno alumno = new Alumno
            {
                CodAlumno = txtCodAlumno.Text.Trim(),
                APaterno = txtAPaterno.Text.Trim(),
                AMaterno = txtAMaterno.Text.Trim(),
                Nombres = txtNombres.Text.Trim(),
                CodUsuario = txtCodUsuario.Text.Trim(),
                Contrasena = txtContrasena.Text.Trim(),
                CodEscuela = txtCodEscuela.Text.Trim()
            };

            AlumnoBL alumnoBL = new AlumnoBL();
            if (alumnoBL.Actualizar(alumno))
            {
                Listar();
                lblMensaje.Text = "Alumno actualizado correctamente.";
            }
            else
            {
                lblMensaje.Text = "Error al actualizar el alumno.";
            }
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            string codAlumno = txtBuscarCodAlumno.Text.Trim();

            AlumnoBL alumnoBL = new AlumnoBL();
            DataTable dt = alumnoBL.Buscar(codAlumno);
            if (dt.Rows.Count > 0)
            {
                DataRow alumno = dt.Rows[0];
                txtCodAlumno.Text = alumno["CodAlumno"].ToString();
                txtAPaterno.Text = alumno["APaterno"].ToString();
                txtAMaterno.Text = alumno["AMaterno"].ToString();
                txtNombres.Text = alumno["Nombres"].ToString();
                txtCodUsuario.Text = alumno["CodUsuario"].ToString();
                txtContrasena.Text = alumno["Contrasena"].ToString();
                txtCodEscuela.Text = alumno["CodEscuela"].ToString();
                lblMensaje.Text = "Alumno encontrado.";
            }
            else
            {
                lblMensaje.Text = "Alumno no encontrado.";
            }
        }
    }
}