# Utiliser l'image Elixir pour le build et le runtime
FROM elixir:1.15.6

# Variables d'environnement
ENV MIX_ENV=prod \
    LANG=C.UTF-8

# Installer hex et rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Install debian packages
RUN apt-get update && \
    apt-get install --yes build-essential inotify-tools postgresql-client git && \
    apt-get clean

# Installer openssl
RUN apt-get update && apt-get install -y openssl && rm -rf /var/lib/apt/lists/*

# Créer le répertoire de l'application
WORKDIR /app

# Copier les fichiers nécessaires pour construire le projet
COPY mix.exs mix.lock ./
COPY config config
COPY lib lib
COPY priv priv

# Copier le répertoire des migrations Ecto
COPY priv/repo priv/repo

# Récupérer et compiler les dépendances et construire le projet
RUN mix deps.get && \
    mix deps.compile && \
    mix phx.digest && \
    mix release

EXPOSE 4000

# Copier le script entrypoint.sh
COPY entrypoint.sh /app/entrypoint.sh

# Rendre le script exécutable
RUN chmod +x /app/entrypoint.sh

# Exécuter l'application
CMD ["/app/entrypoint.sh"]