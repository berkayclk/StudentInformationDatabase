USE StudentInformation


/*******************************************************************/
/******************* TABLES **********************************/
/******************************************************************/


/***************************** ACADEMIC_UNIT TABLE *****************************************/
CREATE TABLE ACADEMIC_UNIT(
	unitID int NOT NULL,
	deanID int NOT NULL,
	name nvarchar(100) NOT NULL UNIQUE,
	location nvarchar(100) NULL,
 CONSTRAINT PK_ACADEMIC_UNIT PRIMARY KEY CLUSTERED (unitID ASC))

GO
/***************************** DEPARTMNENT TABLE *****************************************/

CREATE TABLE DEPARTMENT(
	deptID int NOT NULL ,
	unitID int NOT NULL FOREIGN KEY  REFERENCES ACADEMIC_UNIT(unitID),
	name nvarchar(100) NOT NULL UNIQUE,
 CONSTRAINT PK_DEPARTMENT PRIMARY KEY CLUSTERED (deptID ASC)) 
GO


/***************************** PERSON TABLE *****************************************/

CREATE TABLE PERSON(
	personID int NOT NULL,
	name nvarchar(50) NOT NULL,
	surname nvarchar(50) NOT NULL,
	birthday date NULL,
	sex nvarchar(5) NOT NULL CHECK  (sex='Kadın' OR sex='Erkek'),
	adress nvarchar(100) NULL,
	telefon nvarchar(11) NULL,
 CONSTRAINT PK_PERSON PRIMARY KEY CLUSTERED (personID ASC))


GO

/***************************** STUDENT TABLE *****************************************/
CREATE TABLE STUDENT(
	studentID int NOT NULL,
	personID int NOT NULL FOREIGN KEY REFERENCES PERSON(personID),
	name nvarchar(50) NOT NULL,
	surname nvarchar(50) NOT NULL,
	birthday date NULL,
	sex nvarchar(5) NOT NULL CHECK  (sex='Kadın' OR sex='Erkek'),
	adress nvarchar(100) NULL,
	telefon nvarchar(11) NULL,
 CONSTRAINT PK_STUDENT_1 PRIMARY KEY CLUSTERED (studentID ASC)) 

GO
/***************************** GRADUATE TABLE *****************************************/
CREATE TABLE GRADUATE(
	studentID int NOT NULL FOREIGN KEY REFERENCES STUDENT(studentID),
	personID int NOT NULL,
	avarage float NOT NULL CHECK (avarage >= 0 and avarage <= 4),
	gradeDate int NOT NULL,
	name nvarchar(50) NOT NULL,
	surname nvarchar(50) NOT NULL,
	birthday date NULL,
	sex nvarchar(5) NOT NULL CHECK  (sex='Kadın' OR sex='Erkek'),
	adress nvarchar(100) NULL,
	telefon nvarchar(11) NULL,
 CONSTRAINT PK_GRADUATE_1 PRIMARY KEY CLUSTERED (studentID ASC))

GO


/***************************** UNDERGRADUATE TABLE *****************************************/
CREATE TABLE UNDERGRADUATE(
	studentID int NOT NULL FOREIGN KEY REFERENCES STUDENT (studentID),
	personID int NOT NULL,
	ECTS int NOT NULL DEFAULT(30) CHECK (ECTS = 42 OR ECTS = 30),
	isRegular bit NOT NULL DEFAULT(1),
	classLevel int NOT NULL DEFAULT (1) CHECK (classLevel>=1 and classLevel <=6),
	entryDate int NOT NULL,
	name nvarchar(50) NOT NULL,
	surname nvarchar(50) NOT NULL,
	birthday date NULL,
	sex nvarchar(5) NOT NULL CHECK  (sex='Kadın' OR sex='Erkek'),
	adress nvarchar(100) NULL,
	telefon nvarchar(11) NULL,
 CONSTRAINT PK_UNDERGRADUATE_1 PRIMARY KEY CLUSTERED ( studentID ASC))



/***************************** PROFESSOR TABLE *****************************************/
CREATE TABLE PROFESSOR(
	profID int NOT NULL,
	personID int NOT NULL FOREIGN KEY REFERENCES PERSON(personID),
	profType nvarchar(10) NOT NULL,
	name nvarchar(50) NOT NULL,
	surname nvarchar(50) NOT NULL,
	birthday date NULL,
	sex nvarchar(5) NOT NULL,
	adress nvarchar(100) NULL,
	telefon nvarchar(11) NULL,
 CONSTRAINT PK_PROFESSOR PRIMARY KEY CLUSTERED (profID ASC),
 CONSTRAINT CK_PROFESSOR CHECK  ((profType='Assistant' OR profType='Associate' OR profType='Full')))

GO


/***************************** COURSE TABLE *****************************************/

CREATE TABLE COURSE(
	courseID int NOT NULL,
	name nvarchar(50) NOT NULL,
	semester nvarchar(6) NOT NULL CHECK(semester = 'Fall' or semester = 'Spring' or semester = 'Summer'),
	theoreticalHours int not null,
	practiceHours int not null,
	ECTS int NOT NULL,
 CONSTRAINT PK_COURSE PRIMARY KEY CLUSTERED (courseID ASC)) 
GO

/***************************** COMPANY TABLE *****************************************/

CREATE TABLE COMPANY(
	companyID int NOT NULL PRIMARY KEY,
	name nvarchar(50) NOT NULL,
	foundDate date null  default getdate())
GO


/***************************** FACEBOOKPAGE TABLE *****************************************/

CREATE TABLE FACEBOOKPAGE(
	pageID int NOT NULL FOREIGN KEY REFERENCES COURSE (courseID) PRIMARY KEY,
	name nvarchar(50) NOT NULL,
	adminID int NOT NULL FOREIGN KEY REFERENCES PROFESSOR(profID),
	beginDate date not null  default getdate())
GO


/***************************** LINKEDIN_MEMBERS TABLE *****************************************/

CREATE TABLE LINKEDIN_MEMBERS(
	memID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	memName nvarchar(50) NOT NULL,
	personID int NULL FOREIGN KEY REFERENCES PERSON(personID),
	companyID int NULL FOREIGN KEY REFERENCES COMPANY(companyID),
	mailAdress nvarchar(50) null,
	isCompany bit not null default(0))
GO

CREATE TABLE ADVERT(
	advertID int not null identity(1,1) PRIMARY KEY,
	description nvarchar(100) not null,
	memberID int not null FOREIGN KEY REFERENCES LINKEDIN_MEMBERS(memID)
)


/***************************** TEACHS_ON TABLE (RELATION BETWEEN PROFESSOR AND COURSE TABLES) ************************/
CREATE TABLE TEACHS_ON(
	profID int NOT NULL FOREIGN KEY REFERENCES PROFESSOR (profID) ,
	courseID int NOT NULL FOREIGN KEY REFERENCES COURSE (courseID) ,
 CONSTRAINT PK_TEACHS_ON PRIMARY KEY CLUSTERED (profID ASC,courseID ASC))

GO


/***************************** REGISTRATION TABLE (RELATION BETWEEN DEPARTMENT AND STUDENT TABLES) ************************/
CREATE TABLE REGISTRATION(
	studentID int NOT NULL FOREIGN KEY REFERENCES STUDENT (studentID),
	deptID int NOT NULL FOREIGN KEY REFERENCES DEPARTMENT (deptID),
 CONSTRAINT PK_REGISTRATION PRIMARY KEY CLUSTERED (studentID ASC,deptID ASC))

GO

/***************************** REGISTRATION TABLE (RELATION BETWEEN DEPARTMENT AND STUDENT TABLES) ************************/
CREATE TABLE HAS(
	courseID int NOT NULL FOREIGN KEY REFERENCES COURSE (courseID),
	deptID int NOT NULL FOREIGN KEY REFERENCES DEPARTMENT (deptID)
	 CONSTRAINT PK_HAS PRIMARY KEY CLUSTERED (courseID ASC,deptID ASC))

GO

/***************************** REGISTRATION TABLE (RELATION BETWEEN DEPARTMENT AND STUDENT TABLES) ************************/
CREATE TABLE WORKS_ON(
	profID int NOT NULL FOREIGN KEY REFERENCES PROFESSOR (profID),
	deptID int NOT NULL FOREIGN KEY REFERENCES DEPARTMENT (deptID),
	beginDate date DEFAULT GETDATE(),
 CONSTRAINT PK_WORKSFOR PRIMARY KEY CLUSTERED (profID ASC,deptID ASC))

GO
/***************************** ENROLL TABLE (RELATION BETWEEN UNDERGRADUATE AND COURSE TABLES) ************************/
CREATE TABLE ENROLL(
	studentID int NOT NULL FOREIGN KEY REFERENCES UNDERGRADUATE (studentID),
	courseID int NOT NULL   FOREIGN KEY REFERENCES COURSE (courseID),
	year int NOT NULL,
 CONSTRAINT PK_ENROLL PRIMARY KEY CLUSTERED (studentID ASC,courseID ASC,year ASC)) 
GO
/***************************** REGULAR TABLE (RELATION BETWEEN UNDERGRADUATE AND COURSE TABLES) ************************/
CREATE TABLE REGULAR(
	studentID int NOT NULL FOREIGN KEY REFERENCES UNDERGRADUATE (studentID) ,
	pastCourseID int NOT NULL  FOREIGN KEY REFERENCES COURSE (courseID) ,
 CONSTRAINT PK_REGULAR PRIMARY KEY CLUSTERED (studentID ASC,pastCourseID ASC)) 
GO
/***************************** IRREGULAR TABLE (RELATION BETWEEN UNDERGRADUATE AND COURSE TABLES) ************************/
CREATE TABLE IRREGULAR(
	studentID int NOT NULL FOREIGN KEY REFERENCES UNDERGRADUATE (studentID) ,
	failCourseID int NOT NULL  FOREIGN KEY REFERENCES COURSE (courseID) 
 CONSTRAINT PK_IRREGULAR PRIMARY KEY CLUSTERED (studentID ASC,failCourseID ASC)) 
GO

/***************************** members TABLE (RELATION BETWEEN UNDERGRADUATE AND FACEBOOKPAGE TABLES) ************************/
CREATE TABLE MEMBERS(
	studentID int NOT NULL FOREIGN KEY REFERENCES UNDERGRADUATE (studentID) ,
	pageID int NOT NULL  FOREIGN KEY REFERENCES FACEBOOKPAGE (pageID) 
 CONSTRAINT PK_MEMBERS PRIMARY KEY CLUSTERED (studentID ASC,pageID ASC)) 
GO

/***************************** invite TABLE (RELATION BETWEEN LINKEDIN_MEMBERS TABLES) ************************/
CREATE TABLE INVITE(
	inviterID int NOT NULL FOREIGN KEY REFERENCES LINKEDIN_MEMBERS (memID) ,
	invitedID int NOT NULL  FOREIGN KEY REFERENCES LINKEDIN_MEMBERS (memID) 
 CONSTRAINT PK_INVITE PRIMARY KEY CLUSTERED (inviterID ASC,invitedID ASC)) 
GO

CREATE TABLE APPLICANT(
	applicantID int not null foreign key references LINKEDIN_MEMBERS(memID),
	advertID int not null foreign key references ADVERT(advertID),
	CONSTRAINT PK_APPLICANT PRIMARY KEY CLUSTERED (applicantID ASC,advertID ASC) 	
)

GO
/*******************************************************************/
/******************* END TABLES **********************************/
/******************************************************************/




/*******************************************************************/
/******************* CONSTRAINTS **********************************/
/******************************************************************/

/****** ACADEMIC_UNIT ************/
ALTER TABLE ACADEMIC_UNIT  WITH CHECK ADD  CONSTRAINT FK_ACADEMIC_UNIT_PROFESSOR FOREIGN KEY(deanID)
REFERENCES PROFESSOR (profID)
GO







/*******************************************************************/
/******************* END CONSTRAINTS **********************************/
/******************************************************************/








/*******************************************************************/
/******************* TRIGGERS TRIGGERS **********************************/
/******************************************************************/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/***************************** ectsUpdate ************************/
CREATE TRIGGER ectsUpdate
on UNDERGRADUATE
AFTER UPDATE 
as
	declare @oldEcts int, @newisRegular int , @sID int
	
	select @newisRegular = isRegular from inserted
	select @sID = studentID from inserted
	select @oldEcts = ECTS from UNDERGRADUATE WHERE studentID = @sID

BEGIN
	if @newisRegular=0 and @oldEcts = 30
		begin
			update UNDERGRADUATE set ECTS = 42 where studentID = @sID
		end
	else if @newisRegular=1 and @oldEcts = 42
		begin
			update UNDERGRADUATE set ECTS = 30 where studentID = @sID
		end

END


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/***************************** checkEcts ************************/

CREATE TRIGGER checkEcts
on ENROLL
FOR INSERT 
AS
DECLARE @essentialECTS int, @totalECTS int,@sID int,@courseID int,@year int,@semester nvarchar(6),@courseECTS int

select @sID=studentID , @courseID=courseID ,@year =year from inserted
select @essentialECTS= ects from UNDERGRADUATE where studentID = @sID
select @semester =  semester , @courseECTS = ECTS from COURSE WHERE COURSE.courseID =@courseID
select @totalECTS = sum(C.ECTS) from COURSE AS C,ENROLL AS E WHERE E.year = @year AND C.semester = @semester AND C.courseID= E.courseID AND E.studentID=@sID

BEGIN
	IF @essentialECTS < (@totalECTS)
	begin
		RAISERROR('Bu dönem alabileceğiniz maximum krediyi aştınız',12,1);
		rollback
	end
END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**************************** irregularAdd oparation for IRREGULAR *********************/

CREATE TRIGGER irregularAdd
on IRREGULAR
AFTER INSERT
AS
DECLARE @sID int
select @sID = studentID from inserted
BEGIN 
	if (select count(*) from IRREGULAR where studentID = @sID) = 1
	begin
		update UNDERGRADUATE SET isRegular = 0 where studentID = @sID
	end
END

GO
/**************************** regularAdd oparation for REGULAR *********************/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER regularAdd
on REGULAR
AFTER INSERT
AS
DECLARE @sID int, @cID int  
select @sID = studentID , @cID = pastCourseID from inserted
BEGIN 
	IF EXISTS (select *  from IRREGULAR where studentID = @sID AND failCourseID = @cID)
	BEGIN
		DELETE FROM IRREGULAR where studentID = @sID AND failCourseID = @cID
	END

	if NOT EXISTS(select * from IRREGULAR Where studentID = @sID)
	begin
		UPDATE UNDERGRADUATE SET isRegular = 1 where studentID = @sID
	end 
END


GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**************************** addMembers oparation for REGULAR *********************/
	
	
CREATE TRIGGER addMembers
on ENROLL
AFTER INSERT
AS
declare @cID int, @sID int
select @sID = studentID ,@cID = courseID from inserted
BEGIN 
	IF not exists (select * from MEMBERS Where pageID= @cID and studentID = @sID)
	begin
		INSERT INTO MEMBERS VALUES (@sID,@cID) 
	end
END

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**************************** delete oparation *********************/

CREATE TRIGGER deleteOparation_STUDENT
on STUDENT
AFTER DELETE
AS
declare @PID int
select @PID = personID FROM deleted
BEGIN
	DELETE FROM PERSON WHERE personID = @PID
END

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER deleteOparation_PROF
on PROFESSOR
AFTER DELETE
AS
declare @PID int
select @PID = personID FROM deleted
BEGIN
	DELETE FROM PERSON WHERE personID = @PID
END

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER deleteOparation_UNDERGRADUATE
on UNDERGRADUATE
AFTER DELETE
AS
declare @sID int
select @sID = studentID FROM deleted
BEGIN
	DELETE FROM STUDENT WHERE studentID = @sID
END

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE TRIGGER deleteOparation_GRADUATE
on GRADUATE
AFTER DELETE
AS
declare @sID int
select @sID = studentID FROM deleted
BEGIN
	DELETE FROM STUDENT WHERE studentID = @sID
END

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE TRIGGER facePageCreate
on TEACHS_ON
AFTER INSERT
AS 
DECLARE @cID int, @aID int, @cName nvarchar(50)
select @cID = courseID , @aID = profID from inserted
select @cName = name from COURSE WHERE courseID = @cID
 
BEGIN
	IF NOT EXISTS(select pageID from FACEBOOKPAGE where pageID = @cID)
	begin
		INSERT INTO FACEBOOKPAGE (pageID,name, adminID) values (@cID,@cName,@aID)
	end
END

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER addLinkedin
ON PERSON
AFTER INSERT
as
DECLARE @pID int, @name nvarchar(50) , @mailAdress nvarchar(50)
select @pID = personID , @name = name from inserted
BEGIN
	SET @mailAdress =  CONVERT(nvarchar(30),@pID)+'@ege.edu.tr'
	IF @pID <28
	begin	
		INSERT INTO LINKEDIN_MEMBERS (memName,personID,mailAdress) values(@name,@pID,@mailAdress)
	END
	ELSE IF @pID %3 =0
		BEGIN
			INSERT INTO LINKEDIN_MEMBERS (memName,personID,mailAdress) values(@name,@pID,@mailAdress)
		END
END

GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER delete_IRREGULAR
ON IRREGULAR
AFTER DELETE 
AS
BEGIN
	IF NOT EXISTS(select * from IRREGULAR WHERE studentID = (select studentID FROM deleted))
	BEGIN
		UPDATE UNDERGRADUATE SET isRegular = 1 WHERE studentID = (select studentID FROM deleted)
	END
END

GO


/*******************************************************************/
/******************* END TRIGGERS **********************************/
/******************************************************************/