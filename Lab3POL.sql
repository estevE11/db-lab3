/**
 ** 1. Confeccioneu un llistat amb la ciutat, el nom del departament, el codi de
 ** localitat, el codi de departament dels departaments 10,20 i 30 de la
 ** ciutat de Seattle. (Feu quatre versions, usant NATURAL JOIN, USING,
 ** usant ON i en format clàssic).
 **/

SELECT d.nom, c.codi, d.codi
FROM departaments d NATURAL JOIN ciutats c
WHERE d.codi=110 OR d.codi=20 or d.codi=30;

SELECT d.nom, c.codi, d.codi
FROM departaments d JOIN ciutats c USING (departament_codi)
WHERE d.codi=110 OR d.codi=20 or d.codi=30;

SELECT d.nom, c.codi, d.codi
FROM departaments d JOIN ciutats c ON(d.codi=c.departament_codi)
WHERE d.codi=110 OR d.codi=20 or d.codi=30;

SELECT d.nom, c.codi, d.codi
FROM departaments d, ciutats c
WHERE d.codi=c.departament_codi
AND (d.codi=110 OR d.codi=20 or d.codi=30);
        
/**
 ** 2. Llisteu el nom, el cognom i el nom de departament de tots els empleats,
 ** inclòs els que no són assignats a cap departament. Escriviu dues
 ** versions, una amb SQL99 usant el comandament JOIN i una altra amb
 ** SQL clàssic, sense la paraula reservada JOIN.
 **/

SELECT e.nom, e.cognom, d.nom
FROM employees e JOIN departaments d ON(e.departament=d.codi);

SELECT e.nom, e.cognom, d.nom
FROM employees e, departaments d 
WHERE (e.departament=d.codi);
    
/**
 ** 3. Llisteu el cognom dels empleats acompanyat del cognom del seu cap
 **/

SELECT e.cognom, d.cognom AS cap
FROM employees e JOIN employees d ON(d.codi=e.manager);

/**
 ** 4. Escriviu un llistat que mostri l’organigrama de tots els empleats,
 ** començant amb el director general (l’empleat que no té manager) i
 ** seguint un recorregut de la jerarquia. Escriviu el llistat identant cada
 ** nivell dos caràcters ‘-‘.
 **/
 
SELECT LPAD(last_name, LENGTH(last_name)+(LEVEL*2)-2,'_') AS "Org_Chart"
FROM employees
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id;
    
/**
 ** 5. Refeu el llistat anterior perquè elimini el empleat ‘De Haan’ i tots els que
 ** són en la jerarquia al seu càrrec.
 **/

-- Versio 1 (només elimina el empleat 'De Hann') 
SELECT LPAD(last_name, LENGTH(last_name)+(LEVEL*2)-2,'_') AS "Org_Chart"
FROM employees
WHERE last_name != 'De Hann'
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id;

-- Versio 2 (elimina el empleat 'De Haan' i tota la seva jerarquia)
SELECT LPAD(last_name, LENGTH(last_name)+(LEVEL*2)-2,'_') AS "Org_Chart"
FROM employees
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id
AND last_name!= 'De Haan';


/**
 ** 6. Llisteu el nombre d’empleats i el nombre de managers que hi ha. 
 **/
 
SELECT COUNT(*), COUNT(DISTINCT manager_id) 
FROM employees;

/**
 ** 7. Es vol identificar els dies de la setmana en que s’han contractat tres o més
 ** empleats. El llistat ha de mostrar els dies i el número d’empleats donats
 ** d’alta aquell dia
 **/
 
SELECT TO_CHAR(hire_date, 'day') data_alta, count(*)
FROM employees
GROUP BY TO_CHAR(hire_date, 'day')
HAVING count(*) >= 3;

/**
 ** 8.  El departament de comptabilitat vol obtenir informació del sou mig de
 ** tota la plantilla, del sou mig de cada lloc de treball (job_id), del sou mig
 ** de cada departament (department_id) i del sou mig de cada lloc de
 ** treball (job_id) en cada departament (department_id). Realitzeu
 ** l’obtenció d’aquestes agrupacions usant una sola sentència.
 **/

SELECT department_id, job_id, ROUND(AVG(Salary),2) as sou_mitg
FROM employees
GROUP BY CUBE (department_id, job_id);

/**
 ** 9. El departament de recursos humans necessita informació de la massa
 ** salarial per ciutat, departaments i tipus de feina (job_id). Concretament
 ** es vol una consulta per visualitzar dels departaments amb department_id
 ** >80, la massa salarial total i tots els subtotals que es poden formar amb
 ** els atributs city (que indica la ciutat on es troba ubicat el departament),
 ** department_name i job_id.
 **/
 
SELECT city, department_name, job_id, SUM(salary) massa_salarial
FROM employees
JOIN departments ON employees.department_id = departments.department_id
WHERE employees.department_id>80
GROUP BY CUBE (city, department_name, job_id);
    
/**
 ** 10. El departament de comptabilitat vol obtenir informació del sou més gran
 ** i del sou més petit dels empleats agrupats primer per department_id i
 ** job_id i per altre part també agrupats per job_id i manager_id. Realitzeu
 ** l’obtenció d’aquestes agrupacions usant una sola sentència.
 **/

SELECT departament_id, job_id, MAX(salary), MIN(salary)
FROM employees
GROUP BY GROUPING SETS ((departament_id, job_id),(job_id,manager_id));

/**
 ** 11. A la taula d'empleats, cada cap (manager_id) és el responsable d'un o
 ** més empleats on cadascun té un lloc de treball (job_id) i obté un salari.
 ** Per a cada cap, quin és el salari total obtingut per tots els seus empleats?
 ** I per de cada lloc de treball? Escriviu una consulta per mostrar el
 ** manager_id, job_id i salari total d’aquest job_id per aquest manager_id.
 ** Inclou també en el resultat el salari de tots els treballadors de cada
 ** gestor i la quantitat total de tots els salaris.
 **/
 
SELECT manager_id, job_id, SUM(salary)
FROM employees
GROUP BY ROLLUP(manager_id, job_id);

/**
 ** 12. Escriviu una ÚNICA consulta per mostrar les següents agrupacions:
 **     a. departament_id, manager_id, job_id
 **     b. manager_id, job_id
 **     c. departament_id, manager_id
 **/
SELECT department_id, job_id, manager_id
FROM employees
GROUP BY SETS((departament_id, job_id, manager_id), (departament_id, manager_id));
    
/**
 ** Escriviu una consulta per tornar l'empleat_id, job_id, hire_date i
 ** department_id de tots els empleats i una segona llista de consultes
 ** employee_id, job_id, start_date i department_id des de la taula
 ** job_history i combineu els resultats com una sola sortida ordenada de la
 ** data més antiga a la més recent. Assegureu-vos de què cap interval no es
 *** visualitzi dos cops
 **/
SELECT e.empleat_id, e.job_id, e.hire_date, e.department_id 
FROM employees e
UNION 
SELECT j.employee_id, j.job_id, j.start_date j.department_id 
FROM job_history j
ORDER BY hire_date;
    
/**
 ** 14. Cerqueu els empleats que no son directors (manager) de ningú sense
 ** utilizar ni joins ni subconsultes.
 **/
SELECT e.empleat_id FROM employees e
    MINUS m.manager_id FROM employees m;

--Ex15

--Ex16

/**
 ** 17. Llisteu els empleats que no han canviat mai de lloc de treball.
 **/

SELECT e.employee_id
FROM employees e
WHERE employee_id NOT IN (SELECT DISTINCT employee_id FROM job_history);

/**
 ** 18. 8.Escriviu una consulta per visualitzar l’employee_id, last_name, hire_date
 ** i salary dels empleats que tenen com director(manager) a “De Hann”. 
 **/

SELECT employee_id, last_name, hire_date, salary
FROM employees
WHERE manager_id IN (SELECT employee_id 
                     FROM employees
                     WHERE last_name='De Haan');

/**
 ** 19. Escriviu una consulta que visualitzi els empleats que tenen un sou
 ** inferior a la mitja. Ordeneu-los per salari, el que menys cobri el primer.
 **/
 
SELECT employee_id, last_name, salary
FROM employees
WHERE salary<(SELECT AVG(salary) FROM employees)
ORDER ASC BY salary;

/**
 ** 20. Escriviu una consulta per visualitzar els empleats que tenen un sou més
 ** gran al sou de cadascun dels empleats que tenen un job_id=’SA_MAN’.
 ** Ordena el resultat del sou més alt al més baix
 **/
 
SELECT employee_id
FROM employees
WHERE salari>(SELECT AVG(salary) 
              FROM employees
              WHERE job_id='SA_MAN')
ORDER BY salary DESC;

/**
 ** 21. Llisteu els empleats que cobren un sou inferior a la mitja del seu
 ** departament. Ordeneu la resposta per salari descendent
 **/
 
SELECT e.employee_id
FROM employees e
WHERE salary<(SELECT AVG(p.salary) 
              FROM employees p
              WHERE p.departament_id=e.departament_id)
ORDER BY salary DESC;

/**
 ** 22. Llisteu els empleats que no són cap de ningú
 **/

SELECT *
FROM employees
WHERE employee_id NOT EXISTS(SELECT ‘X’ 
       FROM employees i
       WHERE i.manager_id = o.employee_id);

/**
 ** 23.Definiu una consulta que retorni el nom, el cognom i el salari dels tres
 ** empleats que més cobren de l’empresa. (Taula employees).
 **/
SELECT nom, cognoom, salary
FROM employees
WHERE employee_id=(SELECT employee_id FROM employees ORDER BY salary DESC);

