USE [Staging_AOW]
GO
/****** Object:  UserDefinedFunction [Utils].[CleanAllText]    Script Date: 31/05/2024 11:24:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
** Created by: Anabel MC	
** Created on: 31/05/2024
** Purpose: Clean all Special Chars, and keep only number, letters, and blank spaces.
** Last modified by: 
** Modification: 
*/

ALTER Function [Utils].[CleanAllText](@Data VARCHAR(150))
Returns VARCHAR(150)
AS BEGIN
  DECLARE @Letter INT
  SET @Letter =PATINDEX('%[^0-9a-zA-Z ]%',@Data)
      BEGIN
		WHILE @Letter>0
		BEGIN
			SET @Data =STUFF(@Data,@Letter,1,'')
			SET @Letter =PATINDEX('%[^0-9a-zA-Z ]%',@Data)
		END
      END
      RETURN @Data
END
