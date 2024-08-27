use TestSQL
go
/*
** created by: Alex Newsham & Sabah Shaib
** created on: 27/08/2024
** Purpose: to demonstrate ordering items in a column string created using the Stuff() function for later use in producing a pivot table of quarterly scores in a table with one person's records per row
**
**
*/

declare @cols nvarchar(max), @query nvarchar(max)

declare @t1 table (RecordId int identity(1,1), PersonId char(4) , YearQuarter int, EntryDate date, Question_A_Score int, Question_B_Score int, Question_C_Score int, Question_D_Score int, Question_E_Score int, Question_F_Score int, Question_G_Score int)
insert into @t1(PersonId, YearQuarter, EntryDate, Question_A_Score, Question_B_Score, Question_C_Score, Question_D_Score, Question_E_Score, Question_F_Score, Question_G_Score)
values('P101', 1, '2023-01-27', 7,8,9,10,8,7,8) 
	  ,('P101',2, '2023-04-27', 7,8,4,8,7,8,9)
	  ,('P101',3, '2023-07-27', 7,8,6,8,7,8,9)
	  ,('P101',4, '2023-10-27', 7,8,9,8,7,8,9)
	  ,('P102',1, '2023-01-27', 6,8,7,7,8,8,8)
	  ,('P102',2, '2023-04-27', 2,1,3,2,1,4,5)
	  ,('P102',3, '2023-07-27', 7,7,7,7,7,7,7)
	  ,('P102',4, '2023-10-27', 6,6,6,6,6,6,6)
	  ,('P103',1, '2023-01-27', 0,1,1,0,0,0,0)
	  ,('P103',2, '2023-04-27', 5,5,5,5,5,3,0)
	  ,('P103',3, '2023-07-27', 5,5,5,5,5,3,0)
	  ,('P103',4, '2023-10-27', 5,5,5,5,5,6,5)
	  ,('P104',1, '2023-01-27', 7,8,9,10,7,8,9)
	  ,('P104',2, '2023-04-27', 7,8,9,10,7,8,9)
	  ,('P104',3, '2023-07-27', 9,9,9,9,9,8,9)
	  ,('P104',4, '2023-10-27', 10,10,10,10,10,10,10)	  
	  ,('P105',1, '2023-01-27', 6,6,6,6,6,6,6)
	  ,('P105',2, '2023-04-27', 7,7,7,7,7,7,7)
	  ,('P105',3, '2023-07-27', 7,8,9,10,7,8,9)
	  ,('P105',4, '2023-10-27', 7,8,9,10,8,7,8)
	  ,('P106',1, '2023-01-27', 7,8,9,8,7,8,9)
	  ,('P106',2, '2023-04-27', 7,8,9,8,7,8,9)
	  ,('P106',3, '2023-07-27', 7,8,9,8,7,8,9)
	  ,('P106',4, '2023-10-27', 7,8,10,8,7,8,9)
	  ,('P108',2, '2023-04-27', 7,8,9,10,7,8,9)
	  ,('P103',4, '2023-10-27', 7,9,10,8,7,8,9)
	  ,('P103',1, '2023-01-27', 7,8,9,10,8,7,9)
	  ,('P103',3, '2023-07-27', 7,8,9,10,8,7,9)

IF OBJECT_ID('tempdb..#test') IS NOT NULL
    DROP TABLE #test;

select PersonId
	   ,YearQuarter
	   ,EntryDate
	   ,VariableName
	   ,VariableValue
	   ,VariableOrder
into #test
from (select
		PersonId
	   ,YearQuarter
	   ,EntryDate
	   ,VariableName
	   ,VariableValue
	   ,VariableOrder
from @t1 t1
cross apply (
		   values
				 ('Question_A_Score_Qtr', Question_A_Score, 1),
				 ('Question_B_Score_Qtr', Question_B_Score, 2),
				 ('Question_C_Score_Qtr', Question_C_Score, 3),
				 ('Question_D_Score_Qtr', Question_D_Score, 4),
				 ('Question_E_Score_Qtr', Question_E_Score, 5),
				 ('Question_F_Score_Qtr', Question_F_Score, 6),
				 ('Question_G_Score_Qtr', Question_G_Score, 7)
			) as Variables(VariableName, VariableValue, VariableOrder)
		) as unpivoted
where VariableValue is not null

select * from #test

set @cols = stuff(
					(
							select 
									',' + quotename(VariableName + '_' + cast(YearQuarter as varchar))
							from (select  distinct YearQuarter ,VariableName, VariableOrder
									from #test
									)x
							order by x.YearQuarter, VariableOrder
							for xml path(''), type
					).value('.', 'nvarchar(max)'), 1, 1, ''
				)

set @query = '
              select PersonId, ' +@cols+ '
			  from (
			  select 
					PersonId
					,VariableName + ''_'' + cast(YearQuarter as varchar) as VariableName_YearQuarter
					,VariableValue
				from #test 
				) x
				pivot (
						max(VariableValue)
						for VariableName_YearQuarter
						in (' + @cols + ')
					  ) p
				order by PersonId;'

-- sense check variables
print @cols
print @query

-- execute the dynamic SQL query
exec (@query)

drop table #test

			 