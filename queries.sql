CREATE SCHEMA pandemic;

USE pandemic;

CREATE TABLE countries (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name TEXT NOT NULL,
    code TEXT NOT NULL
);

CREATE TABLE diseases (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name TEXT NOT NULL
);

CREATE TABLE cases (
    id INT PRIMARY KEY AUTO_INCREMENT,
    country_id INT,
    disease_id INT,
    year INT,
    number_cases INT,
    FOREIGN KEY (country_id) REFERENCES countries(id),
    FOREIGN KEY (disease_id) REFERENCES diseases(id)
);

INSERT INTO countries (name, code)
SELECT DISTINCT Entity, Code
FROM infectious_cases;

INSERT INTO diseases (name)
SELECT DISTINCT Number_yaws
FROM infectious_cases;

INSERT INTO cases (country_id, disease_id, year, number_cases)
SELECT c.id,
       d.id,
       infectious_cases.Year,
       COALESCE(NULLIF(CAST(REPLACE(NULLIF(Number_yaws, ''), ',', '') AS UNSIGNED), ''), 0)
FROM infectious_cases
JOIN countries c ON c.code = infectious_cases.Code
JOIN diseases d ON d.name = infectious_cases.Number_yaws;
