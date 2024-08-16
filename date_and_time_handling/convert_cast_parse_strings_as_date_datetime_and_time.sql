/*
** CREATED BY: Alex Newsham
** CREATED ON: 21/06/2024
** PURPOSE: To offer working solutions for transforming date and time values provide as strings into values of date and time type
** 
*/

-- TRANSFORM DATE VALUES FROM STRINGS

declare @dtStr varchar(255) ,@dtStr2 varchar(255), @dtStr3 varchar(255), @timeValue varchar(8)
set @dtStr = '12/01/2022'
set @dtStr2 = '24-07-1968'

select convert(date, @dtStr, 103) as StrToDateVal

select convert(date, @dtStr2, 103) as strToDateVal

select convert(date, substring(rtrim(ltrim(@dtStr3)), 0,11), 103) as strToDateVal

select parse(substring(rtrim(ltrim(@dtStr3)), 0,11) as date using 'en-GB')



-- TRANSFORM TIME VALUES FROM STRINGS

-- 1. TRANSFORM AND LOAD TIME PORTION OF A STRING INTO A TABLE AS A TIME VALUE
set @dtStr3 = '   24-07-1985 14.22.00      ' 
declare @t1 table (id int identity(1,1), TimeVal time)
insert into @t1 (TimeVal)
select replace(cast(substring(rtrim(ltrim(@dtStr3)), 12,19)as varchar(8)), '.',':') as strTime

-- OUTPUT
select * from @t1

-- 2. WELL-FORMED STRING CONVERTED TO TIME VALUE USING A VARIABLE
declare @timeString varchar(8) = '14:22:00'
declare @TimeValue2 time
set @TimeValue2 = convert(time, @TimeString)

-- OUTPUT
select @TimeValue2 AS TimeValue2

