# Utiliser l'image Elixir pour le build et le runtime
FROM elixir:1.15.6

# Variables d'environnement
ENV MIX_ENV=prod \
    LANG=C.UTF-8

# Installer hex et rebar
RUN mix local.hex --force && \
    mix local.rebar --force

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
RUN mix deps.get
RUN mix ecto.create
RUN mix ecto.migrate
RUN mix deps.compile
RUN mix phx.digest
RUN mix release

# Passer à un utilisateur non-root pour des raisons de sécurité
RUN chown -R nobody: /app
USER nobody

# Exécuter l'application
CMD ["_build/prod/rel/server/bin/server", "start"]