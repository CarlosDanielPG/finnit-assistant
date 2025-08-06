# Development Workflow

## Before Starting
- Read the development plan in `docs/development-plan.md`
- Understand the current architecture
- Check existing implementations
- Review related documentation
- Check the project README in `docs/README.md`

## During Development
- Follow the established patterns
- Write tests alongside code
- Update documentation as needed
- Commit frequently with clear messages
- Use conventional commit messages
- Create feature branches for new work

## Before Submitting
- Run all tests: `yarn test`
- Check linting: `yarn lint`
- Check formatting: `yarn format`
- Run type checking: `yarn check-types`
- Review code for best practices
- Update documentation if needed
- Test in different environments

## Code Review Process
- Create pull requests for all changes
- Request reviews from team members
- Address feedback promptly
- Ensure CI/CD checks pass
- Update documentation as needed

## Quality Assurance Checklist
- [ ] Code follows style guidelines
- [ ] Tests are included and passing
- [ ] Documentation is updated
- [ ] Performance is considered
- [ ] Security is addressed
- [ ] Accessibility is maintained
- [ ] No console.log statements in production code
- [ ] Environment variables are properly configured
- [ ] Dependencies are up to date 