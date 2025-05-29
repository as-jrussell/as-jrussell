1) Run FPC Info script

Review cancel start date. Review most recent billing group ID

2) That cancel amount is calculated differently than the rest of their financials. (Daily vs. Monthly)
As a result, a cancel will be added to the most recent term. This needs to be reduced to match the payment amount and the difference needs
 to be added into the previous term as a cancel txn.

UpdateNicholasCancelFTX_Final.sql will perform the above. ID final cancel amt and last payment amount. Will insert new cancel diff amt into prev term
 then update orig cxl to match payment
***MAKE SURE TO UPDATE FTX TXN DATE IN INSERT STATEMENT*****

***Need Billing Group ID for FTA Updates in above script***
--Tob obtain Billing Group ID, query FTA table:
SELECT BILLING_GROUP_ID,*
FROM FINANCIAL_TXN_APPLY
WHERE FINANCIAL_TXN_ID = 24483272

SELECT *
FROM BILLING_GROUP
WHERE ID = 2105944

SELECT *
FROM BILLING_GROUP
WHERE LENDER_ID = 2234
ORDER BY ID DESC
************************


3) When the refunds (cancelled payment) are posted, they will usually go into most recent term instead of the previous term 
which they should be in.

TFS49456_UpdateNicholasCP_FTX_Term will then moved those back into the previous term.

*********************
Example FPC# to monitor entire process
Policy # NIC0043989
************************


