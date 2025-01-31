create database TechSAPSolutionsDB;
use TechSAPSolutionsDB;

CREATE TABLE Consultants (
    ConsultantID VARCHAR(10) PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Specialization VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    ExperienceYears INT,
    Salary DECIMAL(10,2)
);

INSERT INTO Consultants 
(ConsultantID,	FirstName,	LastName,	Specialization,	Email,	Phone,	ExperienceYears,	Salary)
VALUES 
('C101', 'Amit', 'Mehra', 'SAP B1', 'amit.mehra@techsap.com', '9876543210', 5, 90000),
('C102', 'Nisha', 'Kapoor', 'SAP S/4HANA', 'nisha.kapoor@techsap.com', '8765432109', 7, 110000),
('C103', 'Rakesh', 'Verma', 'SAP FICO', 'rakesh.verma@techsap.com', '7654321098', 6, 95000),
('C104', 'Priyanka', 'Sharma', 'SAP MM', 'priyanka.sharma@techsap.com', '6543210987', 8, 120000);


CREATE TABLE Clients (
    ClientID VARCHAR(10) PRIMARY KEY,
    ClientName VARCHAR(100),
    Industry VARCHAR(50),
    ContactPerson VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15)
);

INSERT INTO Clients
(ClientID,	ClientName,	Industry,	ContactPerson,	Email,	Phone)
 VALUES 
('CL001', 'ABC Manufacturing', 'Manufacturing', 'Rajesh Gupta', 'rajesh.gupta@abc.com', '9876541111'),
('CL002', 'XYZ Retail', 'Retail', 'Sunita Reddy', 'sunita.reddy@xyz.com', '8765432222'),
('CL003', 'LMN Logistics', 'Logistics', 'Sameer Khan', 'sameer.khan@lmn.com', '7654323333');


CREATE TABLE Projects (
    ProjectID VARCHAR(10) PRIMARY KEY,
    ProjectName VARCHAR(100),
    ClientID VARCHAR(10),
    ConsultantID VARCHAR(10),
    StartDate DATE,
    EndDate DATE,
    Status VARCHAR(20),
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
    FOREIGN KEY (ConsultantID) REFERENCES Consultants(ConsultantID)
);

INSERT INTO Projects
(ProjectID,	ProjectName,	ClientID,	ConsultantID,	StartDate,	EndDate	,Status)
 VALUES 
('P1001', 'SAP B1 for ABC Corp', 'CL001', 'C101', '2023-01-10', '2023-07-15', 'Completed'),
('P1002', 'SAP MM for XYZ', 'CL002', 'C104', '2023-03-05', '2023-12-20', 'Ongoing'),
('P1003', 'SAP S/4HANA for LMN', 'CL003', 'C102', '2023-06-01', '2024-01-30', 'Ongoing');

CREATE TABLE Trainings (
    TrainingID VARCHAR(10) PRIMARY KEY,
    TrainingName VARCHAR(100),
    ConsultantID VARCHAR(10),
    ClientID VARCHAR(10),
    TrainingDate DATE,
    DurationHours INT,
    FOREIGN KEY (ConsultantID) REFERENCES Consultants(ConsultantID),
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID)
);
INSERT INTO Trainings
(TrainingID,	TrainingName,	ConsultantID,	ClientID,	TrainingDate,	DurationHours)
 VALUES 
('T2001', 'SAP B1 Basics', 'C101', 'CL001', '2023-02-15', 6),
('T2002', 'SAP MM Advanced', 'C104', 'CL002', '2023-05-20', 8),
('T2003', 'SAP FICO Overview', 'C103', 'CL003', '2023-09-12', 5);

CREATE TABLE SupportTickets (
    TicketID VARCHAR(10) PRIMARY KEY,
    ClientID VARCHAR(10),
    IssueDescription VARCHAR(255),
    ConsultantID VARCHAR(10),
    RaisedDate DATE,
    Status VARCHAR(20),
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
    FOREIGN KEY (ConsultantID) REFERENCES Consultants(ConsultantID)
);

INSERT INTO SupportTickets
(TicketID,	ClientID,	IssueDescription,	ConsultantID,	RaisedDate,	Status)
 VALUES 
('ST3001', 'CL001', 'Error in SAP B1 Reports', 'C101', '2023-07-20', 'Resolved'),
('ST3002', 'CL002', 'SAP MM Integration Issue', 'C104', '2023-10-10', 'Open'),
('ST3003', 'CL003', 'S/4HANA Login Issue', 'C102', '2024-01-15', 'Open');


-- Retrieve the names, specializations, and experience of all SAP consultants.
select FirstName,	LastName,	Specialization,	ExperienceYears
from consultants;

-- Get a list of all clients along with their industries.
select ClientID,	ClientName,	Industry
from clients;

-- Find the contact details of the client "XYZ Retail".
select ContactPerson,	Email,	Phone
from clients
where clientname = "XYZ retail";


-- List all consultants who specialize in "SAP B1".
select * from consultants
where Specialization = "SAP B1";

-- Retrieve all projects that are currently ongoing.
select *
from projects
where status = "ongoing";

-- Find consultants who have more than 6 years of experience.
select * from consultants
where ExperienceYears > 6;


--  Show the list of projects along with their client names.
select projects.ProjectID,	projects.ProjectName, clients.clientname
from projects
join clients on projects.clientid = clients.clientid;

-- Get the consultants assigned to each project.
select consultants.ConsultantID,	consultants.FirstName,	consultants.LastName, projects.ProjectName
from consultants
join projects on consultants.consultantid = projects.consultantid;

-- Retrieve training sessions along with consultant names who conducted them.
select trainings.TrainingID,	trainings.TrainingName, consultants.FirstName,	consultants.LastName
from trainings
join consultants on trainings.ConsultantID = consultants.consultantid;

-- Count the number of projects handled by each consultant.
select consultants.ConsultantID,	consultants.FirstName, count(projects.projectid) as totalprojects
from projects 
join consultants on projects.consultantid = consultants.ConsultantID
group by consultants.ConsultantID,	consultants.FirstName;

-- find the average experience of all consultants.
-- average of each
select ConsultantID,	FirstName,	LastName,	avg(ExperienceYears)
from consultants
group by ConsultantID,	FirstName,	LastName;
-- average of all
SELECT AVG(ExperienceYears) AS AvgExperience FROM Consultants;


-- Get the total number of training hours conducted for each client.
select  clients.ClientID,	clients.ClientName, sum(trainings.DurationHours) as TotalTrainingHours 
from trainings
join clients on trainings.ClientID = clients.clientid
group by clients.ClientID,	clients.ClientName;


--  Find clients who have raised support tickets but have no completed projects.
select 	clients.ClientName
from clients
join supporttickets on clients.clientid = supporttickets.clientid
where clients.clientid not in (select clientid from projects where status = "completed");


-- Retrieve the consultant with the highest salary.
select FirstName,lastname,salary 
from consultants
order by salary desc
limit 1;


--  List all open support tickets along with consultant names.
select supporttickets.TicketID, consultants.FirstName,	consultants.LastName
from supporttickets
join consultants on supporttickets.ConsultantID = consultants.ConsultantID
where supporttickets.status = "open";













