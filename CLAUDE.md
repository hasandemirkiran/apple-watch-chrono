# Claude Development Guide

## General Principles

- Keep changes focused and minimal — only modify what is necessary for the task
- Prefer editing existing files over creating new ones
- Do not add comments, docstrings, or refactors unless explicitly asked

## Commits

- Commit after each logical unit of work (new feature, bug fix, refactor)
- Use clear, descriptive commit messages that explain the *why*, not just the *what*
- Never commit secrets, credentials, or generated build artifacts
- Stage specific files rather than `git add -A`

## Testing

- Write tests for new functionality before or alongside the implementation
- Run the full test suite before committing to catch regressions
- Fix failing tests before moving on — never skip or comment them out
- Test edge cases: empty state, single item, large input, error paths

## Code Quality

- Run the linter/formatter before committing (`swiftlint` for Swift)
- Resolve all compiler warnings in modified files
- Keep functions small and single-purpose
- Avoid deeply nested logic — early returns are preferred

## Swift / watchOS Specifics

- Target watchOS 9.0+ minimum; use Swift Charts for any chart views
- Use `@MainActor` or dispatch to the main thread for all UI updates
- Prefer `ObservableObject` + `@Published` for state shared across views
- Use `.common` run loop mode for timers so they fire during scroll/interaction
- Keep views lightweight — move logic into the ViewModel

## Branching

- All work goes on a feature branch, never directly on `main`
- Branch naming: `feature/<short-description>` or follow project convention
- Open a PR when the feature is complete and all tests pass

## What to Avoid

- Do not force-push to shared branches
- Do not introduce third-party dependencies without discussion
- Do not leave debug print statements or commented-out code in commits
- Do not silently swallow errors — surface them to the user or log them clearly
