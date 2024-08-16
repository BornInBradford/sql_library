/*
** CREATED BY: ALEX NEWSHAM
** CREATED ON: 12/07/2018
** PURPOSE: GET DATES, HOURS, MINUTES AND SECONDS BETWEEN 8 AND 12 WEEKS AGO FROM NOW
*/

--get dates, hours, minutes and seconds between 8 and 12 weeks ago from now (i.e. in reverse when used in a where clause)
SELECT dateadd(day,-84,getdate()) as Date12WeeksAgo, dateadd(day,-56,getdate())  as Date8WeeksAgo
