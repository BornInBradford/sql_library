/*
**   created by: Alex Newsham
**   created on: 19/02/2024
**  description: Example of calculating dates in range of Expected Date of Delivery, Date 21 Weeks (EDD -19 weeks) and Date 45 Weeks (EDD +5 Weeks) 
**  modified by:
**  modified on:
** modification:
*/


declare @dt table (EDD date)

insert into @dt 
values('1943-05-27'),('1952-06-13'),('2021-07-02'),('2021-08-15'),('2022-02-02'),('2023-02-07'),('2024-04-30'),('2024-07-24'),('2023-12-14')

select EDD 
      ,dateadd(week,-19,EDD) as  Week21PregDate 
	  ,dateadd(week, +5, EDD) as Week45PregDate
from @dt

