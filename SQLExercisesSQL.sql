--List each employee first name, last name and supervisor status along with their department name. Order by department name, then by employee last name, and finally by employee first name.

SELECT e.Id, e.FirstName, e.LastName, e.IsSupervisor, d.Name as DepartmentName
FROM Employee e Left JOIN Department d on e.DepartmentId = d.Id
ORDER BY DepartmentName, e.LastName, e.FirstName

--List each department ordered by budget amount with the highest first.

SELECT Name as DepartmentName, Budget
FROM Department
ORDER BY Budget DESC

--List each department name along with any employees (full name) in that department who are supervisors.
SELECT d.name as DepartmentName, e.FirstName + ' ' + e.LastName as Supervisor, e.DepartmentId
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
SELECT TOP 3 tp.Id, tp.Name, COUNT(et.Id) NumberOfAttendees
FROM EmployeeTraining et INNER JOIN TrainingProgram tp ON et.TrainingProgramId = tp.Id
						GROUP BY tp.Id, tp.Name
						ORDER BY COUNT(*) DESC


--List the top 3 most popular training programs. (For this question consider training programs with the same name to be the SAME training program).
SELECT TOP 3 tp.Name as TrainingProgram_Name, COUNT(et.Id) NumberOfAttendees
FROM EmployeeTraining et LEFT JOIN TrainingProgram tp ON et.TrainingProgramId = tp.Id
						GROUP BY tp.Name
						ORDER BY COUNT(*) DESC

--List all employees who do not have computers.
SELECT e.Id, e.FirstName, e.LastName
FROM Employee e LEFT JOIN ComputerEmployee ce ON e.Id = ce.EmployeeId
WHERE NOT EXISTS(SELECT ce.EmployeeId FROM ComputerEmployee ce WHERE e.Id = ce.EmployeeId)

--select ce.EmployeeId
--from ComputerEmployee ce
--where ce.UnassignDate is not null
--and ce.EmployeeId not in (

--select ce.EmployeeId
--from ComputerEmployee ce
--where ce.UnassignDate is null)

--select * from ComputerEmployee where employeeid = 1;

--List all employees along with their current computer information make and manufacturer combined into a field entitled ComputerInfo. If they do not have a computer, this field should say "N/A".
SELECT e.Id, e.FirstName, e.LastName, CONCAT(ISNULL(c.Manufacturer, 'N/A'), ' ', ISNULL(c.Make, '')) as ComputerInfo
FROM Employee e LEFT JOIN ComputerEmployee ce ON e.Id = ce.EmployeeId and ce.UnassignDate is null
LEFT JOIN Computer c ON ce.ComputerId = c.Id

--List all computers that were purchased before July 2019 that are have not been decommissioned.
SELECT c.Id, c.Manufacturer, c.Make, C.PurchaseDate, c.DecomissionDate 
FROM Computer c WHERE c.PurchaseDate < '2019-07-01' AND c.DecomissionDate IS NULL;

--List all employees along with the total number of computers they have ever had.
SELECT e.Id, e.FirstName, e.LastName, COUNT(*) as NumberOfComputers
FROM Employee e INNER JOIN ComputerEmployee ce on ce.EmployeeId = e.Id
GROUP BY e.Id, e.FirstName, e.LastName

--List the number of customers using each payment type
SELECT pt.Name as PaymentType, COUNT(*) as NumberOfCustomers
FROM PaymentType pt LEFT JOIN Customer c on pt.CustomerId = c.Id
GROUP BY pt.Name

--List the 10 most expensive products and the names of the seller
SELECT TOP 10 p.Id, p.Title as ProductTitle, p.Price, p.Description, c.Id, c.FirstName + ' ' + c.LastName as Seller
FROM Product p LEFT JOIN Customer c ON p.CustomerId = c.Id
ORDER BY p.Price DESC

--List the 10 most purchased products and the names of the seller
SELECT TOP 10 p.Id, p.Title, p.Price, p.Description, c.FirstName + ' ' + c.LastName as Seller, COUNT(*) as NumberSold
FROM OrderProduct op LEFT JOIN Product p ON p.Id = op.ProductId LEFT JOIN Customer c on p.CustomerId = c.Id
GROUP BY p.Id, p.Price, p.Title, p.Description, c.FirstName, c.LastName
ORDER BY NumberSold DESC

--Find the name of the customer who has made the most purchases
SELECT TOP 1 WITH TIES c.FirstName + ' ' + c.LastName as Customer, COUNT(o.CustomerId) as OrdersPlaced
FROM CUSTOMER c LEFT JOIN [Order] o ON o.CustomerId = c.Id

GROUP BY c.FirstName, c.LastName
ORDER BY NumberOfPurchases DESC

--List the amount of total sales by product type
SELECT pt.Id, pt.Name as ProductType, SUM(p.Price) as Price
FROM ProductType pt LEFT JOIN Product p on p.ProductTypeId = pt.Id
GROUP BY pt.Id, pt.Name
ORDER BY pt.Id

--List the total amount made from all sellers
SELECT c.Id, c.FirstName + ' ' + c.LastName as Seller, SUM(p.Price) as TotalSales
FROM Customer c INNER JOIN Product p on p.CustomerId = c.Id INNER JOIN OrderProduct op on op.ProductId = p.Id
GROUP BY c.id, c.FirstName, C.LastName
ORDER BY SUM(p.Price) DESC
