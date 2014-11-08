ALTER TABLE employees CHANGE last_name surname VARCHAR(16);

ALTER VIEW employee_titles AS
  SELECT e.emp_no, e.first_name, e.surname, e.middle_name, t.title, t.from_date, t.to_date 
    FROM employees e
    LEFT JOIN titles t ON e.emp_no = t.emp_no
  WHERE to_date > CURRENT_DATE()
