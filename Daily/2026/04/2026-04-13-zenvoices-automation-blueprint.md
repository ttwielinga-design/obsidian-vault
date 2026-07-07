---
title: "ZenVoices Automation Blueprint"
date: 2026-04-13
source_file: "3. Personal\Personal Learning\Coding\ZenVoices Automation Blueprint.docx"
source_type: docx
tags: [personal]
area: Areas
status: active
confidence: 0.8
imported: 2026-05-14
---

# ZenVoices Automation Workflow
### A Systems Engineer’s Complete Blueprint

## 📐 ARCHITECTURE OVERVIEW
Before building anything, understand ZenVoices’ core architecture:
ZenVoices is a software tool designed for efficient invoice processing, featuring automatic invoice recognition, digital authorization, and real-time scanning capabilities tailored for accountants and entrepreneurs.
It is an accounts payable software designed to automate invoice processing, manage supplier relationships, and ensure accurate financial records. The platform provides tools for capturing invoice data, managing approvals, and scheduling payments, reducing manual entry and improving efficiency.
Everything in ZenVoices flows through 5 core pillars:
[INTAKE] → [RECOGNITION] → [AUTHORIZATION] → [BOOKING] → [PAYMENT]
Each pillar can be automated to varying degrees. The goal of this blueprint is to maximize automation at every stage while maintaining control, auditability, and exception handling.

## 🏗️ PHASE 1 — FOUNDATION & ENVIRONMENT SETUP
Before automation can work, the environment must be perfectly configured. Garbage in = garbage out.
### 1.1 — Master Data Synchronization
Administrations, journals, financial periods, suppliers, customers, currencies, payment terms, VAT codes, and ledger accounts are automatically retrieved from your accounting software. Suppliers and customers can also be created directly from Zenvoices.
Action Items:
✅ Connect your accounting package first (see Phase 2)
✅ Verify that all suppliers are synced with correct VAT codes and default ledger accounts
✅ Pre-configure default posting rules per supplier — this is the single biggest lever for automation. The AI learns from corrections, so the more accurate your master data, the fewer corrections it needs to learn from
✅ Set financial periods to match your accounting calendar precisely
✅ Validate payment terms per supplier so due-date calculations are accurate from day one
Other master data is managed in your accounting software and synchronised automatically — so keep your source of truth in the accounting system, not in ZenVoices.

### 1.2 — User Roles & Access Rights
Navigate to Manage → Environment → Users & Access Rights.
Build a least-privilege access model:
The help center covers how to manage settings, users, and access rights for administrations and your environment — use this to define scoped access per administration, especially if you manage multiple entities.
Pro tip: If your organization uses Microsoft Entra ID (formerly Azure AD), configure SSO:
You can integrate Zenvoices IMAP with Microsoft Entra ID. When integrated, you can use Microsoft Entra ID to control who can access Zenvoices IMAP and enable your users to be automatically signed in with their Microsoft Entra accounts.
Alternatively, Okta’s Zenvoices integration allows Zenvoices users to log into Zenvoices using Okta as a single sign-on provider.

## 🔌 PHASE 2 — ACCOUNTING INTEGRATION
This is the nervous system of the automation. Everything depends on a rock-solid accounting integration.
Integration with accounting systems and ERP solutions ensures a seamless flow of financial data across departments.
### Supported Integrations (per official documentation):
Integrations include: AFAS Profit, Exact Online, Exact Online Bouw, e-Boekhouden.nl & .be, Exact Globe, InformerOnline, KING ERP, Microsoft Dynamics 365 Business Central, Octopus, Reeleezee, SAP Business One, SnelStart, Twinfield, Exact Boekhoud Gemak, Multivers, and more.
### Integration Setup Checklist:
For cloud-based systems (e.g., Exact Online, Twinfield):
Navigate to Manage → Environment → Accounting Integrations → New
Authenticate via OAuth (no local installation needed)
Test sync — verify that ledgers, cost centers, and VAT pull correctly
For on-premise systems (e.g., Visma AccountView, AFAS on-premise):
Installation requires: A) Installation of the AccountView Communication Service, B) Connection between AccountView.Net and the Communication Service, C) Adding the Zenvoices Connector App to the user, and D) Setting up the Zenvoices accounting integration.
⚠️ Critical nuance for on-premise setups: When administrations are located on network locations, these locations must be defined in AccountView using UNC paths (e.g., \\Servername\SharedFolder) instead of drive letters such as X:\ or Z:\. Drive letter mappings will break the service on restart.

## 📥 PHASE 3 — DOCUMENT INTAKE AUTOMATION
This is where the pipeline starts. The goal is zero manual uploads.
### 3.1 — Email Intake via IMAP Connector
Configure a dedicated invoice inbox (e.g., invoices@yourcompany.com) and connect it via the IMAP channel connector:
Navigate to Manage → Channel Connectors → Add IMAP
Point it to your invoice inbox
Set polling interval (recommendation: every 5–15 minutes)
Configure attachment filtering: accept PDF, XML, UBL, TIFF, PNG
Best Practice: Instruct all suppliers to send invoices directly to this inbox. Create an email auto-responder confirming receipt — this sets professional expectations and reduces duplicate submissions.
### 3.2 — Supplier Email Portal
Many suppliers still email to your general inbox. Solve this with:
A supplier-specific upload link (ZenVoices supports per-supplier upload portals)
Supplier onboarding email template with their dedicated upload address
### 3.3 — UBL / E-Invoice Intake
ZenVoices supports quick conversion of invoices to UBL format for electronic invoicing.
Documents can be automatically converted to UBL in real time — configure this to be on by default for all Dutch/Belgian suppliers subject to e-invoicing mandates.
### 3.4 — Mobile App & Manual Fallback
The mobile app provides additional capture features — use this for on-the-go receipt capture (e.g., expense receipts from field staff). Set a policy: all physical paper invoices must be scanned within 24 hours of receipt.

## 🤖 PHASE 4 — AI RECOGNITION & SMART CODING
This is the brain of ZenVoices. Set it up correctly and it compounds in value over time.
ZenVoices employs machine learning to enhance its invoice processing capabilities, learning from user interactions to improve its accuracy over time.
### 4.1 — Recognition Rules Setup
For each supplier, define:
Default ledger account
Default cost center / cost unit
Default VAT code
Default payment method
The system will pre-fill these on recognition. Corrections made by users feed the ML model.
### 4.2 — Document Splitting Module
The Automatically Split Documents module is available — enable this if suppliers send batch PDFs (multiple invoices in one file). Configure splitting rules based on:
Page count thresholds
Visual separators
Barcode/QR recognition
### 4.3 — Training the AI (Critical!)
The ML model improves with consistent corrections. Establish a discipline:
Week 1–4: All processors correct every misread field immediately and consistently
Month 2+: Spot-check only — the model should be hitting >90% accuracy on known suppliers
Ongoing: When a new supplier appears more than 3 times, verify their default settings are configured

## ✅ PHASE 5 — AUTHORIZATION WORKFLOW (THE APPROVAL MATRIX)
The Authorization Management module supports both simple digital approval workflows and complex multi-level authorization matrices with conditions.
This is the most nuanced part of the setup. Design it carefully.
### 5.1 — Authorization Matrix Design
Build your matrix around three axes:
Example Matrix:
Invoice < €500 + Known Supplier      → Auto-approve (no human touch)
Invoice €500–€5,000                  → L1 Approver (Department Head)
Invoice > €5,000                     → L1 + L2 (Controller + CFO)
New/Unknown Supplier (any amount)    → Always L1 + L2
### 5.2 — Approval Notifications
Configure email notifications for:
Approver receives invoice pending approval → immediate notification
Reminder escalation → 48 hours if no action
Escalation to supervisor → 72 hours if still no action
Approval/rejection confirmation → to processor
### 5.3 — Delegation & Out-of-Office Rules
Always configure delegation rules. An approval workflow breaks down the moment the approver is on holiday. Set fallback approvers per user, per cost center.

## 💳 PHASE 6 — PAYMENT AUTOMATION
ZenVoices facilitates easy payments through SEPA integration.
### 6.1 — Payment Module Setup
The Payments module is available as an optional module — enable it and:
Link your bank account(s) via SEPA configuration
Set payment run schedules (e.g., Tuesday and Friday payment runs)
Configure payment grouping: group multiple invoices to the same supplier into one payment
### 6.2 — Payment Discount Automation
ZenVoices supports processing payment discounts — configure early-payment discount rules per supplier. For example: if supplier offers 2% discount within 10 days, set an automatic flag to prioritize those invoices in the next payment run.
### 6.3 — Payment File Export
After approval, configure the payment file export:
Generate SEPA XML pain.001 files automatically after final approval
Upload to your bank portal (or use direct bank integration if available)
Archive payment confirmation back in ZenVoices

## 🔗 PHASE 7 — PURCHASE-TO-PAY (P2P) MATCHING
With the Purchase to Pay module, purchase orders from your accounting or ERP system can be automatically matched with purchase invoices.
### 7.1 — P2P Configuration
ZenVoices can match invoices with orders and receipts for accuracy.
Setup steps:
Enable the Purchase to Pay module (Compleet subscription or Pay-per-use)
Sync purchase orders from your ERP/accounting system
Configure matching tolerance: e.g., ±2% or ±€10 for price differences
Define matching logic: 2-way match (PO + Invoice) or 3-way match (PO + GRN + Invoice)
### 7.2 — Exception Handling for Mismatches
When a match fails:
Route to procurement team for review (not finance)
Set SLA: resolved within 3 business days
If unresolved → escalate to controller

## 📊 PHASE 8 — ANALYTICS, REPORTING & CONTINUOUS IMPROVEMENT
ZenVoices’ analytics offer insights into cash flow, payment schedules, and outstanding invoices, supporting data-driven financial planning.
### 8.1 — KPIs to Monitor Weekly
### 8.2 — External Reporting via API or Data Warehouse
ZenVoices supports secure API-based access with organization-specific tenancy name, ensuring controlled and structured data retrieval.
You can choose to sync ZenVoices data to your own data warehouse such as Snowflake, Google BigQuery, or MS SQL. With a federated query engine, you can write queries on ZenVoices data, transform it, and join it with other data sources — enabling a unified view of accounting and business operations.
Use this for building dashboards in Power BI, Tableau, or Looker on top of your ZenVoices data.

## 🔐 PHASE 9 — SECURITY, COMPLIANCE & AUDIT TRAIL
### 9.1 — Secure Archiving
ZenVoices provides safe and organized storage of invoices and financial documents.
ZenVoices prioritizes data security and compliance, ensuring that all user data is handled securely.
Configure:
Retention policy: minimum 7 years for tax compliance (Dutch/Belgian law)
Archive access: Auditor role (read-only) for external auditors
Enable audit trail logging — every change, approval, and action is logged with timestamp and user ID
### 9.2 — SSO + MFA Enforcement
Enforce SSO via Microsoft Entra ID or Okta (configured in Phase 1)
Enforce MFA for all users with payment approval rights
Rotate API credentials quarterly

## 🗺️ COMPLETE SYSTEM FLOW DIAGRAM
┌─────────────────────────────────────────────────────────┐
│                     DOCUMENT INTAKE                     │
│  Email (IMAP) → Supplier Portal → Mobile App → API     │
└──────────────────────┬──────────────────────────────────┘
│
▼
┌─────────────────────────────────────────────────────────┐
│                  AI RECOGNITION ENGINE                  │
│  OCR → ML Field Extraction → UBL Conversion → Duplicate │
│  Detection → Auto-coding (Ledger / VAT / Cost Center)  │
└──────────────────────┬──────────────────────────────────┘
│
▼
┌─────────────────────────────────────────────────────────┐
│               P2P MATCHING (if applicable)              │
│  PO Sync → 2-way/3-way Match → Tolerance Check         │
│  Match OK → continue │ Mismatch → Procurement Review   │
└──────────────────────┬──────────────────────────────────┘
│
▼
┌─────────────────────────────────────────────────────────┐
│             AUTHORIZATION / APPROVAL MATRIX             │
│  Auto-approve (low risk) OR Multi-level human approval  │
│  Notifications → Reminders → Escalations               │
└──────────────────────┬──────────────────────────────────┘
│
▼
┌─────────────────────────────────────────────────────────┐
│              BOOKING TO ACCOUNTING SYSTEM               │
│  Automatic journal entry sync → Period validation →    │
│  VAT reporting alignment                               │
└──────────────────────┬──────────────────────────────────┘
│
▼
┌─────────────────────────────────────────────────────────┐
│                   PAYMENT RUN (SEPA)                    │
│  Payment scheduling → Discount optimization →          │
│  SEPA XML generation → Bank upload → Confirmation      │
└──────────────────────┬──────────────────────────────────┘
│
▼
┌─────────────────────────────────────────────────────────┐
│           ARCHIVING, AUDIT TRAIL & ANALYTICS            │
│  Secure 7yr archive → KPI dashboards → API/DWH export  │
└─────────────────────────────────────────────────────────┘

## IMPLEMENTATION ROADMAP

## TOP 5 NUANCES (Systems Engineer’s Notes)
UNC paths over drive letters for on-premise integrations — this single mistake causes the most integration outages
Supplier default ledger pre-configuration is the #1 lever for AI accuracy — do it before going live, not after
Delegation rules are non-negotiable — an authorization workflow without holiday coverage is a liability
Duplicate detection is passive unless tuned — set duplicate detection sensitivity in settings; by default it may miss invoices from the same supplier with slightly different invoice numbers
Payment discount automation is the fastest ROI feature most organizations miss entirely — even 1–2% early payment discounts at volume compound significantly

💡 Final Note: The ZenVoices platform’s true power is not in any single feature — it is in the compounding effect of every stage being properly configured. When fully set up, users have reported reducing invoice processing time from 30–60 seconds per invoice down to 2 seconds. At scale, that is a transformational shift in your finance operation.