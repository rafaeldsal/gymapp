# GymApp 🏋️

[![CI Status](https://github.com/rafaeldsal/gymapp/workflows/CI%20Pipeline/badge.svg)](https://github.com/rafaeldsal/gymapp/actions)
[![Coverage](https://img.shields.io/badge/Coverage-80%25-brightgreen)](https://github.com/rafaeldsal/gymapp)
[![Java](https://img.shields.io/badge/Java-21-007396?logo=openjdk)](https://java.com)
[![Angular](https://img.shields.io/badge/Angular-16-DD0031?logo=angular)](https://angular.io)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.0-6DB33F?logo=springboot)](https://spring.io)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker)](https://docker.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

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

- Node.js v22.20.0
- Java 21
- Docker & Docker Compose
- Angular CLI 20.2.1

### Desenvolvimento

```bash
# Clonar repositório
git clone https://github.com/rafaeldsal/gymapp.git
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

- Angular 20.2.1 com Standalone Components
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
