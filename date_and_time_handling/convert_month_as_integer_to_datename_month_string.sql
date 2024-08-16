/** 
 
 ** CREATED BY: ALEX NEWSHAM
 ** CREATED ON: 21/06/2024
 ** PURPOSE: CONVERT MONTH INTEGER TO TEXT STRING (E.G. MONTH = 1 TO JANUARY)
*/

-- Convert integer to DateName MONTH
DECLARE @RecruitmentMonth INT = 1
SELECT 'Convert integer to month name' AS Solution, @RecruitmentMonth AS MonthAsInteger,  DateName(MONTH, DATEADD(MONTH, @RecruitmentMonth, -1)) AS MonthAsName
