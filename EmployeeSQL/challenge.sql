DROP TABLE IF EXISTS department CASCADE;
DROP TABLE IF EXISTS title CASCADE;
DROP TABLE IF EXISTS employee CASCADE;
DROP TABLE IF EXISTS dept_emp CASCADE;
DROP TABLE IF EXISTS dept_manager CASCADE;
DROP TABLE IF EXISTS salary CASCADE;

CREATE TABLE department (
	dept_no VARCHAR(30) NOT NULL,
	PRIMARY KEY (dept_no),
	dept_name VARCHAR(50) NOT NULL
);

CREATE TABLE title (
	title_id VARCHAR(30) NOT NULL,
	PRIMARY KEY (title_id),
	title VARCHAR(100) NOT NULL
);

CREATE TABLE employee (
	emp_no INT NOT NULL,
	PRIMARY KEY (emp_no),
	emp_title_id VARCHAR(30) NOT NULL,
	FOREIGN KEY (emp_title_id) REFERENCES title(title_id),
	birth_date DATE,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	sex VARCHAR(10),
	hire_date DATE
);

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employee(emp_no),
	dept_no VARCHAR(30) NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES department(dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(30) NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES department(dept_no),
	emp_no INT NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employee(emp_no),
	PRIMARY KEY (dept_no, emp_no)
);

CREATE TABLE salary (
	emp_no INT NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employee(emp_no),
	PRIMARY KEY (emp_no),
	salary INT NOT NULL
);

--IMPORTANT NOTE: Import data from CSVs provided before moving on!!

-- List the employee number, last name, first name, sex, and salary of each employee.
SELECT e.emp_no, last_name, first_name, sex, salary
FROM employee e
JOIN salary s
ON e.emp_no = s.emp_no;

-- List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT first_name, last_name, hire_date
FROM employee
WHERE DATE_PART('Year', hire_date) = 1986;

-- List the manager of each department along with their department number, department name, employee number, last name, and first name.
SELECT d.dept_no, d.dept_name, e.first_name, e.last_name, e.emp_no
FROM department d
JOIN dept_manager dm
	ON d.dept_no = dm.dept_no
JOIN employee e
	ON e.emp_no = dm.emp_no;

-- List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
SELECT d.dept_no, d.dept_name, e.emp_no, e.last_name, e.first_name
FROM employee e
JOIN dept_emp de
	ON e.emp_no=de.emp_no
JOIN department d
	ON d.dept_no=de.dept_no
ORDER BY 1;

-- List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT first_name, last_name, sex
FROM employee
WHERE first_name = 'Hercules' AND last_name like 'B%';

-- List each employee in the Sales department, including their employee number, last name, and first name.
SELECT emp_no, last_name, first_name FROM employee
WHERE emp_no IN (
	SELECT emp_no FROM dept_emp
	WHERE dept_no IN (
		SELECT dept_no FROM department
		WHERE dept_name = 'Sales'
	)
);

-- List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT e.emp_no, last_name, first_name, d.dept_name
FROM employee e
JOIN dept_emp de
	ON e.emp_no = de.emp_no
JOIN department d
	ON d.dept_no = de.dept_no
WHERE dept_name in ('Sales', 'Development')
ORDER BY d.dept_name;

-- List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT last_name, COUNT(1)
FROM employee
GROUP BY last_name
ORDER BY 2 DESC;