# GymApp 🏋️

Sistema completo desenvolvido em monorepo para modernizar a gestão de academias, oferecendo soluções integradas para administradores, instrutores e alunos.

## **🏗️ Estrutura do Monorepo**

```text
gymapp/
├── apps/
│ ├── web-admin/ # Angular 17+ - Painel administrativo
│ ├── api/ # Spring Boot 3+ - API REST
│ └── mobile-android/ # Kotlin - App mobile (em breve)
├── scripts/ # Automação e utilitários
├── docker/ # Containers para desenvolvimento
├── libs/shared-types/ # Contratos OpenAPI
└── docs/ # Documentação
```

## **🚀 Começando**

### Pré-requisitos

- Node.js 18+
- Java 17+
- Docker & Docker Compose
- Angular CLI

### Desenvolvimento

```bash
# Clonar repositório
git clone https://github.com/SEU_USUARIO/gymapp.git
cd gymapp

# Iniciar ambiente completo de desenvolvimento
./scripts/start-dev.sh

# Buildar todas as aplicações
./scripts/build-all.sh

# Limpar ambiente
./scripts/cleanup.sh
```

## **📡 Serviços em Desenvolvimento**

| Serviço        | URL                                                                            | Descrição             |
| -------------- | ------------------------------------------------------------------------------ | --------------------- |
| 🅰️ Angular     | [http://localhost:4200](http://localhost:4200)                                 | Painel administrativo |
| ☕ Spring Boot | [http://localhost:8080](http://localhost:8080)                                 | API REST              |
| 🐘 PostgreSQL  | localhost:5433                                                                 | Banco de dados        |
| 📚 Swagger UI  | [http://localhost:8080/swagger-ui.html](http://localhost:8080/swagger-ui.html) | Documentação da API   |

## **🛠️ Stack Tecnológica**

### **Frontend Web**

- Angular 17+ com Standalone Components
- Clarity Design System - Design system enterprise
- Tailwind CSS - Utilitários CSS
- TypeScript - Tipagem estática

### **Backend**

- Spring Boot 3+ - Framework Java
- Gradle - Gerenciamento de dependências
- PostgreSQL - Banco de dados principal
- OpenAPI 3.0 - Especificação de APIs

### **Infraestrutura**

- Docker - Containerização
- Docker Compose - Orquestração
- Monorepo - Gerenciamento de múltiplos projetos

## **📊 Funcionalidades**

### **✅ Implementadas**

- Estrutura de monorepo
- Ambiente de desenvolvimento integrado
- API REST básica
- Interface web básica
- Containerização com Docker
- Documentação OpenAPI

### **🚧 Em Desenvolvimento**

- CRUD de alunos
- Sistema de planos
- Gestão de pagamentos
- App mobile

### **🤝 Contribuindo**

1. Fork o projeto
2. Crie uma branch para sua feature (git checkout -b feature/AmazingFeature)
3. Commit suas mudanças (git commit -m 'Add some AmazingFeature')
4. Push para a branch (git push origin feature/AmazingFeature)
5. Abra um Pull Request

## **📄 Licença**

Distribuído sob a licença MIT. Veja LICENSE para mais informações.

## **👨‍💻 Autor**

Rafael de Souza Alves

- GitHub: @rafaeldsal
# 🏋️ GymApp

[![CI Status](https://github.com/rafael/gymapp/workflows/CI/badge.svg)](https://github.com/rafael/gymapp/actions)
[![Java](https://img.shields.io/badge/Java-17-blue.svg)](https://java.com)
[![Angular](https://img.shields.io/badge/Angular-17+-red.svg)](https://angular.io)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Sistema completo de gestão para academias...