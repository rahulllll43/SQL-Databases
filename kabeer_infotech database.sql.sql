create database kabeer_infotech;

use kabeer_infotech;

create table employees(
EmployeeID varchar(10) primary key,	FirstName varchar(50),	LastName varchar(50),	DOB date,	Gender varchar(1),	Email varchar(50),
	Phone varchar(15),	DepartmentID varchar(10),	HireDate date,	Salary varchar(10)
);

Insert into employees
(EmployeeID,	FirstName,	LastName,	DOB	,Gender,	Email,	Phone	,DepartmentID,	HireDate,	Salary)
values
("E101",	"Rahul",	"Sharma",	"1990-05-14",	"M",	"rahul.sharma@kabeer.com",	"9876543210",	"D001",	"2020-01-15",	"75000"),
("E102",	"Priya",	"Verma",	"1992-08-21",	"F",	"priya.verma@kabeer.com",	"8765432109",	"D002",	"2019-07-10",	"85000"),
("E103",	"Ankit",    "Mishra",	"1995-04-12",	"M",	"ankit.mishra@kabeer.com",	"7654321098",	"D001",	"2021-03-25",	"60000"),
("E104",	"Sneha",    "Gupta",	"1988-12-02",	"F",	"sneha.gupta@kabeer.com",	"6543210987",	"D003",	"2018-11-30",	"95000"),
("E105",	"Karan",	"Yadav",	"1993-06-19",	"M",	"karan.yadav@kabeer.com",	"5432109876",	"D002",	"2022-06-15",	"70000");


CREATE TABLE Departments (
    DepartmentID VARCHAR(10) PRIMARY KEY,
    DepartmentName VARCHAR(100),
    ManagerID VARCHAR(10),
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);

INSERT INTO Departments 
(DepartmentID,	DepartmentName,	ManagerID)  VALUES 
('D001', 'Software Development', 'E101'),
('D002', 'IT Support', 'E102'),
('D003', 'HR', 'E104');

CREATE TABLE Projects (
    ProjectID VARCHAR(10) PRIMARY KEY,
    ProjectName VARCHAR(100),
    Client VARCHAR(100),
    StartDate DATE,
    EndDate DATE,
    DepartmentID VARCHAR(10),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
INSERT INTO Projects 
(ProjectID,	ProjectName,	Client,	StartDate,	EndDate	,DepartmentID)  VALUES 
('P1001', 'Cloud Migration', 'ABC Corp', '2023-01-10', '2023-07-15', 'D001'),
('P1002', 'E-commerce App', 'XYZ Ltd', '2023-03-05', '2023-12-20', 'D001'),
('P1003', 'Network Security', 'DEF Inc', '2023-06-01', '2024-01-30', 'D002'),
('P1004', 'Employee Management', 'KLM Pvt Ltd', '2023-09-15', '2024-06-10', 'D003');

CREATE TABLE EmployeeProjects (
    AssignmentID VARCHAR(10) PRIMARY KEY,
    EmployeeID VARCHAR(10),
    ProjectID VARCHAR(10),
    Role VARCHAR(50),
    HoursPerWeek INT,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID));

INSERT INTO EmployeeProjects 
(AssignmentID,	EmployeeID	,ProjectID,	Role	,HoursPerWeek)
values
('A2001', 'E101', 'P1001', 'Developer', 40),
('A2002', 'E103', 'P1002', 'Tester', 35),
('A2003', 'E102', 'P1003', 'Network Admin', 40),
('A2004', 'E105', 'P1003', 'Support Staff', 30),
('A2005', 'E104', 'P1004', 'HR Coordinator', 20);


-- --Retrieve the names, emails, and departments of all employees.
select employees.FirstName,	employees.LastName, departments.departmentname
from employees
join departments on employees.departmentID = departments.departmentID;

-- Get a list of all projects along with their clients.
select projectname, client
from projects;

-- Find the phone number and email of an employee named "Ankit Mishra".
select email, phone
from employees
where Firstname = "Ankit" and lastname = "Mishra";

-- Find all employees who work in the "Software Development" department.
select employees.EmployeeID,	employees.FirstName,	employees.LastName, departments.departmentname
from employees
join departments on employees.departmentid = departments.departmentid
where departmentname = "software development";

-- List all projects that started after "March 1, 2023".
select * 
from projects 
where StartDate < '2023-03-01';

-- Retrieve employees who earn more than ₹75,000.
select EmployeeID,	FirstName,	LastName, salary
from employees
where salary > '75000';

-- Display a list of employees along with their assigned project names.
select employees.EmployeeID,	employees.FirstName,	employees.LastName, projects.projectname
from employees
join employeeprojects on employees.employeeid = employeeprojects.employeeid
join projects on employeeprojects.projectid = projects.projectID;


-- Get the project names along with the department responsible for them.
select projects.projectname, departments.departmentname
from projects
join departments on projects.departmentid = departments.departmentid;


-- Show the employees working on "Cloud Migration".
SELECT Employees.FirstName, Employees.LastName 
FROM Employees
JOIN EmployeeProjects ON Employees.EmployeeID = EmployeeProjects.EmployeeID
JOIN Projects ON EmployeeProjects.ProjectID = Projects.ProjectID
WHERE Projects.ProjectName = 'Cloud Migration';


-- Count the number of employees in each department.
select departments.DepartmentName, count(employees.employeeid) as totalemployees
from employees
join departments on employees.departmentid = departments.departmentid
group by departments.DepartmentName;


-- Find the average salary of employees in each department.
select departments.departmentname, avg(employees.salary) as AVGSalary
from employees
join departments on employees.departmentid = departments.departmentid
group by departments.departmentname;


-- Retrieve the total number of hours worked per week for each project.
select projects.projectname, sum(EmployeeProjects.hoursperweek) as totalhours
from EmployeeProjects
join projects on EmployeeProjects.projectid = projects.projectid
group by  projects.projectname;


--  Find employees who are assigned to more than one project.
select employees.EmployeeID,	employees.FirstName,	employees.LastName, count(employeeprojects.projectid) as totalproject
from employees
join employeeprojects on Employees.employeeid = employeeprojects.employeeid
group by employees.EmployeeID,	employees.FirstName,	employees.LastName
having count(employeeprojects.projectid) > 1;


-- Get the highest salary in each department.
select departments.DepartmentID,	departments.DepartmentName, max(employees.salary) as highestsalary
from employees 
join departments on employees.departmentid = departments.departmentid
group by departments.DepartmentID,	departments.DepartmentName;


-- Retrieve employees who are NOT assigned to any project.
SELECT FirstName, LastName 
FROM Employees 
WHERE EmployeeID NOT IN (SELECT EmployeeID FROM EmployeeProjects);









