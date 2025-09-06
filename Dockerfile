# Étape 1: Installation des dépendances
FROM node:20-alpine AS deps
WORKDIR /app

# Installer les dépendances système nécessaires
RUN apk add --no-cache libc6-compat

COPY package.json package-lock.json* ./
RUN npm ci --omit=dev --frozen-lockfile

# Étape 2: Construction de l'application
FROM node:20-alpine AS builder
WORKDIR /app

# Installer les dépendances système nécessaires
RUN apk add --no-cache libc6-compat

COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Générer le client Prisma
RUN npx prisma generate

# Build de l'application
RUN npm run build

# Étape 3: Image de production finale
FROM node:20-alpine AS runner
WORKDIR /app

# Créer un utilisateur non-root pour la sécurité
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Installer les dépendances système nécessaires
RUN apk add --no-cache libc6-compat

# Copie uniquement les fichiers nécessaires
COPY --from=builder /app/package.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/next.config.mjs ./
COPY --from=builder /app/locales ./locales
COPY --from=builder /app/node_modules/.prisma ./.prisma
COPY --from=builder /app/prisma ./prisma

# Changer la propriété des fichiers
RUN chown -R nextjs:nodejs /app
USER nextjs

EXPOSE 3000

ENV PORT 3000
ENV HOSTNAME "0.0.0.0"

CMD ["sh", "-c", "npx prisma migrate deploy && npm start"]
