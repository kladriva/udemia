#!/bin/bash

# Script de démarrage pour l'application Udemy Clone avec Docker

echo "🚀 Démarrage de l'application Udemy Clone..."

# Vérifier si Docker est installé
if ! command -v docker &> /dev/null; then
    echo "❌ Docker n'est pas installé. Veuillez installer Docker d'abord."
    exit 1
fi

# Vérifier si Docker Compose est installé
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose n'est pas installé. Veuillez installer Docker Compose d'abord."
    exit 1
fi

# Vérifier si le fichier .env existe
if [ ! -f .env ]; then
    echo "⚠️  Le fichier .env n'existe pas. Création d'un fichier .env.example..."
    echo "Veuillez copier .env.example vers .env et configurer vos variables d'environnement."
    exit 1
fi

# Arrêter les conteneurs existants
echo "🛑 Arrêt des conteneurs existants..."
docker-compose down

# Construire et démarrer les services
echo "🔨 Construction et démarrage des services..."
docker-compose up --build -d

# Attendre que les services soient prêts
echo "⏳ Attente du démarrage des services..."
sleep 10

# Vérifier le statut des services
echo "📊 Vérification du statut des services..."
docker-compose ps

# Afficher les logs
echo "📝 Logs des services:"
docker-compose logs --tail=20

echo "✅ Application démarrée avec succès!"
echo "🌐 Application accessible sur: http://localhost:3010"
echo "🗄️  Base de données accessible sur: localhost:3306"
echo ""
echo "Pour voir les logs en temps réel: docker-compose logs -f"
echo "Pour arrêter l'application: docker-compose down"
