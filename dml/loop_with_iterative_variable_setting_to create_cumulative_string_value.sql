/*
** Created by: Alex Newsham
** Created on: 19/07/2024
**    Purpose: To demonstrate a looping solution for concatenating strings 
**             (Example: Concatenate research study-specific information regarding study status and study sampling )
**       Tags: #WHILE #LOOP; #VARIABLE #STRING #CONCATENATION 
**
**
*/

--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
-- CREATE TABLES OF TEST DATA TO USE FOR THE LOOPS
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

-- DECLARE TABLE VARIABLES
declare @PIIList table (SubjectId int, ParticipantType varchar(50), IndexId int identity(1,1))
declare @t1 table (SubjectId int, StudyId int, StudyName varchar(50), StudyStatus int, SampleNumber int, IndexId int identity(1,1))
declare @studies table (SubjectId int ,Studies varchar(max), StudySamplingTotal varchar(max))

-- INSERT PARTICIPANT INFO TO GET LIST OF PARTICIPANTS
insert into @PIIList (SubjectId, ParticipantType)
values (111, 'Mother'), (112, 'Child')

-- INSERT PARTICIPATION INFORMATION
insert into @t1 (SubjectId, StudyId, StudyName, StudyStatus, SampleNumber)
values(111, 1, 'Cohort-1',1, 8), (111, 3, 'Cohort-2', 1, 0), (112, 1, 'Cohort-1', 1, 5),(112, 3, 'Cohort-2', 0, 1)

-- SENSE CHECK TABLE POPULATION - COMMENT IN IF NEEDED
--select * from @t1
--select * from @PIIList

-- DECLARE VARIABLES USED BY THE LOOPS
declare @iCount int, @iCountMax int, @subjectId int, @studyId int, @studyCountMax int, @subCount int, 
        @study varchar(50), @studyStr varchar(max), @sampleTotal varchar(50), @samplingStr varchar(max)

-- SET LOOP COUNTERS
set @iCount = 1
set @iCountMax = (select MAX(IndexId) from @PIIList)
set @studyCountMax = (select MAX(IndexId) from @t1)

-- START THE OUTER PARTICIPANT LOOP
while @iCount <= @iCountMax
begin

	-- GET SUBJECT ID FROM THE LIST AND INSERT INTO THE RESULTS TABLE '@studies'
	set @subjectId = (select SubjectId from @PIIList where IndexId = @iCount)
	insert into @studies(SubjectId)
	select @subjectId

	-- SET THE INNER LOOP COUNTER
	set @subCount = 1

	-- START THE INNER LOOP TO ITERATE THROUGH EACH STUDY TO GET THE STATUS AND SAMPLE TOTALS FOR EACH STUDY THE PARTICIPANT HAS REGISTERED FOR
	while @subCount <= @studyCountMax
	begin
		set @study = (select distinct  stuff(coalesce(StudyName, '') + coalesce('(' + cast(StudyStatus as varchar(1)) +')', ''),1, 0, '') from @t1 where SubjectId = @subjectId and IndexId = @subCount)
		set @sampleTotal = (select distinct stuff(coalesce(StudyName, '') + coalesce('(' + cast(SampleNumber as varchar(3)) +  ')',''), 1, 0, '') from @t1 where SubjectId = @subjectId and IndexId = @subCount)
		set @studyStr =    stuff(coalesce(', ' + @studyStr, '')  + coalesce(', ' + @study, ''), 1, 2, '')
		set @samplingStr = stuff(coalesce(', ' + @samplingStr, '') + coalesce(', ' + @sampleTotal, ''), 1, 2, '')
		
		-- INCREMENT THE COUNTER FOR THE INNER LOOP
		set @subCount = @subCount +1

		--sense check variable population - COMMENT IN IF NEEDED
		--select @study as StudyStatus   COMMENT IN IF NEEDED
		--select @sampleTotal as SampleTotalPerStudy - COMMENT IN IF NEEDED

		-- clear @study and @sampleTotal variables
		set @study = null	
		set @sampleTotal = null

		--sense check variable population - COMMENT IN IF NEEDED
		--select @studyStr as studystring
		--select @samplingStr as samplingstring
		
	end

	-- UPDATE THE @studies TABEL WITH THE STATUS AND SAMPLING INFORMATION STRINGS
	update @studies
	set Studies = @studyStr, StudySamplingTotal = @samplingStr
	where SubjectId = @subjectId 
	
	set @studyStr = null
	set @samplingStr = null

	-- INCREMENT THE COUNTER FOR THE OUTER LOOP
	set @iCount = @iCount + 1

end


-- RETURN THE RESULT
select * from @studies
