
/** 
 ** PURPOSE: DATE PERIODISATION AND CONVERSION
 **  AUTHOR: ALEX NEWSHAM
 ** UPDATED: 12/07/2018
*/


-- Convert integer to DateName MONTH
DECLARE @RecruitmentMonth INT = 1
SELECT 'Convert integer to month name' AS Solution, @RecruitmentMonth AS MonthAsInteger,  DateName(MONTH, DATEADD(MONTH, @RecruitmentMonth, -1)) AS MonthAsName

-- Last Month
SELECT 'Get Last Month - First and Last Dates of the Month' AS Interval, DATEADD(S, +0.99, DATEADD(M, DATEDIFF(M,0,GETDATE())-1,0)) ,DATEADD(S, -1, DATEADD(M, DATEDIFF(M,0,GETDATE()),0))

-- This Month
SELECT 'Get This Month - First and Last Dates of the Month' AS Interval, DATEADD(month, datediff(month, 0, getdate()), 0) ,DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, GETDATE()) + 1, 0))

-- Last Day of this Month
SELECT 'Last Day of this Month' AS Datetype ,DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, GETDATE()) + 1, 0))

-- This Week
SELECT 'Get This Week - First and Last Dates of the Week' AS Interval, DATEADD(WEEK, DATEDIFF(WEEK, 0, GETDATE()), 0) ,DATEADD(d, -1, DATEADD(w, DATEDIFF(w, 0, GETDATE()) + 1, 0)) as WeekOfTheYearInt

-- Last Week
SELECT 'Get Last Week - First and Last Dates of the Week' AS Interval, DATEADD(WEEK, DATEDIFF(WEEK, 0, GETDATE())-1,-1) ,DATEADD(WEEK, DATEDIFF(WEEK,0,GETDATE()),-1)

-- GET WEEK OF THE YEAR NUMBER E.G. OUT OF 1 TO 52
SELECT 'Get Today''s Week of the Year Number' AS DatePartType, DATEPART(WK, GETDATE())

--LAST DAY AND TIME OF LAST MONTH
SELECT DATEADD(S, -1, DATEADD(M, DATEDIFF(M,0,GETDATE()),0))

-- GET FIRST DAY OF THE WEEK FOR A GIVEN DATE
DECLARE @GivenDate DATE
SET @GivenDate = '2018-06-28'
SELECT 'Get First Day of the Week for a Given Date' AS DateType, DATEADD(WEEK, DATEDIFF(WEEK, 0, @GivenDate), 0)

-- GET FIRST DAY OF THIS WEEK
SELECT 'Get First Day of this Week' AS DateType, DATEADD(WEEK, DATEDIFF(WEEK, 0, GETDATE()), 0)

-- GET FIRST DAY OF LAST WEEK
SELECT 'Get First Day of Last Week' AS DateType, DATEADD(WEEK, DATEDIFF(WEEK, 0, GETDATE()), -1)

-- 1 MONTH BACK FROM TODAY
SELECT DATEADD(month, -1, GETDATE())

-- 3 MONTHS FROM TODAY'S DATE ONLY
SELECT CAST(DATEADD(DAY,0,GETDATE())-91 AS DATE)

-- 12 weeks back
SELECT CAST(DATEADD(DAY,0,GETDATE())-84 AS DATE)

-- 8 weeks back
SELECT CAST(DATEADD(DAY,0,GETDATE())-56 AS DATE)

-- date and times for between 8 and 12 weeks (i.e. in reverse when used in a where clause)
SELECT dateadd(day,-84,getdate()), dateadd(day,-56,getdate()) 

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
-- Example - estimate a booking 28 or 29 weeks prior to EDD (espected date of delivery)
-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  declare @edd date, @doBk29
  
  date, @doBk28 date
  set @edd = '2023-01-25'  
  set @doBk29 = (select DATEADD(DAY,-203,@edd)) -- 29 weeks
  set @doBk28 = (select DATEADD(DAY,-196,@edd)) -- 28 weeks 

  select @doBk29 ,@doBk28