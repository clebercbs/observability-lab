#!/bin/bash
set -e

echo "==============================================="
echo "   CLEAN INSTALL - OBSERVABILITY LAB"
echo "==============================================="

echo "⚠ Isso irá remover containers, volumes e imagens do projeto."

read -p "Tem certeza? (y/n): " confirm

if [ "$confirm" != "y" ]; then
    echo "Cancelado."
    exit 0
fi

echo "Parando containers..."
docker compose down -v --remove-orphans

echo "Removendo volumes órfãos..."
docker volume prune -f

echo "Removendo imagens não utilizadas..."
docker image prune -af

echo "Subindo stack limpa..."
docker compose pull
docker compose up -d

echo "Ambiente recriado com sucesso."
