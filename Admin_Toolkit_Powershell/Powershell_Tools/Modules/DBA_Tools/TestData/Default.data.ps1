#
# Data used in all unit tests
#
# Would prefer to have a temp install created locally.
#
 $goodTarget = [ordered]@{
               Host = 'DBA-SQLPRD-01'
               Instance = 'DBA-SQLPRD-01\I01'
               Database = 'DBA'
               Services = 'Instance','Agent'#,'SSIS'
            }

 $badTarget = [ordered]@{
               Host = 'DBA-SQLPRD-02'
               Instance = 'DBA-SQLPRD-02\I01'
               Database = 'DBA2'
               Services = 'Instance','Agent'#,'SSIS'
            }

## Would like to get a localDB build and loaded for unit testing.
$localTarget = [ordered]@{
        Host = 'LoCaLDB'
        Instance = '.\HKB2'
        Database = 'DBA'
        Services = 'Instance','Agent'#,'SSIS'
        }