# Localized	09/27/2013 04:07 AM (GMT)	303:4.80.0411 	PSDesiredStateConfiguration.Resource.psd1
# Localized PSDesiredStateConfigurationResource.psd1

ConvertFrom-StringData @'
###PSLOC
CheckSumFileExists=File '{0}' already exists. Please specify -Force parameter to overwrite existing checksum files.
CreateChecksumFile=Create checksum file '{0}'
OverwriteChecksumFile=Overwrite checksum file '{0}'
OutpathConflict=(ERROR) Cannot create directory '{0}'. A file exists with the same name.
InvalidConfigPath=(ERROR) Invalid configuration path '{0}' specified.
InvalidOutpath=(ERROR) Invalid OutPath '{0}' specified.
NoValidConfigFileFound=No valid config files (mof,zip) were found.
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
###PSLOC
'@
