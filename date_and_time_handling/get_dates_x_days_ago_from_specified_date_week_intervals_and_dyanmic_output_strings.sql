/*
** CREATED BY: ALEX NEWSHAM
** CREATED ON: 21/06/2024
** PURPOSE: GET DATES X DAYS AGO FROM SPECIFIED DATE - PARAMETERISED WITH DYNAMIC OUTPUT TEXT STRINGS
*/

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
-- Example - estimate a booking 28 or 29 weeks prior to EDD (espected date of delivery)
-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  declare @givenDate date, @doBk29 date, @doBk28 date, @intervalDays as int ,@dateXDaysAgo date
  
  -- hardcoded
  set @givenDate = '2023-01-25'  
  set @doBk29 = (select DATEADD(DAY,-203,@givenDate)) -- 29 weeks
  set @doBk28 = (select DATEADD(DAY,-196,@givenDate)) -- 28 weeks 

  -- output
  select 'Estimate dates x days ago from specified date' OutputDescription, @doBk29 as OutputDate29WeeksAgo ,@doBk28 as OutputDate28WeeksAgo

  -- dynamic ouput strings
  set @intervaldays = 203
  set @dateXDaysAgo = (select DATEADD(DAY,-@intervalDays,@givenDate))

  --output
  select 'Estimated date ' + cast(@intervalDays as varchar(10)) 
          + ' days ago from ' + cast(@givenDate as varchar(10)) as OutputDescription
         ,@dateXDaysAgo as OutputDate




