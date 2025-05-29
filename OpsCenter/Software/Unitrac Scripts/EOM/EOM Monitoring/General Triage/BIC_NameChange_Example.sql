create table #lookup
( oldValue nvarchar(30),
  newValue nvarchar(30)
);

insert into #lookup values('Aeto Insurance Company', 'Alfa');
insert into #lookup values('American Vehicle Ins Co', 'State Farm');
insert into #lookup values('St Paul Surplus Lines Ins CO', 'State Farm');
insert into #lookup values('Encompass Floridian Indemnity', 'Erie');
insert into #lookup values('Liberty Fire Benevolent Societ', 'Liberty Mutual');
insert into #lookup values('National Generl Ins Online Inc', 'Nat General');
insert into #lookup values('Steegh Assurantien Bv', 'Safeco');
insert into #lookup values('Lloyd Thompson Limited', 'Liberty Mutual');
insert into #lookup values('North Pacific', 'Nationwide');
insert into #lookup values('Omega Ins CO', 'Omni');
insert into #lookup values('Medical Protective Co', 'Mercury');
insert into #lookup values('Great Oaks Insurance', 'Geico');
--insert into #lookup values('TMP', 'Travelers');
insert into #lookup values('Kemper Lloyds Ins Co', 'Kemper');
insert into #lookup values('First Indemnity Ins of Hawaii', 'Liberty Mutual');
insert into #lookup values('General Agents Ins Co', 'Geico');
insert into #lookup values('Inland Mutual Ins Co', 'Integon');
insert into #lookup values('Liberty Southern Ins Co Inc', 'Liberty Mutual');
insert into #lookup values('Hanover', 'Horace Mann');
insert into #lookup values('Hanover American Ins CO', 'Horace Mann');
insert into #lookup values('Halifax Mutual', 'Haulers Ins');
insert into #lookup values('Great Lakes Reinsurance', 'Grange Insurance');
insert into #lookup values('Rockingham Casualty Co', 'Rockingham');
insert into #lookup values('Dealers Assurance CO', 'Donegal');


BEGIN TRY
	BEGIN TRANSACTION
	
--select l.NUMBER_TX,OP.BIC_NAME_TX, lu.oldValue, lu.newValue
update op set BIC_NAME_TX = lu.newValue
from LENDER ls
join LOAN l on ls.ID = l.LENDER_ID --and l.PURGE_DT is null
join COLLATERAL c on l.ID = c.LOAN_ID --and c.PURGE_DT is null
join PROPERTY p on c.PROPERTY_ID = p.ID --and p.PURGE_DT is null
join PROPERTY_OWNER_POLICY_RELATE popr on p.ID = popr.PROPERTY_ID --and popr.PURGE_DT is null
join OWNER_POLICY op on popr.OWNER_POLICY_ID = op.ID --and op.PURGE_DT is null
join #lookup lu on op.BIC_NAME_TX = lu.oldValue
where ls.CODE_TX = '4198'


	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	   ROLLBACK TRANSACTION
	   RAISERROR ('ROLLBACK occured BIC_Name Update. NO RECORDS Updated', 16, 1) WITH LOG
	   SELECT
		ERROR_NUMBER() AS ErrorNumber
		,ERROR_SEVERITY() AS ErrorSeverity
		,ERROR_STATE() AS ErrorState
		,ERROR_PROCEDURE() AS ErrorProcedure
		,ERROR_LINE() AS ErrorLine
		,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO  

drop table #lookup


