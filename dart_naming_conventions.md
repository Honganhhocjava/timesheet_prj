# 🧾 Dart Naming Convention Guide

Derived from [Effective Dart - Style Guide](https://dart.dev/effective-dart/style)

---

## ✅ Formatting

| Convention | Rule | Description |
|-----------|------|-------------|
| Format code | DO | Use `dart format` (e.g. default formatting in Android Studio) |
| Line length | AVOID | Lines longer than 80 characters |

---

## 🆔 Identifiers

| Type | Naming | Example |
|------|--------|---------|
| Class, Enum, Typedef | `UpperCamelCase` | `HttpRequest`, `SliderMenu`, `Predicate<T>` |
| Extension | `UpperCamelCase` | `extension SmartIterable<T>` |
| File, Folder | `snake_case` | `product_model.dart`, `app_config.dart` |
| Variable, Method, Params | `lowerCamelCase` | `numberOfItems`, `fetchData()`, `userId` |
| Constants | Prefer `lowerCamelCase` | `const defaultTimeout = 1000;` |
| Enum values | `lowerCamelCase` | `enum Status { loading, success, error }` |
| Unused callback params | `_`, `__`, `___` | `(_) => print('done')` |
| Don't use underscore prefix for non-private | ❌ `_someVar` unless private |
| Don't use prefix letters | ❌ `kDefaultTimeout` (use `defaultTimeout`) |

---

## 🔢 Variable Naming

| Type | Convention | Example |
|------|------------|---------|
| Enum | `<Something>Status`, `<Something>Type` | `GenderType`, `LoadingStatus` |
| Number | `numberOf<Something>`, `<Something>Count` | `numberOfTickets`, `ticketCount` |
| With Unit | `<Name>In<Unit>` | `delayInMilliseconds` |
| Boolean | `is<Something>`, `has<Something>` etc. | `isLoading`, `hasError`, `shouldUpdate` |
| String | `<value>AsString`, `<value>String` | `yearAsString` |
| List | `<name>List` or `<name>s` | `productList`, `users` |
| Map/Set | `<name>Map`, `<name>Set` | `userMap`, `idSet` |

---

## 🧱 Class Naming

| Type | Rule | Example |
|------|------|---------|
| Page / Screen | `<ScreenName>Page` | `LoginPage`, `SettingsPage` |
| List Screen | `<ScreenName>ListPage` or `<ScreenName>sPage` | `NotificationsPage` |
| Detail Screen | `<ScreenName>DetailPage` | `ProductDetailPage` |
| Custom Widget (Material) | `<CustomName><WidgetName>` | `AppDialog`, `EmailTextField` |
| Common View | `App<Widget>` | `AppTabbar`, `AppDrawer` |
| Entity Class | `<name>Entity` | `UserEntity` |
| Param Class | `<name>Param` | `LoginParam` |

---

## 🌐 API Convention

### Pagination Parameters

```json
{
  "page": 1,
  "pageSize": 20
}
```

### Response (Paging)

```json
{
  "code": "200",
  "message": "Success",
  "page": 1,
  "total_pages": 10,
  "total_results": 100,
  "data": [ ... ]
}
```

### Response (Array)

```json
{
  "code": "200",
  "message": "Success",
  "data": [ ... ]
}
```

### Response (Object)

```json
{
  "code": "200",
  "message": "Success",
  "data": { ... }
}
```
