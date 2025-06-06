# Zero-Touch-SQL-Server-Backup-with-Auto-Log-Cleanup
 Repository Description (short tagline under the title) Automatically cleans heavy log tables before backing up databases. Lightweight, Express Edition compatible, zero manual intervention.




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
