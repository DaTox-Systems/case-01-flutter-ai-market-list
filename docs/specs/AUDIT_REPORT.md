---
id: "DTX-REPORT-CASE-01"
title: "Architectural Audit Report: Akıllı Market Listem"
type: audit_report
status: active
version: 1.0
module: commercial_deliverable
target_repo: "ruwiss/akilli_market_listem"
target_stack: "Flutter / Dart / Provider / Sqflite / Dio"
target_loc: "~1,200 LOC"
ari_score: 83.5
recommended_tier: "Tier 2A (Core Remediation)"
author: "DaTox Remediation Board"
created: 2026-02-24
---

# ARCHITECTURAL AUDIT & TRIAGE REPORT (v1.0)
**Target:** `ruwiss/akilli_market_listem` (Cursor AI-Generated App)  
**Evaluator:** DaTox Remediation & Architecture Governance  
**Diagnostic Methodology:** `DTX_AUDIT_STANDARD.md (v1.0)`

---

## 1. EXECUTIVE SUMMARY (Для Фаундера / Заказчика)

```text
┌────────────────────────────────────────────────────────────────────────┐
│  ARCHITECTURAL RISK INDEX (ARI): 83.5 / 100 ──► CRITICAL AI-DEBT       │
│  DI / IoC COVERAGE: 0%                      ──► ZERO TESTABILITY       │
│  SAFE AI CONTINUATION: FAIL                 ──► REGRESSION GUARANTEED  │
└────────────────────────────────────────────────────────────────────────┘
```

### Бизнес-диагноз: "Лотерейная кодовая база"
Приложение визуально запускается и выполняет базовые функции, однако архитектурно представляет собой **классический монолитный AI-Debt (ИИ-долг)**, характерный для быстрой сборки через Cursor/ChatGPT без написания кода вручную.

**Ключевой бизнес-риск:**  
В проекте полностью отсутствуют архитектурные границы между экранами, бизнес-логикой и базой данных. Любая последующая доработка (добавление новой категории, смена API или изменение корзины) с высокой вероятностью приводит к **каскадным падениям соседних экранов** и непредвиденным регрессиям.

**Рекомендация бюро:** **Tier 2A (Core Architectural Remediation)** — полная изоляция слоев, внедрение Dependency Injection и фиксация контрактов для безопасного продолжения разработки.

---

## 2. ДЕТАЛЬНОЕ ВСКРЫТИЕ ПО 4 ОСЯМ (Evidence-Based Autopsy)

### 🔴 ОСЬ 1: COUPLING & LAYER ISOLATION — CRITICAL (Оценка: 85/100)
* **Нарушение 1.1 (Утечка UI в бизнес-логику):** Метод `addItem()` в `ShoppingListViewModel.dart` принимает `BuildContext` в качестве первого аргумента для отображения UI-уведомлений:
  ```dart
  // extracted from: lib/viewmodel/shopping_list_view_model.dart:L56
  Future<void> addItem(BuildContext context, String name, double price, ...) async
  ```
  *Риск:* Попытка показать тост через контекст после закрытия экрана или смены ориентации устройства вызывает неуправляемый краш приложения (`Unhandled Exception: Looking up a deactivated widget's ancestor`).
* **Нарушение 1.2 (Отсутствие слоев Domain и Repositories):** ViewModels напрямую обращаются к базам данных SQLite и HTTP-клиентам без промежуточных интерфейсов.

---

### 🔴 ОСЬ 2: STATE & LIFECYCLE RIGOR — HIGH (Оценка: 80/100)
* **Нарушение 2.1 (State Cross-Talk / Мутация между контроллерами):** `ShoppingListViewModel` напрямую командует чужим `ArchiveViewModel` через UI-дерево:
  ```dart
  // extracted from: lib/viewmodel/shopping_list_view_model.dart:L218
  context.read<ArchiveViewModel>().loadArchivedLists();
  ```
  *Риск:* Создается неявная циклическая связность контроллеров через виджеты, делающая невозможным модульное переиспользование списков.

---

### 🔴 ОСЬ 3: DI / IOC & COMPOSITION ROOT — CRITICAL (Оценка: 90/100)
* **Нарушение 3.1 (0% Dependency Injection):** В 100% контроллеров сервисы захардкожены через прямой вызов конструкторов синглтонов:
  ```dart
  // extracted from: lib/viewmodel/product_search_view_model.dart:L7
  final ApiService _apiService = ApiService();

  // extracted from: lib/viewmodel/shopping_list_view_model.dart:L11
  final DatabaseService _databaseService = DatabaseService();

  // extracted from: lib/viewmodel/archive_view_model.dart:L5
  final DatabaseService _databaseService = DatabaseService();
  ```
* **Нарушение 3.2 (Отсутствие Composition Root):** В `main.dart` отсутствует связка зависимостей (Wiring Map). Контроллеры создаются пустыми конструкторами `ChangeNotifierProvider(create: (_) => ...)`.
  *Риск:* **Практически нулевая тестопригодность**. На проект невозможно написать Unit-тесты без поднятия живой базы данных и сервера.

---

### 🟡 ОСЬ 4: CODE HYGIENE & DRIFT — HIGH (Оценка: 78/100)
* **Нарушение 4.1 (Фантомные файлы и AI Drift):** В проекте обнаружены дубликаты представлений (`lib/view/product_search_view.dart` и `lib/view/product/product_search_view.dart`), созданные ИИ в процессе неконтролируемой генерации.
* **Нарушение 4.2 (Сырые DTO и нетипизированные ошибки):** `ApiService` при сбое сети выбрасывает неструктурированные строки `throw Exception('Failed to search products: $e')`.

---

## 3. ГРАФ СВЯЗНОСТИ "AS IS" (Клубок зависимостей)

```text
[ ProductSearchView ] ───► [ ProductSearchViewModel ] ───(new)───► [ ApiService (Singleton) ]
                                                                             │ (Dio / HTTP)
                                                                             ▼
[ ShoppingListView ]  ───► [ ShoppingListViewModel ]  ───(new)───► [ DatabaseService ]
       │                         │ (context.read)                            │ (SQLite)
       │                         ▼                                           │
       └────────────────► [ ArchiveViewModel ]       ───(new)───►───────────┘
```

---

## 4. СРАВНИТЕЛЬНАЯ ТАБЛИЦА МЕТРИК (AS IS vs TARGET TO BE)

| Метрика | Исходное состояние (As Is) | Целевое состояние (To Be — DaTox) |
| :--- | :--- | :--- |
| **Architectural Risk (ARI)** | **83.5 / 100 (Critical)** | **< 15.0 / 100 (Stable)** |
| **Dependency Injection** | **0%** (Hardcoded `new`) | **100%** (Composition Root / Interfaces) |
| **Layer Isolation** | **Отсутствует** (UI в ViewModel) | **Полная** (Presentation $\rightarrow$ Domain $\rightarrow$ Data) |
| **State Cross-Talk** | **Присутствует** (`context.read`) | **Ликвидирован** (Domain Events / Repositories) |
| **Unit Testability** | **0%** (Блокировка сетью и БД) | **100%** (Изолированные Mock-тесты) |
| **Safe AI Continuation** | **FAIL** (Промпты ломают экраны) | **PASS** (Разработка по Атласу и контрактам) |

---

## 5. ПОШАГОВЫЙ ПЛАН РЕКОНСТРУКЦИИ (Remediation Blueprint)

1. **Этап 1: Доменные контракты и DTO (`Domain Layer`)**
   * Выделение интерфейсов `IProductRepository`, `IShoppingListRepository`, `IArchiveRepository`.
   * Создание неизменяемых сущностей (`Entities`) и моделей ошибок (`Failure / Result<T>`).
2. **Этап 2: Инфраструктурная изоляция (`Data Layer`)**
   * Перенос `Dio` и `Sqflite` в изолированные DataSources под управлением репозиториев.
3. **Этап 3: Очистка состояния (`Presentation Layer`)**
   * Полное удаление `BuildContext` из всех ViewModel.
   * Изоляция уведомлений через единый `NotificationService` / Event Bus.
4. **Этап 4: Сборка Composition Root & Атлас**
   * Регистрация единого графа зависимостей.
   * Добавление локального паспорта `DATOX_SYSTEM_ATLAS.md` для дальнейшей безопасной работы с ИИ.

---

> *Approved for Client Delivery,*  
> **DaTox Remediation Board**
