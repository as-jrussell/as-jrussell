###########################################################
#
#  'PSDesiredStateConfiguration' logic module
#
###########################################################

data LocalizedData
{
    # culture="en-US"
    ConvertFrom-StringData @'
    CheckSumFileExists = File '{0}' already exists. Please specify -Force parameter to overwrite existing checksum files.
    CreateChecksumFile = Create checksum file '{0}'
    OverwriteChecksumFile = Overwrite checksum file '{0}'
    OutpathConflict = (ERROR) Cannot create directory '{0}'. A file exists with the same name.
    InvalidConfigPath = (ERROR) Invalid configuration path '{0}' specified.
    InvalidOutpath = (ERROR) Invalid OutPath '{0}' specified.
    NoValidConfigFileFound = No valid config files (mof,zip) were found.
    InputFileNotExist=File {0} doesn't exist.
    FileReadError=Error Reading file {0}.
    MatchingFileNotFound=No matching file found.
    CertificateFileReadError=Error Reading certificate file {0}.
    CertificateStoreReadError=Error Reading certificate store for {0}.
    CannotCreateOutputPath=Invalid Configuration name and output path combination :{0}. Please make sure output parameter is a valid path segment.
    DuplicateKeyInNode=The key properties combination '{0}' is duplicated for keys '{1}' of resource '{2}' in node '{3}'. Please make sure key properties are unique for each resource in a node.
    ConfiguratonDataNeedAllNodes=ConfigurationData parameter need to have property AllNodes.
    ConfiguratonDataAllNodesNeedHashtable=ConfigurationData parameter property AllNodes needs to be a collection.
    AllNodeNeedToBeHashtable=all elements of AllNodes need to be hashtable and has a property 'NodeName'.
    DuplicatedNodeInConfigurationData=There are duplicated NodeNames '{0}' in the configurationData passed in.
    EncryptedToPlaintextNotAllowed=Converting and storing an encrypted password as plaintext is allowed only if PSDscAllowPlainTextPassword is set to true.
    NestedNodeNotAllowed=Defining node '{0}' inside the current node '{1}' is not allowed since node definitions cannot be nested. Please move the definition for node '{0}' to the top level of the configuration '{2}'.
    FailToProcessNode=An exception was raised while processing Node '{0}': {1}
    LocalHostNodeNotAllowed=Defining a 'localhost' node in the configuration '{0}' is not allowed since the configuration already contains one or more resource definitions that are not associated with any nodes.
    InvalidMOFDefinition=Invalid MOF definition for node '{0}': {1}
    RequiredResourceNotFound=Resource '{0}' required by '{1}' does not exist. Please ensure that the required resource exists and the name is properly formed.
    DependsOnLinkTooDeep=DependsOn link exceeded max depth limitation '{0}'.
    DependsOnLoopDetected=Circular DependsOn exists '{0}'. Please make sure there are no circular reference.
    FailToProcessConfiguration=Errors occurred while processing configuration '{0}'.
    FailToProcessProperty={0} error processing property '{1}' OF TYPE '{2}': {3}
    NodeNameIsRequired=Node processing is skipped since the node name is empty.
    ConvertValueToPropertyFailed=Cannot convert '{0}' to type '{1}' for property '{2}'.
    ResourceNotFound=The term '{0}' is not recognized as the name of a {1}.
    GetDscResourceInputName=The Get-DscResource input '{0}' parameter value is '{1}'.
    ResourceNotMatched=Skipping resource '{0}' as it does not match the requested name.
    InitializingClassCache=Initializing class cache
    LoadingDefaultCimKeywords=Loading default CIM keywords
    GettingModuleList=Getting module list
    CreatingResourceList=Creating resource list
    CreatingResource=Creating resource '{0}'.
    SchemaFileForResource=Schema file name for resource {0}
    UnsupportedReservedKeyword=The '{0}' keyword is not supported in this version of the language.
    UnsupportedReservedProperty=The '{0}' property is not supported in this version of the language.

'@
}

Import-LocalizedData  LocalizedData -filename PSDesiredStateConfiguration.Resource.psd1


###########################################################
# The MOF generation code
###########################################################

#
# This scriptblock takes a type name and a list of properties and produces
# the MOF source text to define an instance of that type
#
function ConvertTo-MOFInstance
{
    param (
        [Parameter(Mandatory)]
        [string]
            $Type,
        [Parameter(Mandatory)]
        [AllowNull()]
        [hashtable]
            $Properties
    )

    # Look up the property definitions for this keyword.
    $PropertyTypes = [System.Management.Automation.Language.DynamicKeyword]::GetKeyword($type).Properties;

    # and the CIM type name to use since the keyword might be an alias.
    $ResourceName = [System.Management.Automation.Language.DynamicKeyword]::GetKeyword($type).ResourceName
    
    #
    # Function to convert .NET datetime object to MOF datetime string format
    # We're not using [System.Management.ManagementDateTimeConverter]::ToDmtfDateTime()
    # because it has known bugs which are not going to be fixed.
    #
    function ConvertTo-MofDateTimeString ([datetime] $d)
    {
        $utcOffset = ($d -$d.ToUniversalTime()).TotalMinutes
        $utcOffsetString = if ($utcOffset -ge 0) { '+' } else { '-'}
        $utcOffsetString += ([System.Math]::Abs(($utcOffset)).ToString().PadLeft(3,'0'))
        '{0}{1}' -f
            $d.ToString("yyyyMMddHHmmss.ffffff"),
            $utcOffsetString
    }

        
    #
    # Utility routine to render a property
    # as a string in MOF syntax.
    #
    function stringify ($value, $asArray = $false, $targetType = [string])
    {
        $result = if ($value -is [array] -or $asArray)
        {
            "{"
                $len = @($value).Length
                foreach ($e in $value)
                {
                    "    " + (stringify $e -targetType $targetType) +
                            $(if (--$len -gt 0) { "," } else { '' })
                }
            '}'
        }
        elseif ($value -is [PSCredential] )
        {
            # If the input object is a PSCredential, turn it into an MSFT_Credential with an encrypted password.
            $clearText = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
                    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($value.Password))
            $newValue =  @{
                UserName = $value.UserName
                Password = $clearText
            }
            # Recurse to build the object.
            ConvertTo-MOFInstance MSFT_Credential $newValue
        }
        elseif ($value -is [System.Collections.Hashtable])
        {
            # Collect the individual strings
            $elementsAsStrings = foreach ($p in $value.GetEnumerator())
            {
                ConvertTo-MOFInstance MSFT_KeyValuePair @{Key = $p.Key; Value = $p.Value}
            }
            # Produce a single formatted string.
            "   " + ($elementsAsStrings -join ",`n   ") + "`n"
        }
        elseif ($value -is [ScriptBlock] )
        {

            # Find all $using: variables used in the script and replace them with normal variables
            $scriptText = "$value"
            # Need to create a new scriptblock so the extent offsets are correct
            $scriptAst = [scriptblock]::Create($scriptText).Ast
            # get the $using: variable asts into an array
            $variables = $scriptAst.FindAll({param ($ast)
                $ast.GetType().FullName -match 'VariableExpressionAst' -and 
                    $ast.Extent.Text -match '^\$using:'}, $true).ToArray()

            # do the substitutions in reverse order
            [Array]::Reverse($variables)
            $variables | foreach {
                $start = $_.Extent.StartOffset
                $length = $_.Extent.EndOffset - $start
                $newName = '$' + $_.VariablePath.UserPath
                $scriptText = $scriptText.Remove($start, $length).Insert($start, $newName)
            }

            $completeScript = ""
            # generate assignement statements to set the variable values on the other side
            # using serialized values passed from the local environment
            $varNames = @($variables).VariablePath.UserPath | sort -unique
            foreach ($v in $varNames)
            {
                # If the ScriptBlock was defined in a module, then use the module for lookups
                if ($value.Module)
                {
                    $varValue = $value.Module.SessionState.PSVariable.Get($v).Value
                }
                else
                {
                    # Otherwise look up in the callers context
                    $varValue = $ExecutionContext.SessionState.Module.GetVariableFromCallersModule($v).Value
                }

                if ($varValue)
                {
                    # Skip null values but preserve empty arrays and strings for type propigation
                    if ($varValue -ne $null)
                    {
              
                        # Pass strings quoted; amn explicit type check is needed because -is recognizes too many things as strings
                        if ($varValue -is [string])
                        {
                            $completeScript += "`$$v ='" + ($varValue -replace "'","''") + "'`n"
                        }
                        else
                        {
                            # Serialize everything else
                            $serializedValue = [System.Management.Automation.PSSerializer]::Serialize($varValue) -replace "'","''"
                            $completeScript += "`$$v = [System.Management.Automation.PSSerializer]::Deserialize('$serializedValue')`n"
                        }
                    }
                }
            }
    
            # Merge in the actual scriptblock body
            $completeScript += $scriptText
    
            # Quote the string so it's suitable to embed in the MOF file...
            '"' + ($completeScript -replace '\\','\\' -replace "[`r]*`n", "\n"  -replace '"','\"') + '"'
        }
        elseif ($targetType -eq [datetime])
        {
            # If the target is a datetime, convert the argument to a datetime and then render that
            # as a DMTF datetime...
            '"' + (ConvertTo-MofDateTimeString $value) + '"'
        }
        elseif ($targetType -eq [double])
        {
            # MOF syntax requires reals to always have a decimal point so add
            # so add one if the string representation does contain one.
            [string] $dblAsString = [double] $value
            if ( -not $dblAsString.Contains('.') )
            {
                $dblAsString += '.0'
            }
            $dblAsString
            
        }
        elseif ($targetType -eq [char])
        {
            # A char16 is encode as a single quoted character
            "'$value'"
        }
        elseif ($targetType -ne [string])
        {
            # Cast the value to the target type...
            $value -as $targetType
        }
        elseif ($value -is [string] -and $value -notmatch ' *instance of' -and -not $InstanceAliases[$value] )
        {
            '"' + ($value -replace '\\','\\' -replace "`n", "\n"  -replace '"','\"') + '"'
        }
        elseif ($value -eq $null)
        {
            'NULL'
        }
        else
        {
            $value
        }
    
        $result -join "`n"
    }
    
    Write-Debug "        BEGIN MOF GENERATION FOR $type"
    
    # Generate the MOF instance alias to use for the current node
    if ( (Get-PSCurrentConfigurationNode) )
    {
        if($Script:NodeTypeRefCount[ (Get-PSCurrentConfigurationNode) ] -eq $null)
        {
            $Script:NodeTypeRefCount[ (Get-PSCurrentConfigurationNode) ] = 
                New-Object 'System.Collections.Generic.Dictionary[string, System.Collections.Generic.Dictionary[string,int]]'([System.StringComparer]::OrdinalIgnoreCase) 
        }
        
        $MofAliasString = '$' + $resourceName + ++$Script:NodeTypeRefCount[ (Get-PSCurrentConfigurationNode) ][$resourceName] + "ref"
        $InstanceAliases = $Script:NodeInstanceAliases[ (Get-PSCurrentConfigurationNode) ]
    }
    else #  Generate the MOF instance alias to use for the default (unnamed) node.
    {
        $MofAliasString = '$' + $resourceName + ++$Script:NoNameNodeTypeRefCount[$resourceName] + "ref"
        $InstanceAliases = $Script:NoNameNodeInstanceAliases
    }
    
    # Start generating the MOF source text for this instance
    $result = "instance of $resourceName as $MofAliasString`n{`n"
    
    # generate the property definitions
    $result += try {
        if ($properties -and $properties.Count)
        {
            foreach ($p in $properties.GetEnumerator())
            {
                Write-Debug "          Generating property data for '$($p.Name)' = '$($p.Value)'"
                $targetTypeName = $propertyTypes[$p.Name].TypeConstraint

                # see if the target type is an array
                $asArray = $p.Name -eq "DependsOn" -or $targetTypeName -match 'Array'

                # Convert the CIM typename to the appropriate .NET type to use
                # to convert the input object into an appropriately encoded string
                # using the PowerShell type conversion semantics.
                switch -regex ($targetTypeName)
                {
                    # unsigned integer types
                    '^sint[0-9]{1,2}' { $targetType = [int64] ; break }
                    # Single 16 bit character (note - this type is deprecated and removed in MOFv3
                    '^char16' { $targetType = [char] ; break }
                    # signed integer types
                    '^uint[0-9]{0,2}' { $targetType = [uint64] ; break }
                    # reals
                    '^real32|^real64' { $targetType = [double] ; break }
                    # boolean
                    '^boolean' { $targetType = [bool] }
                    # datetime
                    "datetime" { $targetType = [datetime] }
                    # everything else render directly as a string...
                    default { $targetType = [string] }
                }

                #
                # If the scalar target types is a credential, then we need to encrypt the Password property value
                # before generating the MOF text
                #
                if(($type -match 'MSFT_Credential') -and $p.Name -match 'Password')
                {
                    # For MSFT_Credential we'll have a password that may need to be encrypted depending
                    # on the availability of a key. This may need to change to the base class of MSFT_WindowCredential
                    # if we're using the class to refer to non-Windows machines where a Domain may be irrelevant.
                    
                    $p.Name + " = " + (stringify -value (Get-EncryptedPassword $p.Value) -asArray $asArray -targetType  $targetType ) + ";`n"
                }
                else
                {
                    #embeded instances cannot be null
                    if($p.Value -eq $null -and $PropertyTypes[$p.Name].TypeConstraint -eq "Instance")
                    {
                        $errorMessage = $LocalizedData.ConvertValueToPropertyFailed -f @('$null', $type, $p.Name)
                        $errorMessage += Get-PositionInfo $Properties["SourceInfo"]
                        $exception = New-Object System.InvalidOperationException $errorMessage
                        Write-Error -Exception $exception -Message $errorMessage  -Category InvalidArgument -ErrorId FailToProcessProperty 
                        Update-ConfigurationErrorCount
                    }
                    if($p.Value -is [PSCredential])
                    {
                        [bool] $PSDscAllowPlainTextPassword = $false;

                        if($Node -and $selectedNodesData)
                        {
                            if($selectedNodesData -is [array])
                            { 
                                foreach($target in $selectedNodesData)
                                {
                                    if($target["NodeName"] -and $target["NodeName"] -match $Node)
                                    {
                                        $currentNode = $target;
                                    }
                                }
                            }
                            else
                            {
                                $currentNode = $selectedNodesData;
                            }

                        }
                        # where user need to specify properties for resources not in a node, 
                        # they can do it through localhost nodeName in $allNodes
                        elseif($allnodes -and $allNodes.AllNodes)
                        {
                            foreach($target in $allNodes.AllNodes)
                            {
                                if($target["NodeName"] -and $target["NodeName"] -match "localhost")
                                {
                                    $currentNode = $target;
                                }
                            }
                        }
                        
                        if($currentNode)
                        {
                            # PSDscAllowPlainTextPassword set to true would indicate that we want to allow the
                            # automatic conversion of the encrypted password to plaintext if a certificate or
                            # certificate id is not specified.
                            if($currentNode["PSDscAllowPlainTextPassword"])
                            {
                                $PSDscAllowPlainTextPassword = $currentNode["PSDscAllowPlainTextPassword"];
                            }
                            
                            if(-not $PSDscAllowPlainTextPassword)
                            {
                                $certificateid = $currentNode["CertificateID"];
    
                                if ( -not $certificateid)
                                {
                                    # CertificateFile is the public key file 
                                    $certificatefile = $currentNode["CertificateFile"];

                                    if ( -not $certificatefile)
                                    {
                                        $errorMessage = $($LocalizedData.EncryptedToPlaintextNotAllowed);
                                        ThrowError -ExceptionName "System.InvalidOperationException" -ExceptionMessage $errorMessage -ExceptionObject $p -ErrorId "InvalidPathSpecified" -ErrorCategory InvalidOperation
                                    }
                                }
                                
                                if($currentNode["NodeName"])
                                {
                                    $Script:NodesPasswordEncrypted[$currentNode["NodeName"]] = $true
                                }    
                            }
                            $p.Name + " = " + (stringify -value $p.Value -asArray $asArray -targetType  $targetType ) + ";`n"
                        }

                        else
                        {
                            $errorMessage = $($LocalizedData.EncryptedToPlaintextNotAllowed);
                            ThrowError -ExceptionName "System.InvalidOperationException" -ExceptionMessage $errorMessage -ExceptionObject $p -ErrorId "InvalidPathSpecified" -ErrorCategory InvalidOperation
                        }
                    }
                    else
                    {   if ($targetTypeName -notmatch 'Array' -or $p.Value.Count)
                        {  
                            $p.Name + " = " + (stringify -value $p.Value -asArray $asArray -targetType  $targetType ) + ";`n"
                        }
                    }
                }
            }
        }
        else
        {
            if ($type -notmatch 'OMI_ConfigurationDocument')
            {
                "// This instance definition of $type had no properties`n"
            }
            Write-Debug "          ENCOUNTERED INSTANCE OF TYPE '$type' WITH NO PROPERTIES"
        }
    }
    catch
    {
        $errorMessage = $_.Exception.Message + (Get-PositionInfo $Properties["SourceInfo"])
        $errorMessage = $LocalizedData.FailToProcessProperty -f @($_.Exception.GetType().FullName, $p.Name, $type, $errorMessage)
        $exception = New-Object System.InvalidOperationException $errorMessage
        Write-Error -Exception $exception -Message $errorMessage -Category InvalidOperation -ErrorId FailToProcessProperty
        Update-ConfigurationErrorCount
    }

    #
    # Add extra information about Author, GenerationHost and GenerationDate if they are not specified
    #
    if ($Type -match 'OMI_ConfigurationDocument' -and $Properties)
    {
        if (-not $Properties.ContainsKey("Author"))
        {
            $result += "Author = `"$([system.environment]::UserName)`";`n"
        }

        if (-not $Properties.ContainsKey("GenerationDate"))
        {
            $result += "GenerationDate = `"$(Get-Date)`";`n"
        }

        if (-not $Properties.ContainsKey("GenerationHost"))
        {
            $result += "GenerationHost = `"$([system.environment]::MachineName)`";`n"
        }
    }

    #
    # Append the completed mof instance text to the overall document
    #
    $instanceText = "`n" + $result + "`n};`n"
    
    #
    # Record and return the alias for that document
    #
    Write-Debug "          Added alias $MofAliasString to InstanceAliases array for node '$(Get-PSCurrentConfigurationNode)'"
    
    if ( Get-PSCurrentConfigurationNode )
    {    
        if($Script:NodeInstanceAliases[ (Get-PSCurrentConfigurationNode) ] -eq $null)
        {
            $Script:NodeInstanceAliases[ (Get-PSCurrentConfigurationNode) ] =  New-Object 'System.Collections.Generic.Dictionary[string,string]'([System.StringComparer]::OrdinalIgnoreCase) 
        }
        $Script:NodeInstanceAliases[ (Get-PSCurrentConfigurationNode) ][$MofAliasString] = $instanceText
    }
    else
    {
        $Script:NoNameNodeInstanceAliases[$MofAliasString] = $instanceText
    }
    
    # todo: we can check error for duplicated alias in a node and report it here 
    # because this can live acrose configurationelement calls
    Write-Debug "        MOF GENERATION COMPLETED FOR $type"
    $MofAliasString
}


#
# Returns the MOF text for the instance that
# corresponds to the aliasId
#
function Get-MofInstanceText
{
    param (
        [Parameter(Mandatory)]
        [string]
            $aliasId
    )
    
    if ( Get-PSCurrentConfigurationNode )
    {    
        $Script:NodeInstanceAliases[ (Get-PSCurrentConfigurationNode) ][$aliasId]
    }
    else
    {
        $Script:NoNameNodeInstanceAliases[$aliasId]
    }
}

#
# Get the position message based on the SourceMetadata
#
function Get-PositionInfo
{
    param(
        [string]
        $sourceMetadata
    )

    $positionMessage = ""
    if ($sourceMetadata)
    {
        $positionMessage = "`nAt"
        $infoItems = $sourceMetadata -split "::"

        # File name may be empty
        if ($infoItems[0])
        {
            $positionMessage += " $($infoItems[0]):$($infoItems[1])"
        }
        else
        {
            $positionMessage += " line:$($infoItems[1])"
        }

        $positionMessage += " char:$($infoItems[2])"
        $positionMessage += "`n+   $($infoItems[3])"
    }

    $positionMessage
}


###################################################################################
#
# A function that implements the 'Node' keyword logic. The Node keyword accumulates
# the resource instances to define for a specific node or nodes. It's passed into the
# configuration statement using the ScriptBlock.InvokeWithContext() method
#
function Node
{
    [OutputType([void])]
    param (
        [Parameter(Mandatory)]
            $KeywordData,       # Not used in this function....
        [string[]]
            $Name,              # the list of nodes to process in this call
        [Parameter(Mandatory)]
        [ScriptBlock]
            $Value,             # The scriptblock that generates the configuration in each node.
        [Parameter(Mandatory)]
            $SourceMetadata     # Not used in this function
    )
    

    if (-not $Name)
    {
        $errorMessage = $LocalizedData.NodeNameIsRequired
        $exception = New-Object System.InvalidOperationException $errorMessage
        Write-Error -Exception $exception -Message $errorMessage -Category InvalidOperation -ErrorId NodeNameIsRequired
        Update-ConfigurationErrorCount

        Write-Debug "The name parameter was empty, no nodes generated"
        return
    }
    
    Write-Debug "*PROCESSING STARTED FOR NODE SET {$(@($name) -join ',')} "
    
    # Save any global level resources and initialize for the resources defined for this node.
    $Script:PSOuterConfigurationNodes.Push( (Get-PSCurrentConfigurationNode) )
    $OldNodeResources = $Script:NodeResources;
    $OldNodeKeys = $Script:NodeKeys
        
    try
    {
        $OuterNode = $Script:PSOuterConfigurationNodes.Peek()
        if(( $OuterNode -eq [string]::Empty) -or
            (($OuterNode -ne [string]::Empty) -and ($Name -contains $OuterNode)))
        {

            #
            # Set up a map from node name to data
            #
            $nodeDataMap = @{}

            #
            # Copy the AllNodes data into the map
            #

            if($script:ConfigurationData)
            {
                $script:ConfigurationData.AllNodes | foreach { $nodeDataMap[$_.NodeName] = $_ }
             }

            #
            # Create the SelectedNodes list for this Node statement
            #
            $selectedNodesData = foreach ($nn in $Name) {
                # If there is no data for this node, create a dummy node
                # with at least the node name
                if ( -not $nodeDataMap[$nn] )
                {
                    $nodeDataMap[$nn] = @{ NodeName = $nn }
                }
                $nodeDataMap[$nn] 
            }

            foreach ($node in $Name)
            {
                if(($OuterNode -ne [string]::Empty) -and ($OuterNode -ne $node))
                {
                    continue 
                }
    
                Set-PSCurrentConfigurationNode $node

                if( $Script:NodesInThisConfiguration[$node] )
                {
                    $Script:NodeResources = $Script:NodesInThisConfiguration[$node]
                }
                else
                {
                    $Script:NodesInThisConfiguration[$node] = New-Object 'System.Collections.Generic.Dictionary[string,[string[]]]'([System.StringComparer]::OrdinalIgnoreCase) 
                    $Script:NodeResources = $Script:NodesInThisConfiguration[$node]  
                }

                if(-not $Script:NodeTypeRefCount[$node])
                {
                    $Script:NodeTypeRefCount[$node] = New-Object 'System.Collections.Generic.Dictionary[string, System.Collections.Generic.Dictionary[string,int]]'([System.StringComparer]::OrdinalIgnoreCase) 
                    $Script:NodeInstanceAliases[$node] = New-Object 'System.Collections.Generic.Dictionary[string, System.Collections.Generic.Dictionary[string,string]]'([System.StringComparer]::OrdinalIgnoreCase) 
                }

                if(-not $script:NodesKeysInThisConfiguration[$node])
                {
                    $script:NodesKeysInThisConfiguration[$node] = New-Object 'System.Collections.Generic.Dictionary[string,System.Collections.Generic.HashSet[string]]'([System.StringComparer]::OrdinalIgnoreCase) 
                }
                $Script:NodeKeys = $script:NodesKeysInThisConfiguration[$node]

                #
                # Set up the context variable list.
                #
                $variablesToDefine = @(
                    New-Object PSVariable ("SelectedNodes", $selectedNodesData)
                    New-Object PSVariable ("Node", $nodeDataMap[$node])
                    New-Object PSVariable ("NodeName", $node)
                )

                try
                {
                    # Evaluate the node's business logic scriptblock
                    Write-Debug "*$node : NODE PROCESSING STARTED FOR THIS NODE."
                    $Value.InvokeWithContext($functionsToDefine, $variablesToDefine)
                }
                catch [System.Management.Automation.MethodInvocationException]
                {
                    # Write the unwrapped exception message
                    $pscmdlet.CommandRuntime.WriteError((Get-InnerMostErrorRecord $_))
                    Update-ConfigurationErrorCount
                }

                # Validate make sure all of the required resources are defined
                ValidateNodeResources

                # Validate make sure all of the required resources are defined
                ValidateNoCircleInNodeResources
                
                Write-Debug "*$node : NODE PROCESSING COMPLETED FOR THIS NODE. configuration errors encountered so far: $(Get-ConfigurationErrorCount)"
    
            }
        }
        else
        {
            $errorMessage = $LocalizedData.NestedNodeNotAllowed -f @(($Name -join ","), (Get-PSCurrentConfigurationNode), $Script:PSConfigurationName)
            $exception = New-Object System.InvalidOperationException $errorMessage
            Write-Error -Exception $exception -Message $errorMessage -Category InvalidOperation -ErrorId NestedNodeNotAllowed
            Update-ConfigurationErrorCount
        }
    }
    catch
    {
        $errorMessage = $_.Exception.Message + (Get-PositionInfo $SourceMetadata)
        $errorMessage = $LocalizedData.FailToProcessNode -f @($node, $errorMessage)
        $exception = New-Object System.InvalidOperationException $errorMessage
        Write-Error -Exception $exception -Message $errorMessage -Category InvalidOperation -ErrorId FailToProcessNode
        Update-ConfigurationErrorCount
    }
    finally
    {
        Set-PSCurrentConfigurationNode  ($Script:PSOuterConfigurationNodes.Pop())
        $Script:NodeResources = $OldNodeResources;
        $Script:NodeKeys = $OldNodeKeys
        Write-Debug "*NODE STATEMENT PROCESSING COMPLETED. Configuration errors encountered so far: $(Get-ConfigurationErrorCount)"
    }
}


#
# Utility used to track the number of errors encountered while processing the configuration
#
function Update-ConfigurationErrorCount
{
    [OutputType([void])]
    param()

    $Script:PSConfigurationErrors++
}

function Get-ConfigurationErrorCount
{
    [OutputType([int])]
    param()

    $Script:PSConfigurationErrors
}

#
# A function to set the document text for default (unnamed) node
#
function Set-PSDefaultConfigurationDocument
{
    [OutputType([void])]
    param (
        [Parameter()]
        [string]
            $documentText = ""
    )

    $Script:PSDefaultConfigurationDocument = $documentText
}

#
# Get the text associated with the default (unnamed) node.
#
function Get-PSDefaultConfigurationDocument
{
    [OutputType([string])]
    param()

    return $Script:PSDefaultConfigurationDocument
}

##################################################
#
# Returns the name of the node currently being configured
#
function Get-PSCurrentConfigurationNode
{
    [OutputType([string])]
    param()

    return $Script:PSCurrentConfigurationNode
}

function Set-PSCurrentConfigurationNode
{
    [OutputType([void])]
    param (
        [Parameter()]
        [string]
            $nodeName
    )

    $Script:PSCurrentConfigurationNode = $nodeName
}

#################################################

function Set-NodeResources
{
    [OutputType([void])]
    param (
        [Parameter(Mandatory)]
        [string]
            $resourceId,
        [Parameter(Mandatory)]
        [AllowNull()]
        [string[]]
            $requiredResourceList
    )

    if ($Script:NodeResources -eq $null)
    {
        $Script:NodeResources =  New-Object 'System.Collections.Generic.Dictionary[string,[string[]]]'([System.StringComparer]::OrdinalIgnoreCase) 
    }
    $Script:NodeResources[$resourceId] = $requiredResourceList
}


function Test-NodeResources
{
    [OutputType([bool])]
    param (
        [Parameter(Mandatory)]

        [string]
            $resourceId
    )

    if ( -not $Script:NodeResources)
    {
        $false
    }
    else
    {
        $Script:NodeResources.ContainsKey($resourceId)
    }
}

function Add-NodeKeys
{
    [OutputType([void])]
    param (
        [Parameter(Mandatory)]
        [string]
            $ResourceKey,
        [parameter(Mandatory)]
        [string]
            $keyCombination,
        [parameter(Mandatory)]
        [string]
            $keywordName

    )

    if ($Script:NodeKeys -eq $null)
    {
        $Script:NodeKeys =  New-Object 'System.Collections.Generic.Dictionary[string,System.Collections.Generic.HashSet[string]]'([System.StringComparer]::OrdinalIgnoreCase) 
    }

    if( -not $Script:NodeKeys.ContainsKey($keywordName))
    {
        $Script:NodeKeys[$keywordName] = New-Object 'System.Collections.Generic.HashSet[string]'([System.StringComparer]::OrdinalIgnoreCase) 
    }

    if($Script:NodeKeys[$keywordName].Contains($ResourceKey))
    {
        $currentNodeName = Get-PSCurrentConfigurationNode
        if (-not $currentNodeName)
        {
            $currentNodeName = 'localhost'
        }
        $errorMessage = $LocalizedData.DuplicateKeyInNode -f @($ResourceKey,$keyCombination,$keywordName,$currentNodeName)
        $exception = New-Object System.InvalidOperationException $errorMessage
        Write-Error -Exception $exception -Message $errorMessage -Category InvalidOperation -ErrorId DuplicateKeyInNode
        Update-ConfigurationErrorCount
    }
    else
    {
        $null = $Script:NodeKeys[$keywordName].Add($ResourceKey)
    }
    
}
#################################################
#
# A function to get the innermost error record.
#
function Get-InnerMostErrorRecord
{
    param (
        [Parameter(Mandatory)]
        [System.Management.Automation.ErrorRecord]
            $ErrorRecord
    )

    $exception = $ErrorRecord.Exception
    while ($Exception.InnerException -and $Exception.InnerException.ErrorRecord)
    {
        $exception = $exception.InnerException
        $ErrorRecord = $exception.ErrorRecord
    }
    $ErrorRecord
}

###########################################################
#
# A function to set up all of the module-scoped state variables.
#
function Initialize-ConfigurationRuntimeState
{
    param (
        [Parameter()]
        [string]
            $ConfigurationName = ""
    )

    # The overall name of the configuration being processed
    [string] $Script:PSConfigurationName = $ConfigurationName

    # For the current configuration, this contains the name of the node currently being processed
    [string] $Script:PSCurrentConfigurationNode = ""

    # For the current node, this contains a map of resource instance to resource prerequisites (required resources).
    [System.Collections.Generic.Dictionary[string,string[]]] `
        $Script:NodeResources =  New-Object 'System.Collections.Generic.Dictionary[string,[string[]]]'([System.StringComparer]::OrdinalIgnoreCase) 

    # For all nodes except the unnamed node, this contains the per-node per-type reference counter used to generate the CIM aliases for each instance
    [System.Collections.Generic.Dictionary[string, System.Collections.Generic.Dictionary[string,int]]] `
        $Script:NodeTypeRefCount = New-Object 'System.Collections.Generic.Dictionary[string, System.Collections.Generic.Dictionary[string,int]]'([System.StringComparer]::OrdinalIgnoreCase) 
    
    # For all nodes except the unnamed node, this maps the node name to the node's table of alias to mof text mappings.
    [System.Collections.Generic.Dictionary[string,System.Collections.Generic.Dictionary[string,string]]] `
        $Script:NodeInstanceAliases = New-Object 'System.Collections.Generic.Dictionary[string,System.Collections.Generic.Dictionary[string,string]]'([System.StringComparer]::OrdinalIgnoreCase) 
    
    # For all nodes except the unnamed node, this maps the node name to the node's map of resource instance to resource prerequisites 
    [System.Collections.Generic.Dictionary[string,object]] `
        $Script:NodesInThisConfiguration = New-Object 'System.Collections.Generic.Dictionary[string,object]'([System.StringComparer]::OrdinalIgnoreCase) 
    
    # For the unnamed (default) node, this contains a map of resource instance to resource prerequisites (required resources).
    [System.Collections.Generic.Dictionary[String,String[]]] `
        $Script:NoNameNodesResources = New-Object 'System.Collections.Generic.Dictionary[String,String[]]'([System.StringComparer]::OrdinalIgnoreCase) 

    # For the unnamed (default) node, this contains the per-node per-type reference counter used to generate the CIM aliases for each instance
    [System.Collections.Generic.Dictionary[String,int]] `
        $Script:NoNameNodeTypeRefCount = New-Object 'System.Collections.Generic.Dictionary[String,int]'([System.StringComparer]::OrdinalIgnoreCase) 

    # For the unnamed (default) node, this maps the node name to the node's table of alias to mof text mappings.
    # Alias to mof text mapping for the unnamed node.
    [System.Collections.Generic.Dictionary[string,string]] `
        $Script:NoNameNodeInstanceAliases = New-Object 'System.Collections.Generic.Dictionary[string,string]'([System.StringComparer]::OrdinalIgnoreCase) 

    #dictionary to save whether a node has encrypted password
    [System.Collections.Generic.Dictionary[string,bool]] `
        $Script:NodesPasswordEncrypted = New-Object 'System.Collections.Generic.Dictionary[string,bool]'([System.StringComparer]::OrdinalIgnoreCase) 

    [System.Collections.Generic.Stack[String]] $Script:PSOuterConfigurationNodes = New-Object 'System.Collections.Generic.Stack[String]'

    # The number of errors that have occurred while processing this configuration.
    [int] $Script:PSConfigurationErrors = 0

    # Set up a variable to hold a top-level OMI_ConfigurationDocument value
    # which will be used by all nodes if it's present.
    [string]    $Script:PSDefaultConfigurationDocument = ""

     # For all nodes except the unnamed node, this maps the node name to the node's map of keys of resources. 
    [System.Collections.Generic.Dictionary[string,object]] `
        $Script:NodesKeysInThisConfiguration = New-Object 'System.Collections.Generic.Dictionary[string,object]'([System.StringComparer]::OrdinalIgnoreCase) 

     # For the current node, this contains keys of resource instances.
    [System.Collections.Generic.Dictionary[string,System.Collections.Generic.HashSet[string]]] `
        $Script:NodeKeys =  New-Object 'System.Collections.Generic.Dictionary[string,System.Collections.Generic.HashSet[string]]'([System.StringComparer]::OrdinalIgnoreCase) 

    # For the unnamed (default) node, this contains keys of resource instances.
    [System.Collections.Generic.Dictionary[String,System.Collections.Generic.HashSet[string]]] `
        $Script:NoNameNodeKeys = New-Object 'System.Collections.Generic.Dictionary[String,System.Collections.Generic.HashSet[string]]'([System.StringComparer]::OrdinalIgnoreCase) 

}

#
# Then call it to enact the default state.  This happens
# only once during the module load. Thereafter the
# configuration function is responsible for resetting state.
#
Initialize-ConfigurationRuntimeState

# make sure configuration data format:
# 1. Is a hashtable
# 2. Has a collection AllNodes
# 3. Allnodes is an collection of Hashtable
# 4. Each element of Allnodes has NodeName
# 5. We will copy values from NodeName="*" to all node if they don't exist
function ValidateUpdate-ConfigurationData
{
    param (
        [Parameter()]
        [hashtable]
            $ConfigurationData
    )

    if( -not $ConfigurationData.ContainsKey("AllNodes"))
    {
        $errorMessage = $LocalizedData.ConfiguratonDataNeedAllNodes
        $exception = New-Object System.InvalidOperationException $errorMessage
        Write-Error -Exception $exception -Message $errorMessage -Category InvalidOperation -ErrorId ConfiguratonDataNeedAllNodes
        return $false
    }

    if($ConfigurationData.AllNodes -isnot [array])
    {
        $errorMessage = $LocalizedData.ConfiguratonDataAllNodesNeedHashtable
        $exception = New-Object System.InvalidOperationException $errorMessage
        Write-Error -Exception $exception -Message $errorMessage -Category InvalidOperation -ErrorId ConfiguratonDataAllNodesNeedHashtable
        return $false
    }

    $nodeNames = New-Object 'System.Collections.Generic.HashSet[string]'([System.StringComparer]::OrdinalIgnoreCase)
    foreach($node in $ConfigurationData.AllNodes)
    { 
        if($node -isnot [hashtable] -or -not $node.NodeName)
        { 
            $errorMessage = $LocalizedData.AllNodeNeedToBeHashtable
            $exception = New-Object System.InvalidOperationException $errorMessage
            Write-Error -Exception $exception -Message $errorMessage -Category InvalidOperation -ErrorId ConfiguratonDataAllNodesNeedHashtable
            return $false
        } 

        if($nodeNames.Contains($node.NodeName))
        {
            $errorMessage = $LocalizedData.DuplicatedNodeInConfigurationData -f $node.NodeName
            $exception = New-Object System.InvalidOperationException $errorMessage
            Write-Error -Exception $exception -Message $errorMessage -Category InvalidOperation -ErrorId DuplicatedNodeInConfigurationData
            return $false
        }
        
        if($node.NodeName -eq "*")
        {
            $AllNodeSettings = $node
        }
        [void] $nodeNames.Add($node.NodeName)
    }
    
    if($AllNodeSettings)
    {
        foreach($node in $ConfigurationData.AllNodes)
        {
            if($node.NodeName -ne "*") 
            {
                foreach($nodeKey in $AllNodeSettings.Keys)
                {
                    if(-not $node.ContainsKey($nodeKey))
                    {
                        $node.Add($nodeKey, $AllNodeSettings[$nodeKey])
                    }
                }
            }
        }

        $ConfigurationData.AllNodes = @($ConfigurationData.AllNodes | where {$_.NodeName -ne "*"})
    }

    return $true
}

##############################################################
#
# Checks to see if a module defining composite resources should be reloaded 
# based the last write time of the schema file. Returns true if the file exists
# and the last modified time was either not recorded or has change.
#
function Test-ModuleReloadRequired
{
    [OutputType([bool])]
    param (
        [Parameter(Mandatory)]
        [string]
            $SchemaFilePath
    )

    if (-not $SchemaFilePath -or  $SchemaFilePath -notmatch '\.schema\.psm1$')
    {
        # not a composite res
        return $false
    }

    # If the path doesn't exist, then we can't reload it.
    # Note: this condition is explicitly not an error for this function.
    if ( -not (Test-Path $SchemaFilePath))
    {
        if ($schemaFileLastUpdate.ContainsKey($SchemaFilePath))
        {
            $schemaFileLastUpdate.Remove($SchemaFilePath);
        }
        return $false
    }

    # If we have a modified date, then return it.
    if ($schemaFileLastUpdate.ContainsKey($SchemaFilePath))
    {
        if ( (Get-Item $SchemaFilePath).LastWriteTime -eq $schemaFileLastUpdate[$SchemaFilePath] )
        {
            return $false
        }
        else
        {
            return $true
        }

    }

    # Otherwise, record the last write time and return true.
    $script:schemaFileLastUpdate[$SchemaFilePath] = (Get-Item $SchemaFilePath).LastWriteTime
    $true
}
# Holds the schema file to lastwritetime mapping.
[System.Collections.Generic.Dictionary[string,DateTime]] $script:schemaFileLastUpdate = 
    New-Object 'System.Collections.Generic.Dictionary[string,datetime]'

###########################################################
# Configuration keyword implementation
###########################################################
#
# Implements the 'configuration' keyword logic that accumulates and writes
# out the generated DSC MOF files
#
function Configuration
{
    [CmdletBinding()]
    param (
        $ModuleDefinition,
        $ResourceDefinition,
        $OutputPath = ".",
        $Name,
        [scriptblock]
            $Body,
        [hashtable]
            $ArgsToBody,
        [hashtable]
            $ConfigurationData = @{AllNodes=@()},
        [string]
            $InstanceName = ""
    )

    try
    {
        Write-Debug "BEGIN CONFIGURATION '$name' PROCESSING: Additional Resource Modules: [$($ResourceDefinition -join ', ')] OutputPath: '$OutputPath'"

        #
        # True if this is the top-most level of the configuration statement.
        #
        [bool] $topLevel = $false;

        if ($Script:PSConfigurationName -eq "")
        {
            
            Write-Debug "  ${name}: TOP-LEVEL CONFIGURATION STARTED"
            $topLevel = $true;
            #
            # Define a dictionary to hold the "driver" functions that will be created for each CIM class/keyword.
            # This dictionary is passed into the body scriptblock, defining these functions in the body scope
            # which simplifies cleanup.
            #
            $script:functionsToDefine = New-Object 'System.Collections.Generic.Dictionary[string,ScriptBlock]'

            if($ConfigurationData -eq $null)
    	    {
	        	$ConfigurationData = @{AllNodes=@()}
	        }

            $dataValidated = ValidateUpdate-ConfigurationData $ConfigurationData
            
            if (-not $dataValidated)
            {
                Update-ConfigurationErrorCount
                Write-Debug "ConfigurationData validation failed"
                return
            }
            else
            {
                $script:ConfigurationData = $ConfigurationData;
            }

            if($OutputPath -eq "." -or $OutputPath -eq $null -or $OutputPath -eq "")
            {
                $OutputPath = ".\$Name"
            }
            # Load the default CIM keyword/function definitions set, populating the function collection
            # with the default functions.
            [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::LoadDefaultCimKeywords($functionsToDefine);

            # Set up the rest of the configuration runtime state.
            Initialize-ConfigurationRuntimeState $name

            # Create the output directory only if it does not exist.
            # If it exists then the document MOF files will overwrite
            # any existing MOF files with the same name but otherwise
            # leave contents of existing directory alone.
            $ConfigurationOutputDirectory = "$OutputPath"
            if (!(test-path $ConfigurationOutputDirectory))
            {
                $mkdirError = $null
                mkdir -ErrorVariable mkdirError -Force $ConfigurationOutputDirectory > $null 2> $null
                if (! $?)
                {
                    Update-ConfigurationErrorCount       
                }

                if ($mkdirError)
                {
                    $errorId = "InvalidOutputPath"; 
                    $errorCategory = [System.Management.Automation.ErrorCategory]::InvalidOperation;
                    $errorMessage = $($LocalizedData.CannotCreateOutputPath) -f ${ConfigurationOutputDirectory} ;
                    $exception = New-Object System.InvalidOperationException $errorMessage ;
                    $errorRecord = New-Object System.Management.Automation.ErrorRecord $exception, $errorId, $errorCategory, $null
                    Write-Error $errorRecord
                    foreach ($e in $mkdirError)
                    {
                        Write-Error -Exception $e.Exception
                        Update-ConfigurationErrorCount
                    }
                }
            }

            #
            # Add the utility functions used by the resource implementation functions.
            # 

            $functionsToDefine.Add("Get-MofInstanceText",                ${function:Get-MofInstanceText} )
            $functionsToDefine.Add("ConvertTo-MOFInstance",              ${function:ConvertTo-MOFInstance} )
            $functionsToDefine.Add("Update-ConfigurationErrorCount",     ${function:Update-ConfigurationErrorCount} )
            $functionsToDefine.Add("Get-ConfigurationErrorCount",        ${function:Get-ConfigurationErrorCount} )
            $functionsToDefine.Add("Set-PSDefaultConfigurationDocument", ${function:Set-PSDefaultConfigurationDocument} )
            $functionsToDefine.Add("Get-PSDefaultConfigurationDocument", ${function:Get-PSDefaultConfigurationDocument} )
            $functionsToDefine.Add("Get-PSCurrentConfigurationNode",     ${function:Get-PSCurrentConfigurationNode} )
            $functionsToDefine.Add("Set-NodeResources",                  ${function:Set-NodeResources} )
            $functionsToDefine.Add("Test-NodeResources",                 ${function:Test-NodeResources} )
            $functionsToDefine.Add("Add-NodeKeys",                       ${function:Add-NodeKeys} )


            #
            # Add the node keyword implementation function which must be module qualified even though
            # it's not exported from the module because the parsing logic always adds the module name
            # to the command call.
            #
            $functionsToDefine.Add("PSDesiredStateConfiguration\node",   ${function:Node});

            Write-Debug "    ${name}: $($functionsToDefine.Count) type handler functions loaded."
            Write-Debug "  ${name} TOP-LEVEL INITIALIZATION COMPLETED"
        }
        else
        {
            Write-Debug "  ${name}: NESTED CONFIGURATION STARTED"
            $oldFunctionsToDefine = New-Object 'System.Collections.Generic.Dictionary[string,ScriptBlock]'
        }

        #
        # Load all of the required resource definition modules
        #
        $requiredResources = New-Object System.Collections.ObjectModel.Collection[String]
        foreach($res in $ResourceDefinition)
        {
            $requiredResources.Add($res)
        }

        $modules = New-Object System.Collections.ObjectModel.Collection[System.Management.Automation.PSModuleInfo]
        if($ModuleDefinition)
        {
            foreach ($moduleToImport in $ModuleDefinition)
            {
                $moduleInfos = Get-Module -ListAvailable -FullyQualifiedName $moduleToImport

                if ($moduleInfos -and ($moduleToImport.ModuleVersion -or $moduleToImport.Guid))
                {
                    foreach ($moduleInfo in $moduleInfos)
                    {
                        if (($moduleToImport.Guid -and $moduleToImport.Guid.Equals($moduleInfo.Guid.ToString())) -or
                            ($moduleToImport.ModuleVersion -and $moduleToImport.ModuleVersion.Equals($moduleInfo.Version.ToString())))
                        {
                            $modules.Add($moduleInfo);
                            break;
                        }
                    }
                }
                elseif ($moduleInfos.Count -eq 1)
                {
                    $modules.Add($moduleInfos);
                }
            }            
        }
        elseif ($requiredResources)
        {
            $modules = Get-Module -ListAvailable
        }

        # When only moduleName is specified we need to import all resources from the modules
        # This wildcard is required in enumerating all sub-folders under <modulebase>\DscResources\ directory
        if(!($requiredResources))
        {
            $requiredResources.Add("*")
        }

        foreach ($mod in $modules)
        {
            $dscResourcesPath = Join-Path $mod.ModuleBase "DSCResources"

            # Skip the module without DscResources sub-folder
            if(!(Test-Path $dscResourcesPath))
            {
                continue
            }

            $resourcesFound = New-Object System.Collections.ObjectModel.Collection[String]
            foreach($requiredResource in $requiredResources)
            {
                $foundResource = $false
            	foreach ($resource in Get-ChildItem -Path $dscResourcesPath -Directory -Name -Filter $requiredResource)
            	{
                    $foundResource = ImportCimAndScriptKeywordsFromModule -Module $mod -Resource $resource -functionsToDefine $functionsToDefine
                }

                if($foundResource -and !($requiredResource.Contains("*")))
                {
                    $resourcesFound.Add($resource)
                }
            }

            foreach($foundResource in $resourcesFound)
            {
                [void]$requiredResources.Remove($foundResource)
            }

            if(!$requiredResources)
            {
                break
            }
        }

        if (-not (Get-PSCurrentConfigurationNode))
        {
            # A dictionary maps a resourceId to its list of required resources list for any resources
            # defined outside of a node statement
            $Script:NodeResources = $Script:NoNameNodesResources
            $Script:NodeKeys = $Script:NoNameNodeKeys
            [System.Collections.Generic.Dictionary[string,string[]]] $OldNodeResources =
                New-Object 'System.Collections.Generic.Dictionary[string,[string[]]]' ([System.StringComparer]::OrdinalIgnoreCase) 
        }
        else
        {
            $Script:NodeResources = $Script:NodesInThisConfiguration[(Get-PSCurrentConfigurationNode)]
        }

        #
        # Evaluate the configuration statement body which will generate the resource definitons 
        # for this configuration.
        #
        Write-Debug "  ${name}: Evaluating configuration statement body..."
        try
        {
            $variablesToDefine = @(
                #
                # Figure out the "type" of this resource, with is the name of the driver function that was called.
                #
                New-Object PSVariable ("ConfigurationData", $script:ConfigurationData )
                New-Object PSVariable ("MyTypeName", $ExecutionContext.SessionState.Module.GetVariableFromCallersModule("MyInvocation").Value.MyCommand.Name)
                if($script:ConfigurationData)
                {
                    New-Object PSVariable ("AllNodes", $script:ConfigurationData.AllNodes)
                }
            )

            $variablesToDefine += foreach ($key in $ArgsToBody.Keys) {
                New-object PSVariable($key, $ArgsToBody[$key])
            }

            $result = $Body.InvokeWithContext($functionsToDefine, $variablesToDefine)
        }
        catch [System.Management.Automation.MethodInvocationException]
        {
            Write-Debug "  ${name}: Top level exception: $($_ | out-string)"
            # Write the unwrapped exception message
            $PSCmdlet.CommandRuntime.WriteError((Get-InnerMostErrorRecord $_))
            Update-ConfigurationErrorCount
        }

        Write-Debug "  ${name}: Evaluation completed, validating the generated resource set."
        ValidateNodeResources
        Write-Debug "  ${name} Validation completed."

        Write-Debug "  ${name}: Evaluation completed, validating the generated resource set has no circle."
        ValidateNoCircleInNodeResources
        Write-Debug "  ${name} Validation circle completed."

        #
        # write the generated files to disk and return the resulting files to stdout.
        #
       
        if( $topLevel )
        {
            if($Script:NoNameNodeInstanceAliases.Count -gt 0)
            {
                if ($Script:NodeInstanceAliases.ContainsKey("localhost"))
                {
                    $errorMessage = $LocalizedData.LocalHostNodeNotAllowed -f "${name}"
                    $exception = New-Object System.InvalidOperationException $errorMessage
                    Write-Error -Exception $exception -Message $errorMessage -Category InvalidOperation -ErrorId LocalHostNodeNotAllowed
                    Update-ConfigurationErrorCount
                }

                #
                # Write the mof instance texts to files
                #
                Write-NodeMOFFile $name "localhost" $Script:NoNameNodeInstanceAliases

                # If no script-level $ConfigurationData variable is set, this code 
                # tries to get it first, from a global PowerShell ConfigurationData variable,
                # then if that doesn't work it trys the environment
                # variable $ENV:ConfigurationData when is expected to contain a JSON string
                # that will be converted to objects.
                #
                if (-not $script:ConfigurationData)
                {

                    $script:ConfigurationData = try {
                        if ($global:ConfigurationData)
                        {
                            $global:ConfigurationData
                        }
                        elseif ($ENV:ConfigurationData)
                        {
                            $ENV:ConfigurationData | ConvertFrom-Json
                        }
                        else
                        {
                            @()
                        }
                    }
                    catch
                    {
                        Write-Error $_
                        Update-ConfigurationErrorCount
                         @()
                    }
                }
            }

            #
            # write using the top-level hashtable
            #
            foreach($mofNode in $Script:NodeInstanceAliases.Keys)
            {
                #
                # Write the mof instance texts to files
                #
                Write-NodeMOFFile $name $mofNode $Script:NodeInstanceAliases[$mofNode]
            }

            if ($Script:PSConfigurationErrors -gt 0)
            {
                $errorMessage = $LocalizedData.FailToProcessConfiguration -f "$name"
                ThrowError -ExceptionName "System.InvalidOperationException" -ExceptionMessage $errorMessage -ExceptionObject "$name" -ErrorId "FailToProcessConfiguration" -ErrorCategory InvalidOperation
            }
        }
    }
    finally 
    {
        if($topLevel)
        {
            Write-Debug "  CONFIGURATION ${name}: DOING TOP-LEVEL CLEAN UP"
            [System.Management.Automation.Language.DynamicKeyword]::Reset();
            [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ClearCache();

            Initialize-ConfigurationRuntimeState
        }
        Write-Debug "END CONFIGURATION '$name' PROCESSING. OutputPath: '$OutputPath'"
    }
}
Export-ModuleMember -Function Configuration

function ImportCimAndScriptKeywordsFromModule
{
    param (
        [Parameter(Mandatory)]
        $Module,

        [Parameter(Mandatory)]
        $Resource,

        $FunctionsToDefine
    )

	trap { continue }

	$schemaFilePath = $null
	$oldCount = $FunctionsToDefine.Count

	$foundCimSchema = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportCimKeywordsFromModule(
	    $Module, $Resource, [ref] $schemaFilePath, $FunctionsToDefine )

	$functionsAdded = $FunctionsToDefine.Count - $oldCount
	Write-Debug "  ${name}: PROCESSING RESOURCE FILE: Added $functionsAdded type handler functions from  '$schemaFilePath'"

	$schemaFilePath = $null
	$oldCount = $FunctionsToDefine.Count

	$foundScriptSchema = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportScriptKeywordsFromModule(
	    $Module, $Resource, [ref] $schemaFilePath, $FunctionsToDefine )

	$functionsAdded = $FunctionsToDefine.Count - $oldCount
	Write-Debug "  ${name}: PROCESSING RESOURCE FILE: Added $functionsAdded type handler functions from  '$schemaFilePath'"

	if ($foundScriptSchema -and $schemaFilePath)
	{
	    $resourceDirectory = split-path $schemaFilePath
	    if($resourceDirectory -ne $null)
	    {
	        Import-Module -Force: (Test-ModuleReloadRequired $schemaFilePath) -Verbose:$false -Name $resourceDirectory -Global -ErrorAction SilentlyContinue
	    }
	}

    return $foundCimSchema -or $foundScriptSchema
}

#
# A function to write the MOF instance texts of a node to files
#
function Write-NodeMOFFile
{
    param(
        [string]
        $ConfigurationName,

        [string]
        $mofNode,

        [System.Collections.Generic.Dictionary[string,string]]
        $mofNodeHash
    )

    # Set up prefix for both the configuration and metaconfiguration documents.
    $nodeDoc = "/*`n@TargetNode='$mofNode'`n" + "@GeneratedBy=$([system.environment]::UserName)`n@GenerationDate=$(Get-Date)`n@GenerationHost=$([system.environment]::MachineName)`n*/`n"
    $nodeMetaDoc = $nodeDoc
    $nodeConfigurationDocument = $null
    [int]$metaDocCount = 0
    [int]$nodeDocCount = 0

    foreach($mofTypeName in $mofNodeHash.Keys)
    {
        if($mofTypeName -match "MSFT_DSCMetaConfiguration")
        {
            $tempMetaDoc = $mofNodeHash[$mofTypeName]
            $metaDocCount++
            break
        }
    }
                   
    foreach($mofTypeName in $mofNodeHash.Keys)
    {
        if(($mofTypeName -notmatch "MSFT_DSCMetaConfiguration"))
        {
            if(($metaDocCount -gt 0) -and ($tempMetaDoc -match [regex]::Escape($mofTypeName)))
            {
                $nodeMetaDoc += $mofNodeHash[$mofTypeName]
            }
            else
            {
                if($mofTypeName -match "OMI_ConfigurationDocument")
                {
                    $nodeConfigurationDocument = $mofNodeHash[$mofTypeName]
                }
                $nodeDoc += $mofNodeHash[$mofTypeName]
                $nodeDocCount++
            }
        }
    }

    $nodeMetaDoc += $tempMetaDoc

    $nodeOutfile = "$ConfigurationOutputDirectory/$($mofNode).mof"
    if($metaDocCount -gt 0)
    {
        $nodeMetaOutfile = "$ConfigurationOutputDirectory/$($mofNode).meta.mof"
        if ($nodeConfigurationDocument)
        {
            Write-Debug "  ${ConfigurationName}: Adding OMI_ConfigurationDocument from the current node '$mofNode': $nodeConfigurationDocument"
            $nodeMetaDoc += $nodeConfigurationDocument
        }
        elseif (Get-PSDefaultConfigurationDocument)
        {
            Write-Debug "  ${ConfigurationName}: Adding OMI_ConfigurationDocument from $(Get-PSDefaultConfigurationDocument)"
            $nodeMetaDoc += Get-PSDefaultConfigurationDocument
        }
        else
        {
            Write-Debug "  ${ConfigurationName}: Adding missing OMI_ConfigurationDocument element to the document"
            $nodeMetaDoc += "`ninstance of OMI_ConfigurationDocument`n{`n Version=`"1.0.0`";`n Author=`"$([system.environment]::UserName)`";`n GenerationDate=`"$(Get-Date)`";`n GenerationHost=`"$([system.environment]::MachineName)`";`n};`n"
        }
    }
    
    if ($nodeDoc -notmatch "OMI_ConfigurationDocument")
    {
        if (Get-PSDefaultConfigurationDocument)
        {
            Write-Debug "  ${ConfigurationName}: Adding OMI_ConfigurationDocument from $(Get-PSDefaultConfigurationDocument)"
            $nodeDoc += Get-PSDefaultConfigurationDocument
        }
        else
        {
            Write-Debug "  ${ConfigurationName}: Adding missing OMI_ConfigurationDocument element to the document"
            if($Script:NodesPasswordEncrypted[$mofNode])
            {
            
                $nodeDoc += "`ninstance of OMI_ConfigurationDocument`n{`n Version=`"1.0.0`";`n Author=`"$([system.environment]::UserName)`";`n GenerationDate=`"$(Get-Date)`";`n GenerationHost=`"$([system.environment]::MachineName)`";`n ContentType=`"PasswordEncrypted`";`n};`n"
            }
            else
            {
                $nodeDoc += "`ninstance of OMI_ConfigurationDocument`n{`n Version=`"1.0.0`";`n Author=`"$([system.environment]::UserName)`";`n GenerationDate=`"$(Get-Date)`";`n GenerationHost=`"$([system.environment]::MachineName)`";`n};`n"
            }
        }
    }
    # Fix up newlines to be CRLF
    $nodeDoc = $nodeDoc -replace "`n","`r`n"

    $errMsg = Test-MofInstanceText $nodeDoc
    if($errMsg)
    {
        $errorMessage = $LocalizedData.InvalidMOFDefinition -f @($mofNode, $errMsg)
        $exception = New-Object System.InvalidOperationException $errorMessage
        Write-Error -Exception $exception -Message $errorMessage -Category InvalidOperation -ErrorId InvalidMOFDefinition
        Update-ConfigurationErrorCount
        $nodeOutfile = "$ConfigurationOutputDirectory/$($mofNode).mof.error"
    }
    
    if($nodeDocCount -gt 0)
    {
        # Write to a file only if no error was generated or we are writing to .mof.error file
        if ($Script:PSConfigurationErrors -eq 0 -or $nodeOutfile.EndsWith('mof.error'))
        {
            $nodeDoc > $nodeOutfile
            dir $nodeOutfile
        }
    }

    if($nodeMetaDoc -match "MSFT_DSCMetaConfiguration" -and $Script:PSConfigurationErrors -eq 0)
    {
        $nodeMetaDoc = $nodeMetaDoc -replace "`n","`r`n"
        $nodeMetaDoc > $nodeMetaOutfile
        dir $nodeMetaOutfile 
    }
}

#
# A function to make sure that only valid resources are referenced within a node. It
# operates off of the $Script:NodeResources dictionary. An empty dictionary is not
# considered an error since this function is called at both the node level and the configuration
# level.
#
function ValidateNodeResources
{
    Write-Debug "          Validating resource set for node: $(Get-PSCurrentConfigurationNode)"
    if ($Script:NodeResources)
    {
        foreach ($resourceId in $Script:NodeResources.Keys)
        {
            Write-Debug "            Checking node $resourceId"
            foreach ($requiredResource in $Script:NodeResources[$resourceId])
            {
                # Skip resources that have no DependsOn.
                if ($requiredResource)
                {
                    Write-Debug "             > Checking for required node $requiredResource"
                    if (-not $Script:NodeResources.ContainsKey($requiredResource))
                    {
                        $errorMessage = $LocalizedData.RequiredResourceNotFound -f @($requiredResource, $resourceId)
                        $exception = New-Object System.InvalidOperationException $errorMessage
                        Write-Error -Exception $exception -Message $errorMessage -Category InvalidOperation -ErrorId RequiredResourceNotFound
                        Update-ConfigurationErrorCount
                    }
                }
            }
        }
    }
    Write-Debug "          Validation complete for node: $(Get-PSCurrentConfigurationNode)"
}

#
# A function to make sure that only valid resources are referenced within a node. It
# operates off of the $Script:NodeResources dictionary. An empty dictionary is not
# considered an error since this function is called at both the node level and the configuration
# level.
# it uses Tarjan strongly connected component algorithms
#
function ValidateNoCircleInNodeResources
{
    Write-Debug "          Validating resource set for node: $(Get-PSCurrentConfigurationNode)"
    [int] $script:CircleIndex = 0
    [System.Collections.Generic.Stack[string]] $script:resourceIdStack = 
                New-Object 'System.Collections.Generic.Stack[string]'  
    [hashtable] $script:resourceIndex = @{}
    [hashtable] $script:resourceLowIndex = @{}
    [int] $script:ComponentDepth = 0
    [int] $script:MaxComponentDepth = 1024

    if ($Script:NodeResources)
    {
        foreach ($resourceId in $Script:NodeResources.Keys)
        {
            if($resourceIndex[$resourceId] -eq $null)
            {
                $script:ComponentDepth = 0
                StrongConnect($resourceId)
            }
        }
    }
    Write-Debug "          Validation circular reference completed for node: $(Get-PSCurrentConfigurationNode)"
}

function StrongConnect
{
    param ([string]$resourceId)

    $script:resourceIndex[$resourceId] = $script:CircleIndex
    $script:resourceLowIndex[$resourceId] = $script:CircleIndex
    $script:CircleIndex++
    $script:ComponentDepth++
    if($script:ComponentDepth -gt $script:MaxComponentDepth)
    {
            $errorMessage = $LocalizedData.DependsOnLinkTooDeep -f $script:MaxComponentDepth
            $exception = New-Object System.InvalidOperationException $errorMessage
            Write-Error -Exception $exception -Message $errorMessage -Category InvalidOperation -ErrorId DependsOnLinkTooDeep
            Update-ConfigurationErrorCount 
    }

    $script:resourceIdStack.Push($resourceId)
    
    foreach ($requiredResource in $Script:NodeResources[$resourceId])
    {
        Write-Debug "             > Checking for required node $requiredResource"
        #$requiredResource is not visited yet
        if(($requiredResource -ne $null) -and ($script:resourceIndex[$requiredResource] -eq $null))
        {
            StrongConnect($requiredResource)
            $script:resourceLowIndex[$resourceId] = [math]::Min($script:resourceLowIndex[$resourceId], $script:resourceLowIndex[$requiredResource])
        }
        elseif($script:resourceIdStack -Contains $requiredResource)
        {
            $script:resourceLowIndex[$resourceId] = [math]::Min($script:resourceLowIndex[$resourceId], $script:resourceIndex[$requiredResource])         
        }
    }

    if($script:resourceIndex[$resourceId] -eq $script:resourceLowIndex[$resourceId])
    {
        $resourceCount = 0
        $circularLinks = ""
        do
        {
            $a = $script:resourceIdStack.Pop()
            $circularLinks += "->$a"
            $resourceCount++
        }
        while($a -ne $resourceId)

        if($resourceCount -gt 1)
        {
            $errorMessage = $LocalizedData.DependsOnLoopDetected -f $circularLinks
            $exception = New-Object System.InvalidOperationException $errorMessage
            Write-Error -Exception $exception -Message $errorMessage -Category InvalidOperation -ErrorId DependsOnLoopDetected
            Update-ConfigurationErrorCount
        }        
    }
}

#
# Returns any validation error messages
#
function Test-MofInstanceText
{
    param (
        [Parameter(Mandatory)]
        $instanceText
    )

    # Ignore empty instances...
    if ( $instanceText)
    {
        try
        {
            [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ValidateInstanceText($instanceText)
        }
        catch [System.Management.Automation.MethodInvocationException]
        {
            # Return the exception message from the inner most ErrorRecord
            $errorRecord = Get-InnerMostErrorRecord $_
            $errorRecord.Exception.Message
        }
    }
}

#
# Encrypt a password using the defined public key
#
function Get-EncryptedPassword
{
    param (
        [Parameter()]
            $value = $null
    )

    $cert = $null


    if($Node -and $selectedNodesData)
    {
        if($selectedNodesData -is [array])
        { 
            foreach($target in $selectedNodesData)
            {
                if($target["NodeName"] -and $target["NodeName"] -match $Node)
                {
                    $currentNode = $target;
                }
            }
        }
        else
        {
            $currentNode = $selectedNodesData;
        }
    
    }
    # where user need to specify properties for resources not in a node, 
    # they can do it through localhost nodeName in $allNodes
    elseif($allnodes -and $allNodes.AllNodes)
    {
        foreach($target in $allNodes.AllNodes)
        {
            if($target["NodeName"] -and $target["NodeName"] -match "localhost")
            {
                $currentNode = $target;
            }
        }
    }
    
    if($currentNode)
    {
        # If PSDscAllowPlainTextPassword is defined and true then just return
        # the original value.  PSDscAllowPlainTextPassword takes precedence over
        # any certificate information.
        if ($currentNode["PSDscAllowPlainTextPassword"])
        {
            return $value
        }

        # CertificateID is currently assumed to be the 'thumbprint' from the certificate
        $certificateid = $currentNode["CertificateID"];
    
        # If there is no certificateid defined, just return the original value...
        if ( -not $certificateid)
        {
            # CertificateFile is the public key file 
            $certificatefile = $currentNode["CertificateFile"];

            if ( -not $certificatefile)
            {
                return $value
            }
            else
            {
                $cert = Get-PublicKeyFromFile $certificatefile
            }
        }
        else
        {
            $cert = Get-PublicKeyFromStore $certificateid
        }
    }

    if($cert -and $value -is [string])
    {
        # Cast the public key correctly
        $rsaProvider = [System.Security.Cryptography.RSACryptoServiceProvider]$cert.PublicKey.Key
        
        # Convert to a byte array
        $keybytes = [System.Text.Encoding]::UNICODE.GetBytes($value)

        # Add a null terminator to the byte array
        $keybytes += 0
        $keybytes += 0

        # Encrypt using the public key
        $encbytes = $rsaProvider.Encrypt($keybytes, $false)
        
        # Reverse bytes for unmanaged decryption
        [Array]::Reverse($encbytes)

        # Return a string
        [Convert]::ToBase64String($encbytes)
    }
    else
    {
        # passwords should be some type of string so this is probably an error but pass
        # back the incoming value. Also if there is no key, then we just pass through the
        # password as is.
    
        $value
    }
}


#
# Retrieve a public key that can be used for encryption. Matching on thumbprint
#
function Get-PublicKeyFromStore
{
    param(
        [Parameter(Mandatory)]
        [string]
            $CertificateID
    )

    $cert = $null

    foreach($certIndex in Get-Childitem cert:\LocalMachine\My)
    {
        if($certIndex.Thumbprint -match $CertificateID)
        {
            $cert = $certIndex
            break
        }
    }

    if(-not $cert)
    {
        $errorMessage = $($LocalizedData.CertificateStoreReadError) -f ${CertificateID} ;
        ThrowError -ExceptionName "System.InvalidOperationException" -ExceptionMessage $errorMessage -ExceptionObject $CertificateID -ErrorId "InvalidPathSpecified" -ErrorCategory InvalidOperation
    }
    else
    {
        $cert
    }
}

#
# Retrieve a public key that can be used for encryption. Certificate loaded from
# a certificate file
#
function Get-PublicKeyFromFile
{
    param(
        [Parameter(Mandatory)]
        [string]
            $CertificateFile
    )

    try
    {
        $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2

        if($cert)
        {
            $cert.Import($CertificateFile)
            $cert
        }
    }
    catch
    {
        $errorMessage = $($LocalizedData.CertificateFileReadError) -f ${CertificateFile} ;
        ThrowError -ExceptionName "System.InvalidOperationException" -ExceptionMessage $errorMessage -ExceptionObject $CertificateFile -ErrorId "InvalidPathSpecified" -ErrorCategory InvalidOperation
    }
}


###########################################################
#
#  Checksum generation functions.
#
###########################################################

#-----------------------------------------------------------------------------------------------------
# New-DSCCheckSum cmdlet is used to create corresponding checksum files for a specified file or folder
#-----------------------------------------------------------------------------------------------------
function New-DSCCheckSum
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [Alias("Path")]        
        [ValidateNotNullOrEmpty()]         
        [string[]]
            $ConfigurationPath,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        	$OutPath = $null,

        [switch]
            $Force
    )
      
    # Check validity of all configuration paths specified, throw if any of them is invalid
    for ($i=0 ; $i -lt $ConfigurationPath.Length ; $i++)
    {
        if (!(Test-Path -Path $ConfigurationPath[$i]))
        {
            $errorMessage = $LocalizedData.InvalidConfigPath -f $ConfigurationPath[$i]
            ThrowError -ExceptionName "System.ArgumentException" -ExceptionMessage $errorMessage -ExceptionObject $ConfigurationPath[$i] -ErrorId "InvalidConfigurationPath" -ErrorCategory InvalidArgument
        }
    }

    # If an OutPath is specified, handle its creation and error conditions
    if ($OutPath)
    {
        # If and invalid path syntax is specified in $Outpath, throw
        if(([System.IO.Path]::InvalidPathChars | % {$OutPath.Contains($_)}).IndexOf($true)[0] -ne -1)
        {
            $errorMessage = $LocalizedData.InvalidOutpath -f $OutPath
            ThrowError -ExceptionName "System.ArgumentException" -ExceptionMessage $errorMessage -ExceptionObject $OutPath -ErrorId "InvalidOutPath" -ErrorCategory InvalidArgument
        }
        
        # If the specified $Outpath conflicts with an existing file, throw
        if(Test-Path -Path $OutPath -PathType Leaf)
        {
            $errorMessage = $LocalizedData.OutpathConflict -f $OutPath
            ThrowError -ExceptionName "System.ArgumentException" -ExceptionMessage $errorMessage -ExceptionObject $ConfigurationPath -ErrorId "InvalidConfigurationPath" -ErrorCategory InvalidArgument
        }

        # IF THE CONTROL REACHED HERE, $OutPath IS A VALID DIRECTORY PATH WHICH HAS NO CONFLICT WITH AN EXISTING FILE

        # If $OutPath doesn't exist, create it
        if(!(Test-Path -Path $OutPath))
        {
            New-Item -Path $OutPath -ItemType Directory | out-null
        }   
        
        $OutPath = (Resolve-Path $OutPath).Path
    }
            
    # Retrieve all valid configuration files at the specified $configPath
    $allConfigFiles = $ConfigurationPath | %  {(Get-ChildItem -Path $_ -Recurse | ? {$_.Extension -eq ".mof" -or $_.Extension -eq ".zip"})}
    
    # If no valid config file was found, log this and return
    if ($allConfigFiles.Length -eq 0)
    {
        Write-Log -Message $LocalizedData.NoValidConfigFileFound

        return
    }

    # IF THE CONTROL REACHED HERE, VALID CONFIGURATION FILES HAVE BEEN FOUND AND WE NEED TO CALCULATE THEIR HASHES

    foreach ($file in $allConfigFiles)
    {
        $fileOutpath = "$($file.FullName).checksum"
        if ($OutPath)
        {
            $fileOutpath = "$OutPath\$($file.Name).checksum"
        }
        
        # If the Force parameter was not specified and the hash file already exists for the current file, log this, and skip this file
        if (!$Force -and (Get-Item -Path $fileOutpath -ErrorAction SilentlyContinue))
        {
            Write-Log -Message ($LocalizedData.CheckSumFileExists -f $fileOutpath)
            continue
        }

        # Devise appropriate message
        $message = $LocalizedData.CreateChecksumFile -f $fileOutpath 
        if (Test-Path -Path $fileOutpath)
        {
            $message = $LocalizedData.OverwriteChecksumFile -f $fileOutpath 
        }        

        # Finally, if the hash file doesn't exist already or -Force has been specified, then output the corresponding hash file
        if ($PSCmdlet.ShouldProcess($message, $null, $null))
        {
            [String]$checksum = (Get-FileHash -Path $file.FullName -Algorithm SHA256).Hash 

            WriteFile -Path $fileOutpath -Value $checksum
        }
    }                        
}
Export-ModuleMember -Function New-DSCCheckSum


#------------------------------------
# Utility to throw an error/exception
#------------------------------------
function ThrowError
{    
    param
    (        
        [parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[System.String]        
        $ExceptionName,

        [parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[System.String]
        $ExceptionMessage,
        
 		[System.Object]
        $ExceptionObject,
        
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ErrorId,

        [parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [System.Management.Automation.ErrorCategory]
        $ErrorCategory
    )
        
    $exception = New-Object $ExceptionName $ExceptionMessage;
    $errorRecord = New-Object System.Management.Automation.ErrorRecord $exception, $ErrorId, $ErrorCategory, $ExceptionObject
    throw $errorRecord
}

#----------------------------------------
# Utility to write WhatIf or Verbose logs
#----------------------------------------
function Write-Log
{
    [CmdletBinding(SupportsShouldProcess=$true)]
	param
	(	
		[parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[System.String]
		$Message
    )

    if ($PSCmdlet.ShouldProcess($Message, $null, $null))
    {
        Write-Verbose $Message        
    }    
}

# WriteFile is a helper function used to write the content to the file
function WriteFile
{
    param(
        [parameter(Mandatory)]
            [string]
            $Value,

        [parameter(Mandatory)]
            [string]
            $Path)

   try
   {
        [system.io.streamwriter]$stream = new-object -TypeName system.io.StreamWriter($Path,$false);
        try
        {
            [void] $stream.Write($Value)  
        }
        finally
        {
            if ($stream) {
                $stream.Close();
            }
        }
   }
   catch
   {
        $errorMessage = $LocalizedData.FileReadError -f $Path
        $exception = New-Object System.InvalidOperationException $errorMessage
        Write-Error -Exception $exception -Message $errorMessage -Category InvalidOperation -ErrorId InvalidPathSpecified
        Update-ConfigurationErrorCount
   }
}

#
# ReadEnvironmentFile imports the contents of a
# file as ConfigurationData
#
function ReadEnvironmentFile
{
    param(
        [parameter(Mandatory)]
            [string]
            $FilePath)

    try
    {
        $resolvedPath = Resolve-Path $FilePath
    }
    catch
    {
        $errorMessage = $LocalizedData.FilePathError -f $FilePath
        $exception = New-Object System.InvalidOperationException $errorMessage
        Write-Error -Exception $exception -Message $errorMessage -Category InvalidOperation -ErrorId InvalidPathSpecified
        Update-ConfigurationErrorCount
    }

    try
    {
        $content = Get-Content $resolvedPath -Raw
        $sb = [scriptblock]::Create($content)
        $sb.CheckRestrictedLanguage($null, $null, $true)
        $sb.Invoke()
    }
    catch
    {
        $errorMessage = $LocalizedData.EnvironmentContentError -f $FilePath
        $exception = New-Object System.InvalidOperationException $errorMessage
        Write-Error -Exception $exception -Message $errorMessage -Category InvalidOperation -ErrorId InvalidEnvironmentContentSpecified
        Update-ConfigurationErrorCount
    }
}

###########################################################
#  Get-DSCResource
###########################################################

#
# Gets DSC resources on the machine. Allows to filter on a particular resource.
# It parses all the resources defined in the schema.mof file and also the composite 
# resources defined or imported from PowerShell modules
# 
function Get-DscResource
{
    [CmdletBinding()]
    [OutputType("Microsoft.PowerShell.DesiredStateConfiguration.DscResourceInfo[]")]
    [OutputType("string[]")]
    param (
        [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [string[]]
            $Name,

        [Parameter()]
        [switch]
            $Syntax
    )
    
    Begin
    {
        $initialized = $false

        Write-progress -id 1 -activity $LocalizedData.LoadingDefaultCimKeywords

        [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::LoadDefaultCimKeywords()
              
        Write-progress -id 2 -activity $LocalizedData.GettingModuleList

        $initialized = $true

        $modules = Get-Module -ListAvailable

        foreach ($mod in $modules)
        {
            $dscResources = Join-Path $mod.ModuleBase "DSCResources"
            if(Test-Path $dscResources)
            {
            	foreach ($resource in Get-ChildItem -Path $dscResources -Directory -Name)
            	{
                    $null = ImportCimAndScriptKeywordsFromModule -Module $mod -Resource $resource -functionsToDefine $functionsToDefine
            	}
            }
        }

        $resources = @()
    }
        
    Process
    {
        try
        {
            if ($Name -ne $null)
            {
                $nameMessage = $LocalizedData.GetDscResourceInputName -f @("Name", [system.string]::Join(", ", $Name));
                Write-Verbose -Message $nameMessage
            }

            $ignoreResourceParameters = @("InstanceName", "OutputPath", "ConfigurationData") + [System.Management.Automation.Cmdlet]::CommonParameters + [System.Management.Automation.Cmdlet]::OptionalCommonParameters

            $patterns = GetPatterns $Name
        
            Write-progress -id 3 -activity $LocalizedData.CreatingResourceList

            # Get resources for CIM cache 
            $keywords = [System.Management.Automation.Language.DynamicKeyword]::GetKeyword() | ? {($_.ResourceName -ne $null) -and !(IsHiddenResource $_.ResourceName)}

            $resources += $keywords | % { GetResourceFromKeyword -keyword $_ -patterns $patterns -modules $modules } | ? {$_ -ne $null}

            # Get composite resources
            $resources += Get-Command -CommandType Configuration | ForEach-Object { GetCompositeResource $patterns $_ $ignoreResourceParameters -modules $modules } | Where-Object {$_ -ne $null}

            # check whether all resources are found
            CheckResourceFound $name $resources 
        }
        catch
        {
            if ($initialized)
            {
                [System.Management.Automation.Language.DynamicKeyword]::Reset()
                [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ClearCache()

                $initialized = $false
            }

            throw $_
        }
   }

   End
   {
        $resources = $resources | Sort-Object -Property Module,Name
        foreach ($resource in $resources)
        {
            # return formatted string if required
            if ($Syntax)
            {
                GetSyntax $resource | Write-Output
            }
            else
            {
                Write-Output $resource
            }
        }

        if ($initialized)
        {
            [System.Management.Automation.Language.DynamicKeyword]::Reset()
            [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ClearCache()

            $initialized = $false
        }
    }
}

#
# Get DSC resoruce for a dynamic keyword
#
function GetResourceFromKeyword
{
    [OutputType("Microsoft.PowerShell.DesiredStateConfiguration.DscResourceInfo")]
    param (
        [Parameter(Mandatory)]
        [System.Management.Automation.Language.DynamicKeyword]
            $keyword,
        [System.Management.Automation.WildcardPattern[]]
            $patterns,        
        [Parameter(Mandatory)]
        [System.Management.Automation.PSModuleInfo[]]
            $modules
    )
       
    # Find whether $name follows the pattern
    $matched = IsPatternMatched $patterns $keyword.Keyword
    if ($matched -eq $false)
    {
        $message = $LocalizedData.ResourceNotMatched -f @($keyword.Keyword)
        Write-Verbose -Message ($message)
        return
    }
    else
    {
        $message = $LocalizedData.CreatingResource -f @($keyword.Keyword)
        Write-Verbose -Message $message
    }

    $resource = New-Object -TypeName Microsoft.PowerShell.DesiredStateConfiguration.DscResourceInfo

    $resource.ResourceType = $keyword.ResourceName

    if ($keyword.ResourceName -ne $keyword.Keyword)
    {
        $resource.FriendlyName = $keyword.Keyword
    }

    $resource.Name = $keyword.Keyword

    $schemaFileName = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::GetFileDefiningClass($keyword.ResourceName)

    if ($schemaFileName -ne $null)
    {
        $message = $LocalizedData.SchemaFileForResource -f @($schemaFileName)
        Write-Verbose -Message $message

        $resource.Module = GetModule $modules $schemaFileName
        $resource.Path = GetImplementingModulePath $schemaFileName
        $resource.ParentPath = Split-Path $schemaFileName
    }

    if ([system.string]::IsNullOrEmpty($resource.Path) -eq $false)
    {
        $resource.ImplementedAs = [Microsoft.PowerShell.DesiredStateConfiguration.ImplementedAsType]::PowerShell
    }
    else
    {
        $resource.ImplementedAs = [Microsoft.PowerShell.DesiredStateConfiguration.ImplementedAsType]::Binary
    }

    if ($resource.Module -ne $null)
    {
        $resource.CompanyName = $resource.Module.CompanyName
    }

    # add properties
    $keyword.Properties.Values | % { AddDscResourceProperty $resource $_ }

    # sort properties
    $updatedProperties = $resource.Properties | sort-object @{expression="IsMandatory";Descending=$true},@{expression="Name";Ascending=$true}
    $resource.UpdateProperties($updatedProperties)

    return $resource
}

#
# Gets composite resource
#
function GetCompositeResource
{
    [OutputType("Microsoft.PowerShell.DesiredStateConfiguration.DscResourceInfo")]
    param (
        [System.Management.Automation.WildcardPattern[]]
            $patterns,        
        [Parameter(Mandatory)]
        [System.Management.Automation.ConfigurationInfo]
            $configInfo,
            $ignoreParameters,
        [Parameter(Mandatory)]
        [System.Management.Automation.PSModuleInfo[]]
            $modules
    )

    # Find whether $name follows the pattern
    $matched = IsPatternMatched $patterns $configInfo.Name
    if ($matched -eq $false)
    {
        $message = $LocalizedData.ResourceNotMatched -f @($configInfo.Name)
        Write-Verbose -Message ($message)
       
        return $null
    }
    else
    {
        $message = $LocalizedData.CreatingResource -f @($configInfo.Name)
        Write-Verbose -Message $message
    }

    $resource = New-Object -TypeName Microsoft.PowerShell.DesiredStateConfiguration.DscResourceInfo

    $resource.ResourceType = $configInfo.Name
    $resource.FriendlyName = $null
    $resource.Name = $configInfo.Name
    $resource.ImplementedAs = [Microsoft.PowerShell.DesiredStateConfiguration.ImplementedAsType]::Composite;

    if ($configInfo.Module -ne $null)
    {
        $resource.Module = GetModule $modules $configInfo.Module.Path
        if($resource.Module -eq $null)
        {
            $resource.Module = $configInfo.Module
        }
        $resource.CompanyName = $configInfo.Module.CompanyName
        $resource.Path = $configInfo.Module.Path
        $resource.ParentPath = Split-Path $resource.Path
    }

    # add properties
    $configInfo.Parameters.Values | % { AddDscResourcePropertyFromMetadata $resource $_ $ignoreParameters }

    return $resource
}

#
# Adds property to a DSC resource
#
function AddDscResourceProperty
{
    param (
        [Parameter(Mandatory)]
        [Microsoft.PowerShell.DesiredStateConfiguration.DscResourceInfo]
            $dscResource,
        [Parameter(Mandatory)]
            $property
    )

    $convertTypeMap = @{ 
        "[MSFT_Credential]"="[PSCredential]"; 
        "[MSFT_KeyValuePair]"="[HashTable]"; 
        "[MSFT_KeyValuePair[]]"="[HashTable]"}

    $ignoreProperties = @("ResourceId")
    if ($ignoreProperties -contains $property.Name)
    {
        return;
    }

    $dscProperty = New-Object Microsoft.PowerShell.DesiredStateConfiguration.DscResourcePropertyInfo
    $dscProperty.Name = $property.Name
    $type = [System.Management.Automation.LanguagePrimitives]::ConvertTypeNameToPSTypeName($property.TypeConstraint)

    if ($type -eq "[]")
    {
        $type = "[" + $property.TypeConstraint + "]"
    }

    if ($convertTypeMap.ContainsKey($type))
    {
        $type = $convertTypeMap[$type]
    }

    if ($property.ValueMap -ne $null)
    {
        $property.ValueMap.Keys | sort | % { $dscProperty.Values.Add($_) }
    }

    $dscProperty.PropertyType = $type
    $dscProperty.IsMandatory = $property.Mandatory

    $dscResource.Properties.Add($dscProperty)
}

#
# Adds property to a DSC resource
#
function AddDscResourcePropertyFromMetadata
{
    param (
        [Parameter(Mandatory)]
        [Microsoft.PowerShell.DesiredStateConfiguration.DscResourceInfo]
            $dscResource,
        [Parameter(Mandatory)]
        [System.Management.Automation.ParameterMetadata]
            $parameter,
            $ignoreParameters
    )

    if ($ignoreParameters -contains $parameter.Name)
    {
        return;
    }

    $dscProperty = New-Object Microsoft.PowerShell.DesiredStateConfiguration.DscResourcePropertyInfo
    $dscProperty.Name = $parameter.Name

    # adding [] in Type name to keep it in sync with the name returned from LanguagePrimitives.ConvertTypeNameToPSTypeName
    $dscProperty.PropertyType = "[" +$parameter.ParameterType.Name + "]"
    $dscProperty.IsMandatory = $parameter.Attributes.Mandatory

    $dscResource.Properties.Add($dscProperty)
}

#
# Gets syntax for a DSC resource
#
function GetSyntax
{
    [OutputType("string")]
    param (
        [Parameter(Mandatory)]
        [Microsoft.PowerShell.DesiredStateConfiguration.DscResourceInfo]
            $dscResource
    )

    $output  = $dscResource.Name + " [string] #ResourceName`n"
    $output += "{`n"
    foreach ($property in $dscResource.Properties)
    {
        $output += "    "
        if ($property.IsMandatory -eq $false)
        {
            $output += '[ '
        }

        $output += $property.Name

        $output += " = " + $property.PropertyType + ""

        # Add possible values
        if ($property.Values.Count -gt 0)
        {
            $output += " { " +  [system.string]::Join(" | ", $property.Values) + " } "
        }

        if ($property.IsMandatory -eq $false)
        {
            $output += ' ]'
        }

        $output += "`n"
    }

    $output += "}`n"

    return $output
}

#
# Checks whether a resource is found or not
#
function CheckResourceFound($names, $resources)
{
    if ($names -eq $null)
    {
        return
    }

    $namesWithoutWildcards = $Names | where { [System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($_) -eq $false }
    
    foreach ($name in $namesWithoutWildcards)
    {
        $foundResources = $resources | where {$_.Name -eq $name}
        if ($foundResources.Count -eq 0)
        {
            $errorMessage = $LocalizedData.ResourceNotFound -f @($name,"Resource")
            Write-Error -Message $errorMessage
        }
    }
}

#
# Get implementing module path
#
function GetImplementingModulePath
{
    param (
        [Parameter(Mandatory)]
        [string]
            $schemaFileName
    )

    $moduleFileName = ($schemaFilename -replace ".schema.mof$","") + ".psd1"
    if (Test-Path $moduleFileName)
    {
        return $moduleFileName
    }

    $moduleFileName = ($schemaFilename -replace ".schema.mof$","") + ".psm1"
    if (Test-Path $moduleFileName)
    {
        return $moduleFileName
    }

    return
}

#
# Gets module for a DSC resource
#
function GetModule
{
    [OutputType("System.Management.Automation.PSModuleInfo")]
    param (
        [Parameter(Mandatory)]
        [System.Management.Automation.PSModuleInfo[]]
            $modules,
        [Parameter(Mandatory)]
        [string]
            $schemaFileName
    )

    if($schemaFileName -eq $null)
    {
        return $null
    }
    
    $schemaFileExt = $null
    if ($schemaFileName -match ".schema.mof")
    {
        $schemaFileExt = ".schema.mof$"
    }

    if ($schemaFileName -match ".schema.psm1")
    {
        $schemaFileExt = ".schema.psm1$"
    }
    
    if(!$schemaFileExt)
    {
        return $null
    }
    
    # get module from parent directory. 
    # Desired structure is : <Module-directory>/DSCResources/<schema file directory>/schema.File
    $validResource = $false
    $schemaDirectory = split-path $schemaFileName
    if($schemaDirectory)
    {
        $subDirectory = [System.IO.Directory]::GetParent($schemaDirectory)

        if ($subDirectory -and ($subDirectory.Name -eq "DSCResources") -and $subDirectory.Parent)
        {
            $moduleDirectory = [System.IO.Directory]::GetParent($subDirectory)
            $results = $modules | where {$_.ModuleBase -eq $subDirectory.Parent.FullName}

            if ($results)
            {
                # Log Resource is internally handled by the CA. There is no formal provider for it.
                if ($schemaFilename -match "MSFT_LogResource")
                {
                    $validResource = $true
                }
                else
                {
                    # check for proper resource module
                    foreach ($ext in @(".psd1", ".psm1", ".dll", ".cdxml"))
                    {
                        $resModuleFileName = ($schemaFilename -replace $schemaFileExt,"") + $ext
                        if(Test-Path($resModuleFileName))
                        {
                            $validResource = $true
                            break;
                        }
                    }
                }
            }
        }
    }

    if ($results -and $validResource)
    {
        return $results[0]
    }
    else
    {
        return $null
    }
}

#
# Checks whether a resource is hidden or not
#
function IsHiddenResource
{
    param (
        [Parameter(Mandatory)]
        [string]
            $resourceName
    )
        
    $hiddenResources = @(
        'OMI_BaseResource',
        'MSFT_KeyValuePair',
        'MSFT_BaseConfigurationProviderRegistration',
        'MSFT_CimConfigurationProviderRegistration',
        'MSFT_PSConfigurationProviderRegistration',
        'OMI_ConfigurationDocument',
        'MSFT_Credential',
        'MSFT_DSCMetaConfiguration'
    )

    return $hiddenResources -contains $resourceName
}

#
# Gets patterns for names
#
function GetPatterns
{
    [OutputType("System.Management.Automation.WildcardPattern[]")]
    param (
        [string[]]
            $names       
    )

    $patterns = @()

    if ($names -eq $null)
    {
        return $patterns
    }

    foreach ($name in $names)
    {
       $patterns +=  new-object System.Management.Automation.WildcardPattern -ArgumentList @($name, [System.Management.Automation.WildcardOptions]::IgnoreCase)
    }

    return $patterns
}

#
# Checks whether an input name matches one of the patterns
# $pattern is not expected to have an empty or null values
#
function IsPatternMatched
{
    [OutputType("bool")]
    param (
        [System.Management.Automation.WildcardPattern[]]
            $patterns, 
        [Parameter(Mandatory)]       
        [string]
            $name
    )

    if ($patterns -eq $null)
    {
        return $true
    }

    foreach ($pattern in $patterns)
    {
        if ($pattern.IsMatch($name))
        {
            return $true
        }
    }

    return $false
}

Export-ModuleMember Get-DscResource
###########################################################

###########################################################
#  Aliases
###########################################################
New-Alias -Name "sacfg" -Value "Start-DSCConfiguration"
New-Alias -Name "tcfg" -Value "Test-DSCConfiguration"
New-Alias -Name "gcfg" -Value "Get-DSCConfiguration"
New-Alias -Name "rtcfg" -Value "Restore-DSCConfiguration"
New-Alias -Name "glcm" -Value "Get-DSCLocalConfigurationManager"
New-Alias -Name "slcm" -Value "Set-DSCLocalConfigurationManager"

Export-ModuleMember -Alias * -Function *
