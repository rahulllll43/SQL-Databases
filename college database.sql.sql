create database college;

use college;

create table student (
StudentID int primary key,
	FirstName varchar(50),	LastName varchar(50),DOB date,
	Gender varchar (1),	Email varchar(100),	Phone varchar(15),	Department varchar(20)	,
    Year varchar(1)
);

insert into student
(StudentID,	FirstName,	LastName,	DOB,	Gender,	Email,	Phone,	Department,	Year)
values
(1001,	"John",	"Doe",	"2002-05-14",	"M",	"john.doe@abcuni.edu",	"123-456-7890",	"Computer Science",	"3"),
(1002,	"Alice",	"Brown",	"2003-07-21",	"F",	"alice.brown@abcuni.edu",	"456-789-0123",	"Business", "2"),
(1003,	"Robert"	,"Smith",	"2001-03-12",	"M",	"robert.smith@abcuni.edu",	"789-012-3456",	"Engineering",	"4"),
(1004,	"Emma",	"Wilson",	"2004-09-05",	"F",	"emma.wilson@abcuni.edu",	"234-567-8901",	"Computer Science",	"1"),
(1005,	"Daniel",	"Lee",	"2002-11-30",	"M",	"daniel.lee@abcuni.edu",	"567-890-1234",	"Business",	"3")
;



create table course (
CourseID varchar(10),	CourseName varchar(50),	Department varchar (50),	Credits int, 	InstructorID varchar(20)
);

insert into course
(CourseID,	CourseName, Department,	Credits,	InstructorID)
values
("CSE101",	"Database Management",	"Computer Science",	4,	"F201"),
("CSE102",	"Data Structures",	"Computer Science",	3,	"F202"),
("BUS201",	"Business Management",	"Business",	3,	"F203"),
("ENG301",	"Thermodynamics",	"Engineering",	4,	"F204"),
("CSE103",	"Operating Systems",	"Computer Science",	4,	"F201");

select * from course;

Create table faculty
(InstructorID varchar(20),	FirstName varchar(10),	LastName varchar(50),	Email varchar(50),	Department varchar(20),	Phone varchar(12));

insert into faculty
(InstructorID,	FirstName,	LastName,	Email,	Department,	Phone)
values
("F202",	"Sarah",	"Miller",	"sarah.miller@abcuni.edu",	"Computer Science",	"654-987-3210"),
("F203",	"James",	"Anderson",	"james.anderson@abcuni.edu",	"Business",	"987-321-6540"),
("F204",	"Laura",	"Davis",	"laura.davis@abcuni.edu",	"Engineering",	"456-123-7890");

create table enrollment(
EnrollmentID varchar(20),	StudentID int,	CourseID varchar(20),	EnrollmentDate date,	Grade varchar(2)
);

insert into enrollment
(EnrollmentID,	StudentID,	CourseID,	EnrollmentDate,	Grade)
values
("E5001",	1001,	"CSE101",	"2024-01-15",	"B+"),
("E5002",	1001,	"CSE103",	"2024-01-15",	"A"),
("E5003",   1002,	"BUS201",	"2024-01-18",	"B"),
("E5004",	1003,	"ENG301",	"2024-01-20",	"A-"),
("E5005",	1004,	"CSE101",	"2024-01-22",	"B"),
("E5006",	1005,	"BUS201",	"2024-01-22",	"C+");

select course.coursename, faculty.InstructorID
from course
join faculty on course.department = faculty.department;

SELECT Course.CourseName, Faculty.FirstName, Faculty.LastName 
FROM Course
JOIN Faculty ON Course.InstructorID = Faculty.InstructorID;

-- better code
select student.StudentID,	student.FirstName,	student.LastName, student.Department, faculty.Firstname, faculty.lastname
from student
join faculty on student.department = faculty.department
where InstructorID = "F204";
-- another code
SELECT Student.FirstName, Student.LastName, Course.CourseName 
FROM Student
JOIN Enrollment ON Student.StudentID = Enrollment.StudentID
JOIN Course ON Enrollment.CourseID = Course.CourseID
JOIN Faculty ON Course.InstructorID = Faculty.InstructorID
WHERE Faculty.FirstName = "laura" AND Faculty.LastName = "davis";

select department, count(*) totalstudent
from student
group by department;

SELECT Course.CourseName, AVG(
    CASE 
        WHEN Grade = 'A' THEN 4.0 
        WHEN Grade = 'A-' THEN 3.7 
        WHEN Grade = 'B+' THEN 3.3 
        WHEN Grade = 'B' THEN 3.0 
        WHEN Grade = 'C+' THEN 2.3 
        ELSE 0 
    END
) AS AvgGrade 
FROM Enrollment
JOIN Course ON Enrollment.CourseID = Course.CourseID
GROUP BY Course.CourseName;


select faculty.Firstname, faculty.lastname , COUNT(Course.CourseID) AS TotalCourses
from faculty
join course on faculty.instructorID = course.InstructorID
group by faculty.Firstname, faculty.lastname;

select student.firstname, student.lastname, count(enrollment.courseid) as totalcourses
from student
join enrollment on student.studentid = enrollment.studentid
group by student.studentid, student.firstname, student.lastname
having count(enrollment.courseid) > 1;



select course.coursename, max(grade) as highestgrade
from enrollment
join course on enrollment.courseid = course.courseid
group by course.coursename;



SELECT Student.FirstName, Student.LastName
FROM Student
WHERE StudentID IN (
    SELECT StudentID FROM Enrollment WHERE CourseID = 'CSE101'
)
AND StudentID NOT IN (
    SELECT StudentID FROM Enrollment WHERE CourseID = 'CSE103'
);






