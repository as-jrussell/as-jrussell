UPDATE ih
set  SPECIAL_HANDLING_XML.modify('replace value of 
   (/SH/Premium/text())[1] with "0"') ,
   ih.UPDATE_DT = GETDATE() , ih.LOCK_ID = ih.LOCK_ID + 1 , ih.UPDATE_USER_TX = 'TASK37559'
   ---- SELECT ih.SPECIAL_HANDLING_XML.value ('(//SH//Premium)[1]', 'varchar(50)'), ih.*
   from CPI_ACTIVITY cpia
	inner join FORCE_PLACED_CERTIFICATE fpc on fpc.CPI_QUOTE_ID = cpia.CPI_QUOTE_ID
	inner join INTERACTION_HISTORY ih on ih.RELATE_ID = fpc.ID
		and ih.RELATE_CLASS_TX = 'Allied.UniTrac.ForcePlacedCertificate'
WHERE
cpia.ID in (
28121455,
28121467,
28121468,
29097040,
29098613,
29100185,
29100310,
29100377,
29100406,
29100557
)
go