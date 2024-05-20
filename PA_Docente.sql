use BDAcademico
go

IF OBJECT_ID('spListarDocente') IS NOT NULL
    DROP PROC spListarDocente
GO

CREATE PROC spListarDocente
AS
BEGIN
    SELECT * FROM TDocente
END
GO
exec spListarDocente
go
IF OBJECT_ID('spAgregarDocente') IS NOT NULL
    DROP PROC spAgregarDocente
GO

CREATE PROC spAgregarDocente
    @CodDocente CHAR(3),
    @APaterno VARCHAR(50),
    @AMaterno VARCHAR(50),
    @Nombres VARCHAR(50),
    @CodUsuario VARCHAR(50),
    @Contrasena VARCHAR(50)
AS
BEGIN
    -- Verificar que el CodDocente no se duplique
    IF NOT EXISTS (SELECT CodDocente FROM TDocente WHERE CodDocente = @CodDocente)
    BEGIN
        -- Verificar que el CodUsuario no exista en TUsuario
        IF NOT EXISTS (SELECT CodUsuario FROM TUsuario WHERE CodUsuario = @CodUsuario)
        BEGIN
            BEGIN TRAN
            BEGIN TRY
                INSERT INTO TUsuario VALUES (@CodUsuario, ENCRYPTBYPASSPHRASE('miFraseDeContraseña', @Contrasena))
                INSERT INTO TDocente VALUES (@CodDocente, @APaterno, @AMaterno, @Nombres, @CodUsuario)
                COMMIT TRAN
                SELECT CodError = 0, Mensaje = 'Docente insertado correctamente'
            END TRY
            BEGIN CATCH
                ROLLBACK TRAN
                SELECT CodError = 1, Mensaje = 'Error: No se ejecutó la transacción'
            END CATCH
        END
        ELSE
            SELECT CodError = 1, Mensaje = 'Error: Usuario ya asignado en TUsuario'
    END
    ELSE
        SELECT CodError = 1, Mensaje = 'Error: Código de Docente duplicado en TDocente'
END
GO-- Procedimiento almacenado para buscar un docente
IF OBJECT_ID('spBuscarDocente') IS NOT NULL
    DROP PROC spBuscarDocente
GO

CREATE PROC spBuscarDocente
    @CodDocente CHAR(3)
AS
BEGIN
    SELECT 
        D.CodDocente,
        D.APaterno,
        D.AMaterno,
        D.Nombres,
        D.CodUsuario,
        CONVERT(VARCHAR(50), DECRYPTBYPASSPHRASE('miFraseDeContraseña', U.Contrasena)) AS Contrasena
    FROM 
        TDocente D
    JOIN 
        TUsuario U ON D.CodUsuario = U.CodUsuario
    WHERE 
        D.CodDocente = @CodDocente;
END
GO
-- Procedimiento almacenado para eliminar un docente
IF OBJECT_ID('spEliminarDocente') IS NOT NULL
    DROP PROC spEliminarDocente
GO

CREATE PROC spEliminarDocente
    @CodDocente CHAR(3)
AS
BEGIN
    -- Verificar que el CodDocente existe en la tabla Docente
    IF EXISTS (SELECT CodDocente FROM TDocente WHERE CodDocente = @CodDocente)
    BEGIN
        DECLARE @CodUsuario VARCHAR(50)
        SET @CodUsuario = (SELECT CodUsuario FROM TDocente WHERE CodDocente = @CodDocente)

        IF EXISTS (SELECT CodUsuario FROM TUsuario WHERE CodUsuario = @CodUsuario)
        BEGIN
            BEGIN TRAN
            BEGIN TRY
                DELETE FROM TDocente WHERE CodDocente = @CodDocente
                DELETE FROM TUsuario WHERE CodUsuario = @CodUsuario
                COMMIT TRAN
                SELECT CodError = 0, Mensaje = 'Docente eliminado correctamente'
            END TRY
            BEGIN CATCH
                ROLLBACK TRAN
                SELECT CodError = 1, Mensaje = 'Error: No se ejecutó la transacción'
            END CATCH
        END
        ELSE
            SELECT CodError = 1, Mensaje = 'Error: No existe CodUsuario en TUsuario'
    END
    ELSE
        SELECT CodError = 1, Mensaje = 'Error: CodDocente no existe en TDocente'
END
GO
-- Procedimiento almacenado para actualizar un docente
IF OBJECT_ID('spActualizarDocente') IS NOT NULL
    DROP PROC spActualizarDocente
GO

CREATE PROC spActualizarDocente
    @CodDocente CHAR(3),
    @APaterno VARCHAR(50),
    @AMaterno VARCHAR(50),
    @Nombres VARCHAR(50),
    @CodUsuario VARCHAR(50),
    @Contrasena VARCHAR(50)
AS
BEGIN
    -- Verificar que el CodDocente existe en la tabla Docente
    IF EXISTS (SELECT CodDocente FROM TDocente WHERE CodDocente = @CodDocente)
    BEGIN
        BEGIN TRAN
        BEGIN TRY
            UPDATE TUsuario
            SET Contrasena = ENCRYPTBYPASSPHRASE('miFraseDeContraseña', @Contrasena)
            WHERE CodUsuario = @CodUsuario

            UPDATE TDocente
            SET APaterno = @APaterno,
                AMaterno = @AMaterno,
                Nombres = @Nombres,
                CodUsuario = @CodUsuario
            WHERE CodDocente = @CodDocente

            COMMIT TRAN
            SELECT CodError = 0, Mensaje = 'Docente actualizado correctamente'
        END TRY
        BEGIN CATCH
            ROLLBACK TRAN
            SELECT CodError = 1, Mensaje = 'Error: No se ejecutó la transacción'
        END CATCH
    END
    ELSE
        SELECT CodError = 1, Mensaje = 'Error: CodDocente no existe en TDocente'
END
GO
-- Procedimiento almacenado para buscar un docente
IF OBJECT_ID('spBuscarDocente') IS NOT NULL
    DROP PROC spBuscarDocente
GO

CREATE PROC spBuscarDocente
    @CodDocente CHAR(3)
AS
BEGIN
    SELECT 
        D.CodDocente,
        D.APaterno,
        D.AMaterno,
        D.Nombres,
        D.CodUsuario,
        CONVERT(VARCHAR(50), DECRYPTBYPASSPHRASE('miFraseDeContraseña', U.Contrasena)) AS Contrasena
    FROM 
        TDocente D
    JOIN 
        TUsuario U ON D.CodUsuario = U.CodUsuario
    WHERE 
        D.CodDocente = @CodDocente;
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
	if exists (select CodUsuario from TUsuario where CodUsuario = @CodUsuario and CONVERT(varchar(50),DECRYPTBYPASSPHRASE('miFraseDeContraseña', Contrasena))=@Contrasena)
	begin
		if exists (select CodUsuario from TDocente where CodUsuario = @CodUsuario)
			select CodError = 0, Mensaje = 'Docente'
		else if exists (select CodUsuario from TAlumno where CodUsuario = @CodUsuario)
			select CodError = 0, Mensaje = 'Alumno'
		else 
			select CodError = 1, Mensaje = 'Error: Usuario no tiene privilegio de docente ni alumno, consulte al administrador'
	end
	else 
		select CodError = 1, Mensaje = 'Error: Usuario y / o contraseñas incorrectas'
end
go


exec spLogin 'cuellar@hotmail.com','1234'
go
