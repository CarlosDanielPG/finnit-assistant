# Code Standards

## Language Requirements
- All code must be written in TypeScript
- All comments must be in English
- All documentation must be in English
- All variable names, function names, and class names must be in English
- All commit messages must be in English

## Code Style
- Use Prettier for code formatting
- Follow ESLint configuration rules
- Use consistent indentation (2 spaces)
- Use semicolons at the end of statements
- Use single quotes for strings
- Use trailing commas in objects and arrays

## Naming Conventions
- Use camelCase for variables and functions
- Use PascalCase for components and classes
- Use UPPER_SNAKE_CASE for constants
- Use kebab-case for file names
- Use descriptive names that explain the purpose

## Component Guidelines
- Use functional components with hooks
- Keep components small and focused
- Extract reusable logic into custom hooks
- Use TypeScript interfaces for props
- Export components as named exports

## File Organization
- Group related files in directories
- Use index files for clean imports
- Keep files under 300 lines when possible
- Separate concerns (UI, logic, types)

## Documentation
- Document all public APIs
- Use JSDoc comments for functions
- Include examples in documentation
- Keep README files updated
- Document architectural decisions

## Testing
- Write tests for all new features
- Maintain high test coverage
- Use descriptive test names
- Test both success and error cases
- Mock external dependencies

## Git Workflow
- Use conventional commit messages
- Create feature branches for new work
- Keep commits small and focused
- Write descriptive commit messages
- Review code before merging

## Performance
- Optimize bundle size
- Use lazy loading when appropriate
- Minimize re-renders
- Use proper caching strategies
- Monitor performance metrics

## Security
- Validate all inputs
- Sanitize user data
- Use environment variables for secrets
- Follow OWASP guidelines
- Regular security audits

## Accessibility
- Use semantic HTML
- Include ARIA labels
- Ensure keyboard navigation
- Test with screen readers
- Follow WCAG guidelines 