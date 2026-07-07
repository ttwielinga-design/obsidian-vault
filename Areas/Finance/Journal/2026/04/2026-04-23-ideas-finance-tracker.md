---
title: "ideas finance tracker"
date: 2026-04-23
type: journal
area: finance
tags: [type/journal, area/finance, status/active, topic/accounting]
status: active
source_file: "Downloads/ideas finance tracker.docx"
source_type: docx
confidence: 0.8
imported: 2026-05-14
---

Remaining issues
1. Credit card payments still Uncategorized
"Overboeking naar creditcard" / "Rabobank Overboeking saldo CC" are now Uncategorized (better than Personal Development) but still count as expenses. They're genuinely Transfer events — paying off a credit card isn't spending. Adding 'creditcard' to the Transfer keywords would fix this for the €10k total).
2. Old pf_networth_history entries contain corrupted data
The history was written with the old broken rules (e.g. March 2025 had -€138k "surplus"). The analytics that read from history — spendingAnomalies, savingsTrend, cashForecast — are all built on this corrupted baseline. The history only updates when the user navigates to a month, so old entries persist stale until then. A "Recalculate History" button (or automatic rebuild on CSV upload) would fix this.
3. "Overboeking naar creditcard" is negative so it's now an Uncategorized expense — same as point 1. One keyword addition would clean up several thousand euros of phantom expenses.
4. The house purchase (€53k to Westvaer B.V., May 2025) distorts the cash forecast
It pulls the 12-month surplus average sharply negative. The forecast's surplusMean includes that month, making projected cash balances pessimistic. There's no way to mark it as a one-time event to exclude from trend calculations.
5. "Gifts / schenking" have no income category
"De heer F. van Dijk" "schenking tbv Thomas furniture fund" (+€6,999), "Hr A J J Boerkamp" birthday/graduation gifts (+€350+) are all Uncategorized. They're not salary, rental, or side income. Adding 'schenking', 'cadeau', 'verjaardag' → Other Income would capture these.

Feature ideas
A. Rental income sub-dashboard
You have at minimum 3 active tenants (Kalf, Sandbergen, Engelen) across multiple properties. A small table showing per-tenant monthly income, arrears, and total annual rental yield vs. mortgage cost would be immediately useful — especially with the tax briefing already tracking rental income.
B. One-time event flagging
A toggle on individual transactions to mark them as "exclude from trends". Transactions marked this way would still appear in the monthly cash flow but be excluded from cashForecast, savingsTrend, and spendingAnomalies. This would fix the house purchase distortion and handle other outliers (large gifts, fund sales).
C. Foreign currency tracking
The CSV already contains "Oorspr bedrag" (original amount) and "Koers" (exchange rate) columns — currently ignored by parseCSV. Surfacing these in the transaction table (e.g. "USD 179 @ 1.02") would be useful given the frequency of international spending (flights, US hotels, Venice).
D. History rebuild on upload
When a new CSV is uploaded, re-run the history-writing logic for all months present in the upload, not just the latest. This would self-heal the corrupted March/Feb 2025 history entries and keep spendingAnomalies accurate.
E. Savings rate when income ≤ 0
Currently shows 0.0% (because inc.total > 0 ? ... : 0). For months with a rent reversal like April 2026, showing — instead of 0.0% would be clearer — 0% implies you saved nothing, when actually the data is just anomalous.



Personal tracker – when was the house bought and thus the mortgage start (also to auto change the loan amount

Hard to read need to fix the letter colors especially here:

And the drop down of the assign category

This looks extremely ugly please advice:


Letter type is in consistent throughout and does not match the estetic of what we try to achieve (the ‘obsidian’ of personal finance)

This looks off in spacing I think we should fold in ISN and Exchange:


Also how hard is it to make a connection to yahoo finance to update this when we load it. I do not mind putting in the avarige purchase price once but actual tracking would be nice.

Also, we have a trding 212 account now where we auto invest everymonth we should build this out as a feature to update every month (they are bought automatically on the first of the month.


This is not readable:


Also, is the amount that is saved if positive spent if negative (cash) per month added/subtrackted to the net worth at the end of the month?

Also I think we should add in a starting balance cash where we can show this since that since the cash we hold is no longer available?

Also the vs last year do not work:


I want a cash flow overtime graph at the bottom where I can select time line:



Also do you not think savings rate should be cash surplus + amount invested?



Cleanness and smoothness of the dropdown for the ‘Category’ still feels off and not like obsidian Esque

This needs to be fixed give 3 suggestions:
:
This coloring makes no sence:



Net worth needs to update depending on month selected:


Net worth also needs to update based on the cashflow result of that month

Add equity section next to the: ‘money’ , ‘ planning’ sections we already have

When money goes to bank accounts related to investing ask for (this should fall under the ‘equity’ section):
What stock / ETF did you purchase on that date
Connection to Yahoo finance to check the price of that ETF on market open of that day.
Add that to networth

The property part should be taken out of settings and fall under the ‘equity’ section (new)


One you have created a full back up of the data there should be an option to delete your data as a popup.

Broker IBAN is not functional


You need to be able to add and delete your own IBAN accounts


Monthly budgeting should be a different tab as well with suggestions etc. Give me tips on how to build this feature, it is a big one. Use market research on the most popular budgeting apps.
Budget should be based on % of income as well as fixed amount. There should be a trend analysis in there (like we have already built in softly)



This white box still look extremely ugly how would you fix it?

I also think we need to implement an SQL database that will run locally on start-up – what do you think?
Should there be one for transactions?
Should there be one for the classification of transactions?

When I use the arrows to select the next transaction it goes up or down 2 transactions instead of 1


The scrolling of this falldown only works when I am at the bottom of the table:
