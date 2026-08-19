---
id: "DTX-SPEC-CASE-01-ARCH"
title: "Architecture Specification: Case 01 (Akıllı Market Listem)"
type: architecture_spec
status: active
version: 1.0
module: commercial_specs
target: "work/portfolio/case_01_market_list"
related:
  - "projects/datox_remediation/docs/adr/ADR-001-case-01-remediation-architecture.md"
  - "projects/datox_remediation/docs/specs/AUDIT_REPORT_CASE_01.md"
updated: 2026-02-24
---

# CASE 01: TARGET ARCHITECTURE SPECIFICATION ("To Be")
**Objective:** Deterministic, modular, and testable Clean Cortex Architecture for `case_01_market_list`.

---

## 1. ПРАВИЛА ИМЕНОВАНИЯ И СТЕК (Conventions)

* **Стек:** Flutter SDK ^3.6.0, `provider` (^6.1.1), `dio` (^5.4.1), `sqflite` (^2.3.2), `path` (^1.8.3).
* **Слой управления состоянием:** Классы наследуются от `ChangeNotifier` и именуются с суффиксом **`*Notifier`** (`ProductSearchNotifier`, `ShoppingListNotifier`, `ArchiveNotifier`).
* **Запрет `BuildContext`:** Ни один метод `Notifier` не имеет права принимать `BuildContext`. Все UI-события (уведомления, ошибки) передаются через `ValueNotifier<UiMessage?>` или стримы, которые слушает UI.

---

## 2. МЕЖФИЧЕВОЕ ВЗАИМОДЕЙСТВИЕ (Cross-Feature Boundaries)

```text
┌─────────────────────────┐               ┌─────────────────────────┐
│  FEATURE: products_search│               │  FEATURE: shopping_list │
├─────────────────────────┤               ├─────────────────────────┤
│ ProductSearchScreen     │               │ ShoppingListScreen      │
│          │              │               │          │              │
│ ProductSearchNotifier   │               │ ShoppingListNotifier    │
│          │              │               │          │              │
│ IProductRepository      │               │ IShoppingRepository     │
└──────────┬──────────────┘               └──────────▲──────────────┘
           │                                         │
           │           BOUNDARY MAPPING              │
           └──────► [ ProductEntity.toShoppingItem() ] ──┘
```

* **Инвариант границы:** Фича `products_search` **не знает** о существовании `shopping_list` и его базе данных.
* **Маппинг:** При нажатии «Добавить в список» на экране поиска, `ProductEntity` конвертируется в доменную сущность `ShoppingItemEntity` через метод расширения/фабрику и передается в `ShoppingListNotifier.addItem()`.

---

## 3. ДЕТАЛЬНАЯ ТОПОЛОГИЯ ФАЙЛОВОЙ СИСТЕМЫ

```text
work/portfolio/case_01_market_list/lib/
│
├── main.dart                          # 🚀 Composition Root (MultiProvider & DI Setup)
│
├── core/                              # 🔴 SHARED & INFRASTRUCTURE
│   ├── error/
│   │   ├── exceptions.dart            # ServerException, CacheException
│   │   └── failures.dart              # Failure (Result-pattern primitives)
│   ├── network/
│   │   ├── api_client.dart            # Dio wrapper & Interceptors
│   │   └── api_constants.dart         # Base URL & Endpoints
│   ├── storage/
│   │   └── database_helper.dart       # SQLite Open, Tables Creation, Upgrades
│   ├── theme/
│   │   └── app_theme.dart             # Colors, Typography, Component themes
│   ├── utils/
│   │   └── ui_message.dart            # Notification/Toast payload model
│   └── widgets/                       # 🟢 SHARED UI COMPONENTS
│       ├── app_toast.dart             # Context-independent toast renderer
│       └── loading_indicator.dart     # Common progress indicator
│
└── features/                          # 🟢 BUSINESS SLICES
    │
    ├── products_search/               # ФИЧА 1: ПОИСК ТОВАРОВ
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── product_remote_data_source.dart
    │   │   ├── models/
    │   │   │   └── product_model.dart (fromJson / toEntity)
    │   │   └── repositories/
    │   │       └── product_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── product_entity.dart
    │   │   └── repositories/
    │   │       └── i_product_repository.dart
    │   └── presentation/
    │       ├── notifiers/
    │       │   └── product_search_notifier.dart
    │       ├── screens/
    │       │   └── product_search_screen.dart
    │       └── widgets/
    │           ├── product_card.dart
    │           └── product_detail_dialog.dart
    │
    ├── shopping_list/                 # ФИЧА 2: АКТИВНЫЙ СПИСОК ПОКУПОК
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── shopping_local_data_source.dart
    │   │   ├── models/
    │   │   │   └── shopping_item_model.dart (fromMap / toMap)
    │   │   └── repositories/
    │   │       └── shopping_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── shopping_item_entity.dart
    │   │   └── repositories/
    │   │       └── i_shopping_repository.dart
    │   └── presentation/
    │       ├── notifiers/
    │       │   └── shopping_list_notifier.dart
    │       ├── screens/
    │       │   └── shopping_list_screen.dart
    │       └── widgets/
    │           ├── shopping_item_card.dart
    │           ├── shopping_summary_card.dart
    │           └── update_price_dialog.dart
    │
    └── archive/                       # ФИЧА 3: АРХИВ СПИСКОВ
        ├── data/
        │   ├── datasources/
        │   │   └── archive_local_data_source.dart
        │   ├── models/
        │   │   └── archived_list_model.dart
        │   └── repositories/
        │       └── archive_repository_impl.dart
        ├── domain/
        │   ├── entities/
        │   │   └── archived_list_entity.dart
        │   └── repositories/
        │       └── i_archive_repository.dart
        └── presentation/
            ├── notifiers/
            │   └── archive_notifier.dart
            ├── screens/
            │   └── archive_screen.dart
            └── widgets/
                └── archived_list_detail_dialog.dart
│
└── di/                                # 🔵 COMPOSITION ROOT
    └── injection_container.dart       # Регистрация Repositories & DataSources
        ├── domain/
        │   ├── entities/
        │   │   └── archived_list_entity.dart
        │   └── repositories/
        │       └── i_archive_repository.dart
        └── presentation/
            ├── notifiers/
            │   └── archive_notifier.dart
            ├── screens/
            │   └── archive_screen.dart
            └── widgets/
                └── archived_list_detail_dialog.dart
```
