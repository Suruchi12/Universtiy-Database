--SURUCHI SINGH
--SUID : 755238759
--Project 2 : University Database 
/*
   I have used the instructor's solution for the database design because my design did not work correctly for 
   Prerequistes, Major and Minor Courses, Benefits offered for the employee and the student status'.
   These were the crucial parts of the database and my design could not effectively handle them. Any changes that 
   I had made were made with the help of the instrutor's solution and ended up being similar to it.
*/
--CREATE SCHEMA Project2;
--************************************************
--CREATING TABLES
--************************************************


CREATE TABLE Project2.Addresses(

	AddressID     INTEGER        PRIMARY KEY    IDENTITY(1,1),
	Street1       VARCHAR(100)   NOT NULL,
	Street2       VARCHAR(100)	 NULL,
	City          VARCHAR(50)    NOT NULL,
	State         VARCHAR(50)    NOT NULL,
	ZIP           VARCHAR(10)    NOT NULL,
);

CREATE TABLE Project2.People(

	PersonID     INTEGER        PRIMARY KEY    IDENTITY(1,1),
	NTID         VARCHAR(20)    NOT NULL,
	FirstName    VARCHAR(50)    NOT NULL,
    LastName     VARCHAR(50)    NOT NULL,
	Password     VARCHAR(20)	NULL		   CHECK (Password>=6),
	DOB          DATETIME       NOT NULL,
	SSN          VARCHAR(10)    NULL,
	HomeAddress  INTEGER        NOT NULL       REFERENCES Project2.Addresses(AddressID),
	LocalAddress INTEGER        NULL           REFERENCES Project2.Addresses(AddressID),
	IsActive     BIT    NOT NULL
);
CREATE TABLE Project2.JobInformation(
 
	JobID             INTEGER         PRIMARY KEY    IDENTITY(1,1),
	JobDescription    VARCHAR(1000)   NOT NULL,
	JobRequirements   VARCHAR(1000)   NULL,
	MinPay            DECIMAL(12,2)   NOT NULL       CHECK (Minpay >= 0),
    MaxPay            DECIMAL(12,2)   NOT NULL       CHECK (Maxpay >= 0),
	UnionJob          BIT			  NOT NULL
);

CREATE TABLE Project2.BenefitSelection(

	BenefitSelectionID	INTEGER       PRIMARY KEY     IDENTITY(1,1),
	BenefitSelection	VARCHAR(100)  NOT NULL,
);

CREATE TABLE Project2.Benefits(

	BenefitID           INTEGER        PRIMARY KEY    IDENTITY(1,1),
	BenefitCost         INTEGER        NOT NULL,
	BenefitSelection    INTEGER        NOT NULL       REFERENCES Project2.BenefitSelection(BenefitSelectionID),
    BenefitDescription  VARCHAR(1000)  NULL,
);

CREATE TABLE Project2.EmployeeInfo(

	EmployeeID		INTEGER        PRIMARY KEY    IDENTITY(1,1),
	PersonID		INTEGER        NOT NULL       REFERENCES Project2.People(PersonID),
	YearlyPay		DECIMAL(12,2)  NOT NULL		  CHECK(YearlyPay>0),
	HealthBenefits	INTEGER        NOT NULL       REFERENCES Project2.Benefits(BenefitID),
	VisionBenefits	INTEGER        NOT NULL       REFERENCES Project2.Benefits(BenefitID),
	DentalBenefits	INTEGER        NOT NULL       REFERENCES Project2.Benefits(BenefitID),
	JobInformation	INTEGER        NOT NULL       REFERENCES Project2.JobInformation(JobID)
);

CREATE TABLE Project2.CourseCatalogue(

	CourseCode		VARCHAR(20)		NOT NULL,
	CourseNumber	INTEGER			NOT NULL,
	CourseTitle		VARCHAR(100)	NOT NULL,
	CourseDesc		VARCHAR(500)	NULL,
	 
	PRIMARY KEY (CourseCode,CourseNumber)
);


CREATE TABLE Project2.Buildings(

	ID				INTEGER		 PRIMARY KEY	IDENTITY(1,1),
	BuildingName	VARCHAR(100)
);

CREATE TABLE Project2.ProjectorInfo(

	ProjectorID		INTEGER		PRIMARY KEY		IDENTITY(1,1),
	ProjectorText	VARCHAR(100)
);

CREATE TABLE Project2.SemesterText(
	SemesterTextID	INTEGER		 PRIMARY KEY		IDENTITY(1,1),
	SemesterText	VARCHAR(50)	 NOT NULL
);

CREATE TABLE Project2.SemesterInfo(
	SemesterID	INTEGER		PRIMARY KEY		IDENTITY(1,1),
	Semester	INTEGER		REFERENCES Project2.SemesterText(SemesterTextID),
	Year		INTEGER		NOT NULL,
	FirstDay	DATETIME	NOT NULL,
	LastDay		DATETIME	NOT NULL
);

CREATE TABLE Project2.DayOfWeek(
	Id		INTEGER		PRIMARY KEY		IDENTITY(1,1),
	Week	VARCHAR(50)	NOT NULL
);

CREATE TABLE Project2.ClassRoom(

	ClassRoomID		VARCHAR(20)		PRIMARY KEY,
	Building		INTEGER		    NOT NULL		REFERENCES Project2.Buildings(Id),
	RoomNumber		VARCHAR(20)		NOT NULL,
	MaximumSeating	INTEGER			NOT NULL		CHECK(MaximumSeating>=0),
	Projector		INTEGER			NOT NULL		REFERENCES Project2.ProjectorInfo(ProjectorID),
	WhiteBoardCount INTEGER			NOT NULL,
	OtherAV			VARCHAR(20)		NULL
);

CREATE TABLE Project2.CourseSchedule(

	CourseScheduleID	INTEGER			PRIMARY KEY		IDENTITY(1,1),
	CourseCode			VARCHAR(20)		NOT NULL,		
	CourseNumber		INTEGER			NOT NULL,		
	NumberOfSeats		INTEGER			NOT NULL		CHECK (NumberOfSeats>=0),
	Location			VARCHAR(20)	    NULL		    REFERENCES Project2.ClassRoom(ClassRoomID),
	Semester			INTEGER		    NOT NULL		REFERENCES Project2.SemesterInfo(SemesterID),

	FOREIGN KEY(CourseCode, CourseNumber) REFERENCES Project2.CourseCatalogue(CourseCode, CourseNumber)
);

CREATE TABLE Project2.Prerequisites(

	ParentCode		VARCHAR(20)		NOT NULL,	
	ParentNumber	INTEGER			NOT NULL,	
	ChildCode		VARCHAR(20)		NOT NULL,	
	ChildNumber		INTEGER			NOT NULL,	

	PRIMARY KEY (ParentCode, ParentNumber,ChildCode,ChildNumber),

	FOREIGN KEY(ParentCode, ParentNumber) REFERENCES Project2.CourseCatalogue(CourseCode, CourseNumber),
	FOREIGN KEY(ChildCode, ChildNumber) REFERENCES Project2.CourseCatalogue(CourseCode, CourseNumber),

);

CREATE TABLE Project2.TeachingAssignment(

	EmployeeID			INTEGER		NOT NULL	REFERENCES Project2.EmployeeInfo(EmployeeID),
	CourseScheduleID	INTEGER		NOT NULL	REFERENCES Project2.CourseSchedule(CourseScheduleID),
	
	PRIMARY KEY (EmployeeID, CourseScheduleID)
);


CREATE TABLE Project2.StudentStatus(

	StudentStatusID		INTEGER			PRIMARY KEY		IDENTITY(1,1),
	StudentStatus		VARCHAR(20)		NOT NULL
);

CREATE TABLE Project2.StudentInfo(

	StudentID		INTEGER		PRIMARY KEY,
	PersonID		INTEGER 	NOT NULL	REFERENCES Project2.People(PersonID),
	StudentStatusID	INTEGER		NOT NULL	REFERENCES Project2.StudentStatus(StudentStatusID)	
);

CREATE TABLE Project2.College(

	CollegeID	VARCHAR(50)		PRIMARY KEY,
	CollegeName	VARCHAR(100)	NOT NULL
);

CREATE TABLE Project2.AreaOfStudy(

	AreaOfStudyID	INTEGER			PRIMARY KEY,
	StudyTitle		VARCHAR(20)		NOT NULL,
	CollegeID		VARCHAR(50)		NOT NULL	REFERENCES Project2.College(CollegeID)
);

CREATE TABLE Project2.StudentAreaOfStudy(

	AreaOfStudyID	INTEGER		PRIMARY KEY,
	StudentID		INTEGER		NOT NULL	REFERENCES Project2.StudentInfo(StudentID),
	AreaID			INTEGER		NOT NULL	REFERENCES Project2.AreaOfStudy(AreaOfStudyID),
	IsMajor			BIT			NOT NULL
);

CREATE TABLE Project2.Grades(

	GradeID		INTEGER			PRIMARY KEY		IDENTITY(1,1),
	Grade		VARCHAR(50)	    NOT NULL		
);

CREATE TABLE Project2.StudentGradingStatus(

	StudentStatusID		INTEGER		PRIMARY KEY		IDENTITY(1,1),
	StudentStatus		VARCHAR(50)
);


CREATE TABLE Project2.CourseEnrollment(

	EnrollmentID	INTEGER			PRIMARY KEY,
	CourseID		INTEGER			NOT NULL	REFERENCES Project2.CourseSchedule(CourseScheduleID),
	StudentID		INTEGER			NOT NULL	REFERENCES Project2.StudentInfo(StudentID),
	StatusID		INTEGER			NOT NULL	REFERENCES Project2.StudentGradingStatus(StudentStatusID),
	GradeID			INTEGER			NULL		REFERENCES Project2.Grades(GradeID)
);


CREATE TABLE Project2.CourseDailySchedule(
	DailyID		INTEGER 	PRIMARY KEY		 IDENTITY(1,1),
	CourseID	INTEGER	    REFERENCES Project2.CourseSchedule(CourseScheduleID)	NOT NULL,
	DayOfWeek	INTEGER	    REFERENCES Project2.DayOfWeek(Id)						NOT NULL,
	StartTime	TIME		NOT NULL,
	EndTime		TIME		NOT NULL
);



--**********************************************************
--INSERTION OF DATA
--**********************************************************

INSERT INTO Project2.College(CollegeID, CollegeName)
	VALUES	('01-EU', 'Beauxbatons Academy of Magic'),
			('02-BR', 'Castelobruxo'),
			('03-BG', 'Durmstrang Institute'),
			('04-GB', 'Hogwarts School of Witchcraft and Wizardry'),
			('05-US', 'Ilvermorny School of Witchcraft and Wizardry'),
			('06-RU', 'Koldovstoretz'),
			('07-JP', 'Mahoutokoro School of Magic'), 
			('08-CF', 'Uagadou School of Magic');



INSERT INTO Project2.Addresses(Street1,Street2,City,State,ZIP)
	VALUES	('Andorra','Basque','Pyrenees','France','75116'),
			('Amazon Rainforest',' Manaus','Brazil','South America','13010'),
			('Galdhopiggen','Gudbrandsdalen','Norway','Scandanavia','54977'),
			('Highlands','North-West of the Highland Boundary Fault',' Dufftown','Scotland','06264'),
			('Mount Greylock','New England','Berkshire County','Massachusetts','01062'),
			('Mount Elbrus','Caucasus','Scythia','Russia','555'),
			('Minami Iwo Jima','Nanpō Islands','Iwo Jima','Japan','610-0121'),
			('Rwenzori Mountains','Mountains of the Moon','Uganda','Africa','BP 120'),
			('Scamader Residence','English Channel coast','Dorset','England','05251'),
			('679 Brownstone House','West 24th Street','New York City','New York','10011'),
			('Shell Cottage','Tinworth','Cornwall','England','12518'),
			('Philosophers Residence','Plymouth','Devon','England','EX16 8QF'),
			('Godrics Hollow','West Country','England','United Kingdom','E12005');


INSERT INTO Project2.AreaOfStudy(AreaOfStudyID,StudyTitle,CollegeID)
	VALUES	(1,'Muggle Studies','06-RU'),
			(2,'Ancient Studies','08-CF'),
			(3,'Magical Creatures','02-BR'),
			(4,'Flying','07-JP'),
			(5,'Ghoul Studies','03-BG'),
			(6,'Xylomancy','01-EU'),
			(7,'Magical Theory','04-GB'),
			(8,'Art','05-US'),
			(9,'Music','01-EU');

INSERT INTO Project2.Grades(Grade)
	VALUES	('Outstanding'),
			('Exceeding Expectations'),
			('Acceptable'),
			('Poor'),
			('Dreadful'),
			('Troll');

INSERT INTO Project2.StudentGradingStatus(StudentStatus)
	VALUES	('Regular'),
			('Audit'),
			('Pass'),
			('Fail'),
			('Part-Time'),
			('Full-Time'),
			('Incomplete');

INSERT INTO Project2.Buildings(BuildingName)
	VALUES	('Gryffindor Tower'),
			('Ravenclaw Tower'),
			('Hufflepuff Basement'),
			('Slytherin Dungeon'),
			('Astronomy Tower'),
			('Hall of Hexes'),
			('Chamber of Reception'),
			('Horned Serpent Burrow'),
			('Wampus Hall'),
			('Thunderbird Tower'),
			('Pukwudgie Chamber'),
			('Greenhouse Tower'),
			('Hospital Wings');

INSERT INTO Project2.ProjectorInfo(ProjectorText)
	VALUES	('Basic'),
			('SmartBoard'),
			('BlackBoard'),
			('GreenBoard'),
			('WhiteBoard'),
			('Epson Brightlink Interactive');

INSERT INTO Project2.SemesterText(SemesterText)
	VALUES	('Autumn'),
			('Spring'),
			('Summer'),
			('Winter');		

INSERT INTO Project2.SemesterInfo(Semester,Year,FirstDay,LastDay)
	VALUES	(1,2015,'22-AUG-2015','16-DEC-2015'),
			(2,2016,'15-JAN-2016','20-APR-2016'),
			(3,2016,'21-APR-2016','21-AUG-2016'),
			(4,2017,'17-DEC-2016','14-JAN-2017'),
			(1,2017,'22-AUG-2017','16-DEC-2017'),
			(2,2018,'15-JAN-2018','20-APR-2018'),
			(3,2018,'21-APR-2018','21-AUG-2018'),
			(4,2019,'17-DEC-2018','14-JAN-2019');			

INSERT INTO Project2.DayOfWeek(Week)
	VALUES	('Monday'),
			('Tuesday'),
			('Wednesday'),
			('Thursday'),
			('Friday'),
			('Saturday'),
			('Sunday');

INSERT INTO Project2.ClassRoom(ClassRoomID,Building,RoomNumber,MaximumSeating,Projector,WhiteBoardCount,OtherAV)
	VALUES	('StoneBridge Room',1,'101-B',20,1,3,'Microphone'),
			('Room Of Requirements',6,'201-C',35,2,2,'Recorder'),
			('Room of Runes',7,'301-A',40,3,1,'Desktop'),
			('Porticus Imago',8,'A-101',25,4,0,'3-D glasses'),
			('Room of Doom',9,'3-L',55,5,4,'Assisstive Listening'),
			('Healer Room',13,'2-23-H',50,6,1,'Clickers'),
			('Constellation Room',5,'202-D',60,1,5,'Wireless Microphone'),
			('Duelling Classroom',4,'401-E',30,2,2,'Television'),
			('Conservatory Room',12,'502-C',22,3,1,'Amplifiers'),
			('Edificium Oriens',3,'205-D',64,4,5,'Analyzers'),
			('Ghoul Studies Room',10,'505-E',15,5,1,'Expendable Ears'),
			('Turris Magnus',13,'601-F',30,6,2,'Television');

INSERT INTO Project2.CourseCatalogue(CourseCode,CourseNumber,CourseTitle,CourseDesc)
	VALUES	('MGT',730,'Alchemy','Alchemy is the study of the four basic elements namely, water, fire, earth and fire. It also deals with the transmutation of substancs.'),
	        ('AST',604,'Ancient Runes','It is the study of runic scriptures, or Runology. Ancient Runes is a mostly theoretical subject that studies the ancient runic scripts of magic.'), 
			('AST',230,'Arithmancy','Arithmancy is described as predicting the future with numbers.'),
			('XYL',657,'Astronomy','Astronomy is a branch of magic that deals with stars and the movement of planets. During the exam students must fill in a blank star chart.'),
			('MGT',322,'Charms','The spells learned in Charms class are taken from textbooks. Students are taught specific wand movements and proper pronunciation.'),
			('MGT',565,'Defence Against the Dark Arts','This course teaches students to magically defend themselves against Dark Creatures, the Dark Arts, and other dark charms.'),
			('MGT',350,'Divination','Divination is a branch of magic that involves attempting to foresee the future, or gather insights into future events.'),
			('MGT',256,'Herbology','Herbology is the study of magical and mundane plants and fungi, making it the wizarding equivalent to botany.'),
			('AST',210,'History of Magic','This class is a study of magical history.'),
			('MGC',111,'Care of Magical Creatures',' In the class, students learn about a wide range of magical creatures. Students are taught about feeding, maintaining, breeding, and proper treatment of these various creatures.'),
			('MGT',641,'Transfiguration','It teaches the art of changing the form and appearance of an object.'),
			('MGT',450,'Potions','In this class, students learn the correct way to brew potions. They follow specific recipes and use various magical ingredients to create the potions.'),
			('AST',226,'Numerology','Numerology is a magical discipline relating to numbers that appears to be part of, similar to, or related to Arithmancy'),
			('MGC',715,'Magizoology','Magizoology is the study of magical creatures.');

INSERT INTO Project2.Prerequisites(ParentCode,ParentNumber,ChildCode,ChildNumber)
	VALUES	('MGT',730,'MGT',641),
			('AST',230,'AST',226),
			('XYL',657,'XYL',350),
			('MGT',565,'MGT',322),
			('MGC',715,'MGC',111),
			('MGC',715,'MGC',256),
			('AST',604,'AST',210);

INSERT INTO Project2.CourseSchedule(CourseCode,CourseNumber,NumberOfSeats,Location,Semester)
	VALUES	('AST',604,38,'Room of Runes',1),
			('MGC',256,20,'Conservatory Room',2),
			('MGT',565,30,'Room Of Requirements',1),
			('XYL',657,57,'Constellation Room',4),
			('MGT',450,22,'Porticus Imago',3),
			('MGT',730,18,'StoneBridge Room',5),
			('MGT',322,25,'Duelling Classroom',2),
			('AST',230,60,'Edificium Oriens',6);

INSERT INTO Project2.CourseDailySchedule(CourseID,DayOfWeek,StartTime,EndTime)
	VALUES	(1,1,'08:00','10:00'),
			(2,2,'11:00','13:00'),
			(3,3,'15:00','17:00'),
			(4,4,'18:00','20:00'),
			(5,5,'08:00','10:00'),
			(6,1,'17:00','20:00'),
			(7,2,'13:00','16:00'),
			(8,3,'10:00','12:00');

INSERT INTO Project2.JobInformation(JobDescription,JobRequirements,MinPay,MaxPay,UnionJob)
	VALUES	('Caretaker','In charge of overseeing the cleanliness and hygiene of Hogwarts Castle. Aside from this, they may patrol the corridors at night to make sure that no students wander in the late hours',250,300,'TRUE'),
			('Librarian','Monitoring the Library,prepare and manage the library budgets and keep the library organised, clean and neat.',500,700,'TRUE'),
			('Apparition Instructor','To teach Apparition to sixth year students.',800,1100,'FALSE'),
			('Flying Instructor','To teach Flying Classes and referee Quidditch matches. They are in charge of teaching the students on the Training Grounds.',1000,1500,'TRUE'),
			('Matron','To monitor all health at Hogwarts, heal the wounded, direct the other Healers and make health potions and ointments.',1200,1600,'TRUE'),
			('Magizoologist','A person who studies magical creatures',1300,1800,'FALSE'),
			('Choir Master','The conductor is in charge of the choir and has lessons and rehearsals in the Great Hall',500,900,'FALSE'),
			('Head of House','Person should be responsible for the one of the four Houses',300,700,'FALSE'),
			('Professor','Teaches and conducts examinations',1600,2000,'FALSE');

INSERT INTO Project2.BenefitSelection(BenefitSelection)
	VALUES	('Single'),
			('Employee Plus One'),
			('Family'),
			('Premium'),
			('Customized'),
			('Opt-Out');

INSERT INTO Project2.Benefits(BenefitCost,BenefitSelection,BenefitDescription)
	VALUES	(700,1,'The employee opts for personal health insurance coverage.'),
			(1200,2,'The employee gets health insurance coverage benefits for himself as well as one more person.'),
			(1800,3,'The employee can opt for health insurance for himself as well as his family members'),
			(2000,4,'The employee can opt for more additional benefits for longer time for himself and his family.'),
			(2500,5,'The employee can customize his health insurance plans as he sees fit.'),
			(0,6,'The employee does not use the benefits offered and prefers to get his health insurance from elsewhere.')

INSERT INTO Project2.People(NTID,FirstName,LastName,Password,DOB,SSN,HomeAddress,LocalAddress,IsActive)
	VALUES	('NAFS','Newton','Scamandar',1234560,'01-01-1897','A-100-2',9,4,'TRUE'),
			('ABPWD','Albus','Dumbledore',2345610,'11-07-1881','200-B',4,4,'FALSE'),
			('QG','Queenie','GoldStein',5612300,'02-02-1902','900-A-1',10,5,'TRUE'),
			('IS','Isolt','Sayre',6123050,'12-04-1803','1-500',5,5,'FALSE'),
			('NPF','Nicolas','Flamel',6712345,'04-03-1976','900-J',12,1,'FALSE'),
			('FVD','Fleur','Delacour',7812345,'10-30-1927','9E',11,1,'TRUE'),
			('OM','Olympe','Maxime',8976543,'05-25-1904','10-GP',1,1,'FALSE'),
			('VK','Victor','Krum',8452130,'10-06-1976','DU-09',3,3,'TRUE'),
			('IK','Igor','Karkaroff',2111011,'01-10-1961','DU-900',3,3,'FALSE'),
			('GG','Gellert','Grindelwald',4567123,'15-08-1983','DU-007',13,3,'FALSE'),
			('LB','Libatius','Borage',4671205,'12-02-1901','CA-1111',2,2,'FALSE'),
			('JC','Joao','Coelho',3456712,'03-12-1978','CA-263',2,2,'TRUE'),
			('PP','Petrova','Porshoff',6710234,'05-2-1980','KOL-1-200',6,6,'TRUE'),
			('AR','Alexandr','Romanov',4512320,'09-19-1964','KOL-2',6,6,'FALSE'),
			('BA','Babajide','Akingbade',1000001,'11-21-1990','3-UAG-11',8,8,'TRUE'),
			('AT','Adrian','Tutely',11111111,'12-23-1990','1-UAG-22',8,8,'FALSE');


INSERT INTO Project2.StudentStatus(StudentStatus)
	VALUES	('Undergraduate'),
			('Graduate'),
			('Non Matriculated'),
			('Graduated'),
			('Part-Time'),
			('Full-Time');

INSERT INTO Project2.StudentInfo(StudentID,PersonID,StudentStatusID)
	VALUES	(1,52,1),
			(2,58,2),
			(3,99,1),
			(4,101,4),
			(5,116,2),
			(6,117,4),
			(7,123,4);

INSERT INTO Project2.StudentAreaOfStudy(AreaOfStudyID,StudentID,AreaID, IsMajor)
	VALUES	(1,1,3,'TRUE'),
			(2,2,1,'TRUE'),
			(3,2,8,'FALSE'),
			(4,3,9,'TRUE'),
			(5,4,4,'TRUE'),
			(6,5,4,'TRUE'),
			(7,5,5,'FALSE'),
			(8,6,8,'TRUE'),
			(9,6,2,'FALSE'),
			(10,7,6,'TRUE'),
			(11,7,7,'FALSE');

INSERT INTO Project2.CourseEnrollment(EnrollmentID,CourseID,StudentID,StatusID,GradeID)
	VALUES	(1,2,1,7,NULL),
			(2,8,2,2,2),
			(3,7,3,1,1),
			(4,1,4,1,3),
			(5,4,5,3,4),
			(6,5,6,4,5),
			(7,4,7,3,1),
			(8,6,7,3,2),
			(9,3,6,1,3),
			(10,4,5,1,6);

INSERT INTO Project2.EmployeeInfo(PersonID,YearlyPay,HealthBenefits,VisionBenefits,DentalBenefits,JobInformation)
	VALUES	(57,1000,3,6,1,9),
			(60,800,2,1,6,6),
			(98,900,5,2,1,2),
			(100,1100,1,2,5,3),
			(102,1105,2,1,5,4),
			(115,850,1,6,6,1),
			(122,950,2,2,2,7);

INSERT INTO Project2.TeachingAssignment(EmployeeID, CourseScheduleID)
	VALUES	(1,6),
			(2,8),
			(3,7),
			(4,1),
			(5,1),
			(6,5),
			(7,4);



	ALTER TABLE Project2.Grades
            ADD CONSTRAINT DF_Grades
            DEFAULT 'Not Assigned' FOR Grade

--*************
--VIEW 1: 
			--To display the student enrollment details (Student Name, the course the student is taking along with the associated faculty , student's status in that course and their grade)
--*************


CREATE VIEW Project2.StudentAndCourse AS
		SELECT p.FirstName + ',' + p.LastName AS StudentName, cc.CourseTitle,p2.FirstName + ',' + p2.LastName AS FacultyName,s.StudentStatus, g.Grade
			   FROM Project2.CourseEnrollment ce,Project2.People p, Project2.StudentInfo si,Project2.CourseCatalogue cc,Project2.CourseSchedule cs, Project2.StudentGradingStatus s, Project2.Grades g, Project2.TeachingAssignment ta ,Project2.People p2, Project2.EmployeeInfo e
			   WHERE ce.StudentID=si.StudentID
					AND si.PersonID=p.PersonID
					AND ce.CourseID = cs.CourseScheduleID AND cs.CourseCode = cc.CourseCode AND cs.CourseNumber =cc.CourseNumber
					AND ce.StatusID = s.StudentStatusID
					AND ce.GradeID = g.GradeID
					AND ta.EmployeeID = e.EmployeeID
					AND e.PersonID = p2.PersonID
					AND ta.CourseScheduleID = cs.CourseScheduleID; 


/*Execution Query*/

SELECT * 
		  FROM Project2.StudentAndCourse;


--***********
--VIEW 2: 
		--To display Coursedetails including the semester, faculty name, location and its prerequisite
--**********

CREATE VIEW Project2.CourseScheduleInfo AS
		SELECT c.CourseTitle AS Course, cp.CourseTitle AS Prerequisite, b.BuildingName AS Location, st.SemesterText AS Semester, prof.LastName + ',' + prof.FirstName AS Faculty
			FROM Project2.CourseCatalogue c 
				INNER JOIN Project2.Prerequisites p 
					ON c.CourseCode = p.ParentCode AND c.CourseNumber = p.ParentNumber
				INNER JOIN Project2.CourseCatalogue cp
					ON cp.CourseCode = p.ChildCode AND cp.CourseNumber = p.ChildNumber
				INNER JOIN Project2.CourseSchedule cs
					ON cs.CourseCode = c.CourseCode AND cs.CourseNumber = c.CourseNumber
				INNER JOIN Project2.ClassRoom cr
					ON cs.Location = cr.ClassRoomID
				INNER JOIN Project2.Buildings b
					ON cr.Building = b.ID
				INNER JOIN Project2.SemesterInfo si
					ON si.SemesterID =  cs.Semester
				INNER JOIN Project2.SemesterText st
					ON st.SemesterTextID = si.SemesterID
				INNER JOIN Project2.TeachingAssignment ta
					ON ta.CourseScheduleID = cs.CourseScheduleID
				INNER JOIN Project2.EmployeeInfo e
					ON e.EmployeeID = ta.EmployeeID
				INNER JOIN Project2.People prof
					ON prof.PersonID = e.PersonID;

/*Execution Query*/
SELECT * 
		  FROM Project2.CourseScheduleInfo;

				
--**********
--VIEW 3: 
		--Displays Employee Information-name,benefits offered,salary and their job information
--**********

CREATE VIEW Project2.EmployeeDetails AS
		SELECT p.FirstName + ',' + p.LastName AS EmployeeName, e.YearlyPay, bs1.BenefitSelection AS HealthBenefits,bs2.BenefitSelection AS VisionBenefits,bs3.BenefitSelection AS DentalBenefits,j.JobDescription
			FROM Project2.EmployeeInfo e 
				INNER JOIN Project2.People p
					ON e.PersonID = p.PersonID
				INNER JOIN Project2.JobInformation j
					ON j.JobID = e.JobInformation
				INNER JOIN Project2.Benefits hb
					ON e.HealthBenefits = hb.BenefitID
				INNER JOIN Project2.BenefitSelection bs1
					ON hb.BenefitSelection = bs1.BenefitSelectionID
				INNER JOIN Project2.Benefits vb
					ON e.VisionBenefits = vb.BenefitID 
				INNER JOIN Project2.BenefitSelection bs2
					ON vb.BenefitSelection = bs2.BenefitSelectionID
				INNER JOIN Project2.Benefits db
					ON e.DentalBenefits = db.BenefitID 
				INNER JOIN Project2.BenefitSelection bs3
					ON db.BenefitSelection = bs3.BenefitSelectionID
			WHERE YEAR(p.DOB) > 1880;

/*Execution Query*/
SELECT * 
			FROM Project2.EmployeeDetails;


--**********
--VIEW 4: 
         --Student Details dealing with their major they have taken from diffeent colleges in the university,days they attend and their status
--*********

CREATE VIEW Project2.StudentCollege AS
		SELECT  TOP(2) p.FirstName + ',' + p.LastName AS StudentName, a.StudyTitle, c.CollegeName , s.StudentStatus, dw.Week
			FROM Project2.StudentInfo si
				INNER JOIN Project2.People p
					ON si.PersonID = p.PersonID
				INNER JOIN Project2.StudentAreaOfStudy sa
					ON sa.StudentID = si.StudentID
				INNER JOIN Project2.AreaOfStudy a
					ON a.AreaOfStudyID = sa.AreaID
				INNER Join Project2.College c
					ON c.CollegeID = a.CollegeID
				INNER JOIN Project2.StudentStatus s
					ON s.StudentStatusID = si.StudentStatusID
				INNER JOIN Project2.CourseEnrollment ce
					ON ce.StudentID = si.StudentID
				INNER JOIN Project2.CourseSchedule cs
					ON cs.CourseScheduleID = ce.CourseID
				INNER JOIN Project2.CourseDailySchedule cds
					ON cs.CourseScheduleID = cds.CourseID
				INNER JOIN Project2.DayOfWeek dw
					ON dw.Id = cds.DayOfWeek
			WHERE s.StudentStatus = 'Undergraduate' AND sa.IsMajor = 1;


/*Execution Query*/
SELECT * 
		FROM Project2.StudentCollege;



/*Stored Procedure 1:
		To change the existing status of a student enrolled in a class to 'fail' if he has received poor grades in that course.
		The procedure checks if the student is enrolled into the course and has a valid student status before making any changes based on their grade.
*/

 CREATE PROCEDURE Project2.StudentEnrolled(@CourseId AS INTEGER, @StudentId AS INTEGER,
									       @StatusId	AS INTEGER, @Grade AS INTEGER)
	AS
		IF(NOT EXISTS(SELECT 1 FROM Project2.CourseEnrollment WHERE CourseID = @CourseId))
			BEGIN

				PRINT 'Error: The course does not exist.';
			END
		ELSE IF(NOT EXISTS(SELECT 1 FROM Project2.CourseEnrollment WHERE CourseID = @CourseId AND StudentID = @StudentId))
			BEGIN
				
				PRINT 'Error: The student is not enrolled in this course.';
			END
		ELSE IF(NOT EXISTS(SELECT 1 FROM Project2.CourseEnrollment WHERE CourseId = @CourseId AND StatusId = @StatusId))
			BEGIN

				PRINT 'Error: The student enrolled in this course does not have this status.';
			END
		ELSE
			BEGIN 
				DECLARE @oldstatusname AS VARCHAR(20)
				SET @oldstatusname = (SELECT StudentStatus 
												FROM Project2.CourseEnrollment ce INNER JOIN Project2.StudentGradingStatus s
												ON ce.StatusID = s.StudentStatusID
												AND StudentID = @StudentId
												AND CourseID = @CourseId
												AND StatusID = @StatusId)

				DECLARE @newstatusname AS VARCHAR(20)
				SET @newstatusname = (SELECT StudentStatus 
												FROM Project2.StudentGradingStatus sgs
												WHERE sgs.StudentStatusID = 4) 

				IF @Grade = (SELECT GradeID 
										   FROM Project2.Grades 
										   WHERE  @Grade = GradeID AND GradeID IN (1,2,3))
					BEGIN
						PRINT 'Student has Passed the class'
					END
				ELSE
					BEGIN
						UPDATE Project2.CourseEnrollment 
							SET StatusID = 4
							WHERE @StudentId= StudentID
							AND @CourseID = CourseID
							AND @StatusId = StatusID

							PRINT 'Students status has changed from  ' + CAST(@oldstatusname AS VARCHAR(20)) + ' to  ' + CAST(@newstatusname AS VARCHAR(20))
					END
	END;

/*Execution Query*/
EXEC Project2.StudentEnrolled @CourseId =8 , @StudentId =2, @StatusId	=2, @Grade= 2





/*Stored Procedure 2:
				The procedure checks if the course exists and has an associated faculty and checks if the 
				number of seats entered by the users is sufficient for the course. If it is not, it adds a seat to the course.
			*/

CREATE PROCEDURE Project2.CourseSeating(@CourseId AS INTEGER, @EmployeeId AS INTEGER,
									    @NumberOfSeats AS INTEGER)
	AS
		IF(NOT EXISTS(SELECT 1 FROM Project2.TeachingAssignment WHERE EmployeeID = @EmployeeId))
			BEGIN

				PRINT 'Error: The teacher does not exist.';
			END

		ELSE IF(NOT EXISTS(SELECT 1 FROM Project2.CourseSchedule cs, Project2.TeachingAssignment ta WHERE cs.CourseScheduleID = @CourseId AND ta.EmployeeID = @EmployeeId))
			BEGIN
				
				PRINT 'Error: The teacher does not teach this course.';
			END
	
		DECLARE @maxseating AS INTEGER
		DECLARE @incr AS INTEGER
		SET @maxseating = (SELECT NumberOfSeats FROM Project2.CourseSchedule WHERE CourseScheduleID = @CourseId)

		IF @NumberOfSeats<=@maxseating
			BEGIN
				  PRINT 'The seats you have entered is sufficient for the class'
			END

		ELSE
			BEGIN	
				
				SET @incr = @maxseating +1 

				UPDATE Project2.CourseSchedule
					SET NumberOfSeats = NumberOfSeats+1
					WHERE CourseScheduleID = @CourseId

				PRINT 'The total strenght of class was : ' + CAST(@maxseating AS VARCHAR(20)) + 'and now, it is :' + CAST(@incr AS VARCHAR(20))

			END;

/*Execution Query*/
EXEC Project2.CourseSeating @CourseId =1, @EmployeeId =4, @NumberOfSeats =40;





/*FUNCTION : 1
         --Keeps track of all the courses each faculty teaches in the university.
*/

CREATE FUNCTION Project2.TeacherCourse()
	RETURNS @return TABLE(FacultyName VARCHAR(100),CourseName VARCHAR(110))
	BEGIN
		INSERT INTO @return
		SELECT p.FirstName + ' ' + p.LastName, cc.CourseTitle
			FROM Project2.People p LEFT OUTER JOIN Project2.EmployeeInfo e
				ON p.PersonID = e.PersonID
				INNER JOIN Project2.TeachingAssignment ta 
				ON ta.EmployeeId = e.EmployeeID
				INNER JOIN Project2.CourseSchedule cs
				ON ta.CourseScheduleID = cs.CourseScheduleID
				INNER JOIN Project2.CourseCatalogue cc
				ON cc.CourseCode = cs.CourseCode
				AND cc.CourseNumber =cs.CourseNumber
			GROUP BY p.FirstName + ' ' + p.LastName, cc.CourseTitle
		RETURN
	END;
	
/*Execution Query*/

SELECT * 
		  FROM Project2.TeacherCourse();


/* FUNCTION 2:
				Since, the grades assigned to each student is not in numerical format, if one desires 
				to know in what range on do their grades fall into, then the function below
				provides the student name, grades and their assocaiated range on a scale of 100
*/


CREATE FUNCTION Project2.StudentGrades(@StudentID AS INTEGER)
	RETURNS @Grades TABLE(StudentName VARCHAR(100), Grade VARCHAR(100), AssociatedRange VARCHAR(100))
	BEGIN
		
		DECLARE @AssociatedRange AS VARCHAR(50)
		DECLARE @Student AS VARCHAR(50)
		DECLARE @Grade AS VARCHAR(50)

		SELECT @AssociatedRange = g.Grade FROM Project2.Grades g WHERE g.GradeID = (SELECT ce.GradeID FROM Project2.CourseEnrollment ce WHERE ce.StudentID = @StudentID)	
		
		SET @Grade = @AssociatedRange
		
		SELECT @Student = p.FirstName + ' ' + p.LastName FROM Project2.People p INNER JOIN Project2.StudentInfo si ON si.PersonID = p.PersonID AND si.StudentID = @StudentID
		
		SELECT @AssociatedRange =
			CASE
					WHEN @AssociatedRange = 'Outstanding' THEN '95-100'
					WHEN @AssociatedRange = 'Exceeding Expectations' THEN '90-95'
					WHEN @AssociatedRange = 'Acceptable' THEN '80-90'
					WHEN @AssociatedRange = 'Poor' THEN '70-80'
					WHEN @AssociatedRange = 'Dreadful' THEN '60-70'
					WHEN @AssociatedRange = 'Troll' THEN '50-60' 
					ELSE 'Not Assigned'
			
			END

		INSERT INTO @Grades
			SELECT @Student,@Grade,@AssociatedRange		
		
		RETURN
			
	END;

/*Execution Query*/
SELECT * 
			FROM  Project2.StudentGrades(2);




