CREATE DATABASE Examination_System_DWH;

--Table Branch
CREATE TABLE Branch
	(BranchID INT PRIMARY KEY, 
	 Branch_Name VARCHAR(100) NOT NULL UNIQUE,
	 Branch_Country NVARCHAR(50) NOT NULL,
	 Branch_City NVARCHAR(50) NOT NULL,
	 Branch_Create_Date DATETIME  NOT NULL);

--------------------------------------------------------------------

CREATE TABLE Provider 
	(ProviderID INT PRIMARY KEY, 
	 Provider_Name VARCHAR(100)  NOT NULL, 
	 Email VARCHAR(250) NOT NULL UNIQUE,
	 Password NVARCHAR(30) NOT NULL CHECK(LEN(Password) > 8), 
	 Phone NVARCHAR(30) NOT NULL, 
	 Social_Media VARCHAR(250),
	 Country NVARCHAR(60) NOT NULL,
	 City NVARCHAR(60) NOT NULL,
	 Register_Date DATETIME  NOT NULL);

--------------------------------------------------------------------

CREATE TABLE Student 
	(StudentID INT  PRIMARY KEY, 
	 First_Name NVARCHAR(50) COLLATE Arabic_CI_AI_KS_WS NOT NULL,
	 Last_Name NVARCHAR(50) COLLATE Arabic_CI_AI_KS_WS NOT NULL, 
	 Gender VARCHAR(10) CHECK(Gender IN ('Female', 'Male')),
	 Birth_Date Date NOT NULL,
	 Email VARCHAR(250) NOT NULL UNIQUE,
	 Password NVARCHAR(30) NOT NULL CHECK(LEN(Password) > 8), 
	 Phone NVARCHAR(30) NOT NULL,
	 Social_Media VARCHAR(250),
	 Country NVARCHAR(60) NOT NULL,
	 City NVARCHAR(60) NOT NULL,
	 BranchID INT,
	 Register_Date DATETIME NOT NULL);

--------------------------------------------------------------------

CREATE TABLE Course 
	(CourseID INT PRIMARY KEY,  
	 Course_Name VARCHAR(100)  NOT NULL, 
	 Course_Duration INT NOT NULL,
	 Course_Add_Date DATETIME  NOT NULL,
	 ProviderID INT,
	 Course_Price INT DEFAULT 1000);

--------------------------------------------------------------------

CREATE TABLE Exam 
	(ExamID INT PRIMARY KEY, 
	 Duration_MINs INT NOT NULL,
	 MCQ_Num INT NOT NULL, 
	 True_False_Num INT NOT NULL,
	 Create_Date DATETIME NOT NULL, 
	 ProviderID INT);

--------------------------------------------------------------------

CREATE TABLE Track 
	(TrackID INT  PRIMARY KEY, 
	 Track_Name VARCHAR(100) NOT NULL UNIQUE);

--------------------------------------------------------------------

CREATE TABLE Student_Exam 
	(ExamID INT, 
	 StudentID INT, 
	 Time_Taken_MINs INT NOT NULL, 
	 Grade INT NOT NULL,
	 Start_Date DATETIME NOT NULL,
	 PRIMARY KEY(ExamID, StudentID));

--------------------------------------------------------------------

CREATE TABLE Question
	(QuestionID INT  PRIMARY KEY, 
	 Question_Header VARCHAR(MAX) NOT NULL,
	 Correct_Answers  VARCHAR(300) NOT NULL, 
	 Marks INT  NOT NULL,
	 Question_TypeID INT,
	 Question_Type VARCHAR(10) CHECK(Question_Type IN ('MCQ','TrueFalse')),
	 CourseID INT,
	 AnswerID INT, 
	 Answer1 VARCHAR(300),
	 Answer2 VARCHAR(300), 
	 Answer3 VARCHAR(300), 
	 Answer4 VARCHAR(300));

--------------------------------------------------------------------

CREATE TABLE Student_Answers 
	(ExamID INT, 
	 StudentID INT,
	 QuestionID INT, 
	 Answers VARCHAR(300),
	 PRIMARY KEY(ExamID, StudentID, QuestionID));

--------------------------------------------------------------------

CREATE TABLE Fact_Table
	(StudentID INT FOREIGN KEY REFERENCES Student(StudentID),
	 Time_Enrolled DATETIME,
	 CourseID INT FOREIGN KEY REFERENCES Course(CourseID),
	 TrackID INT FOREIGN KEY REFERENCES Track(TrackID),
	 ProviderID INT FOREIGN KEY REFERENCES Provider(ProviderID),
	 BranchID INT FOREIGN KEY REFERENCES Branch(BranchID),
	 ExamID INT FOREIGN KEY REFERENCES Exam(ExamID),
	 QuestionID INT FOREIGN KEY REFERENCES Question(QuestionID),
	 FOREIGN KEY (ExamID, StudentID, QuestionID) REFERENCES Student_Answers(ExamID, StudentID, QuestionID),
	 FOREIGN KEY (ExamID, StudentID) REFERENCES Student_Exam(ExamID, StudentID));

--------------------------------------------------------------------


ALTER TABLE Student 
ADD Age AS (CONVERT(int,ROUND(DATEDIFF(hour, Birth_Date,GETDATE())/8766.0,0)));

ALTER TABLE Student 
ADD Duration AS (CONVERT(int,ROUND(DATEDIFF(hour, Register_Date,GETDATE())/8766.0,0)));


ALTER TABLE Provider 
ADD Duration AS (CONVERT(int,ROUND(DATEDIFF(hour, Register_Date,GETDATE())/8766.0,0)));

ALTER TABLE Student 
ADD Region VARCHAR(25) DEFAULT 'Other'

UPDATE Student
SET Region = 'Middle East'
WHERE Country IN ('Egypt','Algeria','Iraq','Sudan','Morocco','Saudi Arabia','Yemen','Syria','Tunisia','Somalia','United Arab Emirates','Jordan','Libya','Palestine','Lebanon','Oman','Kuwait','Mauritania','Qatar','Bahrain','Djibouti','Comoros')
UPDATE Student
SET Region = 'Other'
WHERE Country NOT IN ('Egypt','Algeria','Iraq','Sudan','Morocco','Saudi Arabia','Yemen','Syria','Tunisia','Somalia','United Arab Emirates','Jordan','Libya','Palestine','Lebanon','Oman','Kuwait','Mauritania','Qatar','Bahrain','Djibouti','Comoros')

ALTER TABLE Provider 
ADD Region VARCHAR(25) DEFAULT 'Other'

UPDATE Provider
SET Region = 'Middle East'
WHERE Country IN ('Egypt','Algeria','Iraq','Sudan','Morocco','Saudi Arabia','Yemen','Syria','Tunisia','Somalia','United Arab Emirates','Jordan','Libya','Palestine','Lebanon','Oman','Kuwait','Mauritania','Qatar','Bahrain','Djibouti','Comoros')
UPDATE Provider
SET Region = 'Other'
WHERE Country NOT IN ('Egypt','Algeria','Iraq','Sudan','Morocco','Saudi Arabia','Yemen','Syria','Tunisia','Somalia','United Arab Emirates','Jordan','Libya','Palestine','Lebanon','Oman','Kuwait','Mauritania','Qatar','Bahrain','Djibouti','Comoros')


-----------------------------------------------------------------------------

DECLARE @StartDate  date = '20150101';

DECLARE @CutoffDate date = DATEADD(DAY, -1, DATEADD(YEAR, 8, @StartDate));

;WITH seq(n) AS 
(
  SELECT 0 UNION ALL SELECT n + 1 FROM seq
  WHERE n < DATEDIFF(DAY, @StartDate, @CutoffDate)
),
d(d) AS 
(
  SELECT DATEADD(DAY, n, @StartDate) FROM seq
),
src AS
(
  SELECT
    TheDate         = CONVERT(date, d),
    TheDay          = DATEPART(DAY,       d),
    TheDayName      = DATENAME(WEEKDAY,   d),
    TheWeek         = DATEPART(WEEK,      d),
    TheISOWeek      = DATEPART(ISO_WEEK,  d),
    TheDayOfWeek    = DATEPART(WEEKDAY,   d),
    TheMonth        = DATEPART(MONTH,     d),
    TheMonthName    = DATENAME(MONTH,     d),
    TheQuarter      = DATEPART(Quarter,   d),
    TheYear         = DATEPART(YEAR,      d),
    TheFirstOfMonth = DATEFROMPARTS(YEAR(d), MONTH(d), 1),
    TheLastOfYear   = DATEFROMPARTS(YEAR(d), 12, 31),
    TheDayOfYear    = DATEPART(DAYOFYEAR, d)
  FROM d
),
dim AS
(
  SELECT
    TheDate, 
    TheDay,
    TheDayName,
    TheDayOfWeek,
    IsWeekend           = CASE WHEN TheDayOfWeek IN (CASE @@DATEFIRST WHEN 1 THEN 6 WHEN 7 THEN 1 END,7) 
                            THEN 1 ELSE 0 END,
    TheISOweek,

    TheWeekOfMonth      = CONVERT(tinyint, DENSE_RANK() OVER 
                            (PARTITION BY TheYear, TheMonth ORDER BY TheWeek)),
    TheMonth,
    TheMonthName,
    TheQuarter,
    TheYear
  FROM src
)
SELECT * 
INTO Calendar
FROM dim
ORDER BY TheDate
OPTION (MAXRECURSION 0);