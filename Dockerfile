# Étape 1: Installation des dépendances
FROM node:20-alpine AS deps
WORKDIR /app

# Copier les fichiers de package et installer les dépendances
COPY package.json package-lock.json* ./
RUN npm install

# Étape 2: Construction de l'application
FROM node:20-alpine AS builder
WORKDIR /app

# Copier les dépendances de l'étape précédente
COPY --from=deps /app/node_modules ./node_modules
# Copier le reste du code source
COPY . .

# Générer le client Prisma
RUN npx prisma generate

# Construire l'application Next.js pour la production
RUN npm run build

# Étape 3: Image de production finale
FROM node:20-alpine AS runner
WORKDIR /app

# Copier uniquement les dépendances de production
COPY package.json package-lock.json* ./
RUN npm install --production

# Copier les fichiers nécessaires depuis l'étape de construction
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/next.config.mjs ./
COPY --from=builder /app/locales ./locales
COPY --from=builder /app/node_modules/.prisma ./.prisma
COPY --from=builder /app/prisma ./prisma

# Exposer le port sur lequel l'application tourne
EXPOSE 3000

# Commande pour démarrer l'application
# Applique les migrations de la base de données puis démarre le serveur Next.js
CMD ["sh", "-c", "npx prisma migrate deploy && npm start"]
