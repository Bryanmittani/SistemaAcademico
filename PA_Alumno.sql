use BDAcademico
go

-- Procedimientos almacenados para TAlumno
if OBJECT_ID('spListarAlumno') is not null
	drop proc spListarAlumno
go
create proc spListarAlumno
as
begin
	select * from TAlumno
end
go

exec spListarAlumno
go

-- Procediimiento almacenado para agregar Alumno
if OBJECT_ID('spAgregarAlumno') is not null
	drop proc spAgregarAlumno
go
create proc spAgregarAlumno
@CodAlumno char(5),
@APaterno varchar(50),
@AMaterno varchar(50),
@Nombres varchar(50),
@CodUsuario varchar(50),
@Contrasena varchar(50),
@CodEscuela char(3)
as
begin
	-- CodAlumno no se duplique
	if not exists(select CodAlumno from TAlumno where CodAlumno = @CodAlumno)
		-- Usuario no existe en TUsuario
		if not exists(select CodUsuario from TUsuario where CodUsuario=@CodUsuario)
			-- CodCarrera debe existir en la tabla TCarrera
			if exists(select CodEscuela from TEscuela where CodEscuela = @CodEscuela)
				begin
					begin tran tranAgregar 
					begin try
						insert into TUsuario values(@CodUsuario,ENCRYPTBYPASSPHRASE('miFraseDeContrase�a', @Contrasena))
						insert into TAlumno values(@CodAlumno,@APaterno,@AMaterno,@Nombres,@CodUsuario,@CodEscuela)
						commit tran tranAgregar
						select CodError = 0, Mensaje = 'Alumno insertado correctamente'
					end try
					begin catch
						rollback tran tranAgregar
						select CodError = 1, Mensaje = 'Error: No se ejecuto la transaccion'
					end catch
				end
			else select CodError = 1, Mensaje = 'Error: CodEscuela no existe en TEscuela'
		else select CodError = 1, Mensaje = 'Error: Usuario ya asignado en TUsuario'
	else select CodError = 1, Mensaje = 'Error: Codigo de Alumno duplicado en la TAlumno'
end
go

exec spAgregarAlumno 'A0031','Juarez','Maquera','Rosa','juarezm@gmail.com','1234','C01'
go

-- Procedimiento almacenado para eliminar un alumno
if OBJECT_ID('spEliminarAlumno') is not null
	drop proc spEliminarAlumno
go
create proc spEliminarAlumno
@CodAlumno char(5)
as
begin
	-- Verificar que el CodAlumno existe en la tabla Alumno
	if exists (select CodAlumno from TAlumno where CodAlumno=@CodAlumno)
	begin
	    declare @CodUsuario varchar(50)
		set @CodUsuario = (select CodUsuario from TAlumno where CodAlumno = @CodAlumno)
		if exists (select CodUsuario from TUsuario where CodUsuario = @CodUsuario)
		begin
			begin tran tranEliminar
				begin try
					delete from TAlumno where CodAlumno = @CodAlumno
					delete from TUsuario where CodUsuario = @CodUsuario
					commit tran tranEliminar
					select CodError = 0, Mensaje = 'Alumno eliminado correctamente'
				end try
				begin catch
					rollback tran tranEliminar
					select CodError = 1, Mensaje = 'Error: No se ejecuto la transaccion'
				end catch
			end			
		else select CodError = 1, Mensaje = 'Error: No existe CodUsuario en la TUsuario'		
	end
	else select CodError = 1, Mensaje = 'Error: CodAlumo no existe en la TAlumno'
end
go

exec spEliminarAlumno 'A0031'
go

IF OBJECT_ID('spActualizarAlumno') IS NOT NULL
    DROP PROC spActualizarAlumno
GO

CREATE PROC spActualizarAlumno
    @CodAlumno CHAR(5),
    @APaterno VARCHAR(50),
    @AMaterno VARCHAR(50),
    @Nombres VARCHAR(50),
    @CodUsuario VARCHAR(50),
    @Contrasena VARCHAR(50),
    @CodEscuela CHAR(3)
AS
BEGIN
    IF EXISTS (SELECT CodAlumno FROM TAlumno WHERE CodAlumno = @CodAlumno)
    BEGIN
        BEGIN TRAN tranActualizar
        BEGIN TRY
            UPDATE TUsuario
            SET Contrasena = ENCRYPTBYPASSPHRASE('miFraseDeContrase�a', @Contrasena)
            WHERE CodUsuario = @CodUsuario;

            UPDATE TAlumno
            SET APaterno = @APaterno,
                AMaterno = @AMaterno,
                Nombres = @Nombres,
                CodEscuela = @CodEscuela
            WHERE CodAlumno = @CodAlumno;

            COMMIT TRAN tranActualizar;
            SELECT CodError = 0, Mensaje = 'Alumno actualizado correctamente';
        END TRY
        BEGIN CATCH
            ROLLBACK TRAN tranActualizar;
            SELECT CodError = 1, Mensaje = 'Error: No se pudo actualizar el alumno';
        END CATCH
    END
    ELSE
        SELECT CodError = 1, Mensaje = 'Error: C�digo de alumno no encontrado';
END
GO
-- Procedimiento almacenado para buscar un alumno
IF OBJECT_ID('spBuscarAlumno') IS NOT NULL
    DROP PROC spBuscarAlumno
GO

CREATE PROC spBuscarAlumno
    @CodAlumno CHAR(5)
AS
BEGIN
    SELECT 
        A.CodAlumno, 
        A.APaterno, 
        A.AMaterno, 
        A.Nombres, 
        A.CodUsuario, 
        CONVERT(VARCHAR(50), DECRYPTBYPASSPHRASE('miFraseDeContrase�a', U.Contrasena)) AS Contrasena, 
        A.CodEscuela
    FROM 
        TAlumno A
    JOIN 
        TUsuario U ON A.CodUsuario = U.CodUsuario
    WHERE 
        A.CodAlumno = @CodAlumno;
END
GO


-- Login de usuario
if OBJECT_ID('spLogin') is not null
	drop proc spLogin
go
create proc spLogin
@CodUsuario varchar(50),@Contrasena varchar(50)
as
begin
	if exists (select CodUsuario from TUsuario where CodUsuario = @CodUsuario and CONVERT(varchar(50),DECRYPTBYPASSPHRASE('miFraseDeContrase�a', Contrasena))=@Contrasena)
	begin
		if exists (select CodUsuario from TDocente where CodUsuario = @CodUsuario)
			select CodError = 0, Mensaje = 'Docente'
		else if exists (select CodUsuario from TAlumno where CodUsuario = @CodUsuario)
			select CodError = 0, Mensaje = 'Alumno'
		else 
			select CodError = 1, Mensaje = 'Error: Usuario no tiene privilegio de docente ni alumno, consulte al administrador'
	end
	else 
		select CodError = 1, Mensaje = 'Error: Usuario y / o contrase�as incorrectas'
end
go


exec spLogin 'cuellar@hotmail.com','1234'
go








