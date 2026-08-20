# 🛒 Case Study: From Cursor AI Spaghetti to Clean Architecture in Flutter

> **Original project generated entirely with Cursor AI · Zero manual code by the author.**  
> *How we transformed a fragile AI-generated prototype into a production-ready, testable Clean Architecture codebase.*

[![Flutter](https://img.shields.io/badge/Flutter-3.6+-02569B?logo=flutter)](https://flutter.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Cortex-00E676)]()
[![Linter](https://img.shields.io/badge/Linter-0%20Issues-brightgreen)]()
[![Tests](https://img.shields.io/badge/Tests-100%25%20Passing-brightgreen)]()
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

---

## 📌 Executive Summary

Modern AI tools (Cursor, Claude, Copilot) allow builders to scaffold functional prototypes in minutes. However, as applications scale beyond **1,000–2,000 LOC**, AI-generated projects frequently accumulate severe **AI-Debt & Architectural Drift**:
* Tightly coupled UI and database operations causing cascading regressions.
* Hardcoded instantiations (`new Service()`) rendering unit testing impossible.
* Leaking `BuildContext` into asynchronous business logic, triggering runtime crashes.

This case study documents the **systematic architectural remediation** of an open-source grocery shopping app (`akilli_market_listem`) originally generated without manual code.

---

## 📊 Key Engineering Metrics (Before vs After)

| Metric / Dimension | Before (As-Is: AI Prototype) | After (To-Be: Clean Architecture) | Impact |
| :--- | :--- | :--- | :--- |
| **Architectural Risk Index (ARI)** | **83.5 / 100 (Critical)** | **11.0 / 100 (Stable)** | **-87% Risk Reduction** |
| **Dependency Injection (DI)** | **0%** (Hardcoded `new`) | **100%** (Single Composition Root) | **Full Inversion of Control** |
| **Layer Isolation** | **None** (`BuildContext` in logic) | **Strict** (Data $\rightarrow$ Domain $\rightarrow$ Presentation) | **Zero UI-logic coupling** |
| **State Cross-Talk** | Direct `context.read<ArchiveVM>` | **Eliminated** (Domain Repositories) | **Modular Feature Slices** |
| **Unit Testability** | **0%** (Blocked by DB/Network) | **100%** (Isolated Mock Tests) | **Production-grade Suite** |
| **Static Analysis** | 161 issues / compile errors | **0 errors, 0 warnings** | **Clean Flutter Analyze** |

---

## 🔍 The Anatomy of AI-Debt (What Went Wrong)

### 1. BuildContext Leaks in State Management
```dart
// ❌ BEFORE (before/lib/viewmodel/shopping_list_view_model.dart)
Future<void> addItem(BuildContext context, String name, double price) async {
  await _databaseService.insertItem(item);
  ToastUtils.showSuccessToast(context, title: 'Item Added'); // Crashes if widget is unmounted!
}
```

```dart
// ✅ AFTER (after/lib/features/shopping_list/presentation/notifiers/shopping_list_notifier.dart)
Future<void> addItem(ShoppingItemEntity item) async {
  await _shoppingRepository.insertItem(item);
  _message = UiMessage.success(title: 'Item Added'); // Zero-context reactive event!
  notifyListeners();
}
```

### 2. Zero Dependency Injection & Hardcoded Singletons
```dart
// ❌ BEFORE: Direct instantiation inside presentation layer
final ApiService _apiService = ApiService();
final DatabaseService _databaseService = DatabaseService();
```

```dart
// ✅ AFTER: Injected domain contracts via single Composition Root
class ShoppingListNotifier extends ChangeNotifier {
  final IShoppingRepository _shoppingRepository;
  final IArchiveRepository _archiveRepository;

  ShoppingListNotifier({
    required IShoppingRepository shoppingRepository,
    required IArchiveRepository archiveRepository,
  }) : _shoppingRepository = shoppingRepository,
       _archiveRepository = archiveRepository;
}
```

---

## 🛠️ Repository Structure

* [`/before`](./before) — Original untouched codebase (*As-Is snapshot for comparison*).
* [`/after`](./after) — Remediated Clean Architecture codebase (*100% working, testable Flutter app*).
* [`/docs`](./docs) — Detailed architectural artifacts:
  * [`AUDIT_REPORT.md`](./docs/specs/AUDIT_REPORT.md) — 4-axis diagnostic triage report.
  * [`ARCHITECTURE_SPEC.md`](./docs/specs/ARCHITECTURE_SPEC.md) — Domain, layer, and contract specification.
  * [`ADR-001.md`](./docs/adr/ADR-001-remediation.md) — Architectural Decision Record.
* [`CASE_STUDY.md`](./CASE_STUDY.md) — Full in-depth case report.

---

## 🚀 How to Run the Remediated App

```bash
cd after
flutter pub get
flutter test
flutter run -d windows # or macos / linux / chrome / android
```

---

## ⚖️ Attribution & Ethics

This project is an independent architectural remediation and educational showcase.
* **Original UI Concept & Application Idea:** [@ruwiss](https://github.com/ruwiss/akilli_market_listem) (HQ NET).
* **Remediation & Architecture:** [DaTox Remediation & Architecture Governance](https://github.com/DaTox-Systems).

---

## 🤝 Need Architectural Triage?

Working with an AI-generated Flutter codebase that has become fragile or difficult to maintain?  
We offer independent architectural audits and structured codebase remediation.

📬 Reach out via **GitHub Discussions**, **LinkedIn**, or **Upwork** to discuss your project.
