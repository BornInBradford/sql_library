/*
** Created by: Alex Newshame
** Created on: 16/08/2016
** Modified:   16/08/2024
** Purpose: Provides a template to create a stored procedure transaction control with 
**          rollback, error trapping and try-catch blocks
*/

USE [MyDatabase]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [SCHEMA NAME].[SP NAME]

	/* Declare you parameters here, e.g...*/
	
	 @PID			        INT
	,@RecID					VARCHAR(10)
	,@Details				XML	(DOCUMENT [Schema].[XMLTypeName])
	,@Message				VARCHAR(255)	= NULL	OUTPUT
	,@Error					VARCHAR(255)	= NULL	OUTPUT
	,@OutputVariableName	BIT			    OUTPUT
	
	
	
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @TranCount INT;
	SET @TranCount = @@TRANCOUNT;
	
	DECLARE @XState INT;
	DECLARE @ErrorNumber INT
	
	/*********************************************************************************************************
	
	Add error checks here...
	
		E.G. 
		
			-- Check ID is valid
			IF @RID NOT LIKE '[1-9][0-9][0-9][0-9][0-9][0-9]'
			BEGIN
				SET @Message = CONVERT(VARCHAR(MAX), @RecruitmentID) + ' is not a valid ID.';
				GOTO PROBLEM
			END	
	*********************************************************************************************************/	
	
	BEGIN TRY
			
		IF @TranCount = 0
		BEGIN
			BEGIN TRANSACTION;
		END
		ELSE
		BEGIN
			SAVE TRANSACTION MyTransaction
		END
		
		
		/**************************************************************************************
		
		ADD THE BODY OF THE STORED PROCEDURE HERE 
		
		E.G. ADD IN-SCOPE VARIABLES AND ACTIONS 
		

		
		**************************************************************************************/
		
		
		
		IF @TranCount = 0
			BEGIN
				COMMIT TRANSACTION;
			END
	END TRY
	BEGIN CATCH
		
		SET @ErrorNumber = ERROR_NUMBER();
		SET @Error = ERROR_MESSAGE();
		GOTO PROBLEM
		
	END CATCH
	
	SET @Message = 'Processing succeeded for ''' + @PID + ''', PersonID: ''' + @RecID + '''';
	
	RETURN
	
	PROBLEM:
		
		SET @XState = XACT_STATE();
		
		IF @XState = -1
		BEGIN
			ROLLBACK TRANSACTION;
		END
		
		IF @XState = 1 AND @TranCount = 0
		BEGIN
			ROLLBACK TRANSACTION;
		END
		
		IF @XState = 1 AND @TranCount > 0
		BEGIN
			ROLLBACK TRANSACTION SaveMyTransacton;
		END
		
		IF @ErrorNumber IS NOT NULL
			RAISERROR ('MySchema.MyProceure: %d: %s', 16, 1, @ErrorNumber, @Error);
		
	RETURN
	
END

