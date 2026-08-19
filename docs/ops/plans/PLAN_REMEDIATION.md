---
id: "DTX-PLAN-CASE-01"
title: "Tactical Plan: Remediation of Akıllı Market Listem"
type: tactical_plan
status: active
version: 1.0
module: commercial_ops
target: "work/portfolio/case_01_market_list"
updated: 2026-02-24
---

# TACTICAL REMEDIATION PLAN: CASE-01 (v1.0)
**Objective:** Transform `akilli_market_listem` from monolithic AI-Debt (ARI 83.5) to Clean Cortex Architecture (ARI < 15.0).

---

## 📋 ЭТАПЫ РЕАЛИЗАЦИИ

### ШАГ 1: Каркас и Инфраструктура (`Core & DI`)
* [ ] Создание чистого проекта в `work/portfolio/case_01_market_list/`.
* [ ] Настройка `pubspec.yaml` (только проверенные зависимости).
* [ ] Базовые классы `Failure`, `Result<T>`, `ApiClient` и `DatabaseHelper`.
* [ ] Настройка `injection_container.dart` (DI).

### ШАГ 2: Слой Data & Domain (Контракты)
* [ ] Реализация Entities и Interfaces (`i_product_repository.dart`, `i_shopping_repository.dart`, `i_archive_repository.dart`).
* [ ] Реализация DataSources и Repositories с локальным SQLite и удаленным API.

### ШАГ 3: Слой Presentation (Контроллеры и UI)
* [ ] Реализация `ProductSearchController` (без UI context, чистый debounce).
* [ ] Реализация `ShoppingListController` (управление корзиной и расчетом total).
* [ ] Реализация `ArchiveController` (сортировка и просмотр архивов).
* [ ] Перенос и очистка UI-виджетов.

### ШАГ 4: Тестирование и Сдача
* [ ] Написание Unit-тестов на контроллеры и репозитории.
* [ ] Контрольный промпт AI Continuation (добавление тестовой фичи по Атласу).
* [ ] Формирование финального `CASE_STUDY.md`.

---

> *Approved,*  
> **DaTox Remediation Board**
