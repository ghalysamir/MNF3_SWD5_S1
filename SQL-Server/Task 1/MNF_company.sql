CREATE TABLE Department (
  DNum INT PRIMARY KEY,
  DName VARCHAR(30) UNIQUE NOT NULL,
  Locations VARCHAR(100)
);
CREATE TABLE Employee (
  SSN CHAR(9) PRIMARY KEY,
  Fname VARCHAR(30) NOT NULL,
  Lname VARCHAR(30) NOT NULL,
  Gender CHAR(1) CHECK (Gender IN ('M', 'F')) NOT NULL,
  Birth_date DATE NOT NULL,
  DNum INT NOT NULL,
  Supervisor CHAR(9),
  FOREIGN KEY (DNum) REFERENCES Department(DNum),
  FOREIGN KEY (Supervisor) REFERENCES Employee(SSN)
);
CREATE TABLE Project (
  PNum INT PRIMARY KEY,
  PName VARCHAR(50) NOT NULL,
  City VARCHAR(50),
  DNum INT NOT NULL,
  FOREIGN KEY (DNum) REFERENCES Department(DNum)
);
CREATE TABLE Work (
  SSN CHAR(9),
  PNum INT,
  Work_hr DECIMAL(5,2) CHECK (Work_hr >= 0) NOT NULL,
  PRIMARY KEY (SSN, PNum),
  FOREIGN KEY (SSN) REFERENCES Employee(SSN),
  FOREIGN KEY (PNum) REFERENCES Project(PNum)
);
CREATE TABLE Dependent (
  SSN CHAR(9),
  DependentName VARCHAR(30),
  Gender CHAR(1) CHECK (Gender IN ('M', 'F')) NOT NULL,
  Birthdate DATE NOT NULL,
  PRIMARY KEY (SSN, DependentName),
  FOREIGN KEY (SSN) REFERENCES Employee(SSN)
);
INSERT INTO Department (DNum, DName, Locations) VALUES
(1, 'HR', 'Cairo'),
(2, 'Engineering', 'Alexandria'),
(3, 'Finance', 'Giza');
INSERT INTO Employee (SSN, Fname, Lname, Gender, Birth_date, DNum, Supervisor) VALUES
('E001', 'Ali', 'Hassan', 'M', '1990-01-01', 1, NULL),
('E002', 'Sara', 'Ibrahim', 'F', '1992-05-10', 2, 'E001'),
('E003', 'Khaled', 'Youssef', 'M', '1985-03-15', 2, 'E001'),
('E004', 'Mona', 'Ahmed', 'F', '1994-07-22', 3, 'E002'),
('E005', 'Omar', 'Sami', 'M', '1988-11-30', 1, 'E001');
-------------

UPDATE Employee
SET DNum = 3
WHERE SSN = 'E005';

DELETE FROM Dependent
WHERE SSN = 'E002' AND DependentName = 'Layla';

SELECT *
FROM Employee
WHERE DNum = 2;

SELECT E.SSN, E.Fname, E.Lname, P.PName, W.Work_hr
FROM Employee E
JOIN Work W ON E.SSN = W.SSN
JOIN Project P ON W.PNum = P.PNum;
