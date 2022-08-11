-- COURSE, PROVDER ,STUDENT ,TRACKS, BRANCHES

-- Tracks
GO
CREATE PROCEDURE Tracks
      @Action VARCHAR(20)
      ,@trackID INT = NULL
      ,@Track_Name VARCHAR(100) = NULL
	  
AS
BEGIN
      --SELECT
      IF @Action = 'SELECT'
      BEGIN
            SELECT *
            FROM Track
      END
      --INSERT
      ELSE IF @Action = 'INSERT'
		
      BEGIN
			IF NOT EXISTS( SELECT Track_Name FROM Track WHERE Track_Name = @Track_Name)
				 INSERT INTO Track(Track_Name)
				 VALUES (@Track_Name)
			ELSE SELECT 'Track is already added.' AS ERROR
      END
      --UPDATE
      ELSE IF @Action = 'UPDATE'
      BEGIN
			IF EXISTS (SELECT trackID FROM Track WHERE TrackID = @trackID)
				UPDATE Track
				SET Track_Name =@Track_Name
				WHERE TrackID = @trackID
			ELSE SELECT 'Track is not Found.' AS ERROR
      END
      --DELETE
      ELSE IF @Action = 'DELETE'
      BEGIN
		IF  EXISTS(SELECT trackID FROM Track where TrackID = @trackID)
            DELETE FROM Track
            WHERE TrackID = @trackID
		ELSE SELECT 'Track is not Found.' AS ERROR
      END
END

-------------------------------------------------------------------
--Students
GO
CREATE PROCEDURE Students
      @Action VARCHAR(20)
      ,@Studentid INT = NULL
      ,@First_Name varchar(20) = NULL
	  ,@Last_Name varchar(20) = NULL
	  ,@gender varchar(10) = NULL
	  ,@rgdate datetime = NULL
	  ,@pswrd nvarchar(20) = NULL
	  ,@birthdate date = NULL
	  ,@socialmedia varchar(250) = NULL
	  ,@phone int = NULL
	  ,@email varchar(200) = NULL
	  ,@city varchar(50) = NULL
	  ,@country varchar(50) = NULL
	  ,@branchid int = NULL
AS
BEGIN
      --SELECT
      IF @Action = 'SELECT'
      BEGIN
            SELECT *
            FROM Student
      END

      --INSERT
     ELSE IF @Action = 'INSERT'
      BEGIN
			IF NOT EXISTS( SELECT phone,email FROM Student WHERE Phone = @phone OR Email = @email)
				AND EXISTS(SELECT BRANCHID FROM branch WHERE branchid = @branchid)
				 INSERT INTO Student(First_Name,Last_Name,Gender,Register_Date,Password,Birth_Date,Social_Media,Phone,Email,City,Country,BranchID)
				 VALUES ( @First_Name ,@Last_Name ,@gender,@rgdate ,@pswrd,@birthdate ,@socialmedia ,@phone ,@email ,@city ,@country,@branchid  )
			ELSE SELECT 'your Eamil, Phone are already used Or Branch ID is not Found.' AS ERROR
      END
      --UPDATE
     ELSE  IF @Action = 'UPDATE'
      BEGIN
			IF  EXISTS (SELECT Studentid FROM Student WHERE Studentid = @Studentid)
				AND EXISTS( SELECT branchid from branch  WHERE branchid = @branchid)
				UPDATE Student
				SET First_Name = @First_Name, Last_Name= @Last_Name, BranchID = @branchid, Country = @country, City = @city, Email = @email, Password = @pswrd,Birth_Date=@birthdate, Social_Media = @socialmedia
				WHERE StudentID = @Studentid
			ELSE SELECT 'Student is not Found.' AS ERROR
      END
      --DELETE
      ELSE IF @Action = 'DELETE'
      BEGIN
		IF  EXISTS(SELECT @Studentid FROM Student where StudentID = @Studentid)
            DELETE FROM Student
            WHERE StudentID = @Studentid
		ELSE SELECT 'Student is not Found.' AS ERROR
      END
END
----------------------------------------------------------------------------------
--Providers
GO
CREATE PROCEDURE Providers
      @Action VARCHAR(20) 
      ,@proid INT = NULL
      ,@proname varchar(20) = NULL
	  ,@rgdate datetime = NULL
	  ,@pswrd nvarchar(20) = NULL
	  ,@socialmedia varchar(250) = NULL
	  ,@phone int = NULL
	  ,@email varchar(200) = NULL
	  ,@city varchar(50) = NULL
	  ,@country varchar(50) = NULL
AS
BEGIN
      --SELECT
      IF @Action = 'SELECT'
      BEGIN
            SELECT *
            FROM Provider
      END

     ELSE IF @Action = 'INSERT'
      BEGIN
			IF NOT  EXISTS( SELECT phone,email FROM Provider WHERE Phone = @phone OR Email = @email)
				 INSERT INTO Provider(Provider_Name,Register_Date,Password,Social_Media,Phone,Email,City,Country)
				 VALUES (@proname ,@rgdate ,@pswrd,@socialmedia ,@phone,@email ,@city ,@country)
			ELSE SELECT 'your Eamil or Phone are already used.' AS ERROR
      END
      --UPDATE
      ELSE IF @Action = 'UPDATE'
      BEGIN
			IF EXISTS (SELECT ProviderID FROM Provider WHERE ProviderID = @proid)
				UPDATE Provider
				SET Provider_Name =@proname, Phone=  @phone, Country = @country, City = @city, Email = @email, Password = @pswrd, Social_Media = @socialmedia
				WHERE ProviderID = @proid
			ELSE SELECT 'Provider is not Found.' AS ERROR
      END
      --DELETE
      ELSE IF @Action = 'DELETE'
      BEGIN
		IF  EXISTS(SELECT ProviderID FROM Provider where ProviderID = @proid)
            DELETE FROM Provider
            WHERE ProviderID = @proid
		ELSE SELECT 'Provider is not Found.' AS ERROR
      END
END
-------------------------------------------------------
--Courses
GO
CREATE PROC Courses 
	   @Action VARCHAR(20) 
	  ,@CrsID int = NULL
      ,@proid INT = NULL
      ,@CrsName varchar(100) = NULL
	  ,@duration int = NULL	
AS
BEGIN
      --SELECT
       IF @Action = 'SELECT'
      BEGIN
            SELECT *
            FROM course
      END

      --INSERT
      ELSE IF @Action = 'INSERT'
      BEGIN
			IF NOT EXISTS(SELECT Course_Name, ProviderID FROM course WHERE Course_Name = @crsname AND ProviderID = @proid)
			AND EXISTS(SELECT providerid from Provider WHERE ProviderID = @proid)
				 INSERT INTO course(ProviderID,Course_Name,Course_Duration)
				 VALUES (@proid ,@crsname ,@duration)
			ELSE SELECT 'This Provider has already added the same course.' AS ERROR
      END
      --UPDATE
      ELSE IF @Action = 'UPDATE'
      BEGIN
			IF  EXISTS (SELECT courseid FROM course WHERE courseid = @crsid)
				AND EXISTS(SELECT providerid from Provider WHERE ProviderID = @proid)
				UPDATE course
				SET Course_Name =@crsname, Course_Duration = @duration, ProviderID =@proid
				WHERE CourseID = @crsid
			ELSE SELECT 'Course is not Found.' AS ERROR
      END
      --DELETE
      ELSE IF @Action = 'DELETE'
      BEGIN
		IF  EXISTS(SELECT CourseID FROM course where CourseID = @crsid)
            DELETE FROM course
            WHERE CourseID = @crsid
		ELSE SELECT 'Course is not Found.' AS ERROR
      END
END

-----------------------------------------------------
--Branches
GO
CREATE PROC branches 
	   @Action VARCHAR(20) 
	  ,@branchid int = NULL
	  ,@branchname varchar(100) = NULL
      ,@city varchar(50) = NULL
	  ,@country varchar(50) = NULL
AS
BEGIN
      --SELECT
       IF @Action = 'SELECT'
      BEGIN
            SELECT *
            FROM branch
      END
      --INSERT
      ELSE IF @Action = 'INSERT'
      BEGIN
			IF NOT EXISTS( SELECT Branch_Name, Branch_City, Branch_Country FROM branch WHERE Branch_Name = @branchname AND Branch_City = @city AND Branch_Country = @country)
				 INSERT INTO branch(Branch_Name, Branch_City,Branch_Country)
				 VALUES (@branchname ,@city ,@country)
			ELSE SELECT 'This branch already added in the same City and Country.' AS ERROR
      END
      --UPDATE
      ELSE IF @Action = 'UPDATE'
      BEGIN
			IF  EXISTS (SELECT branchid FROM branch WHERE branchid = @branchid)
				UPDATE branch
				SET Branch_Name =@branchname
				WHERE BranchID = @branchid
			ELSE SELECT 'Branch is not Found.' AS ERROR
      END
      --DELETE
      ELSE IF @Action = 'DELETE'
      BEGIN
		IF  EXISTS(SELECT BranchID FROM Branch where BranchID = @branchid)
            DELETE FROM branch
            WHERE BranchID = @branchid
		ELSE SELECT 'Branch is not Found.' AS ERROR
      END
END


---------Course_Track
GO
CREATE PROCEDURE Course_Track_proc
      @Action VARCHAR(20),
	  @trackID INT = NULL
	  ,@OldcourseID INT = NULL
	  ,@NewcourseID INT = NULL


AS
BEGIN
      --SELECT
      IF @Action = 'SELECT'
      BEGIN
            SELECT *
            FROM Course_Track
      END
      --INSERT
      Else IF @Action = 'INSERT'
		
      BEGIN
		
			IF EXISTS( SELECT CourseID FROM Course WHERE CourseID = @NewcourseID)
			AND EXISTS( SELECT TrackID FROM Track WHERE TrackID = @trackID)
			Begin
				 INSERT INTO Course_Track
				 VALUES (@NewcourseID,@trackID)
			END
			ELSE SELECT 'Track ID or Course ID Or Both Are not Exsist in the main tables(Course , Track ) ' AS ERROR
      END
      --UPDATE
      IF @Action = 'UPDATE'
      BEGIN
	  IF EXISTS( SELECT CourseID FROM Course WHERE CourseID = @newcourseID )
	  AND  EXISTS( SELECT TrackID,CourseID FROM Course_Track WHERE CourseID = @oldcourseID AND TrackID = @trackID )
	  And Not EXISTS ( SELECT TrackID,CourseID FROM Course_Track WHERE CourseID = @NewcourseID AND TrackID = @trackID)
	--  AND EXISTS( SELECT TrackID FROM Track WHERE TrackID = @trackID)
	  Begin
	  Update Course_Track
			
				 set CourseID = @newcourseID
				 where TrackID= @trackID  AND CourseID = @OldcourseID


		
     END
		
	ELSE SELECT 'Track ID or Course ID Are not Exsist in  the main tables(Course , Track ) ' AS ERROR

     END
      --DELETE
      Else IF @Action = 'DELETE'

	  BEGIN
	If  EXISTS( SELECT TrackID FROM Course_Track WHERE CourseID = @oldcourseID AND TrackID = @trackID )
	  Begin
	  Delete From Course_Track
				 where TrackID= @trackID AND CourseID = @oldcourseID
     END
	 	ELSE SELECT 'Track ID or Course ID Are not Exsist in  the main tables(Course , Track ) ' AS ERROR
	 END
END 



----------------------------

GO
CREATE PROCEDURE Course_Exam_proc
      @Action VARCHAR(20),
	  @courseID INT = NULL
	  ,@OldExamID INT = NULL
	  ,@NewExamID INT = NULL


AS
BEGIN
      --SELECT
      IF @Action = 'SELECT'
      BEGIN
            SELECT *
            FROM Course_Exam
      END
      --INSERT
      Else IF @Action = 'INSERT'
		
      BEGIN
		
			IF EXISTS( SELECT CourseID FROM Course WHERE CourseID = @courseID)
			AND EXISTS( SELECT ExamID FROM Exam WHERE ExamID = @NewExamID)
			AND Not EXISTS(Select CourseID , ExamID from Course_Exam where CourseID = @courseID AND  ExamID = @NewExamID) 
			Begin
				 INSERT INTO Course_Exam
				 VALUES (@courseID,@NewExamID)
			END
			ELSE SELECT 'Track ID or Course ID Or Both Are not Exsist in the main tables(Course , Track ) ' AS ERROR
      END
      --UPDATE
      IF @Action = 'UPDATE'
      BEGIN
	  IF EXISTS( SELECT ExamID FROM Exam WHERE ExamID = @NewExamID )
	  AND  EXISTS( SELECT ExamID FROM Course_Exam Where CourseID = @courseID AND  ExamID = @OldExamID )
	  AND  NOT EXISTS( SELECT ExamID FROM Course_Exam Where CourseID = @courseID AND  ExamID = @NewExamID )

	  Begin
	  Update Course_Exam
			
				 
				 set ExamID = @NewExamID 
				 where CourseID = @courseID and ExamID = @OldExamID 

		
     END
		
	ELSE SELECT 'Track ID or Course ID Are not Exsist in  the main tables(Course , Track ) ' AS ERROR

     END
      --DELETE
      IF @Action = 'DELETE'

	  BEGIN
	 	  IF  EXISTS( SELECT ExamID,CourseID FROM Course_Exam Where CourseID = @courseID AND  ExamID = @OldExamID )
	  Begin
	  Delete From Course_Exam
				Where CourseID = @courseID AND  ExamID = @OldExamID
     END
	 	ELSE SELECT 'Track ID or Course ID Are not Exsist in  the main tables(Course , Track ) ' AS ERROR
	 END
END 
------------------------------------------------
-------------QuestionType


GO
CREATE PROCEDURE QuestionType_Proc
      @Action VARCHAR(20) 
	  , @QTypeID INT = NULL
	  , @QType VARCHAR(10) = NULL
	


AS
BEGIN
      --SELECT
      IF @Action = 'SELECT'
 
            SELECT * FROM Question_Types
     
      --INSERT
      Else IF @Action = 'INSERT'
		
			 SELECT 'Could Not Insert into QType Table ' AS ERROR
     
      --UPDATE
      Else IF @Action = 'UPDATE'
	   SELECT 'Could Not Update into QType Table ' AS ERROR


      --DELETE
      Else IF @Action = 'DELETE'

	  SELECT 'Could Not Delete from QType Table ' AS ERROR
	 
END 

--------------------------------------------------------------------------------
------------ StudentAnswerss
GO
CREATE PROCEDURE StudentAnswers_Proc
      @Action VARCHAR(20)
	  , @ExamID INT = NULL
	  , @StudentID INT = NULL
	  , @QuestonID INT = NULL
	  , @Answer varchar(300)= NULL


AS
BEGIN
      --SELECT
      IF @Action = 'SELECT'
      BEGIN
            SELECT *
            FROM Student_Answers
      END
      --INSERT
      Else IF @Action = 'INSERT'
		
      BEGIN
		
			IF EXISTS( SELECT studentID FROM Student WHERE StudentID = @StudentID)
			AND EXISTS( SELECT ExamID FROM Exam WHERE ExamID = @ExamID)
			AND EXISTS( SELECT QuestionID FROM Question WHERE QuestionID = @QuestonID)
			Begin
				 INSERT INTO Student_Answers
				 VALUES (@ExamID,@StudentID,@QuestonID,@Answer)

			
			 IF @Answer = (select Correct_Answers from Question where QuestionID = @QuestonID)
				BEGIN
				UPDATE Student_Exam SET Grade = Grade + 10 WHERE StudentID = @StudentID 
				AND ExamID = @ExamID
				END

			END
			ELSE SELECT ' studentID , or QuestionID ,ExamID are not Exsist in the main tables(Student ,Question,Exam ) ' AS ERROR
			
      END
      --UPDATE
      Else IF @Action = 'UPDATE'
      BEGIN

	  IF EXISTS( SELECT StudentID FROM Student_Answers WHERE StudentID = @StudentID AND ExamID = @ExamID AND QuestionID=@QuestonID )

	  Begin
	  Update Student_Answers
			
				 set Answers = @Answer
				 where  StudentID = @StudentID AND ExamID = @ExamID AND QuestionID = @QuestonID

     END
		
	ELSE SELECT ' studentID ,ExamID,Or QuestionID Are not Exsist in StudentAnswers'  AS ERROR

     END
      --DELETE
      Else IF @Action = 'DELETE'

	  BEGIN
	  
	  If EXISTS( SELECT StudentID FROM Student_Answers WHERE StudentID = @StudentID AND ExamID = @ExamID AND QuestionID=@QuestonID )

	  Begin
	  Delete From Student_Answers
	  where  StudentID = @StudentID AND ExamID = @ExamID AND QuestionID=@QuestonID
      END
		ELSE SELECT ' studentID ,ExamID,Or QuestionID or both Are not Exsist in StudentAnswers'  AS ERROR
	 END
END 

------------------------------------------------
--MCQ_Answers
GO
CREATE PROCEDURE MCQ_Answers_Proc
      @Action VARCHAR(20)
	  , @AnswerID  INT = NULL
	  , @Answer1   varchar(300) = NULL
	  , @Answer2   varchar(300) = NULL
	  , @Answer3   varchar(300) = NULL
	  , @Answer4   varchar(300) = NULL
	  , @quesstionID INT = NULL
AS
BEGIN
      --SELECT
      IF @Action = 'SELECT'
      BEGIN
            SELECT *
            FROM MCQ_Answers
      END
      --INSERT
      Else IF @Action = 'INSERT'
		
      BEGIN
				 INSERT INTO MCQ_Answers
				 VALUES (@Answer1,@Answer2,@Answer3,@Answer4,@quesstionID)
	 END

      --UPDATE
      Else IF @Action = 'UPDATE'
      BEGIN

	  IF EXISTS( SELECT AnswerID FROM MCQ_Answers WHERE AnswerID=@AnswerID )
	  

	  Begin
	  Update MCQ_Answers
			
				 set Answer1 = @Answer1 , Answer2 = @Answer2 , Answer3 = @Answer3 , Answer4 = @Answer4
				 WHERE AnswerID=@AnswerID 

     END
		
	ELSE SELECT ' AnswerID is not Exsist in MCQ_Answers'  AS ERROR

     END
      --DELETE
      Else IF @Action = 'DELETE'

	  BEGIN
	  
	  IF EXISTS( SELECT @AnswerID FROM MCQ_Answers WHERE AnswerID=@AnswerID )
	  Begin
	  Delete From MCQ_Answers
	  where AnswerID=@AnswerID
      END
		ELSE SELECT ' AnswerID is not Exsist in MCQ_Answers'  AS ERROR
	 END
END 


--Exam Table
GO
CREATE PROCEDURE Exam_proc
      @Action VARCHAR(20)
      ,@ExamID INT = NULL
      ,@Duration_MINs INT = NULL
	  ,@MCQ_num INT = NULL
	  ,@True_False_num INT = NULL
	  ,@CreationDate DATETIME = NULL
	  ,@ProviderID INT = NULL
	  
AS
BEGIN
      --SELECT
      IF @Action = 'SELECT'
      BEGIN
            SELECT *
            FROM Exam
      END
      --INSERT
      ELSE IF @Action = 'INSERT'
		
      BEGIN
			IF EXISTS (SELECT ProviderID FROM Provider WHERE ProviderID = @ProviderID)
				BEGIN
				 INSERT INTO Exam(Duration_MINs, MCQ_num, True_False_num, Create_Date, ProviderID)
				 VALUES (@Duration_MINs, @MCQ_num, @True_False_num, @CreationDate, @ProviderID)
				 SET @ExamID = SCOPE_IDENTITY()

				 CREATE TABLE #Temp_MCQ (Temp_MCQ_ID INT IDENTITY(1,1), QuestionID INT)
				 CREATE TABLE #Temp_TF (Temp_MCQ_ID INT IDENTITY(1,1), QuestionID INT)

				 INSERT INTO #Temp_MCQ(QuestionID) SELECT TOP(@MCQ_num) QuestionID FROM Question WHERE Question_TypeID = 1 ORDER BY NEWID()
				 INSERT INTO #Temp_TF(QuestionID) SELECT TOP(@True_False_num) QuestionID FROM Question WHERE Question_TypeID = 2 ORDER BY NEWID()

				 DECLARE @i int = 0
				 WHILE @i < @MCQ_num AND @MCQ_num IS NOT NULL
					BEGIN
					 INSERT INTO Exam_Questions 
					 VALUES (@ExamID, (SELECT QuestionID FROM #Temp_MCQ WHERE Temp_MCQ_ID = (SELECT MAX(Temp_MCQ_ID)-@i FROM #Temp_MCQ)))
					 SET @i = @i + 1
					END 

				SET @i = 0
				WHILE @i < @True_False_num AND @True_False_num IS NOT NULL
					BEGIN
					 INSERT INTO Exam_Questions 
					 VALUES (@ExamID, (SELECT QuestionID FROM #Temp_TF WHERE Temp_MCQ_ID = (SELECT MAX(Temp_MCQ_ID)-@i  FROM #Temp_TF)))
					 SET @i = @i + 1
					END 

				 DROP TABLE #Temp_MCQ
				 DROP TABLE #Temp_TF
				  
				
				
				END
			ELSE SELECT 'ProviderID Not Found.' AS ERROR
      END
      --UPDATE
      ELSE IF @Action = 'UPDATE'
      BEGIN
			IF EXISTS (SELECT ExamID FROM Exam WHERE ExamID = @ExamID)
				UPDATE Exam
				SET Duration_MINs =@Duration_MINs
				WHERE ExamID = @ExamID
			ELSE SELECT 'Exam Not Found.' AS ERROR
      END
      --DELETE
      ELSE IF @Action = 'DELETE'
      BEGIN
		IF EXISTS (SELECT ExamID FROM Exam WHERE ExamID = @ExamID)
            DELETE FROM Exam
            WHERE ExamID = @ExamID
		ELSE SELECT 'Exam is not Found.' AS ERROR
      END
END
GO
--------------------------------------------------------------------------
--Question Table
GO
CREATE PROCEDURE Question_proc
      @Action VARCHAR(20)
      ,@QuestionID INT = NULL
      ,@QuestionHeader VARCHAR(MAX) = NULL
	  ,@CorrectAnswers VARCHAR(300) = NULL
	  ,@Marks INT = NULL
	  ,@CourseID INT = NULL
	  ,@QTypeID INT = NULL
	  
AS
BEGIN
      --SELECT
      IF @Action = 'SELECT'
      BEGIN
            SELECT *
            FROM Question
      END
      --INSERT
      ELSE IF @Action = 'INSERT'
		
      BEGIN
			IF EXISTS (SELECT CourseID FROM Course WHERE CourseID = @CourseID) 
			AND EXISTS (SELECT Question_TypeID FROM Question_Types WHERE Question_TypeID = @QTypeID) 
				BEGIN
				 INSERT INTO Question(Question_Header, Correct_Answers, Marks, CourseID, Question_TypeID)
				 VALUES (@QuestionHeader , @CorrectAnswers, @Marks, @CourseID, @QTypeID)
				 
				END
			ELSE SELECT 'CourseID Or QTypeID Not Found.' AS ERROR
      END
      --UPDATE
      ELSE IF @Action = 'UPDATE'
      BEGIN
			IF EXISTS (SELECT QuestionID FROM Question WHERE QuestionID = @QuestionID)
				UPDATE Question
				SET Marks =@Marks
				WHERE QuestionID = @QuestionID
			ELSE SELECT 'Question Not Found.' AS ERROR
      END
      --DELETE
      ELSE IF @Action = 'DELETE'
      BEGIN
		IF EXISTS (SELECT QuestionID FROM Question WHERE QuestionID = @QuestionID)
            DELETE FROM Question
            WHERE QuestionID = @QuestionID
		ELSE SELECT 'Exam is not Found.' AS ERROR
      END
END
GO
--------------------------------------------------------------------------
--Exam_Quetions Table
GO
CREATE PROCEDURE Exam_Quetions_proc
      @Action VARCHAR(20)
      ,@ExamID INT = NULL
	  ,@QuestionID INT = NULL
	  
AS
BEGIN
      --SELECT
      IF @Action = 'SELECT'
      BEGIN
            SELECT *
            FROM Exam_Questions
      END
      --INSERT
      ELSE IF @Action = 'INSERT'
		
      BEGIN
			IF EXISTS (SELECT ExamID FROM Exam WHERE ExamID = @ExamID) 
			AND EXISTS (SELECT QuestionID FROM Question WHERE QuestionID = @QuestionID) 
				BEGIN
				 INSERT INTO Exam_Questions(ExamID, QuestionID)
				 VALUES (@ExamID , @QuestionID)
				END
			ELSE SELECT 'ExamID Or QuestionID Not Found.' AS ERROR
      END
      --UPDATE
      ELSE IF @Action = 'UPDATE'
      BEGIN
			IF EXISTS (SELECT ExamID FROM Exam_Questions WHERE ExamID = @ExamID)
				UPDATE Exam_Questions
				SET QuestionID =@QuestionID
				WHERE ExamID = @ExamID
			ELSE SELECT 'ExamID Not Found.' AS ERROR
      END
      --DELETE
      ELSE IF @Action = 'DELETE'
      BEGIN
		IF EXISTS (SELECT ExamID, QuestionID FROM Exam_Questions WHERE ExamID=@ExamID AND QuestionID = @QuestionID)
            DELETE FROM Exam_Questions
            WHERE ExamID = @ExamID AND QuestionID = @QuestionID
		ELSE SELECT 'ExamID or QuestionID not Found.' AS ERROR
      END
END
GO
--------------------------------------------------------------------------
--Student_Course Table
GO
CREATE PROCEDURE Student_Course_proc
      @Action VARCHAR(20)
      ,@CourseID INT = NULL
	  ,@StudentID INT = NULL
	  ,@TimeEnrolled DATETIME = NULL  
	  
AS
BEGIN
      --SELECT
      IF @Action = 'SELECT'
      BEGIN
            SELECT *
            FROM Student_Course
      END
      --INSERT
      ELSE IF @Action = 'INSERT'
		
      BEGIN
			IF EXISTS (SELECT CourseID FROM Course WHERE CourseID = @CourseID) 
			AND EXISTS (SELECT StudentID FROM Student WHERE StudentID = @StudentID) 
				BEGIN
				 INSERT INTO Student_Course
				 VALUES (@CourseID , @StudentID, @TimeEnrolled)
				END
			ELSE SELECT 'CourseID Or StudentID Not Found.' AS ERROR
      END
      --UPDATE
      ELSE IF @Action = 'UPDATE'
      BEGIN
			IF EXISTS (SELECT CourseID, StudentID FROM Student_Course WHERE CourseID = @CourseID AND StudentID = @StudentID)
				UPDATE Student_Course
				SET Time_Enrolled =@TimeEnrolled
				WHERE CourseID = @CourseID AND StudentID = @StudentID
			ELSE SELECT 'CourseID or StudentID Not Found.' AS ERROR
      END
      --DELETE
      ELSE IF @Action = 'DELETE'
      BEGIN
		IF EXISTS (SELECT CourseID, StudentID FROM Student_Course WHERE CourseID = @CourseID AND StudentID = @StudentID)
		    DELETE FROM Student_Course
            WHERE CourseID = @CourseID AND StudentID = @StudentID
		ELSE SELECT 'ExamID or QuestionID not Found.' AS ERROR
      END
END
GO
--------------------------------------------------------------------------
--Student_Exam Table
GO
CREATE PROCEDURE Student_Exam_proc
      @Action VARCHAR(20)
      ,@ExamID INT = NULL
	  ,@StudentID INT = NULL
	  ,@TimeTaken_MINs INT = NULL  
	  ,@Grade INT = NULL
	  ,@StratDate DATETIME = NULL  
	  
AS
BEGIN
      --SELECT
      IF @Action = 'SELECT'
      BEGIN
            SELECT *
            FROM Student_Exam
      END
      --INSERT
      ELSE IF @Action = 'INSERT'
		
      BEGIN
			IF EXISTS (SELECT ExamID FROM Exam WHERE ExamID = @ExamID) 
			AND EXISTS (SELECT StudentID FROM Student WHERE StudentID = @StudentID) 
				BEGIN
				 INSERT INTO Student_Exam
				 VALUES (@ExamID , @StudentID, @TimeTaken_MINs, @Grade, @StratDate)
				END
			ELSE SELECT 'ExamID Or StudentID Not Found.' AS ERROR
      END
      --UPDATE
      ELSE IF @Action = 'UPDATE'
      BEGIN
			IF EXISTS (SELECT ExamID, StudentID FROM Student_Exam WHERE ExamID = @ExamID AND StudentID = @StudentID)
				UPDATE Student_Exam
				SET Time_Taken_MINs = @TimeTaken_MINs, Grade = @Grade, Start_Date = @StratDate
				WHERE ExamID = @ExamID AND StudentID = @StudentID
			ELSE SELECT 'ExamID or StudentID Not Found.' AS ERROR
      END
      --DELETE
      ELSE IF @Action = 'DELETE'
      BEGIN
		IF EXISTS (SELECT ExamID, StudentID FROM Student_Exam WHERE ExamID = @ExamID AND StudentID = @StudentID)
		    DELETE FROM Student_Exam
            WHERE ExamID = @ExamID AND StudentID = @StudentID
		ELSE SELECT 'ExamID or StudentID not Found.' AS ERROR
      END
END
GO

----------------------------------------------------------------

CREATE PROCEDURE Course_Top_exam_proc @courseid int
AS
BEGIN
  SELECT TOP(1) ExamID FROM Course_Exam WHERE CourseID= @courseid ORDER BY NEWID()
END














