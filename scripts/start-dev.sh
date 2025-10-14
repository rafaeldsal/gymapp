#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "🚀 Iniciando Ambiente de Desenvolvimento do GymApp..."

# Função para detectar o comando do docker compose
get_docker_compose_cmd() {
    if command -v docker-compose &> /dev/null; then
        echo "docker-compose"
    elif docker compose version &> /dev/null; then
        echo "docker compose"
    else
        echo ""
    fi
}

DOCKER_COMPOSE_CMD=$(get_docker_compose_cmd)

# 1. Banco de Dados
if [ -n "$DOCKER_COMPOSE_CMD" ]; then
    echo "🐘 Iniciando PostgreSQL com Docker..."
    cd "$PROJECT_ROOT/docker"
    
    # Verifica se a porta 5432 está livre
    if lsof -Pi :5432 -sTCP:LISTEN -t >/dev/null ; then
        echo "⚠️  Porta 5432 já está em uso. Parando container conflitante..."
        $DOCKER_COMPOSE_CMD -f docker-compose.dev.yml down 2>/dev/null || true
        
        # Para qualquer container PostgreSQL na porta 5432
        docker ps --filter "publish=5432" --format "{{.ID}}" | xargs -r docker stop
        sleep 2
    fi
    
    $DOCKER_COMPOSE_CMD -f docker-compose.dev.yml up -d database
    sleep 5
    echo "✅ PostgreSQL iniciado"
else
    echo "⚠️  Docker Compose não encontrado. Usando banco em memória (H2)."
fi

# VOLTAR para o root do projeto ANTES de continuar
cd "$PROJECT_ROOT"

# 2. Backend Spring Boot
echo "☕ Iniciando Spring Boot API..."
cd "$PROJECT_ROOT/apps/gymapp-api"

if [ -f "./gradlew" ]; then
    ./gradlew bootRun &
    API_PID=$!
    echo "✅ Spring Boot iniciado (PID: $API_PID)"
else
    echo "❌ Gradlew não encontrado em $PWD"
    echo "📁 Conteúdo da pasta:"
    ls -la
    exit 1
fi

# 3. Frontend Angular
echo "🅰️  Iniciando Angular Web Admin..."
cd "$PROJECT_ROOT/apps/web-admin"

if [ -f "package.json" ]; then
    npx ng serve &
    ANGULAR_PID=$!
    echo "✅ Angular iniciado (PID: $ANGULAR_PID)"
else
    echo "❌ Angular project não encontrado em $PWD"
    echo "📁 Conteúdo da pasta:"
    ls -la
    exit 1
fi

echo ""
echo "🎉 Ambiente de desenvolvimento pronto!"
echo "📊 API: http://localhost:8080"
echo "💻 Web: http://localhost:4200"
if [ -n "$DOCKER_COMPOSE_CMD" ]; then
    echo "🐘 DB: localhost:5432"
else
    echo "🗄️  Banco: H2 (em memória)"
fi
echo ""
echo "⚠️  Para parar: Pressione Ctrl+C"

cleanup() {
    echo ""
    echo "🛑 Parando serviços..."
    kill $API_PID $ANGULAR_PID 2>/dev/null
    if [ -n "$DOCKER_COMPOSE_CMD" ]; then
        cd "$PROJECT_ROOT/docker"
        $DOCKER_COMPOSE_CMD -f docker-compose.dev.yml down
    fi
    exit 0
}

trap cleanup INT
wait