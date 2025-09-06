-- Script d'initialisation de la base de données
-- Ce script s'exécute automatiquement lors du premier démarrage du conteneur MySQL

-- Créer la base de données si elle n'existe pas
CREATE DATABASE IF NOT EXISTS udemia CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Utiliser la base de données
USE udemia;

-- Créer un utilisateur dédié pour l'application (optionnel, car déjà configuré via les variables d'environnement)
-- CREATE USER IF NOT EXISTS 'udemy_user'@'%' IDENTIFIED BY 'udemy_password';
-- GRANT ALL PRIVILEGES ON udemia.* TO 'udemy_user'@'%';
-- FLUSH PRIVILEGES;

-- Afficher un message de confirmation
SELECT 'Base de données udemia initialisée avec succès' as message;
