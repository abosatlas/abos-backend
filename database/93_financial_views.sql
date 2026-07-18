BEGIN;

CREATE OR REPLACE VIEW trial_balance AS

SELECT

a.id,

a.account_code,

a.account_name,

COALESCE(SUM(l.debit),0) debit,

COALESCE(SUM(l.credit),0) credit,

COALESCE(SUM(l.debit-l.credit),0) balance

FROM chart_of_accounts a

LEFT JOIN journal_entry_lines l

ON a.id=l.account_id

GROUP BY

a.id,

a.account_code,

a.account_name;

COMMIT;
