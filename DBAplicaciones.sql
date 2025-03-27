-- DROP DATABASE IF EXISTS DBAplicacion;

CREATE DATABASE DBAplicacion;

USE DBAplicacion;
-- creamos  entidades 
CREATE TABLE maestro (
    maestroId INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) NOT NULL,
    contrasena VARCHAR(20) NOT NULL,
    PRIMARY KEY (maestroId)
);

CREATE TABLE grado (
    gradoId INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    maestroId INT NOT NULL,
    PRIMARY KEY (gradoId),
    CONSTRAINT FK_grado_maestro FOREIGN KEY (maestroId) REFERENCES maestro(maestroId)
);

create table estudiante(
	estudianteId int not null auto_increment,
    nombre varchar(100) not null,
    apellido varchar(100) not null,
    correo varchar(100) not null,
    clave varchar(20) not null,
    gradoId INT NOT NULL,
    
    PRIMARY KEY (estudianteId),
    CONSTRAINT FK_estudiante_grado FOREIGN KEY (estudianteId) REFERENCES grado(gradoId)
);

create table asistencia(
	asistenciaId int not null auto_increment,
	fecha date not null,
	estado TINYINT(1) NOT NULL,  -- 0 = Ausente, 1 = Presente,
    maestroId INT NOT NULL,
	gradoId INT NOT NULL,
	estudianteId INT NOT NULL,
    
    PRIMARY KEY (asistenciaId),
    CONSTRAINT PK_asistencia_maestro FOREIGN KEY (maestroId) REFERENCES maestro(maestroId),
    CONSTRAINT PK_asistencia_grado FOREIGN KEY (gradoId) REFERENCES grado(maestroId),
    CONSTRAINT PK_estudiante_estudiante FOREIGN KEY (estudianteId) REFERENCES estudiante(estudianteId)

);


-- insertamos datos 
INSERT INTO maestro (nombre, correo, contrasena) VALUES
	('Miranda','mir@gmail.com','12345'),
    ('Devora','dev@gmail.com','123456'),
    ('Wendy','dy@gmail.com','1234567');
    
-- select * from maestro;

INSERT INTO grado (nombre, maestroId) VALUES
	('Cuarto Perito',1),
    ('Quinto Perito',2),
    ('Sexto Perito',3);
    
-- select * from grado;

INSERT INTO estudiante(nombre,apellido,correo,clave,gradoId) VALUES
	('Marco','Lopez','Marco@gmail.com','7',1),
    ('Kevin','Garcia','Pablo@gmail.com','9',2),
    ('Jose','Alfredo','jose@gmail.com','10',3);
    
-- select * from estudiante;

INSERT INTO asistencia(fecha,estado,maestroId,gradoId,estudianteId)Values
	('2025-03-26',1,1,1,1),
    ('2025-03-26',0,2,2,2),
    ('2025-03-26',0,3,3,3);

-- select * from asistencia;

-- CRUD maestro

-- Agregar 
DELIMITER $$ 
CREATE PROCEDURE sp_AgregarMaestro(IN nom VARCHAR (100), IN cor VARCHAR (100), IN con VARCHAR (100))
BEGIN 	
	INSERT INTO maestro (nombre, correo,contrasena)VALUES 
		(nom,cor,con);
END$$
DELIMITER ;

-- call sp_AgregarMaestro('Fernanda','fer@gmail.com','12345678');

-- Mostrar 
DELIMITER $$ 
CREATE PROCEDURE sp_ListarMaestro()
BEGIN 
	SELECT
		maestro.maestroId,
        maestro.nombre,
        maestro.correo,
        maestro.contrasena
			FROM maestro;
END$$
DELIMITER ;

CALL sp_ListarMaestro(); 

-- Eliminar 
DELIMITER $$ 
CREATE PROCEDURE sp_EliminarMaestro(IN maeId INT)
BEGIN
	DELETE 
	FROM maestro 
		WHERE maestroId =  maeId;
END$$
DELIMITER ;
	
-- CALL sp_EliminarMaestro(4);

-- Buscar por Id
DELIMITER $$ 
CREATE PROCEDURE sp_BuscarMaestro(IN maeId INT)
BEGIN
	SELECT 	
		maestro.maestroId,
        maestro.nombre,
        maestro.correo,
        maestro.contrasena
			FROM maestro
			WHERE maestroId = maeId;
END$$
DELIMITER ;

-- CALL sp_BuscarMaestro(1);

-- Editar
DELIMITER $$ 
create PROCEDURE sp_EditarMaestro(IN maeId INT,IN nom VARCHAR (100), IN cor VARCHAR (100), IN con VARCHAR (100))
BEGIN
	UPDATE maestro
		SET
			nombre = nom,
			correo = cor,
			contrasena = con
			WHERE maestroId = maeId;
END$$
DELIMITER ;

-- call sp_EditarMaestro(4 , 'chepe','fer@gmail.com','12345678');

-- Crud Grado 
DELIMITER $$ 
CREATE PROCEDURE sp_AgregarGrado(IN nom VARCHAR (100), IN maeId INT)
BEGIN 	
	INSERT INTO grado (nombre, maestroId) VALUES (nom, maeId);
END$$
DELIMITER ;

-- CALL sp_AgregarGrado('Tercero Básico', 1);

DELIMITER $$ 
CREATE PROCEDURE sp_ListarGrado()
BEGIN 
	SELECT
		grado.gradoId,
        grado.nombre,
        grado.maestroId
	FROM grado;
END$$
DELIMITER ;
CALL sp_ListarGrado();

DELIMITER $$ 
CREATE PROCEDURE sp_BuscarGrado(IN graId INT)
BEGIN
	SELECT 	
		grado.gradoId,
        grado.nombre,
        grado.maestroId
	FROM grado
	WHERE gradoId = graId;
END$$
DELIMITER ;
-- CALL sp_BuscarGrado(1);

DELIMITER $$ 
CREATE PROCEDURE sp_EditarGrado(IN graId INT, IN nom VARCHAR (100), IN maeId INT)
BEGIN
	UPDATE grado
	SET
		nombre = nom,
		maestroId = maeId
	WHERE gradoId = graId;
END$$
DELIMITER ;
-- CALL sp_EditarGrado(1, 'Primero Básico', 2);

DELIMITER $$ 
CREATE PROCEDURE sp_EliminarGrado(IN graId INT)
BEGIN
	DELETE FROM grado WHERE gradoId = graId;
END$$
DELIMITER ;
-- CALL sp_EliminarGrado(4);

-- CRUD Estudiante 
DELIMITER $$ 
CREATE PROCEDURE sp_AgregarEstudiante(IN nom VARCHAR(100), IN ape VARCHAR(100), IN cor VARCHAR(100), IN cla VARCHAR(20), IN graId INT)
BEGIN 	
	INSERT INTO estudiante (nombre, apellido, correo, clave, gradoId) 
	VALUES (nom, ape, cor, cla, graId);
END$$
DELIMITER ;

-- CALL sp_AgregarEstudiante('Ana', 'Perez', 'ana@gmail.com', '1234', 1);

DELIMITER $$ 
CREATE PROCEDURE sp_ListarEstudiante()
BEGIN 
	SELECT
		estudiante.estudianteId,
        estudiante.nombre,
        estudiante.apellido,
        estudiante.correo,
        estudiante.clave,
        estudiante.gradoId
	FROM estudiante;
END$$
DELIMITER ;

CALL sp_ListarEstudiante();

DELIMITER $$ 
CREATE PROCEDURE sp_BuscarEstudiante(IN estId INT)
BEGIN
	SELECT 	
		estudiante.estudianteId,
        estudiante.nombre,
        estudiante.apellido,
        estudiante.correo,
        estudiante.clave,
        estudiante.gradoId
	FROM estudiante
	WHERE estudianteId = estId;
END$$
DELIMITER ;

-- CALL sp_BuscarEstudiante(1);

DELIMITER $$ 
CREATE PROCEDURE sp_EditarEstudiante(IN estId INT, IN nom VARCHAR (100), IN ape VARCHAR (100), IN cor VARCHAR (100), IN cla VARCHAR (20), IN graId INT)
BEGIN
	UPDATE estudiante
	SET
		nombre = nom,
		apellido = ape,
		correo = cor,
		clave = cla,
		gradoId = graId
	WHERE estudianteId = estId;
END$$
DELIMITER ;
 
 -- CALL sp_EditarEstudiante(1, 'Ana', 'Rodriguez', 'ana_rod@gmail.com', '5678', 2);

DELIMITER $$ 
CREATE PROCEDURE sp_EliminarEstudiante(IN estId INT)
BEGIN
	DELETE FROM estudiante WHERE estudianteId = estId;
END$$
DELIMITER ;

-- CALL sp_EliminarEstudiante(4);

-- Crud Asitencia 

DELIMITER $$ 
CREATE PROCEDURE sp_AgregarAsistencia(IN fec DATE, IN est TINYINT(1), IN maeId INT, IN graId INT, IN estId INT)
BEGIN 	
	INSERT INTO asistencia (fecha, estado, maestroId, gradoId, estudianteId) 
	VALUES (fec, est, maeId, graId, estId);
END$$
DELIMITER ;

-- CALL sp_AgregarAsistencia('2025-03-27', 1, 1, 1, 1);

DELIMITER $$ 
CREATE PROCEDURE sp_ListarAsistencia()
BEGIN 
	SELECT * FROM asistencia;
END$$
DELIMITER ;

CALL sp_ListarAsistencia();

DELIMITER $$ 
CREATE PROCEDURE sp_EditarAsistencia(IN asiId INT, IN fec DATE, IN est TINYINT(1))
BEGIN
	UPDATE asistencia
	SET
		fecha = fec,
		estado = est
	WHERE asistenciaId = asiId;
END$$
DELIMITER ;

-- CALL sp_EditarAsistencia(1, '2025-03-28', 0);

DELIMITER $$ 
CREATE PROCEDURE sp_EliminarAsistencia(IN asiId INT)
BEGIN
	DELETE FROM asistencia WHERE asistenciaId = asiId;
END$$
DELIMITER ;

-- CALL sp_EliminarAsistencia(4);

set global time_zone = '-6:00';

