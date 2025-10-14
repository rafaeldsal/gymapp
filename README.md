# GymApp 🏋️

Sistema completo de gestão para academias.

## 🏗️ Estrutura do Monorepo

```text
gymapp/
├── apps/
│ ├── web-admin/ # Angular 17+ - Painel administrativo
│ ├── api/ # Spring Boot - API REST
│ └── mobile-android/ # Kotlin - App para alunos
├── libs/ # Recursos compartilhados
├── docker/ # Configurações Docker
└── scripts/ # Scripts de automação
```

## 🚀 Desenvolvimento

```bash
# Instalar dependências do Angular
cd apps/web-admin && npm install

# Executar em desenvolvimento
npm run dev:api    # Spring Boot (localhost:8080)
npm run dev:web    # Angular (localhost:4200)
```

## 📋 Stack Tecnológica

- Frontend Web: Angular 17+, Clarity Design System, Tailwind CSS
- Backend: Spring Boot 3+, Java 17+, Gradle
- Mobile: Kotlin, Android SDK
- Banco: PostgreSQL
- Container: Docker

### **4. 🔧 SCRIPTS DE AUTOMAÇÃO**

#### **4.1 Script de build completo**

```bash
#!/bin/bash
# scripts/build-all.sh

echo "🏗️  Building GymApp Monorepo..."

# Build API
echo "🔨 Building Spring Boot API..."
cd apps/api
./gradlew clean build -x test
cd ../..

# Build Web Admin
echo "🔨 Building Angular Web Admin..."
cd apps/web-admin
npm run build
cd ../..

echo "✅ All builds completed!"
```

#### **4.2 Script de desenvolvimento**

```bash
#!/bin/bash
# scripts/start-dev.sh

echo "🚀 Starting GymApp Development Environment..."

echo "📦 Checking dependencies..."
# Verifica se todas as dependências estão instaladas
if [ ! -d "apps/web-admin/node_modules" ]; then
    echo "Installing Angular dependencies..."
    cd apps/web-admin && npm install && cd ../..
fi

echo "🐘 Starting PostgreSQL with Docker..."
docker-compose -f docker/docker-compose.dev.yml up -d database

# Wait for database
sleep 5

echo "☕ Starting Spring Boot API..."
cd apps/api
./gradlew bootRun &

echo "🅰️  Starting Angular Dev Server..."
cd ../web-admin
ng serve &

echo "✅ Development environment running!"
echo "📱 API: http://localhost:8080"
echo "💻 Web: http://localhost:4200"
echo "🐘 DB: localhost:5432"
echo "📊 H2 Console: http://localhost:8080/h2-console"
```

### **5. 🐳 DOCKER PARA DESENVOLVIMENTO**

#### **5.1 Docker Compose para dev **

```yaml
# docker/docker-compose.dev.yml
version: "3.8"
services:
  database:
    image: postgres:13
    environment:
      POSTGRES_DB: gymapp_dev
      POSTGRES_USER: gymapp
      POSTGRES_PASSWORD: gymapp123
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

### **6. 📚 LIBS - COMPARTILHAMENTO ENTRE STACKS**

#### **6.1 Estrutura da lib shared-types**

```text
gymapp/libs/shared-types/
├── openapi/
│   └── gymapp-api.yaml    # Contrato OpenAPI
├── schemas/               # Esquemas comuns
├── README.md
└── package.json          # Para publicação futura
```

#### **6.2 Cpmtratp OpenAPI básico**

```yaml
# libs/shared-types/openapi/gymapp-api.yaml
openapi: 3.0.0
info:
  title: GymApp API
  description: API para sistema de gestão de academias
  version: 1.0.0
  contact:
    name: Rafael Alves
    email: rafael@email.com

servers:
  - url: http://localhost:8080
    description: Development server

paths:
  /health:
    get:
      summary: Health check
      responses:
        "200":
          description: API is running
          content:
            text/plain:
              example: "GymApp API is running! 🏋️"

  /api/students:
    get:
      summary: List all students
      responses:
        "200":
          description: Students list
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: "#/components/schemas/Student"

components:
  schemas:
    Student:
      type: object
      properties:
        id:
          type: string
          format: uuid
        name:
          type: string
        email:
          type: string
          format: email
        status:
          type: string
          enum: [ACTIVE, INACTIVE, PENDING]
```
