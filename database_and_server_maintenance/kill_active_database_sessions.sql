
/*
** Created by: Alex Newsham
** Created on: 04/01/2024
** Purpose: To terminate all open sessions using a specified database
*/

use [master];

declare @dbId int,  @dbName varchar(20)
set @dbId = 0 -- add database Id
set @dbName = 'MyDb'

DECLARE @kill varchar(8000) = '';  
SELECT @kill = @kill + 'kill ' + CONVERT(varchar(5), session_id) + ';'  
FROM sys.dm_exec_sessions
WHERE database_id  = @dbId  
                     -- db_id(@dbName) -- or by name
-- sense check @kill
--select @kill

EXEC(@kill);

-- sense check result
select * from sys.dm_exec_sessions where database_id = @dbId
