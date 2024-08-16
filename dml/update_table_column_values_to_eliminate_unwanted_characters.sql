/*
** Created by: Alex Newsham
** Created on: 23/01/2024
** Purpose: To demonstrate how you can remove unnecessary values from a table column using UPDATE and REPLACE()
** 
*/


declare @t1 table (PupilID int, YearGroup varchar(5))
insert into @t1
values(1001,'Y8'),(1002,'Y9'),(1003, 'Y10'),(1004, 'Y11'),(1005, 'Y12'),(1101, 'Y8'),(1102, 'Y9'),(1103, 'Y10')

-- before update
select * 
from @t1

update @t1
set YearGroup = REPLACE(YearGroup, 'Y','')

-- after update
select * 
from @t1



