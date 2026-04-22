-- ==========================================================
-- 5. EJERCICIOS EN CLASE
-- ==========================================================

-- 5.1. Crear una vista para mostrar todos los datos de los médicos y sus especialidades.
CREATE OR REPLACE VIEW v_MedicosEspecialidades AS
SELECT 
    m.codM, m.paternoM, m.maternoM, m.nombresM, m.celularM, m.generoM,
    e.nombreEsp, e.descripcionEsp
FROM tMedico m
JOIN tEspecialidadDelMedico em ON m.codM = em.codM
JOIN tEspecialidad e ON em.codEsp = e.codEsp;

-- Comprobación 5.1:
SELECT * FROM v_MedicosEspecialidades;


-- 5.2. A partir de la vista anterior, mostrar cuántas especialidades tiene cada médico.
SELECT 
    nombresM, 
    paternoM, 
    COUNT(nombreEsp) AS cantidad_especialidades
FROM v_MedicosEspecialidades
GROUP BY nombresM, paternoM;


-- 5.3. A partir de la vista anterior, mostrar solamente a los médicos que tengan 2 a más especialidades.
SELECT 
    nombresM, 
    paternoM, 
    COUNT(nombreEsp) AS cantidad_especialidades
FROM v_MedicosEspecialidades
GROUP BY nombresM, paternoM
HAVING COUNT(nombreEsp) >= 2;


-- 5.4. Crear una vista que muestre solamente a las enfermedades que aún no se hayan detectado en los diagnósticos de la Clínica.
CREATE OR REPLACE VIEW v_EnfermedadesNoDetectadas AS
SELECT * FROM tEnfermedad
WHERE codE NOT IN (SELECT codE FROM tEnfermedadEnElDiagnostico);

-- Comprobación 5.4:
SELECT * FROM v_EnfermedadesNoDetectadas;


-- 5.5. Crear una vista que muestre a todas las especialidades para las cuales aún no se tengan médicos en la Clínica.
CREATE OR REPLACE VIEW v_EspecialidadesSinMedico AS
SELECT * FROM tEspecialidad
WHERE codEsp NOT IN (SELECT codEsp FROM tEspecialidadDelMedico);

-- Comprobación 5.5:
SELECT * FROM v_EspecialidadesSinMedico;


-- 5.6. A partir de la vista anterior, mostrar cuántas especialidades aún no tienen médico en la Clínica.
SELECT 
    COUNT(*) AS especialidades_sin_medico
FROM v_EspecialidadesSinMedico;


-- 5.7. Crear una vista que muestre los nombres de los pacientes cuyos diagnósticos no estén relacionados con ninguna enfermedad.
CREATE OR REPLACE VIEW v_PacientesSinEnfermedad AS
SELECT DISTINCT 
    p.nombresP, 
    p.paternoP, 
    p.maternoP
FROM tPaciente p
JOIN tDiagnostico d ON p.codP = d.codP
WHERE d.codD NOT IN (SELECT codD FROM tEnfermedadEnElDiagnostico);

-- Comprobación 5.7:
SELECT * FROM v_PacientesSinEnfermedad;