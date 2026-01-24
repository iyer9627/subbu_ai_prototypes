# Contributing to AI Prototyping Framework

Thank you for your interest in contributing to the AI Prototyping Framework! This document provides guidelines and instructions for contributing.

## Development Setup

1. **Fork and Clone**
```bash
git fork <repository-url>
git clone <your-fork-url>
cd subbu_ai_prototypes
```

2. **Install Dependencies**
```bash
./scripts/setup.sh
```

3. **Create a Branch**
```bash
git checkout -b feature/your-feature-name
```

## Code Standards

### TypeScript
- Use strict TypeScript settings
- Define proper types for all functions and variables
- Avoid using `any` type unless absolutely necessary
- Use interfaces for object shapes
- Use enums for fixed sets of values

### Code Style
- Use 2 spaces for indentation
- Use single quotes for strings
- Add semicolons at the end of statements
- Use meaningful variable and function names
- Write descriptive comments for complex logic

### File Organization
- One component per file
- Group related files in directories
- Use index.ts for barrel exports
- Keep files under 300 lines when possible

## Testing

### Running Tests
```bash
# Run all tests
npm run test

# Run tests for specific workspace
npm run test --workspace=backend
```

### Writing Tests
- Write unit tests for utility functions
- Write integration tests for API endpoints
- Test both success and error cases
- Mock external dependencies

## Pull Request Process

1. **Update Documentation**
   - Update README.md if needed
   - Add JSDoc comments to new functions
   - Update CHANGELOG.md with your changes

2. **Test Your Changes**
   - Run all tests: `npm run test`
   - Test manually in development
   - Check for TypeScript errors: `npm run build`

3. **Commit Guidelines**
   - Use clear, descriptive commit messages
   - Follow conventional commits format:
     - `feat:` for new features
     - `fix:` for bug fixes
     - `docs:` for documentation
     - `refactor:` for code refactoring
     - `test:` for adding tests
     - `chore:` for maintenance tasks

4. **Create Pull Request**
   - Fill out the PR template completely
   - Link related issues
   - Request review from maintainers
   - Address review feedback promptly

## Areas for Contribution

- **Features**: New AI providers, database adapters, UI components
- **Documentation**: Tutorials, examples, API documentation
- **Testing**: Unit tests, integration tests, E2E tests
- **Bug Fixes**: Report and fix bugs
- **Performance**: Optimize code and reduce bundle size
- **DevOps**: Improve CI/CD, Docker configurations

## Questions?

Feel free to open an issue for any questions or clarifications!
