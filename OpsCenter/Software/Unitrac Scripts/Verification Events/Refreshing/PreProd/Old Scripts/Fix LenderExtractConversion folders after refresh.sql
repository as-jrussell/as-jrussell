USE VUT
GO
SELECT * FROM tblLenderExtractConversion WITH (NOLOCK) ORDER BY ConversionProgram DESC

UPDATE  tblLenderExtractConversion
SET     ConversionProgram = ( SELECT    REPLACE(CAST(ConversionProgram AS VARCHAR(255)),
                                                '\\vut-app.colo',
                                                'C:\LenderFileExtracts')
                            )
WHERE   ConversionProgram LIKE '\\vut-app.colo%'
UPDATE  tblLenderExtractConversion
SET     ConversionProgram = ( SELECT    REPLACE(CAST(ConversionProgram AS VARCHAR(255)),
                                                '\\vut-app',
                                                'C:\LenderFileExtracts')
                            )
WHERE   ConversionProgram LIKE '\\vut-app%'
UPDATE  tblLenderExtractConversion
SET     InputFileName = ( SELECT    REPLACE(CAST(InputFileName AS VARCHAR(255)),
                                            '\\vut-app.colo', 'C:\LenderFiles')
                        )
WHERE   InputFileName LIKE '\\vut-app.colo%'
UPDATE  tblLenderExtractConversion
SET     InputFileName = ( SELECT    REPLACE(CAST(InputFileName AS VARCHAR(255)),
                                            '\\vut-app', 'C:\LenderFiles')
                        )
WHERE   InputFileName LIKE '\\vut-app%'
UPDATE  tblLenderExtractConversion
SET     InputFileName = ( SELECT    REPLACE(CAST(InputFileName AS VARCHAR(255)),
                                            '\Data', '')
                        )
WHERE   InputFileName LIKE '%\Data%'
UPDATE  tblLenderExtractConversion
SET     InputFileName = ( SELECT    REPLACE(CAST(InputFileName AS VARCHAR(255)),
                                            '\Eastern', '')
                        )
WHERE   InputFileName LIKE '%\Eastern%'
UPDATE  tblLenderExtractConversion
SET     InputFileName = ( SELECT    REPLACE(CAST(InputFileName AS VARCHAR(255)),
                                            '\Central', '')
                        )
WHERE   InputFileName LIKE '%\Central%'
UPDATE  tblLenderExtractConversion
SET     InputFileName = ( SELECT    REPLACE(CAST(InputFileName AS VARCHAR(255)),
                                            '\Western', '')
                        )
WHERE   InputFileName LIKE '%\Western%'
UPDATE  tblLenderExtractConversion
SET     InputFileName = ( SELECT    REPLACE(CAST(InputFileName AS VARCHAR(255)),
                                            '\Midwest', '')
                        )
WHERE   InputFileName LIKE '%\Midwest%'
UPDATE  tblLenderExtractConversion
SET     InputFileName = ( SELECT    REPLACE(CAST(InputFileName AS VARCHAR(255)),
                                            '\Mountain', '')
                        )
WHERE   InputFileName LIKE '%\Mountain%'
UPDATE  tblLenderExtractConversion
SET     InputFileName = ( SELECT    REPLACE(CAST(InputFileName AS VARCHAR(255)),
                                            '\Kazeck', '')
                        )
WHERE   InputFileName LIKE '%\Kazeck%'
UPDATE  tblLenderExtractConversion
SET     InputFileName = ( SELECT    REPLACE(CAST(InputFileName AS VARCHAR(255)),
                                            '\Kazeck', '')
                        )
WHERE   InputFileName LIKE '%\Kesler%'

UPDATE  tblLenderExtractConversion
--SET InputFileName = (SELECT REPLACE(CAST(InputFileName AS VARCHAR(255)),'C:\LenderFiles','\\utqa2-app1\LenderFiles'))	-- QA2
--SET InputFileName = (SELECT REPLACE(CAST(InputFileName AS VARCHAR(255)),'C:\LenderFiles','\\utqa3-app1\LenderFiles'))	-- QA3
--SET InputFileName = (SELECT REPLACE(CAST(InputFileName AS VARCHAR(255)),'C:\LenderFiles','\\utstage-app1\LenderFiles'))	-- Staging
SET InputFileName = (SELECT REPLACE(CAST(InputFileName AS VARCHAR(255)),'C:\LenderFiles','\\UniTrac-PreProd\LenderFiles'))	-- PreProd
WHERE   InputFileName LIKE 'C:\LenderFiles%'

