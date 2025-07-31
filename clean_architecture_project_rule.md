# 📐 Clean Architecture Project Structure Rule

This project uses **Clean Architecture** principles with `flutter_bloc` (Cubit), `Freezed`, and `GetIt`.

## 🗂️ Project Structure

Each feature should follow this folder structure:

```
lib/
  features/
    <feature_name>/
      data/
        datasources/
        models/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        cubit/
        pages/
        widgets/
  core/
    error/
    network/
    usecases/
    utils/
  di/
    di.dart
```

## ⚙️ Technology Guidelines

- **State Management**: Use `Cubit` from `flutter_bloc`.
  - Each Cubit must have its own state class in a separate file.
  - Cubits only manage **UI states**, not business logic.

- **Freezed**: Use only to generate data classes (models) that work with `json_serializable`.
  - Used for objects to be serialized/deserialized from Firebase (or API).
  - Do **not** use Freezed for UI state.

- **Repositories**: Implement the Repository pattern between `domain` and `data`.

- **Usecases**: Each use case should be a single-purpose class located in `domain/usecases/`.

- **Entities**: Plain Dart classes located in `domain/entities/`.

## 🧠 Dependency Injection

Use `GetIt` for DI.
- All Cubits, Usecases, and Repositories must be registered in `di.dart`.

---

## 🏗️ Example Command Prompts for Cursor

When using Cursor, the following prompts will generate files following this rule:

- `create feature product`
- `generate auth cubit`
- `create usecase get_user_info`
- `generate freezed model user`

These will create files in the appropriate locations with proper naming conventions.

---

## ✅ Naming Convention

Refer to the `naming_convention.md` file for detailed rules on naming classes, functions, variables, and files.

