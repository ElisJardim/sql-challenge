# sql-challenge

## Background

It’s been two weeks since I was hired as a new data engineer at Pewlett Hackard (a fictional company). My first major task is to do a research project about people whom the company employed during the 1980s and 1990s. All that remains of the employee database from that period are six CSV files.

For this project, I’ll design the tables to hold the data from the CSV files, import the CSV files into a SQL database, and then answer questions about the data. I will be using:

* Data Modeling
* Data Engineering
* Data Analysis

## Data Modeling

After I inspected the CSV files, and I have created an Entity Relationship Diagram of the tables using QuickDBD.

NOTE: I have removed all quotes from object names. QuickDBD has enclosed all object names with quotes, which was not necessary. 

![SQL challenge ERD](./images/quickdbd_sql_challenge.png)

## Data Engineering

I have created a table schema for each of the 6 CSV files with specific data types, primary keys, foreign keys, and constraints.

<details open>
<summary>Create table scripts:</summary>

```sql
CREATE TABLE Titles (
    title_id varchar(5)   NOT NULL,
    title varchar(25)   NOT NULL,
    CONSTRAINT pk_Titles PRIMARY KEY (
        title_id
     )
);

CREATE TABLE Employee (
    emp_no int   NOT NULL,
    emp_title_id varchar(5)   NOT NULL,
    birth_date date   NOT NULL,
    first_name varchar(50)   NOT NULL,
    last_name varchar(50)   NOT NULL,
    sex varchar(1)   NOT NULL,
    hire_date date   NOT NULL,
    CONSTRAINT pk_Employee PRIMARY KEY (
        emp_no
     )
);

CREATE TABLE Dept_Manager (
    dept_no varchar(5)   NOT NULL,
    emp_no int   NOT NULL,
    CONSTRAINT pk_Dept_Manager PRIMARY KEY (
        dept_no,emp_no
     )
);

CREATE TABLE Dept_Emp (
    emp_no int   NOT NULL,
    dept_no varchar(5)   NOT NULL,
    CONSTRAINT pk_Dept_Emp PRIMARY KEY (
        emp_no,dept_no
     )
);

CREATE TABLE Salaries (
    emp_no int   NOT NULL,
    salary int   NOT NULL,
    CONSTRAINT pk_Salaries PRIMARY KEY (
        emp_no
     )
);

CREATE TABLE Departments (
    dept_no varchar(5)   NOT NULL,
    dept_name varchar(30)   NOT NULL,
    CONSTRAINT pk_Departments PRIMARY KEY (
        dept_no
     )
);
```

<br>
</details>

<details open>
<summary>Add foreign key constraints to the tables:</summary>

```sql
ALTER TABLE Employee ADD CONSTRAINT fk_Employee_emp_title_id FOREIGN KEY(emp_title_id)
REFERENCES Titles (title_id);

ALTER TABLE Dept_Manager ADD CONSTRAINT fk_Dept_Manager_dept_no FOREIGN KEY(dept_no)
REFERENCES Departments (dept_no);

ALTER TABLE Dept_Manager ADD CONSTRAINT fk_Dept_Manager_emp_no FOREIGN KEY(emp_no)
REFERENCES Employee (emp_no);

ALTER TABLE Dept_Emp ADD CONSTRAINT fk_Dept_Emp_emp_no FOREIGN KEY(emp_no)
REFERENCES Employee (emp_no);

ALTER TABLE Dept_Emp ADD CONSTRAINT fk_Dept_Emp_dept_no FOREIGN KEY(dept_no)
REFERENCES Departments (dept_no);

ALTER TABLE Salaries ADD CONSTRAINT fk_Salaries_emp_no FOREIGN KEY(emp_no)
REFERENCES Employee (emp_no);
```

<br>
</details>

## Data Analysis

1. List the employee number, last name, first name, sex, and salary of each employee.

    ```sql
    SELECT Employee.emp_no, last_name, first_name, sex, salary
    FROM Employee
    JOIN Salaries ON Employee.emp_no = Salaries.emp_no
    ORDER BY Employee.emp_no;
    ```

    Result sample (first 10 rows):

   | "emp_no" | "last_name" | "first_name" | "sex" | "salary" |
   | --- | --- | --- | --- | --- |
   | 10001 | "Facello" | "Georgi" | "M" | 60117 |
   | 10002 | "Simmel" | "Bezalel" | "F" | 65828 |
   | 10003 | "Bamford" | "Parto" | "M" | 40006 |
   | 10004 | "Koblick" | "Chirstian" | "M" | 40054 |
   | 10005 | "Maliniak" | "Kyoichi" | "M" | 78228 |
   | 10006 | "Preusig" | "Anneke" | "F" | 40000 |
   | 10007 | "Zielinski" | "Tzvetan" | "F" | 56724 |
   | 10008 | "Kalloufi" | "Saniya" | "M" | 46671 |
   | 10009 | "Peac" | "Sumant" | "F" | 60929 |
   | 10010 | "Piveteau" | "Duangkaew" | "F" | 72488 |

2. List the first name, last name, and hire date for the employees who were hired in 1986.

    ```sql
    SELECT first_name, last_name, hire_date 
    FROM Employee
    WHERE hire_date BETWEEN '1986-1-1' and '1986-12-31'
    ORDER BY hire_date ASC;
    ```

    Result sample (first 10 rows):

   | "first_name" | "last_name" | "hire_date" |
   | --- | --- | --- |
   | "Jiann" | "Bondorf" | "1986-01-01" |
   | "Holgard" | "Prenel" | "1986-01-01" |
   | "Hercules" | "Veevers" | "1986-01-01" |
   | "Achilleas" | "Kroft" | "1986-01-01" |
   | "Unal" | "Cooley" | "1986-01-01" |
   | "Chaoyi" | "Kaiserswerth" | "1986-01-01" |
   | "Bedir" | "Vanwelkenhuysen" | "1986-01-01" |
   | "Nirmal" | "Comyn" | "1986-01-01" |
   | "Mario" | "Schrift" | "1986-01-01" |
   | "Subir" | "Shumilov" | "1986-01-01" |

3. List the manager of each department along with their department number, department name, employee number, last name, and first name.

    ```sql
    SELECT Departments.dept_no, dept_name, Employee.emp_no, last_name, first_name
    FROM Dept_Manager
    JOIN Employee ON  Dept_Manager.emp_no = Employee.emp_no
    JOIN Departments ON Dept_Manager.dept_no = Departments.dept_no
    ORDER BY dept_name ASC;
    ```

    Result sample (first 10 rows):
 
   | "dept_no" | "dept_name" | "emp_no" | "last_name" | "first_name" |
   | --- | --- | --- | --- | --- |
   | "d009" | "Customer Service" | 111877 | "Spinelli" | "Xiaobin" |
   | "d009" | "Customer Service" | 111939 | "Weedman" | "Yuchang" |
   | "d009" | "Customer Service" | 111692 | "Butterworth" | "Tonny" |
   | "d009" | "Customer Service" | 111784 | "Giarratana" | "Marjo" |
   | "d005" | "Development" | 110511 | "Hagimont" | "DeForest" |
   | "d005" | "Development" | 110567 | "DasSarma" | "Leon" |
   | "d002" | "Finance" | 110114 | "Legleitner" | "Isamu" |
   | "d002" | "Finance" | 110085 | "Alpin" | "Ebru" |
   | "d003" | "Human Resources" | 110228 | "Sigstam" | "Karsten" |
   | "d003" | "Human Resources" | 110183 | "Ossenbruggen" | "Shirish" |

4. List the department number for each employee along with that employee’s employee number, last name, first name, and department name.

    ```sql
    SELECT Departments.dept_no,Employee.emp_no, last_name, first_name, Departments.dept_name
    FROM Employee 
    JOIN Dept_Emp ON Employee.emp_no = Dept_Emp.emp_no
    JOIN Departments ON Dept_Emp.dept_no = Departments.dept_no
    ORDER BY dept_name ASC;
    ```

    Result sample (first 10 rows):
  
    | "dept_no" | "emp_no" | "last_name" | "first_name" | "dept_name" |
    | --- | --- | --- | --- | --- |
    | "d009" | 218338 | "Borstler" | "Dines" | "Customer Service" |
    | "d009" | 459654 | "Besancenot" | "Aram" | "Customer Service" |
    | "d009" | 414161 | "Mahnke" | "Udo" | "Customer Service" |
    | "d009" | 262121 | "Schahn" | "Rafael" | "Customer Service" |
    | "d009" | 94631 | "Haddadi" | "Fusako" | "Customer Service" |
    | "d009" | 262129 | "Schnabel" | "Moon" | "Customer Service" |
    | "d009" | 19513 | "Siepmann" | "Rosalyn" | "Customer Service" |
    | "d009" | 270725 | "Garigliano" | "Wuxu" | "Customer Service" |
    | "d009" | 19531 | "Picel" | "Phillip" | "Customer Service" |
    | "d009" | 73743 | "Bernardeschi" | "Anneke" | "Customer Service" |

5. List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.

    ```sql
    SELECT first_name, last_name, sex
    FROM Employee 
    WHERE first_name = 'Hercules' AND last_name LIKE 'B%'
    ORDER BY last_name ASC;
    ```

    Result sample (first 10 rows):

    | "first_name" | "last_name" | "sex" |
    | --- | --- | --- |
    | "Hercules" | "Baak" | "M" |
    | "Hercules" | "Baer" | "M" |
    | "Hercules" | "Bahr" | "M" |
    | "Hercules" | "Bail" | "F" |
    | "Hercules" | "Bain" | "F" |
    | "Hercules" | "Baranowski" | "M" |
    | "Hercules" | "Barreiro" | "M" |
    | "Hercules" | "Basagni" | "M" |
    | "Hercules" | "Benantar" | "F" |
    | "Hercules" | "Benzmuller" | "M" |

6. List each employee in the Sales department, including their employee number, last name, and first name.

    ```sql
    SELECT Employee.emp_no, last_name, first_name
    FROM Employee 
    JOIN Dept_Emp ON Dept_Emp.emp_no = Employee.emp_no
    JOIN Departments ON Departments.dept_no = Dept_Emp.dept_no
    WHERE dept_name = 'Sales'
    ORDER BY last_name ASC;
    ```

    Result sample (first 10 rows):

    | "emp_no" | "last_name" | "first_name" |
    | --- | --- | --- |
    | 240207 | "Aamodt" | "Jiann" |
    | 67277 | "Aamodt" | "Teiji" |
    | 417814 | "Aamodt" | "Yechiam" |
    | 283857 | "Aamodt" | "Weiru" |
    | 233941 | "Aamodt" | "Hairong" |
    | 43174 | "Aamodt" | "Mariusz" |
    | 265157 | "Aamodt" | "Narain" |
    | 251782 | "Aamodt" | "Somnath" |
    | 280448 | "Aamodt" | "Theron" |
    | 271789 | "Aamodt" | "Valeri" |

7. List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.

    ```sql
    SELECT Employee.emp_no, last_name, first_name, dept_name
    FROM Employee 
    JOIN Dept_Emp ON Dept_Emp.emp_no = Employee.emp_no
    JOIN Departments ON Departments.dept_no = Dept_Emp.dept_no
    WHERE dept_name = 'Sales' OR dept_name = 'Development'
    ORDER BY dept_name ASC;
    ```

    Result sample (first 10 rows):

    | "emp_no" | "last_name" | "first_name" | "dept_name" |
    | --- | --- | --- | --- |
    | 41021 | "Uhrig" | "Narain" | "Development" |
    | 62095 | "Erva" | "Katsuyuki" | "Development" |
    | 62097 | "Klyachko" | "Krassimir" | "Development" |
    | 62099 | "Piazza" | "Mircea" | "Development" |
    | 62102 | "Waterhouse" | "Aleksandar" | "Development" |
    | 62104 | "Sudkamp" | "Kazuhide" | "Development" |
    | 62109 | "Chappelet" | "Hatim" | "Development" |
    | 62110 | "Lubachevsky" | "Rajmohan" | "Development" |
    | 62111 | "Molenkamp" | "Guangming" | "Development" |
    | 62112 | "Servieres" | "Pragnesh" | "Development" |

8. List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).

    ```sql
    SELECT Employee.last_name, COUNT(*) AS freq_count
    FROM Employee 
    GROUP BY last_name
    ORDER BY freq_count DESC;
    ```

    Result sample (first 10 rows):

    | "last_name" | "freq_count" |
    | --- | --- |
    | "Baba" | 226 |
    | "Gelosh" | 223 |
    | "Coorg" | 223 |
    | "Farris" | 222 |
    | "Sudbeck" | 222 |
    | "Adachi" | 221 |
    | "Osgood" | 220 |
    | "Masada" | 218 |
    | "Neiman" | 218 |
    | "Mandell" | 218 |

## Bonus

Import the SQL database into Pandas and create a visualization of the data:

* Create a visualization of the salary ranges for employees.

![Bonus](./images/salaries.png)
