USE [Staging_AOW]
GO
/****** Object:  UserDefinedFunction [Utils].[CleanHiddenChars]    Script Date: 31/05/2024 11:25:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
** Created by: Anabel MC	
** Created on: 31/05/2024
** Purpose:Clean hidden characters.Keeps some printable special chars.
** Last modified by: 
** Modification: 
*/
ALTER Function [Utils].[CleanHiddenChars](@Data VARCHAR(150))
Returns VARCHAR(150)
AS BEGIN
  DECLARE @Letter INT
  SET @Letter =PATINDEX('%[^0-9a-zA-Z .,''()#@$?£+=_\&/!*-]%',@Data)
      BEGIN
		WHILE @Letter>0
		BEGIN
			SET @Data =STUFF(@Data,@Letter,1,'')
			SET @Letter =PATINDEX('%[^0-9a-zA-Z .,''()#@$?£+=_\&/!*-]%',@Data)
		END
      END
      RETURN @Data
END
