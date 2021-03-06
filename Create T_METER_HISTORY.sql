CREATE OR ALTER TRIGGER BBCT.T_METRO_HISTORY
ON BBCT.T_METRO
AFTER INSERT, DELETE,UPDATE
AS
BEGIN
	DECLARE @INSERTCOUNT int, @DELETEDCOUNT int, 
	@INSERTEDMETROID varchar(10), @INSERTEDBASEPLATE varchar(12), @INSERTEDNAMEPLATE varchar(12), @INSERTEDREGISTER varchar (12),
	@INSERTEDDATECREATED varchar(10), @INSERTEDDATECALIBRATED varchar(10),
	@DELETEDMETROID varchar(10), @DELETEDBASEPLATE varchar(12), @DELETEDNAMEPLATE varchar(12), @DELETEDREGISTER varchar (12),
	@DELETEDDATECREATED varchar(10), @DELETEDDATECALIBRATED varchar(10)
	
	SET @INSERTCOUNT = (SELECT COUNT(*) FROM INSERTED);
	SET @DELETEDCOUNT = (SELECT COUNT(*) FROM DELETED);

	SET @INSERTEDMETROID = (SELECT CONVERT(varchar(10), METRO_ID) FROM INSERTED);
	SET @INSERTEDBASEPLATE = (SELECT ISNULL(BASEPLATE, 'NULL') FROM INSERTED);
	SET @INSERTEDNAMEPLATE = (SELECT ISNULL(NAMEPLATE, 'NULL') FROM INSERTED);
	SET @INSERTEDREGISTER = (SELECT ISNULL(REGISTER, 'NULL') FROM INSERTED);
	SET @INSERTEDDATECREATED = (SELECT CONVERT(varchar(10), DATE_CREATED, 6) FROM INSERTED);
	SET @INSERTEDDATECALIBRATED = (SELECT CONVERT(varchar(10), DATE_CALIBRATED, 6) FROM INSERTED);

	SET @DELETEDMETROID = (SELECT CONVERT(varchar(10), METRO_ID) FROM DELETED);
	SET @DELETEDBASEPLATE = (SELECT ISNULL(BASEPLATE, 'NULL') FROM DELETED);
	SET @DELETEDNAMEPLATE = (SELECT ISNULL(NAMEPLATE, 'NULL') FROM DELETED);
	SET @DELETEDREGISTER = (SELECT ISNULL(REGISTER, 'NULL') FROM DELETED);
	SET @DELETEDDATECREATED = (SELECT  CONVERT(varchar(10), DATE_CREATED, 6) FROM DELETED);
	SET @DELETEDDATECALIBRATED = (SELECT CONVERT(varchar(10), DATE_CALIBRATED, 6)  FROM DELETED);

	SET NOCOUNT ON;
	
		if (@INSERTCOUNT >0 AND @DELETEDCOUNT > 0)
			BEGIN
				PRINT 'Update';
				if (@INSERTEDBASEPLATE  != @DELETEDBASEPLATE)
				BEGIN
					INSERT INTO BBCT.T_HISTORY (DATE_DONE, TABLE_NAME, ACTIVITY, DATA_FROM, DATA_TO, DESCRIPTION, USERNAME) 
					VALUES (CURRENT_TIMESTAMP, 'T_METRO', 'U', @DELETEDBASEPLATE, @INSERTEDBASEPLATE , 'Updated ' +  @DELETEDMETROID + ' baseplate from ' + @DELETEDBASEPLATE + ' to ' + @INSERTEDBASEPLATE, 'CF000000');
				END
				if (@INSERTEDNAMEPLATE != @DELETEDNAMEPLATE)
				BEGIN
					INSERT INTO BBCT.T_HISTORY (DATE_DONE, TABLE_NAME, ACTIVITY, DATA_FROM, DATA_TO, DESCRIPTION, USERNAME) 
					VALUES (CURRENT_TIMESTAMP, 'T_METRO', 'U', @DELETEDNAMEPLATE, @INSERTEDNAMEPLATE , 'Updated ' +  @DELETEDMETROID + ' nameplate from ' + @DELETEDNAMEPLATE + ' to ' + @INSERTEDNAMEPLATE, 'CF000000');				
				END
				if (@INSERTEDREGISTER  != @DELETEDREGISTER)
				BEGIN
					INSERT INTO BBCT.T_HISTORY (DATE_DONE, TABLE_NAME, ACTIVITY, DATA_FROM, DATA_TO, DESCRIPTION, USERNAME) 
					VALUES (CURRENT_TIMESTAMP, 'T_METRO', 'U', @DELETEDREGISTER, @INSERTEDREGISTER , 'Updated ' +  @DELETEDMETROID + ' register from ' + @DELETEDREGISTER + ' to ' + @INSERTEDREGISTER, 'CF000000');				
				END
				if (@INSERTEDDATECREATED != @DELETEDDATECREATED)
				BEGIN
					INSERT INTO BBCT.T_HISTORY (DATE_DONE, TABLE_NAME, ACTIVITY, DATA_FROM, DATA_TO, DESCRIPTION, USERNAME) 
					VALUES (CURRENT_TIMESTAMP, 'T_METRO', 'U', @DELETEDDATECREATED, @INSERTEDDATECREATED , 'Updated ' +  @DELETEDMETROID + ' date created from ' + @DELETEDDATECREATED + ' to ' + @INSERTEDDATECREATED, 'CF000000');				
				END
				if (@INSERTEDDATECALIBRATED != @DELETEDDATECALIBRATED)
				BEGIN
					INSERT INTO BBCT.T_HISTORY (DATE_DONE, TABLE_NAME, ACTIVITY, DATA_FROM, DATA_TO, DESCRIPTION, USERNAME) 
					VALUES (CURRENT_TIMESTAMP, 'T_METRO', 'U', @DELETEDDATECALIBRATED, @INSERTEDDATECALIBRATED , 'Updated ' +  @DELETEDMETROID + ' date calibrated from ' + @DELETEDDATECALIBRATED + ' to ' + @INSERTEDDATECALIBRATED, 'CF000000');				
				END
			END
		else 
			if (@INSERTCOUNT >0 AND @DELETEDCOUNT=0)
				BEGIN
					INSERT INTO BBCT.T_HISTORY (DATE_DONE, TABLE_NAME, ACTIVITY, DATA_FROM, DATA_TO, DESCRIPTION, USERNAME) VALUES (CURRENT_TIMESTAMP, 'T_METRO', 'I', null, @INSERTEDMETROID, 'Inserted ' + @INSERTEDMETROID, 'CF000000');		
				END
			else 
			if (@INSERTCOUNT=0 AND @DELETEDCOUNT > 0)
			BEGIN
				INSERT INTO BBCT.T_HISTORY (DATE_DONE, TABLE_NAME, ACTIVITY, DATA_FROM, DATA_TO, DESCRIPTION, USERNAME) VALUES (CURRENT_TIMESTAMP, 'T_METRO', 'D', @DELETEDMETROID, null, 'Deleted ' + @DELETEDMETROID, 'CF000000');
			END
END