CREATE OR REPLACE VIEW employee_titles AS
  SELECT e.emp_no, e.first_name, e.last_name, e.middle_name, t.title, t.from_date, t.to_date 
    FROM employees e
    LEFT JOIN titles t ON e.emp_no = t.emp_no
  WHERE to_date > CURRENT_DATE()
