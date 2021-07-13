USE [Human-Resources]
GO

-- Getting headcount of various segments of current employees at a fictitious company

/* How many employees are there currently at this company? 207 employees */
SELECT COUNT(EmpID) AS CurrentEmployees
FROM HRDataset
WHERE DateofTermination IS NULL
GO

/* Performance Score Headcount */
SELECT PerformanceScore, COUNT(EmpID) AS HeadCount
FROM HRDataset
WHERE DateofTermination IS NULL
GROUP BY PerformanceScore
GO

/* Employee Satisfaction Headcount */
SELECT EmpSatisfaction, COUNT(EmpID) AS HeadCount
FROM HRDataset
WHERE DateofTermination IS NULL
GROUP BY EmpSatisfaction
GO

/* Compensation */
SELECT 
	MIN(Salary) as MinSalary,
	MAX(Salary) AS MaxSalary FROM HRDataset
WHERE DateofTermination IS NULL
GO


WITH HRSalary AS (
	SELECT EmpID,
	CASE 
		WHEN Salary < 50000 THEN 'Less than $50K'
		WHEN Salary < 100000 THEN '$50K - $99K'
		WHEN Salary < 150000 THEN '100K - 149K'
		WHEN Salary < 200000 THEN '150K - 199K'
		ELSE '200k+'
		END AS SalaryCat
	FROM HRDataset)
SELECT SalaryCat, COUNT(A.EmpID) as HeadCount
FROM HRDataset AS A 
	JOIN HRSalary AS B 
ON A.EmpID = B.EmpID
WHERE DateofTermination IS NULL
GROUP BY SalaryCat
GO

/* Tenure */
WITH YearsAtComp AS (
SELECT EmpID, DATEDIFF(day, DateofHire, GETDATE())/365.00 AS Years,
	CASE 
	WHEN DATEDIFF(day, DateofHire, GETDATE())/365.00 < 1 THEN '< 1 Year'
	WHEN DATEDIFF(day, DateofHire, GETDATE())/365.00 < 3 THEN '1 Year to 2.9 Years'
	WHEN DATEDIFF(day, DateofHire, GETDATE())/365.00 < 5 THEN '3 Years to 4.9 Years'
	WHEN DATEDIFF(day, DateofHire, GETDATE())/365.00 < 10 THEN '5 Years to 9.9 Years'
	ELSE '10+ Years' END AS YrsCat
FROM HRDataset
WHERE DateofTermination IS NULL
)
SELECT YrsCat AS 'Year Categorized', COUNT (A.EmpID) as HeadCount 
FROM HRDataset AS A 
	JOIN YearsAtComp AS B
	ON A.EmpID = B.EmpID
GROUP BY YrsCat
GO

/* Department */
SELECT Department, COUNT(EmpID) as HeadCount 
FROM HRDataset
WHERE DateofTermination IS NULL
GROUP BY Department
GO

/* Engagement Score */
WITH Engagement AS (
SELECT EmpID, CASE 
	WHEN EngagementSurvey < 2 THEN 'Very Low'
	WHEN EngagementSurvey < 3 THEN 'Low'
	WHEN EngagementSurvey < 4 THEN 'Medium'
	WHEN EngagementSurvey < 5 THEN 'High'
	ELSE 'Very High'
	END AS EngageCat
FROM HRDataset
WHERE DateofTermination IS NULL
	)
SELECT EngageCat, COUNT(A.EmpID) as HeadCount
FROM HRDataset AS A 
	JOIN Engagement AS B 
	ON A.EmpID = B.EmpID
GROUP BY EngageCat
GO