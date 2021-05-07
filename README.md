# Pewlett-Hackard Employee Retirement Analysis

### Purpose

Many current employees at Pewlett-Hackard are approaching retirement age.  To help address this future challenge, an analysis was conducted to identify the number of retiring employees by job title and identify other employees who are eligible for the mentorship program to fill the gaps in roles as retirement increases.

## Analysis

### Results

Four tables were created as a result of SQL queries to help provide more information and answer key questions about the ‘silver tsunami’ and a potential mentorship program.

1)	A retirement_titles table was first created to identify the employees and their titles who will likely retire in the near future.  The following code was utilized to a create the table which provided almost 134K records.  Employees who held multiple title over the course of their employment appeared multiple times in the data set, which needed to be addressed in the next step.

		SELECT ce.emp_no, ce.first_name, ce.last_name, ti.title, ti.from_date, ti.to_date	
		INTO retirement_titles
		FROM employees AS ce
		INNER JOIN titles AS ti
		ON (ce.emp_no = ti.emp_no)
		WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
		ORDER BY ce.emp_no;


[retirement_titles](https://user-images.githubusercontent.com/80165223/117493629-d74b5580-af38-11eb-8a4d-a756c3052b62.png)


2)	To address the issue of individuals appearing multiple in the retirement_titles table, the following code was written to identify each individual and their most current title.  This removed the duplicates and identified over 90K individuals that are likely to retire soon.

		SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, title
		INTO unique_titles
		FROM retirement_titles 
		ORDER BY emp_no, to_date DESC;


3)	A simple table was created to identify the job titles that will be most impacted by the ‘silver tsunami.’  The following code was written and summarized each title and the count of employees that hold that title who are likely to retire soon.

		SELECT Count(ut.title), ut.title 
		INTO retiring_titles 
		FROM unique_titles AS ut
		GROUP BY ut.title
		ORDER By count DESC;


[retiring_titles](https://user-images.githubusercontent.com/80165223/117493669-e4684480-af38-11eb-9421-24d86e4e7774.png)



4)	To identify employees who are likely eligible for mentorship to help fill employment gaps due to the ‘silver tsunami’ the following code was written, which identified approximately 1,500 individuals.

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

## Summary

A few conclusions and recommendations can be drawn from this analysis:
1)	When looking at employees born from 1952 through 1955, 90,398 roles will need to be filled due to upcoming retirements.  Over 50% of the retirements will affect Senior Engineer and Senior Staff titles.  To be better prepared through a mentorship program, it is recommended to expand the birth date in the query beyond a 3-year period and look at employees born up to 1960 who will be retiring in the near future.

		SELECT ce.emp_no, ce.first_name, ce.last_name, ti.title, ti.from_date, ti.to_date
		INTO retirement_titles
		FROM employees AS ce
		INNER JOIN titles AS ti
		ON (ce.emp_no = ti.emp_no)
		WHERE birth_date BETWEEN '1952-01-01' AND '1959-12-31'
		ORDER BY ce.emp_no;

2)	Assuming that those born in 1965 were identified through the query to be mentored by the outgoing/retiring employees (instructions unclear), there are many more soon-to-be retired employees than mentees (1,549 individuals) and many of the mentees are already in leadership positions.  See the table below.


[mentee_titles](https://user-images.githubusercontent.com/80165223/117493707-f5b15100-af38-11eb-8b0f-9cddb8ccf86c.png)



To have a more robust mentorship program that plans further into the future, it is recommended to modify the query and identify mentees born between 1965 and 1975 as displayed below.

		SELECT DISTINCT ON (e.emp_no) e.emp_no, e.first_name, e.last_name, e.birth_date, de.from_date, de.to_date, ti.title
		INTO mentorship_eligibility 
		FROM employees AS e
				INNER JOIN dept_emp AS de    
					ON (e.emp_no = de.emp_no)      
				INNER JOIN titles AS ti    
					ON (e.emp_no = ti.emp_no)      
		WHERE birth_date BETWEEN '1965-01-01' AND '1975-12-31'
		AND (de.to_date = '9999-01-01')
		ORDER BY e.emp_no
