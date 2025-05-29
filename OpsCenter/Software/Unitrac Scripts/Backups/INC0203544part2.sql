
SELECT  * INTO UniTracHDStorage.dbo.tblextract_26752412
FROM vut.dbo.tblextract_26752412
WHERE lendercollateralcode = 51 --AND contractNumber = '7195-050'


SELECT  *
FROM    UniTrac..LOAN
WHERE   NUMBER_TX IN ( '100439-51      ', '101241-50      ', '101381-51      ',
                       '101470-51      ', '101632-50      ', '101992-50      ',
                       '102127-50      ', '102477-50      ', '103694-50      ',
                       '103956-51      ', '105931-50      ', '106195-50      ',
                       '106565-50      ', '108002-50      ', '109191-50      ',
                       '11100493-050   ', '11101193-051   ', '11102004-050   ',
                       '11102075-050   ', '11102558-050   ', '11103069-050   ',
                       '11103332-050   ', '11104055-050   ', '11104243-050   ',
                       '130099-50      ', '130099-51      ', '130210-50      ',
                       '130339-50      ', '130536-50      ', '130591-50      ',
                       '130899-50      ', '130988-50      ', '131176-52      ',
                       '131207-50      ', '131265-51      ', '131444-50      ',
                       '131531-50      ', '131683-50      ', '131959-50      ',
                       '132344-51      ', '132753-50      ', '133050-50      ',
                       '133240-50      ', '1957114-50     ', '33680-50       ',
                       '34173-50       ', '34835-50       ', '34886-50       ',
                       '34915-50       ', '34986-50       ', '35282-51       ',
                       '35288-50       ', '35476-50       ', '36072-50       ',
                       '36150-50       ', '36408-51       ', '36451-50       ',
                       '36919-50       ', '36921-50       ', '37059-50       ',
                       '37327-50       ', '37367-51       ', '37465-50       ',
                       '37639-50       ', '37729-50       ', '38437-51       ',
                       '38687-50       ', '38842-50       ', '38975-50       ',
                       '39068-50       ', '39145-50       ', '39200-50       ',
                       '39214-50       ', '39422-50       ', '39560-50       ',
                       '39564-50       ', '39620-50       ', '39815-50       ',
                       '39844-51       ', '4030899-50     ', '40760-50       ',
                       '45365-50       ', '9018274-50     ' )
        AND LENDER_ID = '379'
		ORDER BY NUMBER_TX DESC




		SELECT Loan_Number,ContractNumber, * FROM 
		UniTracHDStorage..tblextract_26752412
		WHERE Loan_Number IN ('100439-51      ',
'101241-50      ',
'101381-51      ',
'101470-51      ',
'101632-50      ',
'101992-50      ',
'102127-50      ',
'102477-50      ',
'103694-50      ',
'103956-51      ',
'105931-50      ',
'106195-50      ',
'106565-50      ',
'108002-50      ',
'109191-50      ',
'11100493-050   ',
'11101193-051   ',
'11102004-050   ',
'11102075-050   ',
'11102558-050   ',
'11103069-050   ',
'11103332-050   ',
'11104055-050   ',
'11104243-050   ',
'130099-50      ',
'130099-51      ',
'130210-50      ',
'130339-50      ',
'130536-50      ',
'130591-50      ',
'130899-50      ',
'130988-50      ',
'131176-52      ',
'131207-50      ',
'131265-51      ',
'131444-50      ',
'131531-50      ',
'131683-50      ',
'131959-50      ',
'132344-51      ',
'132753-50      ',
'133050-50      ',
'133240-50      ',
'1957114-50     ',
'33680-50       ',
'34173-50       ',
'34835-50       ',
'34886-50       ',
'34915-50       ',
'34986-50       ',
'35282-51       ',
'35288-50       ',
'35476-50       ',
'36072-50       ',
'36150-50       ',
'36408-51       ',
'36451-50       ',
'36919-50       ',
'36921-50       ',
'37059-50       ',
'37327-50       ',
'37367-51       ',
'37465-50       ',
'37639-50       ',
'37729-50       ',
'38437-51       ',
'38687-50       ',
'38842-50       ',
'38975-50       ',
'39068-50       ',
'39145-50       ',
'39200-50       ',
'39214-50       ',
'39422-50       ',
'39560-50       ',
'39564-50       ',
'39620-50       ',
'39815-50       ',
'39844-51       ',
'4030899-50     ',
'40760-50       ',
'45365-50       ',
'9018274-50     ')
		

        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '33680-50'
        --WHERE   ContractNumber = '33680-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '34173-50'
        --WHERE   ContractNumber = '34173-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '34835-50'
        --WHERE   ContractNumber = '34835-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '34886-50'
        --WHERE   ContractNumber = '34886-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '34915-50'
        --WHERE   ContractNumber = '34915-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '34986-50'
        --WHERE   ContractNumber = '34986-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '35282-51'
        --WHERE   ContractNumber = '35282-051    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '35288-50'
        --WHERE   ContractNumber = '35288-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '35476-50'
        --WHERE   ContractNumber = '35476-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '36072-50'
        --WHERE   ContractNumber = '36072-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '36150-50'
        --WHERE   ContractNumber = '36150-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '36408-51'
        --WHERE   ContractNumber = '36408-051    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '36451-50'
        --WHERE   ContractNumber = '36451-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '36919-50'
        --WHERE   ContractNumber = '36919-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '36921-50'
        --WHERE   ContractNumber = '36921-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '37059-50'
        --WHERE   ContractNumber = '37059-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '37327-50'
        --WHERE   ContractNumber = '37327-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '37367-51'
        --WHERE   ContractNumber = '37367-051    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '37465-50'
        --WHERE   ContractNumber = '37465-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '37639-50'
        --WHERE   ContractNumber = '37639-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '37729-50'
        --WHERE   ContractNumber = '37729-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '38437-51'
        --WHERE   ContractNumber = '38437-051    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '38687-50'
        --WHERE   ContractNumber = '38687-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '38842-50'
        --WHERE   ContractNumber = '38842-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '38975-50'
        --WHERE   ContractNumber = '38975-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '39068-50'
        --WHERE   ContractNumber = '39068-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '39145-50'
        --WHERE   ContractNumber = '39145-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '39200-50'
        --WHERE   ContractNumber = '39200-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '39214-50'
        --WHERE   ContractNumber = '39214-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '39422-50'
        --WHERE   ContractNumber = '39422-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '39560-50'
        --WHERE   ContractNumber = '39560-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '39564-50'
        --WHERE   ContractNumber = '39564-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '39620-50'
        --WHERE   ContractNumber = '39620-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '39815-50'
        --WHERE   ContractNumber = '39815-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '39844-51'
        --WHERE   ContractNumber = '39844-051    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '40760-50'
        --WHERE   ContractNumber = '40760-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '45365-50'
        --WHERE   ContractNumber = '45365-050    ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '100439-51'
        --WHERE   ContractNumber = '100439-051   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '101241-50'
        --WHERE   ContractNumber = '101241-050   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '101381-51'
        --WHERE   ContractNumber = '101381-051   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '101470-51'
        --WHERE   ContractNumber = '101470-051   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '101632-50'
        --WHERE   ContractNumber = '101632-050   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '101992-50'
        --WHERE   ContractNumber = '101992-050   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '102127-50'
        --WHERE   ContractNumber = '102127-050   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '102477-50'
        --WHERE   ContractNumber = '102477-050   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '103694-50'
        --WHERE   ContractNumber = '103694-050   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '103956-51'
        --WHERE   ContractNumber = '103956-051   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '105931-50'
        --WHERE   ContractNumber = '105931-050   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '106195-50'
        --WHERE   ContractNumber = '106195-050   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '106565-50'
        --WHERE   ContractNumber = '106565-050   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '108002-50'
        --WHERE   ContractNumber = '108002-050   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '109191-50'
        --WHERE   ContractNumber = '109191-050   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '130099-50'
        --WHERE   ContractNumber = '130099-050   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '130099-51'
        --WHERE   ContractNumber = '130099-051   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '130210-50'
        --WHERE   ContractNumber = '130210-050   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '130339-50'
        --WHERE   ContractNumber = '130339-050   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '130536-50'
        --WHERE   ContractNumber = '130536-050   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '130591-50'
        --WHERE   ContractNumber = '130591-050   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '130899-50'
        --WHERE   ContractNumber = '130899-050   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '130988-50'
        --WHERE   ContractNumber = '130988-050   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '131176-52'
        --WHERE   ContractNumber = '131176-052   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '131207-50'
        --WHERE   ContractNumber = '131207-050   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '131265-51'
        --WHERE   ContractNumber = '131265-051   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '131444-50'
        --WHERE   ContractNumber = '131444-050   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '131531-50'
        --WHERE   ContractNumber = '131531-050   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '131683-50'
        --WHERE   ContractNumber = '131683-050   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '131959-50'
        --WHERE   ContractNumber = '131959-050   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '132344-51'
        --WHERE   ContractNumber = '132344-051   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '132753-50'
        --WHERE   ContractNumber = '132753-050   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '133050-50'
        --WHERE   ContractNumber = '133050-050   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '133240-50'
        --WHERE   ContractNumber = '133240-050   ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '1957114-50'
        --WHERE   ContractNumber = '1957114-050  ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '4030899-50'
        --WHERE   ContractNumber = '4030899-050  ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '9018274-50'
        --WHERE   ContractNumber = '9018274-050  ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '11100493-050 '
        --WHERE   ContractNumber = '11100493-050 ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '11101193-051 '
        --WHERE   ContractNumber = '11101193-051 ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '11102004-050 '
        --WHERE   ContractNumber = '11102004-050 ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '11102075-050 '
        --WHERE   ContractNumber = '11102075-050 ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '11102558-050 '
        --WHERE   ContractNumber = '11102558-050 ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '11103069-050 '
        --WHERE   ContractNumber = '11103069-050 ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '11103332-050 '
        --WHERE   ContractNumber = '11103332-050 ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '11104055-050 '
        --WHERE   ContractNumber = '11104055-050 ' 	
        --UPDATE  UniTracHDStorage..tblextract_26752412
        --SET     Loan_Number = '11104243-050 '
        --WHERE   ContractNumber = '11104243-050 '		




