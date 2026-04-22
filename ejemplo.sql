-- 1. ELIMINACIÓN DE TABLAS PREVIAS (Ejecutar solo si las tablas ya existen)
DROP TABLE tPaciente CASCADE CONSTRAINTS;
DROP TABLE tMedico CASCADE CONSTRAINTS;
DROP TABLE tEspecialidad CASCADE CONSTRAINTS;
DROP TABLE tEnfermedad CASCADE CONSTRAINTS;
DROP TABLE tDiagnostico CASCADE CONSTRAINTS;
DROP TABLE tEspecialidadDelMedico CASCADE CONSTRAINTS;
DROP TABLE tEnfermedadEnElDiagnostico CASCADE CONSTRAINTS;

-- 2. CREACIÓN DE TABLAS
CREATE TABLE tPaciente
(
    codP VARCHAR2(4) PRIMARY KEY,
    tipoDocP VARCHAR2(15),
    nroDocP VARCHAR2(12),
    paternoP VARCHAR2(50),
    maternoP VARCHAR2(50),
    nombresP VARCHAR2(50),
    fechaNacimientoP DATE,
    generoP CHAR(1)
);

CREATE TABLE tMedico
(
    codM VARCHAR2(4) PRIMARY KEY,
    tipoDocM VARCHAR2(15),
    nroDocM VARCHAR2(12),
    paternoM VARCHAR2(50),
    maternoM VARCHAR2(50),
    nombresM VARCHAR2(50),
    celularM VARCHAR2(12),
    fechaNacimientoM DATE,
    generoM CHAR(1)
);

CREATE TABLE tEspecialidad
(
    codEsp VARCHAR2(4) PRIMARY KEY,
    nombreEsp VARCHAR2(70),
    descripcionEsp VARCHAR2(100)
);

CREATE TABLE tEnfermedad
(
    codE VARCHAR2(4) PRIMARY KEY,
    nombreE VARCHAR2(50),
    descricionE VARCHAR2(100)
);

CREATE TABLE tDiagnostico
(
    codD VARCHAR2(4) PRIMARY KEY,
    fechaHoraD TIMESTAMP,
    descripcionD VARCHAR2(100),
    codP VARCHAR2(4),
    codM VARCHAR2(4),
    FOREIGN KEY (codP) REFERENCES tPaciente (codP),
    FOREIGN KEY (codM) REFERENCES tMedico (codM)
);

CREATE TABLE tEspecialidadDelMedico
(
    codEspM VARCHAR2(4) PRIMARY KEY,
    codEsp VARCHAR2(4),
    codM VARCHAR2(4),
    fechaDeObtencionDeLaEspecialidadEspM DATE,
    FOREIGN KEY (codEsp) REFERENCES tespecialidad (codEsp),
    FOREIGN KEY (codM) REFERENCES tMedico (codM)
);

CREATE TABLE tEnfermedadEnElDiagnostico
(
    CodED VARCHAR2(4) PRIMARY KEY,
    codE VARCHAR2(4),
    codD VARCHAR2(4),
    FOREIGN KEY (codE) REFERENCES tenfermedad (codE),
    FOREIGN KEY (codD) REFERENCES tdiagnostico (codD)
);

-- Insertar Pacientes
INSERT INTO tpaciente VALUES('P01', 'DNI', '11111111', 'Salas', 'Rivas', 'Juan', TO_DATE('02-02-2000', 'DD-MM-YYYY'), 'M');
INSERT INTO tpaciente VALUES('P02', 'DNI', '22222222', 'Pérez', 'Rozas', 'Elena', TO_DATE('01-10-2020', 'DD-MM-YYYY'), 'F');

-- Insertar Médicos
INSERT INTO tmedico VALUES('M1', 'DNI', '33333333', 'Zela', 'Ramírez', 'Javier', '999999999', TO_DATE('10-10-1970', 'DD-MM-YYYY'), 'M');
INSERT INTO tmedico VALUES ('M2', 'Carnet', '7777', 'Cabral', 'Desousa', 'Alejandra', '988888877', TO_DATE('06-12-1975', 'DD-MM-YYYY'), 'F');

-- Insertar Especialidades
INSERT INTO tespecialidad VALUES('Esp1', 'Otorrinolagingología', 'Ojos, nariz y boca');
INSERT INTO tespecialidad VALUES ('Esp2', 'Pediatría', 'Neonato, niño y adolescente');
INSERT INTO tespecialidad VALUES ('Esp3', 'Cardiología', 'Corazón, sistema circulatorio');
INSERT INTO tespecialidad VALUES ('Esp4', 'Odontología', 'Dientes, encías');

-- Insertar Enfermedades
INSERT INTO tEnfermedad VALUES('E1', 'Alergia respiratoria', 'Alergias en el sistema respiratorio');
INSERT INTO tEnfermedad VALUES ('E2', 'Sinusitis', 'Gripe crónica');
INSERT INTO tEnfermedad VALUES ('E3', 'Artritis', 'Enfermedad crónica de los huesos');

-- Insertar Diagnósticos
INSERT INTO tdiagnostico VALUES('D1', TO_TIMESTAMP('25-02-2022 10:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Sinusitis aguda y alergia', 'P01', 'M1');
INSERT INTO tdiagnostico VALUES ('D2', TO_TIMESTAMP('28-02-2022 12:00:00', 'DD-MM-YYYY HH24:MI:SS'), 'Niña sana', 'P02', 'M2');

-- Insertar Relación Especialidad-Médico
INSERT INTO tespecialidaddelmedico VALUES('EM1', 'Esp1', 'M1', TO_DATE('12-12-2010', 'DD-MM-YYYY'));
INSERT INTO tespecialidaddelmedico VALUES('EM2', 'Esp2', 'M2', TO_DATE('02-02-2009', 'DD-MM-YYYY'));
INSERT INTO tespecialidaddelmedico VALUES ('EM3', 'Esp3', 'M2', TO_DATE('21-11-2019', 'DD-MM-YYYY'));

-- Insertar Relación Enfermedad-Diagnóstico
INSERT INTO tenfermedadeneldiagnostico VALUES('ED1', 'E1', 'D1');
INSERT INTO tenfermedadeneldiagnostico VALUES ('ED2', 'E2', 'D1');

--4.6 
SELECT 
    tpaciente.codP, 
    tpaciente.nombresP, 
    tpaciente.paternoP, 
    tpaciente.maternoP, 
    tdiagnostico.codD, 
    tdiagnostico.descripcionD, 
    tenfermedad.nombreE 
FROM tpaciente 
JOIN tdiagnostico ON tpaciente.codP = tdiagnostico.codP 
JOIN tenfermedadeneldiagnostico ON tdiagnostico.codD = tenfermedadeneldiagnostico.codD 
JOIN tenfermedad ON tenfermedadeneldiagnostico.codE = tenfermedad.codE;



--4.7
CREATE OR REPLACE VIEW v_pacienteEnfermedad AS 
SELECT 
    p.codP AS codigoP, 
    p.nombresP, 
    p.paternoP, 
    p.maternoP, 
    d.codD AS codigoD, 
    d.descripcionD AS nombreD, 
    e.nombreE 
FROM tpaciente p
JOIN tdiagnostico d ON p.codP = d.codP 
JOIN tenfermedadeneldiagnostico ed ON d.codD = ed.codD 
JOIN tenfermedad e ON ed.codE = e.codE;



--4.8
SELECT * FROM V_PACIENTEENFERMEDAD;



--4.9
SELECT 
    COUNT(*) AS cantidad_de_enfermedades, 
    nombresP, 
    paternoP, 
    maternoP 
FROM v_pacienteenfermedad 
GROUP BY nombresP, paternoP, maternoP;







SELECT * FROM tpaciente;

SELECT * FROM tmedico;

SELECT * FROM tespecialidad; 

SELECT * FROM tenfermedad; 
 
SELECT * FROM tdiagnostico; 

SELECT * FROM tespecialidaddelmedico;

SELECT * FROM tenfermedadeneldiagnostico;




 