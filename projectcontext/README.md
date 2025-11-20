# BalanceIQ - Project Context for Developers & AI Agents

Welcome to the BalanceIQ project context! This directory contains concise, essential documentation for developers and AI agents working on this project.

## Quick Start

1. **New to the project?** Start with [PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md)
2. **Want to understand the code?** Read [ARCHITECTURE.md](ARCHITECTURE.md)
3. **Ready to develop?** Check [DEVELOPMENT_GUIDE.md](DEVELOPMENT_GUIDE.md)
4. **Need to know what's done?** See [IMPLEMENTATION_STATUS.md](IMPLEMENTATION_STATUS.md)
5. **Planning next steps?** Review [ROADMAP.md](ROADMAP.md) and [TASKS.md](TASKS.md)

## Document Guide

| Document | Purpose | Read Time |
|----------|---------|-----------|
| [PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md) | High-level project summary, tech stack, features | 10 min |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Clean architecture, folder structure, design patterns | 15 min |
| [DEVELOPMENT_GUIDE.md](DEVELOPMENT_GUIDE.md) | How to add features, modify code, best practices | 20 min |
| [API_INTEGRATION.md](API_INTEGRATION.md) | n8n webhooks, API contracts, data flow | 10 min |
| [IMPLEMENTATION_STATUS.md](IMPLEMENTATION_STATUS.md) | What's implemented, what's missing, known issues | 10 min |
| [ROADMAP.md](ROADMAP.md) | Development phases, priorities, timeline | 10 min |
| [TASKS.md](TASKS.md) | Actionable task list with priorities | 5 min |

## Project At a Glance

**BalanceIQ** is an AI-powered personal finance app for Bangladesh market, built with Flutter.

- **Platform**: Flutter 3.27.0 (iOS & Android)
- **Architecture**: Clean Architecture (Domain, Data, Presentation)
- **State Management**: Cubit (flutter_bloc)
- **Backend**: n8n workflows + PostgreSQL
- **Key Features**:
  - Dashboard with financial metrics
  - AI chat assistant for expense tracking
  - Receipt scanning (OCR)
  - Voice commands
  - Multi-provider authentication

## Current Status

- **Development Stage**: Beta (60% complete)
- **Total Code**: ~7,500 lines of Dart
- **Features Implemented**: Auth, Dashboard, Chat, SQLite persistence
- **Critical Missing**: Bank integration, Budgets, Bangla language
- **Next Priority**: Launch-blocking UX fixes

## Development Workflow

```bash
# Setup
flutter pub get
cp .env.example .env  # Configure API URLs

# Run
flutter run

# Test
flutter test
flutter analyze

# Build
flutter build apk --release
flutter build ios --release
```

## Key Technologies

| Layer | Technologies |
|-------|-------------|
| **Frontend** | Flutter, Dart, Cubit |
| **Local DB** | SQLite (sqflite) |
| **Auth** | Google Sign-In, Apple Sign-In |
| **API** | Dio, n8n webhooks |
| **DI** | GetIt service locator |
| **UI** | Material Design, Dark/Light themes |

## Project Structure

```
lib/
├── core/              # Shared utilities, DI, database
│   ├── constants/     # App constants, config
│   ├── database/      # SQLite helper
│   ├── di/           # Dependency injection
│   └── theme/        # App themes
│
├── features/          # Feature modules
│   ├── auth/         # Authentication
│   ├── chat/         # AI chat assistant
│   └── home/         # Dashboard
```

## Getting Help

1. **Architecture questions?** → [ARCHITECTURE.md](ARCHITECTURE.md)
2. **How to add a feature?** → [DEVELOPMENT_GUIDE.md](DEVELOPMENT_GUIDE.md)
3. **API not working?** → [API_INTEGRATION.md](API_INTEGRATION.md)
4. **What needs to be built?** → [TASKS.md](TASKS.md)

## Document Philosophy

These documents are:
- **Concise**: Only essential information
- **Practical**: Real code examples and actionable guidance
- **Current**: Reflects actual codebase state
- **Focused**: For developers and AI agents, not business stakeholders

## Contributing

When updating these docs:
1. Keep them short and actionable
2. Use code examples from actual codebase
3. Update IMPLEMENTATION_STATUS.md when features change
4. Add new tasks to TASKS.md

---

**Last Updated**: 2025-11-21
**Project Version**: 1.0.0+1
**Documentation Version**: 1.0