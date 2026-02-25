# Library Management Database System

Relational database project for Basics of Database Systems

---

## Project Overview

This project implements a normalized relational database for a library management system using SQLite.

The system models:

- Books
- Authors (many-to-many relationship with books)
- Publishers
- Genres
- Members
- Loans
- Fines

---

## Files Included

```
create_insert.sql   - Database schema and sample data
queries.sql         - Required SQL queries
library.db          - SQLite database file
Report.pdf          - Project documentation
```

---

## Database Features

- Primary keys and foreign keys
- ON DELETE and ON UPDATE referential actions
- Many-to-many relationship using associative table (BookAuthor)
- 3NF normalized schema
- Aggregation queries with JOIN and GROUP BY
- Data integrity constraints (NOT NULL, DEFAULT, etc.)

---

## How to Use

Option 1:
1. Open SQLite (e.g., DB Browser for SQLite)
2. Execute `create_insert.sql`
3. Run queries from `queries.sql`

Option 2:
Open `library.db` directly and execute queries.

---

## Course Applied

- ER modeling
- Relational schema design
- Primary and foreign keys
- Normalization (1NF–3NF)
- JOIN operations
- Aggregation functions
- Referential integrity constraints