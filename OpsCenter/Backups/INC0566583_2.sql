DECLARE @Begin_Date date = '01-01-2020';
DECLARE @End_Date date = '01-01-2021';


--copy below for datastore

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
DECLARE @start date = @Begin_Date;
DECLARE @end date = @End_Date;

select 
 op.[Lender Code|TextFormat],
 op.[Lender|TextFormat],
 op.[Loan Number|TextFormat],
op.[Email Status|TextFormat],
op.[First Email Date|DateFormat],
op.[Second Email Date|DateFormat],
op.[Note|TextFormat],
op.[Memo Type|TextFormat]
from
(select * from openquery([on-sqlclstprd-2.colo.as.local], '
select 
ln.CODE_TX [Lender Code|TextFormat],
ln.NAME_TX [Lender|TextFormat],
l.NUMBER_TX [Loan Number|TextFormat],
s.STATUS_CD [Email Status|TextFormat],
convert(varchar(10), s.CREATE_DT, 101) [First Email Date|DateFormat],
convert(varchar(10), s.TRIGGER_EVENT_DT, 101) [Second Email Date|DateFormat],
ih.note_tx [Note|TextFormat],o
case when ih.NOTE_TX is null then ''No Email Yet''
	 when ih.NOTE_TX like ''update status: not%'' then ''Not Good''
	 when ih.NOTE_TX like ''update status: good insurance with%'' then ''Lapse''
	 else ''Good''
end [Memo Type|TextFormat]
from  BSSMessageQueue.dbo.SalesforceMessages s
join Unitrac.dbo.REQUIRED_COVERAGE rc on s.RequiredCoverageID = rc.ID
join Unitrac.dbo.PROPERTY p on rc.PROPERTY_ID = p.id
join Unitrac.dbo.COLLATERAL c on p.ID = c.PROPERTY_ID
join Unitrac.dbo.LOAN l on c.LOAN_ID = l.ID
join Unitrac.dbo.LENDER ln on l.LENDER_ID = ln.ID
left join Unitrac.dbo.INTERACTION_HISTORY ih on p.id = ih.property_id and ih.type_cd = ''memo'' and ih.note_tx like ''update status:%''') )As OP
where convert(Date,op.[First Email Date|DateFormat])   between @start and @end
