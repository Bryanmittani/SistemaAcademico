using System;
using System.Data;
using CapaDato;
using CapaEntidad;

namespace CapaNegocio
{
    public class AlumnoBL : Interface.IAlumno
    {
        private Datos datos = new DatosSQL();
        public string Mensaje { get; set; }

        public DataTable Listar()
        {
            return datos.TraerDataTable("spListarAlumno");
        }

        public bool Agregar(Alumno alumno)
        {
            DataRow fila = datos.TraerDataRow("spAgregarAlumno", alumno.CodAlumno, alumno.APaterno, alumno.AMaterno, alumno.Nombres, alumno.CodUsuario, alumno.Contrasena, alumno.CodEscuela);
            Mensaje = fila["Mensaje"].ToString();
            byte codError = Convert.ToByte(fila["CodError"]);
            return codError == 0;

        }

        public bool Eliminar(string codAlumno)
        {
            DataRow fila = datos.TraerDataRow("spEliminarAlumno", codAlumno);
            Mensaje = fila["Mensaje"].ToString();
            byte codError = Convert.ToByte(fila["CodError"]);
            return codError == 0;
        }

        public bool Actualizar(Alumno alumno)
        {
            DataRow fila = datos.TraerDataRow("spActualizarAlumno", alumno.CodAlumno, alumno.APaterno, alumno.AMaterno, alumno.Nombres, alumno.CodUsuario, alumno.Contrasena, alumno.CodEscuela);
            Mensaje = fila["Mensaje"].ToString();
            byte codError = Convert.ToByte(fila["CodError"]);
            return codError == 0;
        }

        public DataTable Buscar(string codAlumno)
        {
            return datos.TraerDataTable("spBuscarAlumno", codAlumno);
        }
    }
}