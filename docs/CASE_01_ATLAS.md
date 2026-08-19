---
id: "DTX-CASE-01-ATLAS"
title: "Case 01: Smart Market List (Clean Architecture Showcase)"
type: atlas
status: active
version: 1.0
module: case_01
tags:
  - atlas
  - case_01
  - clean_architecture
  - flutter
updated: 2026-02-24
---

# 🛰️ CASE 01: LOCAL SYSTEM ATLAS (v1.0)
**Application:** Akıllı Market Listem (Clean Architecture Showcase)  
**Stack:** Flutter SDK ^3.6.0, Provider, Dio, Sqflite  
**Target:** 100% DI, Zero-Context Notifiers, Decoupled Features.

---

## 1. СТРУКТУРА КАПСУЛЫ КЕЙСА

```text
case_01_market_list/
├── docs/                              # 📄 ДОКУМЕНТАЦИЯ КЕЙСА
│   ├── CASE_01_ATLAS.md               # 🛰️ Локальный Маяк Кейса
│   ├── specs/                         # ARCHITECTURE_SPEC.md, AUDIT_REPORT.md
│   ├── adr/                           # ADR-001-remediation.md
│   ├── ops/plans/                     # PLAN_REMEDIATION.md
│   └── CASE_STUDY.md                  # Итоговый маркетинговый отчет
│
├── input/                             # 🔒 ИСХОДНЫЙ КОД "AS IS" (Passive Text Only)
│   └── raw_repo/                      # Исходный репозиторий akilli_market_listem
│
├── lib/                               # 🛠️ ОЧИЩЕННЫЙ КОД "TO BE" (Clean Cortex)
├── test/                              # 🧪 ТЕСТЫ
└── pubspec.yaml                       # Конфигурация и зависимости
```

---

## 2. СВЯЗЬ С СИСТЕМОЙ БЮРО (UPSTREAM)

* **Реестр кейсов бюро:** `projects/datox_remediation/docs/product/CASE_REGISTRY.md`
* **Стандарт кейсов бюро:** `projects/datox_remediation/docs/standards/DTX_CASE_STUDY_STD.md`

---

> *Signed,*  
> **DaTox Remediation Board**  
> *Case 01 Capsule Registered: 2026-02-24*
