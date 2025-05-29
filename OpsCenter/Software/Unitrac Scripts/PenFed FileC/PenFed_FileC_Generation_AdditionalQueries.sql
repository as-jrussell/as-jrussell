select * from work_item_action
where action_note_tx like '%897001%'

select * from work_item
where relate_id = 70764417

-- 1. Plugin original work item ID from QA.
-- 2. Get the process definition from the Action_Note_tx from the work_item_action
-- 3. Query that Process definition , and get the SETTINGS_XML
-- 4. From the XML, find the  <OriginatorProcessLogId>61431805</OriginatorProcessLogId>
-- 5. THis next: From the original Work ITem, find a PROCESS_DEFINITION that's created soon after the Work_Item_actions in the query below, 
--        that's of process_type_Cd = 'FISERVOBU'. This is the ProcessDef you need to debug.
-- 6. then find the procss Log items for that process log, related to that process definition.
declare @WorkItemId bigint = 46917965  --46917965 -- 46917887
declare @ProcessDefID bigint = 897001 --745452 --745451

select 'WORK_ITEM', * from work_item where id = @WorkItemId 
select 'WORK_ITEM_ACTION', * from work_item_action where work_item_id = @WorkItemId

-- get Cycle Work Item ID and Process Def ID  from Work_item_action.Action_note_tx, ex: Cycle Work Item: 46917887, Process Definition Id: 745451
select 'PROCESS_DEFINITION', * from process_definition where id = @ProcessDefID

select * from process_definition where create_Dt > '2018-07-11 11:03:45.010' and process_type_Cd = 'FISERVOBU'

select 'PROCESS_LOG', * from process_log where process_definition_id = @ProcessDefID
select 'PROCESS_LOG_ITEM', * from process_log_item where process_log_id in (61432398, 61432400, 61432571)
 --(select ID from process_log where process_definition_id = 745453)


declare @ProcessLogId bigint = 61431805
select * from process_log where id = @ProcessLogId

GetBillingFIleDetails 1888657

sp_helptext GetBillingFileDetails
