--List each employee first name, last name and supervisor status along with their department name. Order by department name, then by employee last name, and finally by employee first name.

SELECT e.Id, e.FirstName, e.LastName, e.IsSupervisor, d.Name as DepartmentName
FROM Employee e Left JOIN Department d on e.DepartmentId = d.Id
ORDER BY DepartmentName, e.LastName, e.FirstName

--List each department ordered by budget amount with the highest first.

SELECT Name as DepartmentName, Budget
FROM Department
ORDER BY Budget DESC

--List each department name along with any employees (full name) in that department who are supervisors.
SELECT d.name as DepartmentName, e.FirstName + ' ' + e.LastName as FullName_Supervisor, e.DepartmentId
FROM Employee e LEFT JOIN Department d on e.DepartmentId = d.Id
WHERE e.IsSupervisor = 1

--List each department name along with a count of employees in each department.
SELECT e.DepartmentId, d.Name as DepartmentName,
COUNT(*) as TotalEmployees
FROM Employee e INNER JOIN Department d on e.DepartmentId = d.Id
GROUP BY e.DepartmentId, Name

--Write a single update statement to increase each department's budget by 20%.

update Department
set Budget = Budget * 1.2
SELECT * from Department

--List the employee full names for employees who are not signed up for any training programs.
SELECT e.FirstName + ' ' + e.LastName as Employees_Not_In_Training
FROM Employee e LEFT JOIN EmployeeTraining et on et.EmployeeId = e.Id
WHERE NOT EXISTS(SELECT 1 FROM Employee WHERE et.EmployeeId = e.Id)

--List the employee full names for employees who are signed up for at least one training program and include the number of training programs they are signed up for.
SELECT e.FirstName + ' ' + e.LastName as Employees_In_Training,
COUNT(*) as NumberOfPrograms
FROM Employee e LEFT JOIN EmployeeTraining et on et.EmployeeId = e.Id
WHERE EXISTS(SELECT 1 FROM Employee WHERE et.EmployeeId = e.Id)
GROUP BY e.Id, e.FirstName + ' ' + e.LastName

--List all training programs along with the count employees who have signed up for each.
SELECT tp.Name as TrainingProgram_Name, COUNT(et.Id) NumberOfAttendees
FROM EmployeeTraining et LEFT JOIN TrainingProgram tp ON et.TrainingProgramId = tp.Id
						GROUP BY tp.Name

--List all training programs who have no more seats available.
SELECT tp.Name as TrainingProgram_Not_At_Capacity, COUNT(et.Id) NumberOfAttendees
FROM EmployeeTraining et LEFT JOIN TrainingProgram tp ON et.TrainingProgramId = tp.Id
GROUP BY tp.Name, tp.MaxAttendees
HAVING(Count(*) = tp.MaxAttendees)

--List all future training programs ordered by start date with the earliest date first.
SELECT Name, StartDate 
FROM TrainingProgram
WHERE StartDate > GetDate()

--Assign a few employees to training programs of your choice.
INSERT INTO EmployeeTraining (EmployeeId, TrainingProgramId) VALUES (6, 3);
INSERT INTO EmployeeTraining (EmployeeId, TrainingProgramId) VALUES (15, 5);

INSERT INTO EmployeeTraining (EmployeeId, TrainingProgramId) VALUES (1, 12);
INSERT INTO EmployeeTraining (EmployeeId, TrainingProgramId) VALUES (2, 12);
INSERT INTO EmployeeTraining (EmployeeId, TrainingProgramId) VALUES (3, 12);
INSERT INTO EmployeeTraining (EmployeeId, TrainingProgramId) VALUES (4, 12);


--List the top 3 most popular training programs. (For this question, consider each record in the training program table to be a UNIQUE training program).
SELECT TOP 3 tp.Id, COUNT(et.Id) NumberOfAttendees
FROM EmployeeTraining et INNER JOIN TrainingProgram tp ON et.TrainingProgramId = tp.Id
						GROUP BY tp.Id
						ORDER BY COUNT(8) DESC


--List the top 3 most popular training programs. (For this question consider training programs with the same name to be the SAME training program).
SELECT TOP 3 tp.Name as TrainingProgram_Name, COUNT(et.Id) NumberOfAttendees
FROM EmployeeTraining et LEFT JOIN TrainingProgram tp ON et.TrainingProgramId = tp.Id
						GROUP BY tp.Name
						ORDER BY COUNT(*) DESC






