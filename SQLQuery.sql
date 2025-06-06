DECLARE @BackupPath NVARCHAR(260) = 'D:\AutoBackUp\Back\';

DECLARE @DBName NVARCHAR(100);

DECLARE @SQL NVARCHAR(MAX);

DECLARE @DateSuffix NVARCHAR(30) = CONVERT(NVARCHAR, GETDATE(), 112) + '_' + REPLACE(CONVERT(NVARCHAR, GETDATE(), 108), ':', '');

-- Liste des bases à sauvegarder

DECLARE @Databases TABLE (DBName NVARCHAR(100));

INSERT INTO @Databases (DBName) VALUES

('PS_UserData'),
('PS_Billing'),
('PS_GameDefs'),
('PS_GameData'),
('PS_GameLog'),
('PS_ChatLog');

-- Liste des noms de tables de logs à nettoyer

DECLARE @LogTables TABLE (TableName NVARCHAR(200));

INSERT INTO @LogTables (TableName) VALUES

('dbo.Logs'),
('ChatLog'),
('GameLog');

DECLARE db_cursor CURSOR FOR SELECT DBName FROM @Databases;

OPEN db_cursor;

FETCH NEXT FROM db_cursor INTO @DBName;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '--- Traitement de la base : ' + @DBName;

    -- Construire les suppressions de logs
    SET @SQL = '';
    SELECT @SQL = @SQL + '
    IF EXISTS (SELECT * FROM [' + @DBName + '].sys.tables t JOIN [' + @DBName + '].sys.schemas s ON t.schema_id = s.schema_id WHERE s.name + ''.'' + t.name = ''' + TableName + ''')
    BEGIN
        PRINT ''Nettoyage de ' + TableName + ' dans ' + @DBName + ''';
        EXEC(''DELETE FROM [' + @DBName + '].' + TableName + ' WHERE 1=1'');
    END;'
    FROM @LogTables;

    EXEC(@SQL);

    SET @SQL = 'USE [' + @DBName + ']; CHECKPOINT;';
    EXEC(@SQL);

    -- Correction ici : suppression de COMPRESSION
    SET @SQL = '
    BACKUP DATABASE [' + @DBName + ']
    TO DISK = ''' + @BackupPath + @DBName + '_' + @DateSuffix + '.bak''
    WITH INIT, STATS = 5;';
    
    PRINT 'Backup de la base : ' + @DBName;
    EXEC(@SQL);

    FETCH NEXT FROM db_cursor INTO @DBName;
END

CLOSE db_cursor;
DEALLOCATE db_cursor;

