#!/bin/bash
set -e

echo "Removendo stack Observability..."

docker compose down -v --remove-orphans

echo "Removendo rede..."
docker network prune -f

echo "Removendo volumes..."
docker volume prune -f

echo "Removendo imagens relacionadas..."
docker image rm prom/prometheus grafana/grafana grafana/loki portainer/portainer-ce 2>/dev/null || true

echo "Stack removida completamente."
