function find-database ( [string] $targetDB, [string] $targetInstance, [bool] $dryRun ){
    $selectSQL = "select * from sysdatabases where name = '$($targetDB)'"
    TRY{   
        Write-Verbose "
        $($selectSQL)"
        Write-Host `t"Invoke-Sqlcmd -ServerInstance $targetInstance -Database MASTER -Query $selectSQL -QueryTimeout 65535 -ErrorAction 'Stop'"
        $dbInfo = Invoke-Sqlcmd -ServerInstance $targetInstance -Database MASTER -Query $selectSQL -QueryTimeout 65535 -ErrorAction 'Stop' 
    }
    CATCH{
        Write-Host `t"[ALERT] FAILED TO QUERY !!!!" -ForegroundColor Red 
        Write-Host `t"$($selectSQL)"
        ### record information or raise alert?
        Write-Host `t"error: $_"
        }

    if($dbInfo){ return $true } ELSE { $false }
}
Export-ModuleMember -Function find-database

function get-DBstate ( [Object[]] $targetInstance, [Object[]] $Info ){
    ## Needs to be able to gracefully exit if DBA database does not exist.
    $selectSQL = "
        USE MASTER
        GO
        DECLARE @version varchar(8000),@changeSet varchar(8000);
        IF EXISTS ( SELECT name FROM  sys.databases WHERE name = 'DBA')
            BEGIN
                IF EXISTS (SELECT * FROM DBA.sys.objects WHERE object_id = OBJECT_ID(N'[DBA].[info].[databaseConfig]') AND type in (N'U'))
	                BEGIN
			            SELECT @version = confvalue
			            FROM DBA.info.databaseConfig
			            WHERE confkey = 'version' AND databaseName = '"+ $Info.targetDB +"';
			            if( @version is null )
				            set @version = 0

                        SELECT @changeSet = confvalue
			            FROM DBA.info.databaseConfig
			            WHERE confkey = 'changeSet' AND databaseName = '"+ $Info.targetDB +"';
			            if( @changeSet is null )
				            set @changeSet = 0
	                END
                ELSE
                    BEGIN
                        set @version = 0
                        set @changeSet = 0
                    END
            END
        ELSE
	        BEGIN
		        SET @version = 0
	        END

        SELECT DB.name as Name, DB.state_desc as Status, '' as serverType, @version as Version, @changeSet as changeSet
        FROM  sys.databases as DB
        WHERE name = '"+ $Info.targetDB +"'"

    
    TRY{
        WRITE-VERBOSE "Invoke-Sqlcmd -ServerInstance $targetInstance.ServerName -Database MASTER -Query $selectSQL -ErrorAction SilentlyContinue | select -exp Name Status serverType changeSet"
	    Invoke-Sqlcmd -ServerInstance $targetInstance.ServerName -Database MASTER -Query $selectSQL -ErrorAction SilentlyContinue | select Name, Status, serverType, Version, ChangeSet
    }
    CATCH{
        Write-Host `t"[WARNING] FAILED TO QUERY!!!! $($targetInstance.ServerName)" -ForegroundColor Yellow 
        TRY{
            $Target_FQDN =  $($targetInstance.ServerName) +'.'+ $($targetInstance.DomainName)
            WRITE-VERBOSE "Invoke-Sqlcmd -ServerInstance $($targetInstance.ServerName)$($targetInstance.DomainName) -Database MASTER -Query $selectSQL -ErrorAction SilentlyContinue | select -exp Name Status serverType changeSet"
            Invoke-Sqlcmd -ServerInstance $($Target_FQDN) -Database MASTER -Query $selectSQL -ErrorAction SilentlyContinue | select Name, Status, serverType, Version, ChangeSet
        }
        CATCH{
            Write-Host `t"[WARNING] FAILED TO QUERY!!!! $($Target_FQDN)" -ForegroundColor Yellow 
            TRY{
                $Target_FQDN =  $($targetInstance.ServerName) +'.'+ $($targetInstance.DomainName)
                WRITE-VERBOSE "Invoke-Sqlcmd -ServerInstance $($targetInstance.ServerName)$($targetInstance.DomainName) -Database MASTER -SQLAUTH -Query $selectSQL -ErrorAction SilentlyContinue | select -exp Name Status serverType changeSet"
                Invoke-Sqlcmd -ServerInstance $($Target_FQDN)  -Database MASTER -username $($Info.Credential.username) -password $($Info.Credential.GetNetworkCredential().password) -Query $selectSQL -ErrorAction SilentlyContinue | select Name, Status, serverType, Version, ChangeSet
            }
            CATCH{
                Write-Host `t"[ALERT] FAILED TO QUERY!!!! $($Target_FQDN) SQL AUTH" -ForegroundColor Red 
                Write-Host `t"$($selectSQL)"
                ### record information or raise alert?
                Write-Host `t"error: $_"
            }
        }

    }
     
}
Export-ModuleMember -Function get-dbState

function set-DBowner {
    [cmdletbinding(SupportsShouldProcess=$True)]
    PARAM(
        [string] $targetDB, 
        [string] $targetInstance, 
        [boolean] $dryRun 
    )

    $updateSQL = "
USE master;
GO
DECLARE @dbName SYSNAME;  
DECLARE @sqlCommand NVARCHAR(2000); 
 
DECLARE dbCursor CURSOR FOR 
SELECT [name] FROM sys.databases WHERE [name] NOT IN ('master','model','msdb','tempdb','distrbution') AND [state] = 0
OPEN dbCursor 
FETCH NEXT FROM dbCursor INTO @dbName 
WHILE @@FETCH_STATUS = 0  
   BEGIN
    set @sqlCommand = 'ALTER AUTHORIZATION ON DATABASE::[' + @dbName + '] TO [sa];'
    if( 'true' = '$($dryRun)')
        begin
            PRINT @sqlCommand
        end
    else
        begin
            EXEC (@sqlCommand)
        end
    FETCH NEXT FROM dbCursor INTO @dbName
   END
CLOSE dbCursor  
DEALLOCATE dbCursor"
    
    WRITE-VERBOSE "Invoke-Sqlcmd -ServerInstance $targetInstance -Database MASTER -Query $updateSQL -ErrorAction SilentlyContinue -verbose"
    TRY
        {
	        Invoke-Sqlcmd -ServerInstance $targetInstance -Database MASTER -Query $updateSQL -ErrorAction SilentlyContinue 
        }
    CATCH
        {
            Write-Host `t"[ALERT] FAILED TO UPDATE!!!!" -ForegroundColor Red 
            Write-Host `t"$($updateSQL)"
            ### record information or raise alert?
            Write-Host `t"error: $_"
        }
}
Export-ModuleMember -Function set-DBowner

function get-DBHealth ( [string] $targetDB, [string] $targetInstance, [int] $dryRun ){
    ## Needs to be able to gracefully exit if DBA database does not exist.
    $selectSQL = "
        USE MASTER
        GO
        DECLARE @version varchar(8000);
        IF EXISTS ( SELECT name FROM  sys.databases WHERE name = 'DBA')
            BEGIN
                IF EXISTS (SELECT * FROM DBA.sys.objects WHERE object_id = OBJECT_ID(N'[DBA].[info].[databaseConfig]') AND type in (N'U'))
	                BEGIN
			            SELECT @version = confvalue
			            FROM DBA.info.databaseConfig
			            WHERE confkey = 'version' AND databaseName = '"+ $targetDB +"';
			            if( @version is null )
				            set @version = 0
	                END
                ELSE
                    BEGIN
                        set @version = 0
                    END
            END
        ELSE
	        BEGIN
		        SET @version = 0
	        END

        SELECT DB.name as Name, DB.state_desc as Status, '' as serverType, @version as Version
        FROM  sys.databases as DB
        WHERE name = '"+ $targetDB +"'"

    WRITE-VERBOSE "Invoke-Sqlcmd -ServerInstance $targetInstance -Database MASTER -Query $selectSQL -ErrorAction SilentlyContinue | select -exp Name Status serverType "
    TRY
        {
	        Invoke-Sqlcmd -ServerInstance $targetInstance -Database MASTER -Query $selectSQL -ErrorAction SilentlyContinue | select Name, Status, serverType, Version
        }
    CATCH
        {
            Write-Host `t"[ALERT] FAILED TO QUERY!!!!" -ForegroundColor Red 
            Write-Host `t"$($selectSQL)"
            ### record information or raise alert?
            Write-Host `t"error: $_"
        }
     
}
Export-ModuleMember -Function get-dbState


