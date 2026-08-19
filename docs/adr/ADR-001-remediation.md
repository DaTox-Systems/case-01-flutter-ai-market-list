---
id: "DTX-ADR-001-CASE-01"
title: "ADR-001: Architectural Decisions for Case 01 Remediation"
type: adr
status: accepted
version: 1.0
module: commercial_adr
target: "work/portfolio/case_01_market_list"
related:
  - "projects/datox_remediation/docs/specs/CASE_01_ARCHITECTURE_SPEC.md"
updated: 2026-02-24
---

# ADR-001: ARCHITECTURAL DECISIONS FOR CASE 01 (v1.0)

## 1. CONTEXT (Контекст)
Исходный проект `ruwiss/akilli_market_listem` содержит критические дефекты: передача `BuildContext` в бизнес-логику, прямое инстанцирование синглтонов `new ApiService()`, взаимные вызовы между контроллерами через UI-дерево.

## 2. DECISIONS (Принятые Решения)

### ADR-01.1: State Management & Naming Convention
* **Решение:** Использовать стандартный `ChangeNotifier` из пакета `provider` с суффиксом **`*Notifier`**.
* **Обоснование:** Сохраняет совместимость с исходным стеком (минимальный порог входа для клиента), но внедряет строгую инверсию зависимостей.

### ADR-01.2: Context Elimination (Zero-Context Invariant)
* **Решение:** Полный запрет на передачу `BuildContext` в методы `Notifier`.
* **Обоснование:** Ликвидирует 100% падений из-за деактивированных виджетов при асинхронных операциях и смене конфигурации экрана.

### ADR-01.3: Lean Domain (No UseCase Over-engineering)
* **Решение:** Отказ от создания отдельных классов `UseCase` (e.g. `SearchProductsUseCase`). Контроллеры работают напрямую с `IRepository`.
* **Обоснование:** Для проекта объемом ~1,200 LOC введение UseCases — неоправданный оверинжиниринг. Интерфейсов репозиториев достаточно для 100% тестопригодности.

### ADR-01.4: Cross-Feature Boundary Mapping
* **Решение:** Межмодульный обмен данными выполняется через конвертацию доменных сущностей (`ProductEntity.toShoppingItem()`).
* **Обоснование:** Исключает циклическую связность между модулем поиска и модулем списка покупок.

### ADR-01.5: Decoupled Archive Flow
* **Решение:** Архивирование списка покупок выполняется через вызов `IArchiveRepository` внутри транзакции, без обращения `ShoppingListNotifier` к `ArchiveNotifier`.
* **Обоснование:** Устраняет скрытую спагетти-связность контроллеров.

## 3. CONSEQUENCES (Последствия)
* **Плюсы:** Индекс ARI снижается с 83.5 до <15.0; 100% Unit-тестопригодность; чистый граф зависимостей; легкая доработка через ИИ.
* **Минусы:** Требуется разовая пересборка слоя данных и маппинга моделей.
