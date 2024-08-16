
/*
**	Created by: Alex Newsham
**	Created on: 16/08/2024
**  Purpose: To demonstrate the concatenation of individual record values based on a common set of identifiers
**  Example: Concatenate as a string all the insturments played by a musician in a given band
*/

declare @t1 table (bandId int, musicianId int, Instrument varchar(30))

insert into @t1 values(1, 90, 'Piano'),(1, 91, 'Double Bass'),(2, 92, 'Saxophone'),(2, 92, 'Vocals'),(2, 93, 'Rythm Guitar'),(3, 98, 'Ukelele'),(4, 99, 'Fiddle'),(4, 22, 'Bodhran'),(4, 120, 'Acoustic Guitar'),(4, 121, 'Tin Whistle'),(4,121, 'Vocal')


select *
from @t1

select distinct bandId, musicianId, 
				STUFF( -- the stuff function is used to remove the the leading comma and space
				       -- then it (using .value('.', 'nvarchar(max))) removes a substring and inserts a replacement string (',' + Insturment value, i.e. a leading comma and the the TypeOfExclusion value)
					   -- then replaces the first leading ', ' (using ', 1, 2) removing the first two characters, so the string starts with the first Instrument value rather than a comma.
						(  -- this subquery concatenates the Instrument value for each band and musician combination (effectively a grouping), listing all the instuments played by a musician in a specific band
						select ', ' + Instrument
						from @t1 t2
						where t2.musicianId = t1.musicianId
						for XML PATH(''), type
						).value('.', 'nvarchar(max)'), 1, 2, ''
					 ) as TypeOfInstrumentList
from @t1 t1
order by t1.bandId, musicianId;

