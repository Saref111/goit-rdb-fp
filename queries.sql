CREATE SCHEMA pandemic;

USE pandemic;

CREATE TABLE countries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name TEXT,
    code TEXT
);

CREATE TABLE diseases (
    id INT AUTO_INCREMENT PRIMARY KEY,
    country_id INT,
    year INT,
    yaws INT,
    polio INT,
    guinea_worm INT,
    rabies INT,
    malaria INT,
    hiv INT,
    tuberculosis INT,
    smallpox INT,
    cholera INT,
    FOREIGN KEY (country_id) REFERENCES countries(id)
);

INSERT INTO countries (name, code) SELECT DISTINCT Entity, Code FROM infectious_cases;

INSERT INTO diseases (country_id, year, yaws, polio, guinea_worm, rabies, malaria, hiv, tuberculosis, smallpox, cholera) 
SELECT countries.id, 
       infectious_cases.Year, 
       COALESCE(NULLIF(infectious_cases.Number_yaws, ''), 0), 
       COALESCE(NULLIF(infectious_cases.polio_cases, ''), 0), 
       COALESCE(NULLIF(infectious_cases.cases_guinea_worm, ''), 0), 
       COALESCE(NULLIF(infectious_cases.Number_rabies, ''), 0), 
       COALESCE(NULLIF(infectious_cases.Number_malaria, ''), 0), 
       COALESCE(NULLIF(infectious_cases.Number_hiv, ''), 0), 
       COALESCE(NULLIF(infectious_cases.Number_tuberculosis, ''), 0), 
       COALESCE(NULLIF(infectious_cases.Number_smallpox, ''), 0), 
       COALESCE(NULLIF(infectious_cases.Number_cholera_cases, ''), 0)
FROM infectious_cases 
JOIN countries ON infectious_cases.Entity = countries.name AND infectious_cases.Code = countries.code;

SELECT Entity, Code, AVG(Number_rabies) as avg, MIN(Number_rabies) as min, MAX(Number_rabies) as max, SUM(Number_rabies) as sum
FROM infectious_cases
WHERE Number_rabies != '' AND Number_rabies IS NOT NULL 
GROUP BY Entity, Code
ORDER BY avg DESC
LIMIT 10;