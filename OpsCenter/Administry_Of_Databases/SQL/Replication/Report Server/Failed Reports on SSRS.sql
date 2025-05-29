USE [ReportServer]
GO

SELECT TOP 2

C.Path, C.Name,

EL.UserName,

EL.Status,

EL.TimeStart,

EL.[RowCount],

EL.ByteCount,

(EL.TimeDataRetrieval

+ EL.TimeProcessing

+ EL.TimeRendering)/1000 AS TotalSeconds,

EL.TimeDataRetrieval,

EL.TimeProcessing,

EL.TimeRendering, *

FROM ExecutionLog EL

INNER JOIN Catalog C ON EL.ReportID = C.ItemID

WHERE EL.Status <> 'rsSuccess'

ORDER BY TimeStart DESC




<Parameters>    <UserProfileState>0</UserProfileState>    <Parameter>      <Name>AgencyId</Name>      <Type>String</Type>      <Nullable>False</Nullable>      <AllowBlank>False</AllowBlank>      <MultiValue>False</MultiValue>      <UsedInQuery>True</UsedInQuery>      <State>MissingValidValue</State>      <Prompt />      <DynamicPrompt>False</DynamicPrompt>      <PromptUser>True</PromptUser>      <DefaultValues>        <Value>1</Value>      </DefaultValues>      <Values>        <Value>1</Value>      </Values>    </Parameter>    <Parameter>      <Name>UserId</Name>      <Type>Integer</Type>      <Nullable>False</Nullable>      <AllowBlank>False</AllowBlank>      <MultiValue>False</MultiValue>      <UsedInQuery>True</UsedInQuery>      <State>MissingValidValue</State>      <Prompt />      <DynamicPrompt>False</DynamicPrompt>      <PromptUser>True</PromptUser>      <DefaultValues>        <Value>3</Value>      </DefaultValues>      <Values>        <Value>3</Value>      </Values>    </Parameter>    <Parameter>      <Name>LENDER_NAME</Name>      <Type>String</Type>      <Nullable>False</Nullable>      <AllowBlank>False</AllowBlank>      <MultiValue>False</MultiValue>      <UsedInQuery>True</UsedInQuery>      <State>MissingValidValue</State>      <Prompt>Lender Name</Prompt>      <DynamicPrompt>False</DynamicPrompt>      <PromptUser>True</PromptUser>      <Dependencies>        <Dependency>AgencyId</Dependency>        <Dependency>UserId</Dependency>      </Dependencies>      <DynamicValidValues>True</DynamicValidValues>    </Parameter>    <Parameter>      <Name>DATE_RANGE_TYPE</Name>      <Type>String</Type>      <Nullable>False</Nullable>      <AllowBlank>False</AllowBlank>      <MultiValue>False</MultiValue>      <UsedInQuery>True</UsedInQuery>      <State>MissingValidValue</State>      <Prompt>Date Range Type</Prompt>      <DynamicPrompt>False</DynamicPrompt>      <PromptUser>True</PromptUser>      <DynamicValidValues>True</DynamicValidValues>      <DefaultValues>        <Value>M_CURR</Value>      </DefaultValues>      <Values>        <Value>M_CURR</Value>      </Values>    </Parameter>    <Parameter>      <Name>START_DT</Name>      <Type>DateTime</Type>      <Nullable>False</Nullable>      <AllowBlank>False</AllowBlank>      <MultiValue>False</MultiValue>      <UsedInQuery>True</UsedInQuery>      <State>MissingValidValue</State>      <Prompt>Start Date</Prompt>      <DynamicPrompt>False</DynamicPrompt>      <PromptUser>True</PromptUser>      <Dependencies>        <Dependency>DATE_RANGE_TYPE</Dependency>      </Dependencies>      <DynamicDefaultValue>True</DynamicDefaultValue>    </Parameter>    <Parameter>      <Name>END_DT</Name>      <Type>DateTime</Type>      <Nullable>False</Nullable>      <AllowBlank>False</AllowBlank>      <MultiValue>False</MultiValue>      <UsedInQuery>True</UsedInQuery>      <State>MissingValidValue</State>      <Prompt>End Date</Prompt>      <DynamicPrompt>False</DynamicPrompt>      <PromptUser>True</PromptUser>      <Dependencies>        <Dependency>DATE_RANGE_TYPE</Dependency>      </Dependencies>      <DynamicDefaultValue>True</DynamicDefaultValue>    </Parameter>    <Parameter>      <Name>ProductTypeList</Name>      <Type>String</Type>      <Nullable>False</Nullable>      <AllowBlank>False</AllowBlank>      <MultiValue>True</MultiValue>      <UsedInQuery>True</UsedInQuery>      <State>MissingValidValue</State>      <Prompt>Product List</Prompt>      <DynamicPrompt>False</DynamicPrompt>      <PromptUser>True</PromptUser>      <Dependencies>        <Dependency>LENDER_NAME</Dependency>        <Dependency>UserId</Dependency>      </Dependencies>      <DynamicValidValues>True</DynamicValidValues>      <DynamicDefaultValue>True</DynamicDefaultValue>    </Parameter>    <Parameter>      <Name>AppStatus</Name>      <Type>String</Type>      <Nullable>False</Nullable>      <AllowBlank>False</AllowBlank>      <MultiValue>True</MultiValue>      <UsedInQuery>True</UsedInQuery>      <State>MissingValidValue</State>      <Prompt>Sale Status</Prompt>      <DynamicPrompt>False</DynamicPrompt>      <PromptUser>True</PromptUser>      <DynamicValidValues>True</DynamicValidValues>      <DefaultValues>        <Value>S</Value>        <Value>F</Value>        <Value>RI</Value>      </DefaultValues>      <Values>        <Value>S</Value>        <Value>F</Value>        <Value>RI</Value>      </Values>    </Parameter>    <Parameter>      <Name>OriginList</Name>      <Type>String</Type>      <Nullable>False</Nullable>      <AllowBlank>False</AllowBlank>      <MultiValue>True</MultiValue>      <UsedInQuery>True</UsedInQuery>      <State>MissingValidValue</State>      <Prompt>Origin List</Prompt>      <DynamicPrompt>False</DynamicPrompt>      <PromptUser>True</PromptUser>      <DynamicValidValues>True</DynamicValidValues>      <DynamicDefaultValue>True</DynamicDefaultValue>    </Parameter>    <Parameter>      <Name>DATE_TYPE_CD</Name>      <Type>String</Type>      <Nullable>False</Nullable>      <AllowBlank>False</AllowBlank>      <MultiValue>False</MultiValue>      <UsedInQuery>True</UsedInQuery>      <State>MissingValidValue</State>      <Prompt>Date Type</Prompt>      <DynamicPrompt>False</DynamicPrompt>      <PromptUser>True</PromptUser>      <DynamicValidValues>True</DynamicValidValues>      <DefaultValues>        <Value>ISS</Value>      </DefaultValues>      <Values>        <Value>ISS</Value>      </Values>    </Parameter>    <Parameter>      <Name>BRANCH_TYPE_CD</Name>      <Type>String</Type>      <Nullable>False</Nullable>      <AllowBlank>False</AllowBlank>      <MultiValue>False</MultiValue>      <UsedInQuery>True</UsedInQuery>      <State>MissingValidValue</State>      <Prompt>Filter Using</Prompt>      <DynamicPrompt>False</DynamicPrompt>      <PromptUser>True</PromptUser>      <DynamicValidValues>True</DynamicValidValues>      <DefaultValues>        <Value>CLOSE</Value>      </DefaultValues>      <Values>        <Value>CLOSE</Value>      </Values>    </Parameter>  </Parameters>