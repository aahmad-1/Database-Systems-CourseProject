PRAGMA foreign_keys = OFF; --  disable keys temporarily to drop tables safely

DROP TABLE IF EXISTS Fine;
DROP TABLE IF EXISTS Loan;
DROP TABLE IF EXISTS BookAuthor;
DROP TABLE IF EXISTS Book;
DROP TABLE IF EXISTS Author;
DROP TABLE IF EXISTS Member;
DROP TABLE IF EXISTS Genre;
DROP TABLE IF EXISTS Publisher;

PRAGMA foreign_keys = ON; 

---- Above is added so you can run this query however many times you want without having to delete tables manually

CREATE TABLE Publisher (
    publisher_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    address TEXT,
    phone TEXT,
    email TEXT
);

CREATE TABLE Genre (
    genre_id INTEGER PRIMARY KEY AUTOINCREMENT,
    genre_name TEXT NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE Member (
    member_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    phone TEXT,
    address TEXT,
    membership_date TEXT NOT NULL DEFAULT CURRENT_DATE,
    status TEXT NOT NULL DEFAULT 'active' CHECK(status IN ('active', 'suspended'))
);

CREATE TABLE Author (
    author_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    birth_year INTEGER,
    nationality TEXT DEFAULT 'Unknown'
);

CREATE TABLE Book (
    book_id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    isbn TEXT NOT NULL UNIQUE,
    publisher_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,
    publication_year INTEGER NOT NULL CHECK(publication_year > 1400),
    total_copies INTEGER NOT NULL DEFAULT 1,
    available_copies INTEGER NOT NULL,
    FOREIGN KEY (publisher_id) REFERENCES Publisher(publisher_id) 
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (genre_id) REFERENCES Genre(genre_id) 
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CHECK(available_copies <= total_copies)
);

CREATE TABLE BookAuthor (
    book_id INTEGER NOT NULL,
    author_id INTEGER NOT NULL,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id) 
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (author_id) REFERENCES Author(author_id) 
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Loan (
    loan_id INTEGER PRIMARY KEY AUTOINCREMENT,
    book_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    loan_date TEXT NOT NULL DEFAULT CURRENT_DATE,
    due_date TEXT NOT NULL,
    return_date TEXT,
    status TEXT NOT NULL DEFAULT 'active',
    FOREIGN KEY (book_id) REFERENCES Book(book_id) 
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (member_id) REFERENCES Member(member_id) 
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CHECK(return_date IS NULL OR return_date >= loan_date)
);

CREATE TABLE Fine (
    fine_id INTEGER PRIMARY KEY AUTOINCREMENT,
    loan_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    fine_amount REAL NOT NULL DEFAULT 0.00 CHECK(fine_amount >= 0),
    paid_date TEXT,
    reason TEXT NOT NULL DEFAULT 'Late return',
    FOREIGN KEY (loan_id) REFERENCES Loan(loan_id) 
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES Member(member_id) 
        ON UPDATE CASCADE ON DELETE CASCADE
);

--- Insert ---
INSERT INTO Publisher (name, address, phone, email) VALUES
('Penguin Random House', 'New York, NY', '212-555-1234', 'contact@penguin.com'),
('HarperCollins', 'New York, NY', '212-555-5678', 'info@harpercollins.com'),
('Simon & Schuster', 'New York, NY', '212-555-9012', 'hello@simonandschuster.com'),
('Hachette Book Group', 'New York, NY', '212-555-3456', 'support@hachette.com'),
('Macmillan Publishers', 'New York, NY', '212-555-7890', 'info@macmillan.com'),
('Oxford University Press', 'Oxford, UK', '44-1865-5567', 'info@oup.com'),
('Scholastic', 'New York, NY', '212-555-2233', 'press@scholastic.com'),
('Pearson Education', 'London, UK', '44-20-7010', 'contact@pearson.com'),
('Bloomsbury', 'London, UK', '44-20-7631', 'hello@bloomsbury.com'),
('W. W. Norton', 'New York, NY', '212-555-4499', 'support@wwnorton.com');

INSERT INTO Genre (genre_name, description) VALUES
('Fiction', 'Literary works based on imaginary events and characters'),
('Non-Fiction', 'Writing based on facts, real events, and information'),
('Science Fiction', 'Fiction exploring theoretical scientific and technological concepts'),
('Mystery', 'Fiction focused on the investigation and solution of a crime'),
('Biography', 'Detailed account of a person''s life written by another'),
('History', 'Study and record of past events, societies, and cultures'),
('Technology', 'Books focused on applied science, engineering, and computing'),
('Fantasy', 'Fiction set in imaginary worlds with magical elements and themes'),
('Self-Help', 'Books aimed at personal development & self-guided improvement'),
('Poetry', 'Literary writing emphasizing aesthetic and rhythmic language');

INSERT INTO Member (first_name, last_name, email, phone, address, membership_date, status) VALUES
('John', 'Smith', 'john.smith@email.com', '555-0101', '123 Main St', '2024-01-15', 'active'),
('Emma', 'Johnson', 'emma.j@email.com', '555-0102', '456 Oak Ave', '2024-02-20', 'active'),
('Michael', 'Brown', 'michael.b@email.com', '555-0103', '789 Pine Rd', '2024-03-10', 'active'),
('Sarah', 'Davis', 'sarah.d@email.com', '555-0104', '321 Elm St', '2024-01-05', 'suspended'),
('James', 'Wilson', 'james.w@email.com', '555-0105', '654 Maple Dr', '2024-04-12', 'active'),
('Robert', 'Miller', 'robert.m@email.com', '555-0106', '741 Spruce Ln', '2024-05-01', 'active'),
('Linda', 'Garcia', 'linda.g@email.com', '555-0107', '852 Cedar Ct', '2024-05-15', 'active'),
('William', 'Martinez', 'will.m@email.com', '555-0108', '963 Birch Blvd', '2024-06-10', 'active'),
('Elizabeth', 'Taylor', 'liz.t@email.com', '555-0109', '159 Willow Way', '2024-07-22', 'active'),
('David', 'Anderson', 'dave.a@email.com', '555-0110', '357 Aspen Cir', '2024-08-05', 'active');

INSERT INTO Author (first_name, last_name, birth_year, nationality) VALUES
('George', 'Orwell', 1903, 'British'),
('Jane', 'Austen', 1775, 'British'),
('Ernest', 'Hemingway', 1899, 'American'),
('Toni', 'Morrison', 1931, 'American'),
('Gabriel', 'Garcia', 1927, 'Colombian'),
('J.K.', 'Rowling', 1965, 'British'),
('Stephen', 'King', 1947, 'American'),
('Haruki', 'Murakami', 1949, 'Japanese'),
('Agatha', 'Christie', 1890, 'British'),
('Isaac', 'Asimov', 1920, 'Russian-American');

INSERT INTO Book (title, isbn, publisher_id, genre_id, publication_year, total_copies, available_copies) VALUES
('1984', '9780451524935', 1, 1, 1949, 5, 5),
('Pride and Prejudice', '9780141439518', 2, 1, 1813, 3, 2),
('The Old Man and the Sea', '9780684830490', 3, 1, 1952, 2, 2),
('Beloved', '9781400033416', 4, 1, 1987, 3, 3),
('One Hundred Years of Solitude', '9780060883287', 5, 1, 1967, 4, 4),
('Harry Potter and the Philosopher''s Stone', '9780439708180', 7, 8, 1997, 10, 8),
('The Shining', '9780307743657', 1, 4, 1977, 4, 3),
('Norwegian Wood', '9780375704970', 3, 1, 1987, 3, 3),
('Murder on the Orient Express', '9780007119318', 9, 4, 1934, 5, 4),
('Foundation', '9780553293357', 1, 3, 1951, 2, 1);

INSERT INTO BookAuthor (book_id, author_id) VALUES
(1, 1), -- 1984 by Orwell
(2, 2), -- Pride and Prejudice by Austen
(3, 3), -- Old Man and Sea by Hemingway
(4, 4), -- Beloved by Morrison
(5, 5), -- One Hundred Years by Garcia
(6, 6), -- Harry Potter by Rowling
(7, 7), -- The Shining by King
(8, 8), -- Norwegian Wood by Murakami
(9, 9), -- Murder on Orient Express by Christie
(10, 10); -- Foundation by Asimov

INSERT INTO Loan (book_id, member_id, loan_date, due_date, return_date, status) VALUES
(2, 1, '2026-01-15', '2026-01-29', '2026-01-28', 'returned'),
(1, 2, '2026-01-20', '2026-02-03', NULL, 'active'),
(3, 3, '2026-01-22', '2026-02-05', '2026-02-04', 'returned'),
(4, 1, '2026-01-25', '2026-02-08', NULL, 'active'),
(5, 4, '2026-01-28', '2026-02-11', '2026-02-10', 'returned'),
(6, 5, '2026-01-30', '2026-02-13', NULL, 'active'),
(7, 6, '2026-02-01', '2026-02-15', '2026-02-14', 'returned'),
(8, 7, '2026-02-03', '2026-02-17', NULL, 'active'),
(10, 8, '2026-02-05', '2026-02-19', NULL, 'active'),
(9, 9, '2026-02-08', '2026-02-22', NULL, 'active'),
(2, 2, '2026-02-10', '2026-02-24', NULL, 'active'),
(1, 3, '2026-02-12', '2026-02-26', NULL, 'active'),
(3, 5, '2026-02-13', '2026-02-27', NULL, 'active');

INSERT INTO Fine (loan_id, member_id, fine_amount, paid_date, reason) VALUES
(5, 4, 2.50, '2025-02-10', 'Late return'),
(3, 3, 0.00, NULL, 'No fine - returned on time'),
(2, 2, 1.50, NULL, 'Late return'),
(7, 6, 5.00, '2025-01-26', 'Late return (6 days)'),
(6, 5, 0.00, NULL, 'No fine'),
(8, 7, 0.00, NULL, 'No fine'),
(9, 9, 0.00, NULL, 'No fine'),
(10, 8, 0.00, NULL, 'No fine'),
(1, 1, 0.00, NULL, 'Returned on time - no fine'),
(4, 1, 0.00, NULL, 'Active loan - no fine yet');