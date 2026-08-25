
-- Create the database
CREATE DATABASE HealthcareDB;
USE HealthcareDB;

-- Create the Patients table
CREATE TABLE Patients (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Age INT NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    Address VARCHAR(255)
);

-- Create the Hospitals table
CREATE TABLE Hospitals (
    HospitalID INT AUTO_INCREMENT PRIMARY KEY,
    HospitalName VARCHAR(100) NOT NULL,
    Location VARCHAR(100) NOT NULL,
    Capacity INT NOT NULL
);

-- Create the Admissions table
CREATE TABLE Admissions (
    AdmissionID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    HospitalID INT,
    AdmissionDate DATE NOT NULL,
    DischargeDate DATE,
    ReasonForAdmission VARCHAR(255),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (HospitalID) REFERENCES Hospitals(HospitalID)
);

-- Create the Treatments table
CREATE TABLE Treatments (
    TreatmentID INT AUTO_INCREMENT PRIMARY KEY,
    AdmissionID INT,
    ProcedureName VARCHAR(100) NOT NULL,
    Cost DECIMAL(10, 2) NOT NULL,
    Outcome VARCHAR(50),
    FOREIGN KEY (AdmissionID) REFERENCES Admissions(AdmissionID)
);

-- Insert data into Patients table
INSERT INTO Patients (FullName, Age, Gender, Address) VALUES
('John Doe', 45, 'Male', '123 Elm Street'),
('Jane Smith', 34, 'Female', '456 Oak Avenue'),
('Sam Brown', 29, 'Male', '789 Pine Road'),
('Lisa White', 52, 'Female', '321 Maple Lane'),
('Tom Green', 67, 'Male', '654 Birch Blvd'),
('Alice Johnson', 40, 'Female', '987 Willow Court'),
('Robert Black', 60, 'Male', '564 Cypress Road'),
('Emily Davis', 25, 'Female', '321 Cedar Avenue'),
('Michael Scott', 50, 'Male', '742 Birch Lane'),
('Sarah Taylor', 33, 'Female', '159 Spruce Drive');

-- Insert data into Hospitals table
INSERT INTO Hospitals (HospitalName, Location, Capacity) VALUES
('General Hospital', 'New York', 500),
('City Clinic', 'Los Angeles', 200),
('Central Medical Center', 'Chicago', 300),
('Regional Health Facility', 'Houston', 150),
('Sunrise Hospital', 'Phoenix', 400);

-- Insert data into Admissions table
INSERT INTO Admissions (PatientID, HospitalID, AdmissionDate, DischargeDate, ReasonForAdmission) VALUES
(1, 1, '2024-11-01', '2024-11-05', 'Surgery'),
(2, 2, '2024-11-03', '2024-11-08', 'Therapy'),
(3, 3, '2024-11-10', '2024-11-15', 'Accident'),
(4, 4, '2024-11-12', '2024-11-19', 'Routine Checkup'),
(5, 5, '2024-12-01', '2024-12-08', 'Infection'),
(6, 1, '2024-12-01', NULL, 'Surgery'),
(7, 2, '2024-12-02', '2024-12-05', 'Fracture Repair'),
(8, 3, '2024-12-03', NULL, 'Chronic Illness'),
(9, 4, '2024-12-03', '2024-12-18', 'Therapy'),
(10, 5, '2024-12-04', '2024-12-18', 'Infection');

-- Insert data into Treatments table
INSERT INTO Treatments (AdmissionID, ProcedureName, Cost, Outcome) VALUES
(1, 'Appendectomy', 1500.00, 'Successful'),
(2, 'Physical Therapy', 800.00, 'Ongoing'),
(3, 'Fracture Repair', 3000.00, 'Successful'),
(4, 'Blood Test', 200.00, 'Pending'),
(5, 'Antibiotics', 500.00, 'Improved'),
(6, 'Gallbladder Surgery', 4000.00, 'Successful'),
(7, 'X-Ray', 300.00, 'Successful'),
(8, 'Chemotherapy', 5000.00, 'Ongoing'),
(9, 'MRI Scan', 1200.00, 'Pending'),
(10, 'Diabetes Treatment', 700.00, 'Improved');

USE HealthcareDB;
SHOW TABLES;
SELECT * FROM Hospitals;
SELECT * FROM Patients;
SELECT * FROM Admissions;

-- Patient Demographics
SELECT
    Gender,
    COUNT(*) AS TotalPatients,
    AVG(Age) AS AverageAge
FROM Patients
GROUP BY Gender;

-- Hospital Utilization
SELECT
    h.HospitalName,
    COUNT(a.AdmissionID) AS TotalAdmissions
FROM Hospitals h
JOIN Admissions a
ON h.HospitalID = a.HospitalID
GROUP BY h.HospitalName
ORDER BY TotalAdmissions DESC;

-- Treatment Costs
SELECT
    h.HospitalName,
    SUM(t.Cost) AS TotalTreatmentCost
FROM Hospitals h
JOIN Admissions a
ON h.HospitalID = a.HospitalID
JOIN Treatments t
ON a.AdmissionID = t.AdmissionID
GROUP BY h.HospitalName
ORDER BY TotalTreatmentCost DESC;

-- Length of Stay Analysis
SELECT
    h.HospitalName,
    AVG(DATEDIFF(a.DischargeDate, a.AdmissionDate)) AS AverageStay
FROM Hospitals h
JOIN Admissions a
ON h.HospitalID = a.HospitalID
GROUP BY h.HospitalName;

-- Patients staying more than 7 days
SELECT
    p.PatientID,
    p.FullName,
    h.HospitalName,
    DATEDIFF(a.DischargeDate, a.AdmissionDate) AS DaysStayed
FROM Patients p
JOIN Admissions a
ON p.PatientID = a.PatientID
JOIN Hospitals h
ON a.HospitalID = h.HospitalID
WHERE DATEDIFF(a.DischargeDate, a.AdmissionDate) > 7;

-- Treatments performed more than 5 times
SELECT
    ProcedureName,
    COUNT(*) AS Frequency
FROM Treatments
GROUP BY ProcedureName
HAVING COUNT(*) > 5;

-- Complete Patient History
SELECT
    p.PatientID,
    p.FullName,
    h.HospitalName,
    a.AdmissionDate,
    a.DischargeDate,
    a.ReasonForAdmission,
    t.ProcedureName,
    t.Cost,
    t.Outcome
FROM Patients p
JOIN Admissions a
    ON p.PatientID = a.PatientID
JOIN Hospitals h
    ON a.HospitalID = h.HospitalID
JOIN Treatments t
    ON a.AdmissionID = t.AdmissionID
ORDER BY p.PatientID, a.AdmissionDate;

-- Combine patients admitted for Surgery and Therapy
SELECT
    PatientID,
    ReasonForAdmission
FROM Admissions
WHERE ReasonForAdmission = 'Surgery'

UNION

SELECT
    PatientID,
    ReasonForAdmission
FROM Admissions
WHERE ReasonForAdmission = 'Therapy';

-- Hospital with the Highest Average Treatment Cost
SELECT HospitalName, AverageTreatmentCost
FROM (
    SELECT
        h.HospitalName,
        AVG(t.Cost) AS AverageTreatmentCost
    FROM Hospitals h
    JOIN Admissions a
        ON h.HospitalID = a.HospitalID
    JOIN Treatments t
        ON a.AdmissionID = t.AdmissionID
    GROUP BY h.HospitalName
) AS HospitalAvg
ORDER BY AverageTreatmentCost DESC
LIMIT 1;

-- Create a View
CREATE VIEW HospitalPerformance AS
SELECT
    h.HospitalID,
    h.HospitalName,
    COUNT(DISTINCT a.AdmissionID) AS TotalAdmissions,
    AVG(DATEDIFF(a.DischargeDate, a.AdmissionDate)) AS AverageLengthOfStay,
    SUM(t.Cost) AS TotalRevenue
FROM Hospitals h
JOIN Admissions a
    ON h.HospitalID = a.HospitalID
JOIN Treatments t
    ON a.AdmissionID = t.AdmissionID
GROUP BY h.HospitalID, h.HospitalName;

SELECT * FROM HospitalPerformance;

-- Rank Hospitals Based on Total Revenue
SELECT
    HospitalName,
    TotalRevenue,
    RANK() OVER (ORDER BY TotalRevenue DESC) AS HospitalRank
FROM HospitalPerformance;

-- Rank Treatments Based on Frequency
SELECT
    ProcedureName,
    COUNT(*) AS Frequency,
    DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS TreatmentRank
FROM Treatments
GROUP BY ProcedureName;