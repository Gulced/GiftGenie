# GiftGenie

A Flutter gift-recommendation application that combines user preferences, Gemini-generated suggestions, and external product search.

## Overview

A Flutter gift-recommendation application that combines user preferences, Gemini-generated suggestions, and external product search. The description and capabilities in this document are limited to behavior that can be verified in the repository source.

## Key Features

- Firebase registration and login
- Preference-based prompt construction
- Gemini recommendation requests
- Parsing generated responses into typed gift suggestions
- External product search and URL launching
- Provider-backed authentication state

## Tech Stack

- Dart
- Flutter
- Firebase Authentication
- Provider
- Gemini API
- SerpAPI
- HTTP

## Architecture

Views, a view model, typed models, and service classes separate UI, authentication, prompt construction, model calls, response parsing, and product search.

## Project Structure

- `lib/view/` — application screens
- `lib/view_model/` — authentication state
- `lib/service/` — Firebase, Gemini, prompt, parser, and SerpAPI services
- `lib/models/` — typed recommendation models
- `lib/utils/` — parsing and display helpers

## AI / ML Integration

User preferences are converted into prompts and sent to Gemini. Generated text is parsed into structured gift suggestions; the repository does not contain training or fine-tuning.

## Getting Started

Run the commands appropriate to the project root:

```bash
flutter pub get
flutter run
```

## Configuration and Security

The current implementation references Gemini and SerpAPI credentials directly from service classes rather than loading them from environment configuration. Credential values are intentionally not reproduced here.

Before running or distributing the application:

- Revoke and rotate the committed credentials.
- Move the Gemini and SerpAPI keys to a local, non-committed configuration mechanism.
- Restrict API keys by application, API, and quota where the provider supports it.

## Testing

```bash
flutter test
```

## Technical Highlights

- Prompt construction isolated from UI
- Structured parsing of LLM responses
- Firebase authentication
- LLM-to-product-search workflow

## Possible Improvements

- Add or expand automated tests around core workflows.
- Document deployment and environment-specific configuration.
- Add CI checks for build, linting, and tests where they are not already present.

## Verification Notes

The application performs remote LLM inference; it does not train or fine-tune a model. API credentials are currently embedded in source files and should be rotated and externalized before further use.
