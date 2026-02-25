-- Query 1: List all books currently checked out by a specific member
SELECT Member.first_name || ' ' || Member.last_name AS 'Member Name',
       Book.title AS 'Title',
       Loan.loan_date AS 'Date Loaned',
       Loan.due_date AS 'Date Due'
FROM Loan
JOIN Member ON Loan.member_id = Member.member_id
JOIN Book ON Loan.book_id = Book.book_id
WHERE Member.member_id = 1 AND Loan.return_date IS NULL;

-- Query 2: Show all books by a certain author and their current availability
SELECT Author.first_name || ' ' || Author.last_name AS 'Author',
       Book.title AS 'Title',
       Book.available_copies AS 'Copies Available',
       Book.total_copies AS 'Total Copies'
FROM Author
JOIN BookAuthor ON Author.author_id = BookAuthor.author_id
JOIN Book ON BookAuthor.book_id = Book.book_id
WHERE Author.last_name = 'Orwell';

-- Query 3: Display overdue books with the member contact info and fines
SELECT Member.first_name || ' ' || Member.last_name AS 'Member Name',
       Member.email AS 'Email',
       Member.phone AS 'Phone Number',
       Book.title AS 'Title',
       Loan.due_date AS 'Date Due',
       Fine.fine_amount 'Fine Amount',
       Fine.paid_date AS 'Date Paid'
FROM Loan
JOIN Member ON Loan.member_id = Member.member_id
JOIN Book ON Loan.book_id = Book.book_id
LEFT JOIN Fine ON Loan.loan_id = Fine.loan_id
WHERE Loan.return_date IS NULL 
  AND Loan.due_date < CURRENT_DATE;

-- Query 4: List the most borrowed books in the last 30 days
SELECT Book.title AS 'Title',
       COUNT(Loan.loan_id) AS 'Times Borrowed'
FROM Book
JOIN Loan ON Book.book_id = Loan.book_id
WHERE Loan.loan_date >= DATE('now', '-30 days')
GROUP BY Book.book_id, Book.title
ORDER BY 'Times Borrowed' DESC;

-- Query 5: Show a members borrowing history, return dates, and fines paid (if any)
SELECT Member.first_name || ' ' || Member.last_name AS 'Member Name',
       Book.title AS 'Title',
       Loan.loan_date AS 'Date Loaned',
       Loan.return_date AS 'Date Returned',
       CASE 
           WHEN Loan.return_date IS NULL THEN 'Currently Borrowed'
           WHEN Loan.return_date > Loan.due_date THEN 'Returned Late'
           ELSE 'Returned On Time'
       END AS 'Status',
       COALESCE(Fine.fine_amount, 0) AS 'Fine Amount',
       Fine.paid_date AS 'Date Paid'
FROM Member
JOIN Loan ON Member.member_id = Loan.member_id
JOIN Book ON Loan.book_id = Book.book_id
LEFT JOIN Fine ON Loan.loan_id = Fine.loan_id
WHERE Member.member_id = 1
ORDER BY Loan.loan_date DESC;