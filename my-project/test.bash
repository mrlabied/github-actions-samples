# Initialise un nouveau projet Node.js en acceptant les valeurs par défaut (-y)
# Cela crée automatiquement un fichier package.json à la racine.
npm init -y

# Installe les bibliothèques officielles de GitHub pour développer des GitHub Actions :
# - @actions/core : permet d'interagir avec l'action (entrées, sorties, journalisation, etc.)
# - @actions/github : permet d'accéder au contexte du workflow et au client GitHub (Octokit).
npm install @actions/core @actions/github

# Installe le paquet '@vercel/npm-package-json-lint' ou plus précisément '@vercel/ncc' 
# en tant que dépendance de développement (-D). 
# 'ncc' est utilisé pour compiler et regrouper (bundle) le code TypeScript/JavaScript 
# et tous ses modules en un seul fichier exécutable, ce qui est indispensable pour une GitHub Action.
npm install -D @vercel/ncc


# Utilise l'image de base officielle Alpine Linux version 3.20, légère et sécurisée.
FROM alpine:3.20

# Installe les paquets 'bash' et 'curl' via le gestionnaire de paquets apk,
# sans conserver le cache local (--no-cache) pour réduire la taille de l'image.
RUN apk add --no-cache bash curl

# Copie le script local 'entrypoint.sh' depuis la machine hôte vers la racine du conteneur (/entrypoint.sh).
COPY entrypoint.sh /entrypoint.sh

# Rend le script 'entrypoint.sh' exécutable en lui attribuant les droits d'exécution (+x).
RUN chmod +x /entrypoint.sh

# Définit le script 'entrypoint.sh' comme commande principale à exécuter au démarrage du conteneur.
ENTRYPOINT ["/entrypoint.sh"]


#!/usr/bin/env bash

# Configure le comportement du script en cas d'erreur :
# -e : Arrête le script immédiatement si une commande échoue.
# -u : Traite les variables non définies comme des erreurs et arrête le script.
# -o pipefail : Fait échouer un pipeline (ex: cmd1 | cmd2) si l'une des commandes échoue, et pas seulement la dernière.
set -euo pipefail

# Affiche un message de salutation en utilisant le premier argument ($1) passé au script.
echo "Hello, $1"

# Récupère la date et l'heure actuelles avec la commande 'date', 
# les formate sous forme de variable 'time=...' et les ajoute (>>) dans le fichier 
# pointé par la variable d'environnement GITHUB_OUTPUT (utilisé dans les GitHub Actions pour renvoyer des sorties).
echo "time=$(date)" >> "$GITHUB_OUTPUT"

