CREATE DATABASE Examination_System;

--Table Branch
CREATE TABLE Branch
	(BranchID INT PRIMARY KEY IDENTITY(1,1), 
	 Branch_Name VARCHAR(100) NOT NULL UNIQUE,
	 Branch_Country NVARCHAR(50) NOT NULL,
	 Branch_City NVARCHAR(50) NOT NULL,
	 Branch_Create_Date DATETIME  NOT NULL);

--------------------------------------------------------------------

CREATE TABLE Provider 
	(ProviderID INT PRIMARY KEY IDENTITY(1,1), 
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
	(StudentID INT  PRIMARY KEY IDENTITY(1,1), 
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
	 BranchID INT FOREIGN KEY REFERENCES Branch(BranchID),
	 Register_Date DATETIME NOT NULL);

--------------------------------------------------------------------

CREATE TABLE Course 
	(CourseID INT PRIMARY KEY IDENTITY(1,1),  
	 Course_Name VARCHAR(100)  NOT NULL, 
	 Course_Duration INT NOT NULL,
	 Course_Add_Date DATETIME  NOT NULL,
	 ProviderID INT,
	 Course_Price INT DEFAULT 1000,
	 FOREIGN KEY (ProviderID) REFERENCES Provider(ProviderID));

--------------------------------------------------------------------

CREATE TABLE Exam 
	(ExamID INT PRIMARY KEY IDENTITY(1,1), 
	 Duration_MINs INT NOT NULL,
	 MCQ_Num INT NOT NULL, 
	 True_False_Num INT NOT NULL,
	 Create_Date DATETIME NOT NULL, 
	 ProviderID INT FOREIGN KEY (ProviderID) REFERENCES Provider(ProviderID));
	 
--------------------------------------------------------------------

CREATE TABLE Course_Exam 
	(CourseID INT, 
	 ExamID INT, 
	 PRIMARY KEY(CourseID, ExamID),
	 FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
	 FOREIGN KEY (ExamID) REFERENCES Exam(ExamID));

--------------------------------------------------------------------

CREATE TABLE Track 
	(TrackID INT  PRIMARY KEY IDENTITY(1,1), 
	 Track_Name VARCHAR(100) NOT NULL UNIQUE);

--------------------------------------------------------------------

CREATE TABLE Course_Track
	(CourseID INT, 
	 TrackID INT, 
	 PRIMARY KEY(CourseID, TrackID),
	 FOREIGN KEY (CourseID)  REFERENCES Course(CourseID),
	 FOREIGN KEY (TrackID)  REFERENCES Track(TrackID));

--------------------------------------------------------------------

CREATE TABLE Student_Course 
	(CourseID INT, 
	 StudentID INT, 
	 Time_Enrolled DATETIME NOT NULL,
	 PRIMARY KEY(CourseID, StudentID),
	 FOREIGN KEY (CourseID)  REFERENCES Course(CourseID),
	 FOREIGN KEY (StudentID)  REFERENCES Student(StudentID));

--------------------------------------------------------------------

CREATE TABLE Student_Exam 
	(ExamID INT, 
	 StudentID INT, 
	 Time_Taken_MINs INT NOT NULL, 
	 Grade INT NOT NULL,
	 Start_Date DATETIME NOT NULL,
	 PRIMARY KEY(ExamID, StudentID),
	 FOREIGN KEY (ExamID)  REFERENCES Exam(ExamID),
	 FOREIGN KEY (StudentID)  REFERENCES Student(StudentID));

--------------------------------------------------------------------

CREATE TABLE Question_Types
	(Question_TypeID INT  PRIMARY KEY IDENTITY(1,1),
	 Question_Type VARCHAR(10) CHECK(Question_Type IN ('MCQ','TrueFalse')))

--------------------------------------------------------------------

CREATE TABLE Question
	(QuestionID INT  PRIMARY KEY IDENTITY(1,1), 
	 Question_Header VARCHAR(MAX) NOT NULL,
	 Correct_Answers  VARCHAR(300) NOT NULL, 
	 Marks INT  NOT NULL, 
	 CourseID INT FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
	 Question_TypeID INT FOREIGN KEY (Question_TypeID) REFERENCES Question_Types(Question_TypeID));

--------------------------------------------------------------------
CREATE TABLE MCQ_Answers 
	(AnswerID INT  PRIMARY KEY IDENTITY(1,1), 
	 Answer1 VARCHAR(300) NOT NULL,
	 Answer2 VARCHAR(300) NOT NULL, 
	 Answer3 VARCHAR(300) NOT NULL, 
	 Answer4 VARCHAR(300) NOT NULL, 
	 QuestionID INT FOREIGN KEY (QuestionID)  REFERENCES Question(QuestionID));
	 
--------------------------------------------------------------------

CREATE TABLE Exam_Questions  
	(ExamID INT, 
	 QuestionID INT, 
	 PRIMARY KEY(ExamID, QuestionID),
	 FOREIGN KEY (ExamID)  REFERENCES Exam(ExamID),
	 FOREIGN KEY (QuestionID)  REFERENCES Question(QuestionID));

--------------------------------------------------------------------

CREATE TABLE Student_Answers 
	(ExamID INT, 
	 StudentID INT,
	 QuestionID INT, 
	 Answers VARCHAR(300),
	 PRIMARY KEY(ExamID, StudentID,QuestionID),
	 FOREIGN KEY (ExamID)  REFERENCES Exam(ExamID),
	 FOREIGN KEY (StudentID)  REFERENCES Student(StudentID),
	 FOREIGN KEY (QuestionID)  REFERENCES Question(QuestionID));

--------------------------------------------------------------------
SELECT * FROM Branch
SELECT * FROM Student
SELECT * FROM Student_Exam
SELECT * FROM Student_Answers
SELECT * FROM Student_Course
SELECT * FROM Provider
SELECT * FROM Track
SELECT * FROM Course
SELECT * FROM Course_Track
SELECT * FROM Course_Exam
SELECT * FROM Question
SELECT * FROM Question_Types
SELECT * FROM MCQ_Answers
SELECT * FROM Exam
SELECT * FROM Exam_Questions