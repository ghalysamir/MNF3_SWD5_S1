CREATE TABLE Department (
  DNum INT PRIMARY KEY,
  DName VARCHAR(30)  NOT NULL,
  Locations VARCHAR(100)
);
CREATE TABLE Employee (
  SSN CHAR(9) PRIMARY KEY,
  Fname VARCHAR(30) NOT NULL,
  Lname VARCHAR(30) NOT NULL,
  Gender CHAR(1) ,
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
  Work_hr DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (SSN, PNum),
  FOREIGN KEY (SSN) REFERENCES Employee(SSN),
  FOREIGN KEY (PNum) REFERENCES Project(PNum)
);
CREATE TABLE Dependent (
  SSN CHAR(9),
  DependentName VARCHAR(30),
  Gender CHAR(1) ,
  Birthdate DATE NOT NULL,
  PRIMARY KEY (SSN, DependentName),
  FOREIGN KEY (SSN) REFERENCES Employee(SSN)
); 



