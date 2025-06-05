# Zero-Touch-SQL-Server-Backup-with-Auto-Log-Cleanup
 Repository Description (short tagline under the title) Automatically cleans heavy log tables before backing up databases. Lightweight, Express Edition compatible, zero manual intervention.


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



# Zero-Touch SQL Server Backup Script – Clean Logs Before `.bak`

🛠️ **Par Yuko – pour les devs, DBAs, studios de jeu et admins exigeants**

---

## 🚀 Description

Ce script SQL Server effectue des **sauvegardes automatiques de plusieurs bases de données**, en **nettoyant au préalable certaines tables de logs** (souvent volumineuses et inutiles dans les backups).  
Il est 100% **compatible SQL Server Express** – pas besoin de logiciel externe, ni de compression.

---

## ✅ Fonctionnalités

- 🔁 Boucle automatique sur plusieurs bases SQL
- 🧹 Supprime les données de tables comme `ChatLog`, `GameLog`, `dbo.Logs` avant backup
- 💾 Crée les fichiers `.bak` dans `D:\AutoBackUp\Back\`
- 📅 Ajoute un horodatage aux fichiers `.bak`
- 🔄 Nettoyage et `CHECKPOINT` avant chaque sauvegarde
- 🧠 Ultra simple à modifier et adapter

---

## 🧩 Tables de logs ciblées

Par défaut, le script supprime les données des tables suivantes, si elles existent dans la base :

- `dbo.Logs`
- `ChatLog`
- `GameLog`

Tu peux ajouter ou retirer des tables dans la section :
```sql
INSERT INTO @LogTables (TableName) VALUES
('dbo.Logs'),
('ChatLog'),
('GameLog');
```

---

## 🗂️ Dossier de sauvegarde

Par défaut, les fichiers `.bak` sont enregistrés ici :

```
D:\AutoBackUp\Back\
```

Assure-toi que ce dossier existe et que SQL Server a les droits d’écriture dessus.

---

## 🧠 Utilisation

1. Ouvre SSMS
2. Colle le script dans une nouvelle requête
3. Vérifie ou adapte la liste des bases (`@Databases`)
4. Exécute : le script s’occupe de tout

---

## 💬 Exemple de fichier généré

```
D:\AutoBackUp\Back\PS_GameData_20250606_142501.bak
```

---

## 📦 Compatible avec

✅ SQL Server Express, Standard, Enterprise  
✅ Local, VM, cloud  
❌ Pas de compression activée (non supportée sur Express)

---

## 📘 Auteur

Script développé par **Yuko**  
Vision : créer des outils invisibles ailleurs, utiles partout.  
Suivez mes outils ici : [github.com/yuko90](https://github.com/yuko90)

---

## 💡 Licence

Ce projet est open source.  
Utilisation libre, modification encouragée — juste **créditez si vous réutilisez** 🙏
