# Agent Readme: Dolfin Workspace

> **Welcome, Agent.** This is your central entry point for understanding the Dolfin Workspace project.

## 📁 Documentation Hub

You will find all necessary context linked below. **Always check these first** before exploring the codebase blindly.

- **[Project Context](project_context.md)**: Tech stack, key libraries, and project identity.
- **[Architecture Graph](project_architecture.md)**: Visual diagrams of system dependencies and internal Clean Architecture layers.
- **[Directory Structure](directory_structure.md)**: Detailed breakdown of where things live (`apps`, `packages`, etc.).
- **[Code Review Findings](code_review.md)**: Critical assessment of the current codebase state and recommendations.
- **[Task List](../.gemini/antigravity/brain/8534df61-a842-4d8f-a613-8cda7b95f3f3/task.md)**: Current active tasks and progress.

## 🚀 Quick Start for Agents

1. **Understand Inter-Dependencies**:
   - Apps (`dolfin_test`) depend on Features (`feature_chat`).
   - Features depend on Core (`dolfin_core`).
   - *Do not create circular dependencies.*

2. **Respect the Architecture**:
   - **Data Layer**: API calls, DB operations, DTOs.
   - **Domain Layer**: Pure Dart, Business Logic, Interfaces. **NO Flutter Dependencies here**.
   - **Presentation Layer**: UI, Widgets, Cubits.

3. **Running Tasks**:
   - To run tests: `melos run test`
   - To analyze code: `melos run analyze`

## 🔍 Common Locations
- **DI Setup**: `apps/dolfin_test/lib/core/di/injection_container.dart`
- **Theme**: `packages/core/dolfin_ui_kit/lib/theme/`
- **Network Client**: `packages/core/dolfin_core/lib/network/dio_client.dart`
