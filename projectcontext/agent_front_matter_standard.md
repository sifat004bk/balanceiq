# Agent Front Matter Standard

**Last Updated:** 2025-11-18
**Version:** 1.0.0
**Status:** Active

## Overview

This document defines the standardized front matter structure for all agent files in both the project (`.claude/agents/`) and global agent library (`~/.claude/agent-library/`).

## Standardized YAML Schema

```yaml
---
name: agent-name-here
version: 1.0.0
category: category-name
description: >-
  Concise, clean description of the agent's expertise and capabilities.
  Use YAML multiline format (>-) for clean formatting.
  Avoid embedded examples or escape characters.
model: sonnet  # or opus, haiku
color: color-name  # blue, green, pink, purple, orange, yellow, etc.
tags:
  - tag1
  - tag2
  - tag3
  - project-specific-tag
status: active  # or deprecated, experimental
author: Claude  # or team member name
last_updated: YYYY-MM-DD
project: project-name  # optional, for project-specific agents
use_cases:
  - Use case description 1
  - Use case description 2
  - Use case description 3
---
```

## Field Descriptions

### Required Fields

- **name**: Agent identifier (kebab-case, matches filename without .md)
- **version**: Semantic versioning (e.g., 1.0.0)
- **category**: Classification for organization
- **description**: Clean, concise summary (2-4 sentences max)
- **model**: AI model to use (sonnet, opus, haiku)
- **color**: Visual identifier color
- **tags**: Array of searchable keywords
- **status**: Lifecycle state (active, deprecated, experimental)
- **author**: Creator/maintainer
- **last_updated**: ISO date format (YYYY-MM-DD)

### Optional Fields

- **project**: Project identifier for project-specific agents
- **use_cases**: List of specific scenarios when to invoke the agent

## Category Taxonomy

### Design & Research
- `design` - UI/UX design work
- `design-research` - User research and analysis
- `design-systems` - Design system development

### Development
- `mobile-development` - Mobile app development (Flutter, React Native, native)
- `web-development` - Web application development
- `backend-development` - Server-side development
- `frontend-development` - Client-side web development

### Quality & Testing
- `quality-assurance` - QA and testing
- `code-review` - Code review and analysis
- `testing-automation` - Automated testing setup

### Operations
- `devops` - DevOps and infrastructure
- `database` - Database administration and optimization
- `deployment` - Deployment and release management

### Management
- `project-management` - Project planning and coordination
- `product-management` - Product strategy and planning

### Specialized
- `fintech` - Financial technology
- `security` - Security and compliance
- `ai-ml` - AI and machine learning
- `payment-processing` - Payment integration

### Tools
- `development-tools` - Developer productivity tools
- `automation` - Process automation

## Tag Conventions

### Technology Tags
- Language: `flutter`, `dart`, `python`, `javascript`, `typescript`
- Framework: `react`, `vue`, `django`, `spring-boot`
- Platform: `ios`, `android`, `web`, `desktop`

### Capability Tags
- State management: `bloc`, `riverpod`, `provider`, `redux`
- Architecture: `clean-architecture`, `mvvm`, `mvc`
- Practices: `tdd`, `bdd`, `agile`, `scrum`
- Specialization: `performance-optimization`, `security`, `accessibility`

### Project Tags
- Always include project identifier: `balanceiq`, `project-name`

## Color Guidelines

- **Blue**: Project management, coordination
- **Green**: Mobile development, Flutter/Dart
- **Pink**: Design, UI/UX
- **Purple**: Code review, quality
- **Orange**: Tools, automation, tracking
- **Yellow**: DevOps, infrastructure, database

## Examples

### Project-Specific Agent Example

```yaml
---
name: ux-researcher
version: 1.0.0
category: design-research
description: >-
  Senior UX researcher specializing in user interviews, usability testing, analytics interpretation,
  persona development, journey mapping, and research synthesis. Conducts mixed-methods research to
  uncover deep user insights and translate findings into actionable design recommendations that improve
  user experience and business outcomes.
model: sonnet
color: green
tags:
  - user-research
  - usability-testing
  - analytics
  - persona-development
  - journey-mapping
  - balanceiq
status: active
author: Claude
last_updated: 2025-11-18
project: balanceiq-fintech
use_cases:
  - User building new feature requiring discovery research
  - Post-launch analysis of user engagement and behavior
  - Investigating usability issues or user complaints
  - Planning major redesigns or new product development
---
```

### Global Library Agent Example

```yaml
---
name: flutter-tech-lead
version: 1.0.0
category: mobile-development
description: >-
  Seasoned Flutter Tech Lead with 15+ years mobile development experience. Expert in Flutter/Dart architecture,
  state management (BLoC, Riverpod, Provider), performance optimization, widget composition, platform integration,
  and CI/CD. Provides guidance on Clean Architecture, code quality, testing strategies, and mentorship for teams
  building production Flutter applications.
model: sonnet
color: green
tags:
  - flutter
  - dart
  - mobile-development
  - state-management
  - clean-architecture
  - performance-optimization
  - bloc
  - riverpod
status: active
author: Claude
last_updated: 2025-11-18
use_cases:
  - Reviewing BLoC/Cubit implementations for best practices
  - Choosing state management solutions (BLoC, Riverpod, Provider, GetX)
  - Diagnosing and fixing performance issues (widget rebuilds, list rendering)
  - Designing scalable Flutter architecture (Clean Architecture, feature-first)
  - Platform integration with native iOS/Android code
  - Code review for Dart idioms and Flutter patterns
  - Setting up CI/CD pipelines for Flutter projects
  - Optimizing app size and startup time
---
```

## Migration Guide

### For Existing Agents

1. **Extract clean description**: Remove examples and escape characters from description field
2. **Add versioning**: Start with 1.0.0
3. **Classify category**: Choose appropriate category from taxonomy
4. **Add tags**: Include technology, capability, and project tags
5. **Set status**: Default to "active"
6. **Add metadata**: Include author and last_updated
7. **List use cases**: Extract from old examples into bullet points

### Common Issues to Fix

#### Old Format (Avoid)
```yaml
description: Use this agent when...\n\n<example>...</example>
```

#### New Format (Preferred)
```yaml
description: >-
  Clean, concise description without examples or escape characters.
```

## Benefits of Standardization

1. **Searchability**: Consistent tags enable better agent discovery
2. **Organization**: Categories facilitate logical grouping
3. **Versioning**: Track agent evolution and changes
4. **Clarity**: Clean descriptions improve understanding
5. **Maintenance**: Structured metadata simplifies updates
6. **Documentation**: Use cases provide clear invocation guidance

## Refinement Status

### Completed ✅
- `ux-researcher` - design-research category
- `agile-project-manager` - project-management category
- `ui-designer` - design category
- `progress-tracker` - development-tools category
- `flutter-tech-lead` - mobile-development category (agent-library)

### Pending Refinement 🔄

#### Mobile Category (Priority: High for BalanceIQ)
- `flutter-expert`
- `flutter-plugin-developer`
- `mobile-app-developer`
- `mobile-developer`
- `android-kotlin-expert`
- `swift-expert`

#### Quality Category
- `code-reviewer` ⚠️ (partially refined)
- `qa-expert`
- `test-automator`
- `debug-specialist`
- `refactoring-specialist`

#### Specialized Category (Relevant for Fintech)
- `fintech-engineer`
- `payment-integration-specialist`
- `security-auditor`
- `compliance-auditor`

#### Backend & API
- `api-designer`
- `backend-service-builder`

#### DevOps & Database
- `devops-engineer`
- `database-administrator`
- `database-optimizer`

#### Remaining Categories
- Architecture (context-manager, workflow-orchestrator, etc.)
- Business (business-analyst, product-strategist, etc.)
- General (documentation-engineer, search-specialist, etc.)
- Web (react-specialist, etc.)

## Automation Opportunity

Consider creating a script to:
1. Parse existing agent front matter
2. Extract description and clean it
3. Generate tags from content analysis
4. Apply standardized template
5. Validate YAML structure

This would accelerate refinement of the remaining ~50 agent files.

## Version History

- **1.0.0** (2025-11-18): Initial standard definition and project agent refinement
