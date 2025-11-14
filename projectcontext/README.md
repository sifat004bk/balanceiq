# Project Context Documentation

This directory contains all comprehensive project documentation for BalanceIQ.

## 📁 Document Structure

```
projectcontext/
├── README.md                      # This file - documentation index
├── project_context.md             # Main comprehensive context (START HERE)
├── development_guide.md           # Development and customization guide
├── testing_guide.md               # QA testing checklist
├── app_overview.md                # Visual diagrams and system flows
└── webhook_integration.md         # n8n webhook integration guide
```

## 📖 Reading Guide

### For New Team Members
1. **Start**: [project_context.md](project_context.md) - Get the complete picture
2. **Visualize**: [app_overview.md](app_overview.md) - See the system design
3. **Develop**: [development_guide.md](development_guide.md) - Learn to extend the app

### For Developers
- **Adding Features**: [development_guide.md](development_guide.md)
- **System Architecture**: [project_context.md](project_context.md) → Architecture section
- **Visual Reference**: [app_overview.md](app_overview.md)

### For QA/Testers
- **Testing Checklist**: [testing_guide.md](testing_guide.md)
- **Feature Reference**: [project_context.md](project_context.md) → Features section

### For Backend Integration
- **Webhook Setup**: [webhook_integration.md](webhook_integration.md)
- **API Details**: [project_context.md](project_context.md) → API Integration section

## 📄 Document Descriptions

### [project_context.md](project_context.md) ⭐ START HERE
**The main comprehensive documentation covering everything about BalanceIQ**

Topics covered:
- Complete project overview and purpose
- Architecture and design patterns
- All features and capabilities
- Technology stack and dependencies
- File structure and organization
- Key components deep dive
- Development journey and history
- Database schema
- API integration details
- State management with Cubit
- Authentication flows
- UI/UX design guidelines
- Recent fixes and improvements
- Configuration and setup
- Build and deployment process

**Read time**: ~60 minutes
**Use when**: You need comprehensive understanding of the entire project

---

### [development_guide.md](development_guide.md)
**Practical guide for extending and customizing BalanceIQ**

Topics covered:
- Adding new bots (step-by-step)
- Adding new features with examples
- Modifying UI components
- Database changes and migrations
- API integration patterns
- Best practices and code patterns
- Common development tasks
- Debugging tips

**Read time**: ~30 minutes
**Use when**: You're actively developing features or customizing the app

---

### [testing_guide.md](testing_guide.md)
**Comprehensive QA testing checklist**

Topics covered:
- Pre-testing setup
- Authentication tests (Google, Apple)
- Home screen functionality
- Chat interface testing
- Text/image/audio message tests
- Database persistence tests
- n8n integration verification
- Performance testing
- Platform-specific tests (Android/iOS)
- Edge cases and error scenarios
- Accessibility testing
- Security verification

**Read time**: ~90 minutes (for full test execution)
**Use when**: Performing QA testing or verifying app functionality

---

### [app_overview.md](app_overview.md)
**Visual guide with diagrams and flowcharts**

Topics covered:
- App flow diagram
- Data flow visualization
- Architecture layer diagrams
- Database schema visual
- Bot configuration overview
- n8n integration diagram
- Screen hierarchy
- Theme system visualization
- Deployment pipeline

**Read time**: ~20 minutes
**Use when**: You prefer visual learning or need to explain the system to others

---

### [webhook_integration.md](webhook_integration.md)
**Technical guide for n8n webhook integration**

Topics covered:
- Webhook setup overview
- Flutter app changes for webhook
- n8n workflow updates
- Request/response payload structures
- Data flow from app to n8n
- Database table interactions
- Bot ID configuration
- Migration from Telegram
- Testing checklist
- Troubleshooting

**Read time**: ~25 minutes
**Use when**: Setting up or debugging webhook integration

---

## 🎯 Quick Navigation

### I want to...

**Understand the project**
→ [project_context.md](project_context.md)

**Add a new bot**
→ [development_guide.md](development_guide.md) → "Adding a New Bot"

**Test the app**
→ [testing_guide.md](testing_guide.md)

**See architecture diagrams**
→ [app_overview.md](app_overview.md)

**Configure webhook**
→ [webhook_integration.md](webhook_integration.md)

**Understand database schema**
→ [project_context.md](project_context.md) → "Database Schema"
→ [app_overview.md](app_overview.md) → "Database Schema Visual"

**Learn state management**
→ [project_context.md](project_context.md) → "State Management"

**Customize UI**
→ [development_guide.md](development_guide.md) → "Modifying the UI"

**Deploy the app**
→ [project_context.md](project_context.md) → "Build and Deployment"

---

## 📊 Documentation Stats

| Metric | Value |
|--------|-------|
| Total Documents | 5 markdown files |
| Total Words | ~30,000+ words |
| Code Examples | 100+ snippets |
| Diagrams | 15+ visual flows |
| Sections | 100+ topics covered |

---

## 🔄 Keeping Documentation Updated

### When to Update Each Document

**project_context.md**
- Major architecture changes
- New features added
- Technology stack updates
- Deployment process changes

**development_guide.md**
- New development patterns
- Updated best practices
- New examples added

**testing_guide.md**
- New features to test
- Updated test procedures
- New edge cases discovered

**app_overview.md**
- Architecture changes
- New screens or flows
- Updated diagrams

**webhook_integration.md**
- Webhook endpoint changes
- Payload structure updates
- n8n workflow modifications

---

## 💡 Documentation Philosophy

This documentation follows these principles:

1. **Comprehensive but Organized**: All information in one place, but structured for easy navigation
2. **Multiple Entry Points**: Different documents for different needs
3. **Visual + Text**: Diagrams complement written explanations
4. **Practical Examples**: Real code snippets and step-by-step guides
5. **Cross-Referenced**: Documents link to each other for deeper dives
6. **Maintained**: Updated alongside code changes

---

## 🤝 Contributing to Documentation

When adding or updating documentation:

1. **Choose the right file**:
   - Big picture changes → `project_context.md`
   - How-to guides → `development_guide.md`
   - Testing procedures → `testing_guide.md`
   - Visual representations → `app_overview.md`
   - Backend integration → `webhook_integration.md`

2. **Follow existing format**:
   - Use consistent heading levels
   - Add code examples with syntax highlighting
   - Include cross-references to other sections
   - Update table of contents if needed

3. **Keep it practical**:
   - Real examples over theory
   - Step-by-step instructions
   - Clear, concise language
   - Accurate and tested code

---

## 📞 Need Help?

If you can't find what you need:

1. Use Cmd/Ctrl + F to search within documents
2. Check the [project_context.md](project_context.md) table of contents
3. Review the "Quick Navigation" section above
4. Open an issue in the repository

---

**Last Updated**: 2025-01-09
**Documentation Version**: 2.0
**Maintained by**: BalanceIQ Development Team
