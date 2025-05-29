

select *
into unitrachdstorage..INC0419455_OWNERPOLICY
 from owner_policy
where id in (select [op id] from unitrachdstorage..INC0419455_OP)


update op set purge_dt = GETDATE(), update_dt = GETDATE(), update_user_tx = 'INC0419455', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--select *
 from owner_policy op
where id in (select [op id] from unitrachdstorage..INC0419455_OP)


select *
into unitrachdstorage..INC0419455_INTERACTIONHISTORY
 from interaction_history
where id in (select [ih id] from unitrachdstorage..[INC0419455_OP IH])


update op set purge_dt = GETDATE(), update_dt = GETDATE(), update_user_tx = 'INC0419455', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--select *
 from interaction_history op
where id in (select [ih id] from unitrachdstorage..[INC0419455_OP IH])


select *
into unitrachdstorage..INC0419455_PolicyCoverage
 from policy_coverage
where id in (select [policy_coverage id] from unitrachdstorage..[INC0419455_OP Coverage])


update op set purge_dt = GETDATE(), update_dt = GETDATE(), update_user_tx = 'INC0419455', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--select *
 from policy_coverage op
where id in (select [policy_coverage id] from unitrachdstorage..[INC0419455_OP Coverage])




select *
into unitrachdstorage..INC0419455_ESCROW_Data
 from escrow
where id in (select [ESCROW ID] from unitrachdstorage..INC0419455_Escrow)



update op set purge_dt = GETDATE(), update_dt = GETDATE(), update_user_tx = 'INC0419455', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--select *
 from escrow op
where id in (select [ESCROW ID] from unitrachdstorage..INC0419455_Escrow)






select *
into unitrachdstorage..INC0419455_ESCROW_INTERACTIONHISTORY
 from interaction_history
where id in (select [ih id] from unitrachdstorage..[INC0419455_OP IH])


update op set purge_dt = GETDATE(), update_dt = GETDATE(), update_user_tx = 'INC0419455', LOCK_ID = CASE WHEN LOCK_ID >= 255 THEN 1 ELSE LOCK_ID + 1 END
--select *
 from interaction_history op
where id in (select [ih id] from unitrachdstorage..[INC0419455_Escrow IH])