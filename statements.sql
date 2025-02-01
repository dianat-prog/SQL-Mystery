--*****************************************************************************************
--=========================================================================================
--1 Buscamos en la tabla crime_scene_report la primera pista que dice que el crimen ocurrio el
15/01/2018 en SQL City

SELECT * FROM crime_scene_report WHERE date ='20180115' AND city='SQL City' AND type='murder'

--======resultado
date	    type	description	                                                            city
20180115	murder	Security footage shows that there were 2 witnesses. 
                    The first witness lives at the last house on "Northwestern Dr". 
                    The second witness, named Annabel, lives somewhere on "Franklin Ave".	SQL City


-- ***Pistas: Este registro informa que hay dos testigos que tienen información del asesino.
--El primer testigo vive en la última casa de "Northwestern Dr". 
--El segundo testigo, llamado Annabel, vive en algún lugar de "Franklin Ave".


--*****************************************************************************************
--=========================================================================================
--2 Buscamos en tabla person información de los testigos

--Testigo 1 vive en la última casa de "Northwestern Dr
SELECT  * FROM person WHERE address_street_name='Northwestern Dr'
order by address_number desc LIMIT 1;

--======resultado
id	name	license_id	address_number	address_street_name	ssn
14887	Morty Schapiro	118009	4919	Northwestern Dr	111564949

--Testigo 2  llamado Annabel, vive en algún lugar de "Franklin Ave"
SELECT  * FROM person WHERE address_street_name='Franklin Ave'
AND name LIKE'%Annabel%'

--======resultado
id	   name         license_id	address_number	address_street_name	ssn
16371	Annabel Miller	490173	103         	Franklin Ave	    318771143



--*****************************************************************************************
--=========================================================================================
--3. En la tabla interview podemos obtener información sobre los datos
--que aportarón los testigos en el interrogatorio

--Información que aporte Morty Schapiro que tiene id 14887
SELECT  * FROM interview where person_id=14887

--======resultado
person_id	transcript
14887	    I heard a gunshot and then saw a man run out. 
            He had a "Get Fit Now Gym" bag. The membership
            number on the bag started with "48Z". Only gold 
            members have those bags. The man got into a car 
            with a plate that included "H42W".

	
--Información que aporte Annabel Miller que tiene id 16371
SELECT  * FROM interview where person_id=16371

--======resultado
person_id	transcript
16371	    I saw the murder happen, and I recognized the killer 
            from my gym when I was working out last week on January 
            the 9th.

            Vi ocurrir el asesinato y reconocí al asesino en mi gimnasio 
            cuando estaba entrenando la semana pasada, el 9 de enero.


--*****************************************************************************************
--=========================================================================================
--4 ***Pistas: Buscamos las pistas aportadas por los testidos.
--Testigo 14887 Morty Schapiro
--Bolsa con la inscripción "Get Fit Now Gym"
--Número de socio de la bolsa empieza con "48Z", solo los miembros Gol tienen esas bolsas
--EL hombre se sube a un coche con matricula que contiene "H42W"

SELECT p.id,p.name,p.license_id 
FROM person p
JOIN get_fit_now_member g
ON p.id = g.person_id
JOIN drivers_license d
ON p.license_id = d.id
WHERE g.id LIKE '48z%' 
AND g.membership_status='gold'
AND d.plate_number LIKE'%H42W%'

--======resultado
id	name	license_id
67318	Jeremy Bowers	423327


--***Pistas: Testigo 16371 Annabel Miller
--  Vio el asesinato y reconoce al asesino 
-- habia estado en su gimnasio la semana pasada
-- el 9 de enero.

SELECT p.id,p.name 
FROM person p
JOIN get_fit_now_member g
ON p.id = g.person_id
JOIN get_fit_now_check_in gt
ON g.id = gt.membership_id
JOIN drivers_license d
ON p.license_id = d.id
WHERE g.id LIKE '48z%' 
AND g.membership_status='gold'
AND d.plate_number LIKE'%H42W%'

--======resultado
id	name
67318	Jeremy Bowers


---Yuhuuu   Encontrado el asesino 
Did you find the killer?
Insert the name of the person you found here
1
INSERT INTO solution VALUES (1, 'Jeremy Bowers');
  SELECT value FROM solution;


--======resultado
  value
Congrats, you found the murderer! But wait, there's more... If you think you're up for a challenge, 
try querying the interview transcript of the murderer to find the real villain behind this crime.
 If you feel especially confident in your SQL skills, try to complete this final step with no more than
  2 queries. Use this same INSERT statement with your new suspect to check your answer.
  
  


--*****************************************************************************************
--=========================================================================================
--5. ***Pistas: Consultamos el interrogatorio del asesino Jeremy Bowers
SELECT * FROM interview WHERE person_id='67318'

--======resultado
person_id	transcript
67318	I was hired by a woman with a lot of money. I don't know her name but I know she's 
around 5'5" (65") or 5'7" (67"). She has red hair and she drives a Tesla Model S. 
I know that she attended the SQL Symphony Concert 3 times in December 2017.

--6. ***Pistas: En el interrogatorio dice el asesino que le ha contratado una mujer adinerada de la que no sabe su nombre, solo sabe que 
--tiene una estatura que está entre 1.65 y 1.70, pelo rojo, tiene un Tesla Model S
--y que asistio al concierto sinfónico tres veces en diciembre de 2017


SELECT person_id, count(*) FROM facebook_event_checkin
WHERE  event_name ='SQL Symphony Concert'
AND date LIKE'201712%'
GROUP BY person_id
HAVING COUNT(*)=3

--======resultado
person_id	count(*)
24556	3
99716	3

--En la consula anterior me dice que hay dos personas con id (24556 y 99716) que asistieron tres veces en diciembre del 2017
--al concierto de SQL Symphony Concert

-- 7. En la siguiente consulta busco a una persona que sea peli roja que mida 65" a 67" y qeu tenga un coche Tesla Moldel S,
--de genero femenino y que además se encuentre entre los dos person_id que encontré en la consulta anterior

SELECT p.id,name FROM person p
JOIN drivers_license d
ON p.license_id=d.id
WHERE d.hair_color='red'
AND d.height BETWEEN '65' AND '67'
AND d.car_make= 'Tesla'
AND d.car_model ='Model S'
AND d.gender='female'
AND p.id IN('24556','99716') --Estos son los dos Id que me delvio la consulta anterior

--======resultado
id	name
99716	Miranda Priestly 

--Miranda Priestly es la mujer que ordenó el asesinato  

INSERT INTO solution VALUES (1, 'Miranda Priestly');
        
        SELECT value FROM solution;
--======resultado
value
Congrats, you found the brains behind the murder! Everyone in SQL City hails you as the greatest SQL detective of all time. Time to break out the champagne!
