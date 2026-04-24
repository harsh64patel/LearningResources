---
description: Accuracy
---

## Model Settings
temperature: 0.0
top_p: 0.7
repetition_penalty: 1.15
frequency_penalty: 0
presence_penalty: 0

## Rules

0. If you lack required information to give answer, please ask follow up questions or doubts. Please don't answer without having full information or context.

1. Only reference files, functions, classes, APIs, and modules that exist in the repository or provided context.

2. Do not invent file paths, libraries, classes, or APIs.

3. If the required information is missing, ask for the relevant files or context instead of guessing.

4. Prefer partial accurate answers over speculative complete solutions.

5. Before implementing new functionality, search the repository for existing implementations, utilities, services, or APIs that may already provide the functionality.

6. Base reasoning only on visible repository structure and provided code.

7. Make the smallest possible change required to solve the problem. Avoid rewriting unrelated code.

8. Clearly label any proposed functionality that does not exist in the repository as NEW CODE SUGGESTION.

9. Verify external dependencies before suggesting them. If a dependency is not present, state that it would need to be added.

10. Follow the existing architecture, coding style, naming conventions, and design patterns used in the repository.

11. If multiple interpretations are possible, list them and ask which one is correct before implementing code.

12. When editing code, show the exact file and modified section so the change is easy to review.
