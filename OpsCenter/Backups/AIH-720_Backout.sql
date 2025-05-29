

USE [InforCRM];
	
	UPDATE S SET S.Service_Level_Expectation = C.Service_Level_Expectation
--SELECT C.Service_Level_Expectation, S.Service_Level_Expectation, *
    FROM [InforCRM].sysdba.AREACATEGORYISSUE S
	JOIN InforHDStorage.dbo.CSH2571_AREACATEGORYISSUE_CSS  C ON C.OWNERID = S.OWNERID  AND C.ISSUE = S.ISSUE 	AND S.AREA = 'Delinquency Management Services'
         

	