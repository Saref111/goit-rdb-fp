-- Завдання 1

CREATE SCHEMA pandemic;

USE pandemic;

-- Завдання 2

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

-- Завдання 3

SELECT Entity, Code, AVG(Number_rabies) as avg, MIN(Number_rabies) as min, MAX(Number_rabies) as max, SUM(Number_rabies) as sum
FROM infectious_cases
WHERE Number_rabies != '' AND Number_rabies IS NOT NULL 
GROUP BY Entity, Code
ORDER BY avg DESC
LIMIT 10;

-- Завдання 4

SET SQL_SAFE_UPDATES = 0;

ALTER TABLE infectious_cases ADD COLUMN year_date DATE;

UPDATE infectious_cases SET year_date = STR_TO_DATE(CONCAT(Year, '-01-01'), '%Y-%m-%d');

ALTER TABLE infectious_cases ADD COLUMN `current_date` DATE;

UPDATE infectious_cases SET `current_date` = CURDATE();

ALTER TABLE infectious_cases ADD COLUMN year_diff INT;

UPDATE infectious_cases SET year_diff = YEAR(`current_date`) - YEAR(year_date);

SET SQL_SAFE_UPDATES = 1;

-- Завдання 5

DELIMITER // 
CREATE FUNCTION get_year_diff(year_value INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN YEAR(CURDATE()) - YEAR(STR_TO_DATE(CONCAT(year_value, '-01-01'), '%Y-%m-%d'));
END //
DELIMITER ;

SELECT get_year_diff(1996);