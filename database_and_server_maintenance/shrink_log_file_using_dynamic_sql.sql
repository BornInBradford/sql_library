
DECLARE @DBNAME SYSNAME, @sql_trans NVARCHAR(MAX)
SET @DBNAME = 'MY_DATABASE'  -- N.B. SET @DBNAME (I.E. DATABASE NAME) WITH THE NAME OF THE DATABASE YOU WISH TO SHRINK THE LOG FILES FOR E.G. 'TestSQL2'

/*
** CREATED BY: ALEX NEWSHAM
** CREATED ON: 13/06/2024
** PURPOSE: TO RUN LOG FILE SHRINKAGE STEPS AS A SINGLE SCRIPT
** N.B. (1) RUN COMMANDS IN THE TRANSACTION AS SEPARATE COMMANDS (I.E. USING SEMI-COLON) TO AVOID USING "GO" AS USING "GO" RESULTS IN AN ERROR (BECAUSE GO IS NOT A TSQL COMMAND BUT 
**          A MANAGEMENT STUDIO COMMAND AND THEREFORE NOT IN THE SCOPE OF DYNAMIC SQL)
**      (2) USE QUOTENAME() FUNCTION TO SQL INJECTION BY WRAPPING DBNAME IN SQUARE BRACKETS
*/

SET @sql_trans = N'USE ' + QUOTENAME(@DBNAME) + ';

SELECT file_id, type_desc,
       CAST(FILEPROPERTY(name, ''SpaceUsed'') AS decimal(19,4)) * 8 / 1024. AS space_used_mb,
       CAST(size/128.0 - CAST(FILEPROPERTY(name, ''SpaceUsed'') AS int)/128.0 AS decimal(19,4)) AS space_unused_mb,
       CAST(size AS decimal(19,4)) * 8 / 1024. AS space_allocated_mb,
       CAST(max_size AS decimal(19,4)) * 8 / 1024. AS max_size_mb
FROM sys.database_files;

ALTER DATABASE ' + QUOTENAME(@DBNAME) + '
SET RECOVERY SIMPLE;

-- Shrink the truncated log file to 1 MB.
DBCC SHRINKFILE (' + QUOTENAME(@DBNAME) +', 1);

ALTER DATABASE ' + QUOTENAME(@DBNAME) + '
SET RECOVERY FULL;

SELECT file_id, type_desc,
       CAST(FILEPROPERTY(name, ''SpaceUsed'') AS decimal(19,4)) * 8 / 1024. AS space_used_mb,
       CAST(size/128.0 - CAST(FILEPROPERTY(name, ''SpaceUsed'') AS int)/128.0 AS decimal(19,4)) AS space_unused_mb,
       CAST(size AS decimal(19,4)) * 8 / 1024. AS space_allocated_mb,
       CAST(max_size AS decimal(19,4)) * 8 / 1024. AS max_size_mb
FROM sys.database_files; ';

PRINT (@sql_trans);
EXECUTE (@sql_trans);