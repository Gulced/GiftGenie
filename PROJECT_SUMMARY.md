# Project Summary

## Project Name

GiftGenie

## Repository

GiftGenie

## Project Status

Medium

## Categories

Mobile, Flutter, LLM Integration

## What It Does

A Flutter gift-recommendation application that combines user preferences, Gemini-generated suggestions, and external product search.

## Verified Tech Stack

Dart, Flutter, Firebase Authentication, Provider, Gemini API, SerpAPI, HTTP

## Core Features

- Firebase registration and login
- Preference-based prompt construction
- Gemini recommendation requests
- Parsing generated responses into typed gift suggestions
- External product search and URL launching
- Provider-backed authentication state

## Architecture

Views, a view model, typed models, and service classes separate UI, authentication, prompt construction, model calls, response parsing, and product search.

## Project Structure and Components

- `lib/view/` — application screens
- `lib/view_model/` — authentication state
- `lib/service/` — Firebase, Gemini, prompt, parser, and SerpAPI services
- `lib/models/` — typed recommendation models
- `lib/utils/` — parsing and display helpers

## External Integrations

- Firebase Authentication
- Gemini content-generation API
- SerpAPI product search

## Technically Interesting Parts

- Prompt construction isolated from UI
- Structured parsing of LLM responses
- Firebase authentication
- LLM-to-product-search workflow

## Engineering Complexity

The main observable engineering complexity comes from prompt construction isolated from ui, structured parsing of llm responses, firebase authentication, llm-to-product-search workflow.

## CV General

### Suggested Project Title

GiftGenie – Mobile Project

### Tech Line

Dart, Flutter, Firebase Authentication, Provider, Gemini API, SerpAPI, HTTP

### Bullet 1

Developed a Flutter gift-recommendation application that combines user preferences, Gemini-generated suggestions, and external product search.

### Bullet 2

Structured the implementation around views, a view model, typed models, and service classes separate UI, authentication, prompt construction, model calls, response parsing, and product search.

### Bullet 3

Implemented prompt construction isolated from ui, structured parsing of llm responses, firebase authentication.

## AI / ML CV Version

### Suitability
Medium

### Tech Line
Dart, Flutter, Firebase Authentication, Provider, Gemini API, SerpAPI, HTTP

### CV Bullets
- Developed a Flutter gift-recommendation application that combines user preferences, Gemini-generated suggestions, and external product search.
- Structured the implementation around views, a view model, typed models, and service classes separate UI, authentication, prompt construction, model calls, response parsing, and product search.
- Implemented prompt construction isolated from ui, structured parsing of llm responses, firebase authentication.

## Web / Backend CV Version

### Suitability
Weak

### Tech Line
Dart, Flutter, Firebase Authentication, Provider, Gemini API, SerpAPI, HTTP

### CV Bullets
- Developed a Flutter gift-recommendation application that combines user preferences, Gemini-generated suggestions, and external product search.
- Structured the implementation around views, a view model, typed models, and service classes separate UI, authentication, prompt construction, model calls, response parsing, and product search.
- Implemented prompt construction isolated from ui, structured parsing of llm responses, firebase authentication.

## Mobile CV Version

### Suitability
Strong

### Tech Line
Dart, Flutter, Firebase Authentication, Provider, Gemini API, SerpAPI, HTTP

### CV Bullets
- Developed a Flutter gift-recommendation application that combines user preferences, Gemini-generated suggestions, and external product search.
- Structured the implementation around views, a view model, typed models, and service classes separate UI, authentication, prompt construction, model calls, response parsing, and product search.
- Implemented prompt construction isolated from ui, structured parsing of llm responses, firebase authentication.

## One-Line GitHub Description

A Flutter gift-recommendation application that combines user preferences, Gemini-generated suggestions, and external product search.

## LinkedIn Project Description

A Flutter gift-recommendation application that combines user preferences, Gemini-generated suggestions, and external product search. The implementation uses Dart, Flutter, Firebase Authentication, Provider, Gemini API, SerpAPI, HTTP and emphasizes prompt construction isolated from ui, structured parsing of llm responses, firebase authentication.

## Verification Notes

The application performs remote Gemini inference; it does not contain model training or fine-tuning. Gemini and SerpAPI credentials are embedded in service source files. Their values are deliberately omitted from this document and should be revoked, rotated, and moved to non-committed configuration.
