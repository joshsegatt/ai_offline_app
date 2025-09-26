
# AI Offline App (Flutter)
Offline-first AI chat with luxury black+gold UI. Local LLM placeholder now; premium web/search later.

## Run
```bash
flutter pub get
flutter run
```
## Structure
- `lib/main.dart` entry with bottom navigation (Chat, History, Settings).
- `lib/ui/theme.dart` design tokens (black+gold).
- `lib/ui/pages/*` screens.
- `lib/core/llm_engine.dart` interface for local LLM integration (to wire up later).
- `lib/core/storage.dart` local storage (history).
- `lib/core/models.dart` data models.

## Next
- Wire local LLM (llama.cpp-android via FFI or platform channel).
- Add premium endpoints when you want cloud mode.
