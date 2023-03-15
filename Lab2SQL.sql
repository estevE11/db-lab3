--DROPS
DROP TABLE professor CASCADE CONSTRAINT;
DROP TABLE departament CASCADE CONSTRAINT;
DROP TABLE assignatura CASCADE CONSTRAINT;
DROP TABLE classe CASCADE CONSTRAINT;
DROP TABLE docencia CASCADE CONSTRAINT;

-- Creates

-- Creació de la taula departament
CREATE TABLE departament (
    codi    CHAR(3),
    nom VARCHAR(40) CONSTRAINT nn_dept_nom NOT NULL,
    CONSTRAINT dept_pk PRIMARY KEY(codi)
);
-- Creació de la taula professor
CREATE TABLE professor (
    codi    INTEGER,
    cognom1 VARCHAR(25) NOT NULL,
    cognom2 VARCHAR(25) NOT NULL,
    nom     VARCHAR(20) NOT NULL,
    actiu   CHAR(1) NOT NULL,
    categoria   VARCHAR(40) NOT NULL,
    dedicacio   CHAR(3) NOT NULL,
    departament CHAR(3) NOT NULL,
    director    INTEGER,
    CONSTRAINT prof_pk PRIMARY KEY (codi),
    CONSTRAINT prof_fk FOREIGN KEY (director) REFERENCES professor(codi),
    CONSTRAINT prof_dept_fk FOREIGN KEY (departament) REFERENCES departament(codi)
);

-- Creació de la taula assignatura
CREATE TABLE assignatura (
    sigles  CHAR(6),
    nom VARCHAR(40) NOT NULL,
    credits INTEGER,
    curs    CHAR(3),
    hores_teoria    INTEGER,
    hores_practica  INTEGER,
    num_alumnes INTEGER,
    CONSTRAINT assignatura_pk PRIMARY KEY (sigles,nom),
    CONSTRAINT uk_assignatura_sigles UNIQUE (sigles)
);

-- Creació de la taula classe
CREATE TABLE classe (
    codi    CHAR(5),
    nom VARCHAR(40) NOT NULL,
    capacitat   INTEGER,
    situacio    VARCHAR(40),
    CONSTRAINT classe_pk PRIMARY KEY(codi)
);

-- Creació de la taula docencia
CREATE TABLE docencia (
    id  INTEGER,
    professor   INTEGER NOT NULL,
    classe  CHAR(5) NOT NULL,
    assignatura CHAR(6) NOT NULL,
    Curs_academic   VARCHAR(5),
    CONSTRAINT docencia_pk PRIMARY KEY (id),
    CONSTRAINT doc_prof_fk FOREIGN KEY (professor) REFERENCES professor(codi),
    CONSTRAINT doc_class_fk FOREIGN KEY (classe) REFERENCES classe(codi),
    CONSTRAINT doc_assig_fk FOREIGN KEY (assignatura) REFERENCES assignatura(sigles),
    CONSTRAINT uc_docencia UNIQUE (professor, assignatura)
);

-- Exercici 4
-- Inserció de dades a la taula departament
INSERT INTO departament (codi, nom) VALUES ('001', 'Informàtica');
INSERT INTO departament (codi, nom) VALUES ('002', 'Telemàtica');
INSERT INTO departament (codi, nom) VALUES ('003', 'Electrònica');

-- Inserció de dades a la taula professor
INSERT INTO professor (codi, Cognom1, Cognom2, Nom, Actiu, Categoria, Dedicacio, departament, Director) VALUES (3, 'Mons', 'Adell', 'Marta', 'S', 'Director', 'TC', '002', null);
INSERT INTO professor (codi, Cognom1, Cognom2, Nom, Actiu, Categoria, Dedicacio, departament, Director) VALUES (1, 'Jimenez', 'Clos', 'Josep', 'S', 'Titular', 'TC', '001', '3');
INSERT INTO professor (codi, Cognom1, Cognom2, Nom, Actiu, Categoria, Dedicacio, departament, Director) VALUES (2, 'Marti', 'Margall', 'Maria', 'S', 'Titular', 'TC', '001', '3');


-- Inserció de dades a la taula assignatura
INSERT INTO assignatura (Sigles, Nom, Credits, Curs, Hores_teoria, hores_practica, Num_alumnes) VALUES ('ES', 'Estadística', '6', '1B', '3', '1', '30');
INSERT INTO assignatura (Sigles, Nom, Credits, Curs, Hores_teoria, hores_practica, Num_alumnes) VALUES ('BD', 'Bases de dades', '6', '2A', '4', '0', '28');
INSERT INTO assignatura (Sigles, Nom, Credits, Curs, Hores_teoria, hores_practica, Num_alumnes) VALUES ('SO', 'Sistemes Operatius', '9', '3A', '5', '1', '46');
-- Inserció de dades a la taula classe
INSERT INTO classe (codi, nom, capacitat, situacio) VALUES ('1', '3.1', '60', 'Planta3');
INSERT INTO classe (codi, nom, capacitat, situacio) VALUES ('2', '2.3', '30', 'Planta2');
INSERT INTO classe (codi, nom, capacitat, situacio) VALUES ('3', '2.6', '30', 'Planta2');

-- Inserció de dades a la taula docencia
INSERT INTO docencia (Id, Professor, Classe, assignatura, Curs_academic) VALUES (1, 2, '2', 'ES', '18_19');
INSERT INTO docencia (Id, Professor, Classe, assignatura, Curs_academic) VALUES (2, 2, '2', 'BD', '18_19');
INSERT INTO docencia (Id, Professor, Classe, assignatura, Curs_academic) VALUES (3, 1, '1', 'SO', '18_19');




-- Exercici 5
DESCRIBE departament;

-- Aquesta sentència mostrarà el codi SQL que s'utilitza per crear la taula, incloent-hi la definició de la restricció de clau primària. Busca la llista de restriccions per trobar el nom de la restricció de clau primària actual.
-- Executa la següent sentència SQL per canviar el nom de la restricció de clau primària:

ALTER TABLE departament
RENAME CONSTRAINT dept_pk TO departament_pk;
-- En aquest exemple, hem suposat que el nom de la restricció de clau primària actual és "PRIMARY". La primera part de la sentència elimina la restricció de clau primària existent, i la segona part afegeix una nova restricció de clau primària amb el nom especificat.
-- Executa la següent sentència SQL per comprovar que el nom de la restricció de clau primària ha canviat:

DESCRIBE departament;
-- Aquesta sentència hauria de mostrar el codi SQL actualitzat per a la taula departament, incloent-hi la nova restricció de clau primària amb el nom especificat.


-- Exercici 6
ALTER TABLE professor
ADD CONSTRAINT ck_professor_dedicacio CHECK (dedicacio IN ('TC', '6h', '3h'));

-- Amb això, qualsevol intent de modificar la dedicació d'un professor a un valor diferent de 'TC', '6h' o '3h' generaria un error de comprovació.

UPDATE professor 
SET dedicacio='20m' 
WHERE codi=1;
-- Rebrem un error de comprovació de la restricció:

ERROR:  new row for relation "professor" violates check constraint "dedicacio_check"
DETAIL:  Failing row contains (1, Garcia, Martinez, Juan, S, Professor Associat, INF, null).

-- Exercici 7
DESCRIBE Classe;
-- Això ens mostrarà la definició de la taula, incloent totes les restriccions.
-- Per detectar la restricció redundat, podem analitzar la definició de la taula i identificar si hi ha alguna restricció que ja estigui definida en una altra restricció. Per exemple, si la taula té una clau primària que inclou les mateixes columnes que una clau alternativa, aleshores la clau alternativa és redundant.
-- Per eliminar la restricció redundat, podem fer servir la següent sentència ALTER TABLE:

-- No he trobat cap restriccio redundant, la taula classe nomès té restriccions NN i una PK

ALTER TABLE Classe 
DROP CONSTRAINT codi_classe;
-- On nom_restriccio és el nom de la restricció que volem eliminar.
-- Per demostrar que, tot i haver eliminat la restricció, es segueix satisfent, podem executar una operació de tipus DML que afecti la taula Classe, com ara una inserció, actualització o eliminació. Si la operació s'executa amb èxit, això vol dir que la restricció eliminada no era necessària per mantenir la integritat de les dades.

-- Exercici 8
-- Per desactivar la restricció NOT NULL de la columna "nom" de la taula "departament", es pot utilitzar la següent sentència ALTER TABLE:
ALTER TABLE departament 
DISABLE CONSTRAINT nn_dept_nom;

-- Per comprovar que la restricció ha estat desactivada, es pot realitzar una operació UPDATE amb el valor NULL per a la columna "nom":
UPDATE departament SET nom = NULL WHERE codi = 'INF';

-- Per tornar a activar la restricció NOT NULL, s'utilitza la següent sentència ALTER TABLE:
ALTER TABLE departament
ENABLE CONSTRAINT nn_dept_nom;

-- En aquest cas, si es realitza una operació UPDATE amb el valor NULL per a la columna "nom", es produeix un error ja que la restricció NOT NULL està activada i no es permeten valors nuls per a aquesta columna.

-- Exercici 9
-- Per afegir una regla de negoci que verifiqui que els crèdits d'una assignatura com a màxim són 9, es pot utilitzar una restricció CHECK. Això es pot fer amb la següent sentència:
ALTER TABLE assignatura
ADD CONSTRAINT ck_assig_hores 
CHECK (credits = ((NVL(hores_teoria, 0) + NVL(hores_practica, 0)) * 1.5));

--Exercici 10
-- Aquesta sentència afegirà una restricció CHECK a la taula assignatura que verificarà que el valor de la columna credits és menor o igual a 9. Si s'intenta afegir una assignatura amb més de 9 crèdits, la inserció fallarà.

ALTER TABLE assignatura
ADD CONSTRAINT ck_credits_max
CHECK (credits<=9);


-- Per comprovar que aquesta restricció funciona correctament, es pot provar d'afegir una assignatura amb més de 9 crèdits i veure si la inserció falla:
INSERT INTO assignatura (sigles, nom, credits, curs, hores_teoria, hores_practica, num_alumnes)
VALUES ('XYZ123', 'Assignatura de prova', 10, '2022', 20, 30, 50);

-- Aquesta inserció hauria de fallar, ja que els crèdits de l'assignatura són més grans que 9.
-- Per desactivar aquesta restricció, es pot utilitzar la següent sentència:
ALTER TABLE assignatura
DROP CONSTRAINT ck_credits_max;
-- Això eliminarà la restricció CHECK de la taula assignatura.

-- Exercici 11
-- No es pot fer

-- Exercici 12
DESCRIBE professor;
-- Això ens mostrarà la definició de la taula professor, que inclou informació sobre les restriccions d'integritat referencial. La línia que defineix la restricció referencial per a l'atribut departament tindrà una sintaxi semblant a aquesta:


CONSTRAINT `nom_restriccio` 
FOREIGN KEY (`departament`) 
REFERENCES `nom_taula_referenciada` (`nom_camp_referenciat`) 
ON DELETE RESTRICT 
ON UPDATE CASCADE
-- En aquesta línia, la clàusula ON DELETE indica l'acció referencial que es realitzarà quan s'intenti eliminar una fila de la taula referenciada (en aquest cas, la taula departament). La clàusula ON UPDATE indica l'acció que es realitzarà quan es modifiqui una fila de la taula referenciada.
-- Per tant, en aquesta línia podem veure quina acció referencial està associada a la restricció d'integritat referencial definida a l'atribut departament de la taula professor.

-- Exercici 13
-- Per modificar l'acció referencial de la clau forana de l'atribut departament de la taula professor a l'acció referencial d'esborrat de posada a nuls, es pot utilitzar la següent sentència SQL:


 -- fk_professor_departament
    ALTER TABLE professor
    DROP CONSTRAINT prof_dept_fk;

    ALTER TABLE professor
    ADD CONSTRAINT prof_dept_fk
    FOREIGN KEY (departament) REFERENCES departament(codi)
    ON DELETE SET NULL;


-- Això eliminarà la restricció de clau forana actual (de tipus ON DELETE RESTRICT), i la reemplaçarà per una nova restricció de clau forana amb l'acció referencial ON DELETE SET NULL.
-- Per comprovar que la restricció s'ha canviat correctament, es pot esborrar un departament de la taula departament que estigui associat a un o més professors de la taula professor. Després d'aquesta operació, es comprovarà que els valors de l'atribut departament dels professors afectats han estat posats a null.
-- Per exemple, si es vol esborrar el departament amb codi 1, es pot utilitzar la següent sentència SQL:
DELETE FROM departament WHERE codi = 1;

-- Això provocarà que s'eliminin els registres de la taula professor que estiguin associats a aquest departament, i que els valors de l'atribut departament d'aquests registres es posin a nul.
-- Finalment, per tornar a l'estat inicial de la base de dades, es pot afegir de nou la restricció de clau forana original utilitzant la següent sentència SQL:
  ALTER TABLE professor
    DROP CONSTRAINT prof_dept_fk;

    ALTER TABLE professor
    ADD CONSTRAINT prof_dept_fk
    FOREIGN KEY (departament) REFERENCES departament(codi)
    ON DELETE SET NULL;

-- Exercici 14
-- Per fer que la restricció de clau forana de l'atribut departament de la taula professor tingui l'acció referencial d'esborrat en cascada, s'utilitza la següent sentència ALTER TABLE:
ALTER TABLE professor 
    DROP CONSTRAINT prof_dept_fk;
ALTER TABLE professor
    ADD CONSTRAINT prof_dept_fk 
    FOREIGN KEY (departament) 
    REFERENCES departament (codi_departament) 
    ON DELETE CASCADE;
-- Aquesta sentència primer esborra la restricció existent i després n'afegeix una de nova amb l'acció referencial d'esborrat en cascada.
-- Per comprovar el seu funcionament, es pot fer un esborrat d'un departament i comprovar que les files relacionades a la taula professor s'han eliminat també.
DELETE FROM departament WHERE codi_departament = 'd01';
-- Després d'executar aquesta sentència, totes les files de la taula professor que estaven relacionades amb el departament d01 s'haurien d'haver eliminat també.
-- En cas de no obtenir el resultat esperat, pot ser degut a que existeixen altres taules que també estan relacionades amb la taula departament. En aquest cas, l'ús de l'acció referencial d'esborrat en cascada pot provocar l'eliminació de dades que no es volien eliminar.
-- Per desfer les operacions de comprovació, es pot utilitzar la sentència ROLLBACK per revertir els canvis realitzats a la base de dades.

-- Exercici 15
-- Per exemple, si la clau forana es va crear amb la següent sentència:
ALTER TABLE professor
DROP CONSTRAINT prof_dept_fk, -- fk_professor_departament
ADD CONSTRAINT prof_dept_fk -- fk_professor_departament
    FOREIGN KEY (departament) REFERENCES departament(codi);
-- Ara, quan esborrem una fila de la taula departament, els atributs de la taula professor que depenen del codi_dept es posen a NULL en comptes de ser eliminats.

-- Exercici 16
-- Per aconseguir aquesta tasca cal desactivar les restriccions de clau primària i clau forana de la taula departament, insertar les tres files i tornar a activar les restriccions.
-- Per desactivar les restriccions es pot utilitzar la següent sentència SQL:


ALTER TABLE departament
DISABLE CONSTRAINT nn_dept_nom;
-- A continuació, es pot insertar les tres files a la taula departament:
INSERT INTO departament (codi, nom)
VALUES ('004', NULL);

INSERT INTO departament (codi, nom)
VALUES ('005', NULL);

INSERT INTO departament (codi, nom)
VALUES ('006', NULL);

ALTER TABLE departament
ENABLE CONSTRAINT nn_dept_nom;

-- No es pot fer ja que no permet activar una constraint mentre que hi hagi files amb valors que no la compleixin
DELETE FROM departament
WHERE codi IN('006','005','004');

-- Finalment, per tornar a activar les restriccions, es pot utilitzar la següent sentència SQL:

ALTER TABLE departament
ENABLE CONSTRAINT nn_dept_nom;



-- Exercici 17
-- És possible que surti un error en la inserció de dades a la taula professor, depenent de les restriccions que s'hagin definit. Si s'ha definit una restricció de clau forana a l'atribut departament, per exemple, no es podria inserir una fila amb un valor per aquest atribut que no existeixi a la taula departament.
-- Per tal de garantir que les restriccions es comprovin en el moment del commit, es pot utilitzar la sentència SQL següent:

INSERT INTO professor (codi, Cognom1, Cognom2, Nom, Actiu, Categoria, Dedicacio, departament, Director) 
VALUES (4, 'Marti', 'Gomez', 'Pere', 'S', 'Titular', 'TC', '001', 6);

INSERT INTO professor (codi, Cognom1, Cognom2, Nom, Actiu, Categoria, Dedicacio, departament, Director) 
VALUES (5, 'Cotet', 'Jull', 'Albert', 'S', 'Titular', 'TC', '001', 6);

INSERT INTO professor (codi, Cognom1, Cognom2, Nom, Actiu, Categoria, Dedicacio, departament, Director) 
VALUES (6, 'Adell', 'Carpi', 'Xavier', 'S', 'Director', 'TC', '002', NULL);

--No ha sortit cap error, les taules s'han inserit correctament

ALTER TABLE PROFESSOR
    DROP CONSTRAINT prof_fk;
ALTER TABLE PROFESSOR
    ADD CONSTRAINT prof_fk
    FOREIGN KEY (director) REFERENCES professor(codi)
    DEFERRABLE INITIALLY DEFERRED;

-- Exercici 18

