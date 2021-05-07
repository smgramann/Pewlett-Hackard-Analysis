
--Create retirement_titles table
SELECT ce.emp_no, ce.first_name, ce.last_name, ti.title, ti.from_date, ti.to_date
INTO retirement_titles
FROM employees AS ce
INNER JOIN titles AS ti
ON (ce.emp_no = ti.emp_no)
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY ce.emp_no;

Select * FROM retirement_titles;

-- Use Dictinct with Orderby to remove duplicate rows to create unique_titles table
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title

INTO unique_titles
FROM retirement_titles 
ORDER BY emp_no, to_date DESC;

SELECT * FROM unique_titles;

-- Create retiring_titles table
SELECT Count(ut.title), ut.title 
INTO retiring_titles 
FROM unique_titles AS ut
GROUP BY ut.title
ORDER By count DESC;

SELECT * FROM retiring_titles;

--Create mentorship_eligibility tabe
SELECT DISTINCT ON (e.emp_no) e.emp_no, e.first_name, e.last_name, e.birth_date, de.from_date, de.to_date, ti.title
INTO mentorship_eligibility 
FROM employees AS e
	INNER JOIN dept_emp AS de
		ON (e.emp_no = de.emp_no)
	INNER JOIN titles AS ti
		ON (e.emp_no = ti.emp_no)
WHERE birth_date BETWEEN '1965-01-01' AND '1965-12-31'
AND (de.to_date = '9999-01-01')
ORDER BY e.emp_no

Select * FROM mentorship_eligibility