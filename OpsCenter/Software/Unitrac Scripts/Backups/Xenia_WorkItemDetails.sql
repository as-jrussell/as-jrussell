/*

Hi Ross, 

I've got a report request from Sharlene for Billing File Workflow - the one you've written a query for.

I understood that it needed to pick very first action for a certain workflowID and then append as many as there are sequentially.

I've redone that query to get rid of cursors and temp tables and here is what I've got - I would like to ask you to take a look and tell me if it is good.

@num_col is the greatest number of actions per work item (to determine how many columns and joins there will be)

@sql1 is column selections for additional actions per work item (up to @num_col)

@sql is joins for each additional action pre work item  (up to @num_col)


Here is what it looks like - thank you:
 */




declare @FirstDayLastMonth datetime = DATEADD(month, DATEDIFF(month, -1, getdate()) - 2, 0);
declare @LastDayLastMonth datetime = DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0));
declare @nl Char(2) = char(13) + char(10);
declare @comma Char(1) = char(44);
declare @tab Char(1) = char(9);
declare @Tchar Char(1) = char(84);
declare @num_col int = 
(
select max(rn) from
(
select  
row_number() over(partition by wia.WORK_ITEM_ID order by wia.UPDATE_DT) as rn
FROM [UniTrac].[dbo].[WORK_ITEM] wi 
  join WORK_ITEM_ACTION wia on wia.work_item_id = wi.ID 
  join WORK_QUEUE_WORK_ITEM_RELATE wqwir on wqwir.work_item_id = wi.id and wi.CURRENT_QUEUE_ID=wqwir.WORK_QUEUE_ID
  join WORK_QUEUE wq on wqwir.work_queue_id = wq.ID 
  join WORK_QUEUE wq2 on wq2.ID=wia.CURRENT_QUEUE_ID
where 1=1
  and wi.WORKFLOW_DEFINITION_ID=10
  and wi.STATUS_CD='Complete'
  and wia.update_dt between @FirstDayLastMonth and @LastDayLastMonth
  and ( replace(replace(wia.ACTION_NOTE_TX, @tab, ''), @nl,'') = 'Reassign To Billing File GroupTo User Level: Billing File Specialist' 
  or replace(replace(wia.ACTION_NOTE_TX, @tab, ''), @nl,'') = 'Generate Billing File'  ) 
  ) tbl
  );
 declare @sql varchar(max) = '';
 declare @sql1 varchar(max) = '';
 declare @sql2 varchar(max) = '';
 select 
@sql1 = @sql1 + 
' ,bwi' + cast(ID as varchar(max)) + '.ActionDate as [ActionDate' + cast(ID as varchar(max)) +  '|DateTimeFormat]' +
' ,coalesce(bwi' + cast(ID as varchar(max)) + '.[Action], '''') as Action' + cast(ID as varchar(max)) +  
' ,coalesce(bwi' + cast(ID as varchar(max)) + '.EndStatus, '''') as EndStatus' + cast(ID as varchar(max)) +  
' ,coalesce(bwi' + cast(ID as varchar(max)) + '.Note, '''') as Note' + cast(ID as varchar(max)) +  
' ,coalesce(bwi' + cast(ID as varchar(max)) + '.[User], '''') as User' + cast(ID as varchar(max)) +  
' ,coalesce(bwi' + cast(ID as varchar(max)) + '.[EndQueue], '''') as EndQueue' + cast(ID as varchar(max)),
@sql2 = @sql2 + 
' left outer join bwi bwi' +  + cast(ID as varchar(max)) +  ' on bwi1.WorkItemID = bwi' +  cast(ID as varchar(max)) + '.WorkItemID and bwi'  + cast(ID as varchar(max)) +  '.rn = '  + cast(ID as varchar(max)) + ' ' 
from dbo.SplitFunction(replicate('1,', 1000), ',') where id >= 2 and ID <= @num_col;
set @sql = 
'
declare @nl Char(2) = char(13) + char(10);
declare @comma Char(1) = char(44);
declare @tab Char(1) = char(9);
declare @Tchar Char(1) = char(84);
with bwi as
(
select  
replace(replace(replace(wi.content_xml.value(''(/Content/Lender/Name/node())[1]'', ''varchar(50)''), @tab, ''''), @nl,''''), @comma,'''') BankName, 
wi.content_xml.value(''(/Content/Lender/Code/node())[1]'', ''varchar(30)'') BankCode, 
wia.WORK_ITEM_ID WorkItemID, 
cast(wia.UPDATE_DT as datetime) [ActionDate],  
wia.ACTION_CD [Action], 
wia.TO_STATUS_CD [EndStatus], 
replace(replace(wia.ACTION_NOTE_TX, @tab, ''''), @nl,'''') 
Note, 
wia.UPDATE_USER_TX [User], 
wq2.NAME_TX [EndQueue] ,
row_number() over(partition by wia.WORK_ITEM_ID order by wia.UPDATE_DT) as rn
FROM [UniTrac].[dbo].[WORK_ITEM] wi 
  join WORK_ITEM_ACTION wia on wia.work_item_id = wi.ID 
  join WORK_QUEUE_WORK_ITEM_RELATE wqwir on wqwir.work_item_id = wi.id and wi.CURRENT_QUEUE_ID=wqwir.WORK_QUEUE_ID
  join WORK_QUEUE wq on wqwir.work_queue_id = wq.ID 
  join WORK_QUEUE wq2 on wq2.ID=wia.CURRENT_QUEUE_ID
where 1=1
  and wi.WORKFLOW_DEFINITION_ID=10
  and wi.STATUS_CD=''Complete''
  and wia.update_dt between ''' + cast(@FirstDayLastMonth as varchar(max)) +  ''' and ''' + cast(@LastDayLastMonth as varchar(max)) + '''  
  and ( replace(replace(wia.ACTION_NOTE_TX, @tab, ''''), @nl,'''') = ''Reassign To Billing File GroupTo User Level: Billing File Specialist'' 
  or replace(replace(wia.ACTION_NOTE_TX, @tab, ''''), @nl,'''') = ''Generate Billing File''  ) 
)
select  
bwi1.BankName, 
bwi1.BankCode, 
bwi1.WorkItemID, 
bwi1.ActionDate as [ActionDate1|DateTimeFormat],  
bwi1.[Action] as [Action1], 
bwi1.EndStatus as [EndStatus], 
bwi1.Note as [Note1], 
bwi1.[User] as [User1], 
bwi1.[EndQueue] as [EndQueue1]
'
+ @sql1 + ' from bwi bwi1 ' + @sql2 + ' where bwi1.rn = 1 order by bwi1.WorkItemID';
exec(@sql);

