	
-- List the employee number, last name, first name, sex, and salary of each employee.

    SELECT Employee.emp_no, last_name, first_name, sex, salary
    FROM Employee
    JOIN Salaries ON Employee.emp_no = Salaries.emp_no
    ORDER BY Employee.emp_no;

-- List the first name, last name, and hire date for the employees who were hired in 1986.

    SELECT first_name, last_name, hire_date 
    FROM Employee
    WHERE hire_date BETWEEN '1986-1-1' and '1986-12-31'
    ORDER BY hire_date ASC;

-- List the manager of each department along with their department number, department name, employee number, last name, and first name.

    SELECT Departments.dept_no, dept_name, Employee.emp_no, last_name, first_name
    FROM Dept_Manager
    JOIN Employee ON  Dept_Manager.emp_no = Employee.emp_no
    JOIN Departments ON Dept_Manager.dept_no = Departments.dept_no
    ORDER BY dept_name ASC;

-- List the department number for each employee along with that employee’s employee number, last name, first name, and department name.

    SELECT Departments.dept_no,Employee.emp_no, last_name, first_name, Departments.dept_name
    FROM Employee 
    JOIN Dept_Emp ON Employee.emp_no = Dept_Emp.emp_no
    JOIN Departments ON Dept_Emp.dept_no = Departments.dept_no
    ORDER BY dept_name ASC;

-- List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.

    SELECT first_name, last_name, sex
    FROM Employee 
    WHERE first_name = 'Hercules' AND last_name LIKE 'B%'
    ORDER BY last_name ASC;

-- List each employee in the Sales department, including their employee number, last name, and first name.

    SELECT Employee.emp_no, last_name, first_name
    FROM Employee 
    JOIN Dept_Emp ON Dept_Emp.emp_no = Employee.emp_no
    JOIN Departments ON Departments.dept_no = Dept_Emp.dept_no
    WHERE dept_name = 'Sales'
    ORDER BY last_name ASC;

-- List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.

    SELECT Employee.emp_no, last_name, first_name, dept_name
    FROM Employee 
    JOIN Dept_Emp ON Dept_Emp.emp_no = Employee.emp_no
    JOIN Departments ON Departments.dept_no = Dept_Emp.dept_no
    WHERE dept_name = 'Sales' OR dept_name = 'Development'
    ORDER BY dept_name ASC;

-- List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name)

    SELECT Employee.last_name, COUNT(*) AS freq_count
    FROM Employee 
    GROUP BY last_name
    ORDER BY freq_count DESC;
