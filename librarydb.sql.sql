create database LibraryDB;
use LibraryDB;

-- Table 1: Books
CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    Author VARCHAR(100) NOT NULL,
    Genre VARCHAR(50),
    PublishedYear INT,
    Available ENUM('Yes', 'No') DEFAULT 'Yes'
);

-- Insert data into Books table
INSERT INTO Books (BookID, Title, Author, Genre, PublishedYear, Available) VALUES
(1, 'The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 1925, 'Yes'),
(2, '1984', 'George Orwell', 'Dystopian', 1949, 'No'),
(3, 'To Kill a Mockingbird', 'Harper Lee', 'Fiction', 1960, 'Yes'),
(4, 'Pride and Prejudice', 'Jane Austen', 'Romance', 1813, 'Yes'),
(5, 'The Catcher in the Rye', 'J.D. Salinger', 'Fiction', 1951, 'No');

-- Table 2: Members
CREATE TABLE Members (
    MemberID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    JoinDate DATE
);

-- Insert data into Members table
INSERT INTO Members (MemberID, Name, Email, JoinDate) VALUES
(101, 'Rahul Kumar', 'rahul.kumar@example.com', '2023-01-15'),
(102, 'Priya Sharma', 'priya.sharma@example.com', '2023-02-10'),
(103, 'Amit Singh', 'amit.singh@example.com', '2023-03-05'),
(104, 'Neha Gupta', 'neha.gupta@example.com', '2023-04-20');

-- Table 3: BorrowedBooks
CREATE TABLE BorrowedBooks (
    BorrowID INT PRIMARY KEY,
    BookID INT,
    MemberID INT,
    BorrowDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

-- Insert data into BorrowedBooks table
INSERT INTO BorrowedBooks (BorrowID, BookID, MemberID, BorrowDate, ReturnDate) VALUES
(1001, 2, 101, '2023-05-01', '2023-05-15'),
(1002, 5, 103, '2023-05-10', NULL),
(1003, 1, 102, '2023-05-12', NULL);



-- Retrieve all books that are currently available.
select * from books
where available = "Yes";


-- Find the names of members who have borrowed books but haven't returned them yet.
select members.MemberID, members.Name
from members
join borrowedbooks on members.memberid = borrowedbooks.memberid
where returndate is null;

-- List all books published before the year 1950.
Select * from books
where PublishedYear < 1950;


-- Count the total number of books in the library.
select count(*) from books;


--  Find the member who joined most recently.
select * from members
order by joindate desc
limit 1;


-- Retrieve the title and author of books borrowed by "Rahul Kumar".
select b.Title, b.Author
from books as b
join BorrowedBooks as bb on b.bookid = bb.bookid
join members as m on bb.memberid = m.memberid
where m.name = "Rahul Kumar";


-- List all members who have not borrowed any books.
select m.name
from members as m
left join borrowedbooks as bb on m.memberid = bb.memberid
where bb.borrowid is null;


-- Find the most borrowed book (based on the number of times it appears in the BorrowedBooks table).
-- for most borrowed all books
SELECT books.BookID, books.Title, max(bb.BorrowID) as mostborrowed
from BorrowedBooks as bb 
join books on bb.bookid = books.bookid
group by books.BookID, books.Title;
-- for only 1 book most borrowed
SELECT B.Title, COUNT(BB.BookID) AS BorrowCount
FROM Books B
JOIN BorrowedBooks BB ON B.BookID = BB.BookID
GROUP BY B.BookID
ORDER BY BorrowCount DESC
LIMIT 1;

































































