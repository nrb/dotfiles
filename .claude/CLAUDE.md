# Designing and planning work

When asked to plan for or design a feature, DO NOT edit code unless directly told to.
Always read the code, especially if specific files or directories are mentioned.
Provide code examples.

# Ambiguity and doubt

If there is ever anything that isn't clear, ask questions.
Do not guess.
Use an "open questions" section in our shared document if asked to collaborate in one.
Pause and ask if working in a conversation.

# Code formatting

Look for `make` targets that lint and format code when making changes.
Use them.
Examples such as:

    - `make lint`
    - `make verify-lint`
    - `make imports`

# Testing

In Go projects, you can often use the `make` targets to execute tests.
Prioritize these over running `go test` or `ginkgo` commands directly.

Example targets might be:

    - `make unit`
    - `make test`
