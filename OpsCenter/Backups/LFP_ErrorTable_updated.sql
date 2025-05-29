use UniTrac 

IF NOT EXISTS (select * from sys.tables where name = 'tgt_CETD_Error')
BEGIN
CREATE TABLE tgt_CETD_Error
(
    ID                  bigint NOT NULL,
    TRANSACTION_ID      bigint NOT NULL,
    SEQUENCE_ID         bigint NOT NULL,
    LoanNumber_TX       nvarchar(20),
    CollateralNumber_TX nvarchar(20),
    ValidCode_TX        nvarchar(30),
    Error_Message       nvarchar(250),
    Error_Item          varchar(100),
    Error_Value         varchar(50)
);
	PRINT 'SUCCESS: tgt_CETD_Error created!' 
END
ELSE
BEGIN 
	PRINT 'WARNING: already tgt_CETD_Error exists' 
END

IF EXISTS (select * from sys.tables where name = 'tgt_CETD_Error')
BEGIN
IF NOT EXISTS (select * from sys.tables where name = 'tgt_CETD_Error')
BEGIN
	ALTER TABLE tgt_CETD_Error ADD PRIMARY KEY (ID);
END
END
ELSE
BEGIN 
	PRINT 'WARNING: tgt_CETD_Error DOES NOT EXIST' 
END

IF NOT EXISTS (select * from sys.tables where name = 'tgt_OETD_Error')
BEGIN
CREATE TABLE tgt_OETD_Error
(
    ID               bigint NOT NULL,
    TRANSACTION_ID   bigint NOT NULL,
    SEQUENCE_ID      bigint NOT NULL,
    Loan_Number_TX   nvarchar(30),
    LastName_TX      nvarchar(30),
    FirstName_TX     nvarchar(30),
    MiddleInitial_TX nvarchar(5),
    ValidCode_TX     nvarchar(30),
    Error_Message    nvarchar(250),
    Error_Item       varchar(100),
    Error_Value      varchar(50),
    Owner_Type       varchar(10),
    Address_Line1    varchar(60),
    City             varchar(40),
    State            varchar(30),
    Zip              varchar(10)
);
	PRINT 'SUCCESS: tgt_OETD_Error created!' 
END
ELSE
BEGIN 
	PRINT 'WARNING: already tgt_OETD_Error exists' 
END

IF EXISTS (select * from sys.tables where name = 'tgt_OETD_Error')
BEGIN
IF NOT EXISTS (select * from sys.tables where name = 'tgt_OETD_Error')
BEGIN
ALTER TABLE tgt_OETD_Error ADD PRIMARY KEY (ID);
END
END
ELSE
BEGIN 
	PRINT 'WARNING: tgt_OETD_Error DOES NOT EXIST' 
END


IF NOT EXISTS (select * from sys.tables where name = 'tgt_LETD_Error')
BEGIN
CREATE TABLE tgt_LETD_Error
(
    ID             bigint NOT NULL,
    TRANSACTION_ID bigint NOT NULL,
    PROCESSED_IN   char(1) NOT NULL,
    STATUS_CD      nvarchar(50) NOT NULL,
    SEQUENCE_ID    bigint,
    LoanNumber_TX  nvarchar(20),
    ValidCode_TX   nvarchar(30),
    Error_Message  nvarchar(250),
    Error_Item     varchar(100),
    Error_Value    varchar(50)
);
	PRINT 'SUCCESS: tgt_LETD_Error created!' 
END
ELSE
BEGIN 
	PRINT 'WARNING: already tgt_LETD_Error exists' 
END

IF EXISTS (select * from sys.tables where name = 'tgt_LETD_Error')
BEGIN
IF NOT EXISTS (select * from sys.tables where name = 'tgt_OETD_Error')
BEGIN
ALTER TABLE tgt_LETD_Error ADD PRIMARY KEY (ID);
END
END
ELSE
BEGIN 
	PRINT 'WARNING: tgt_LETD_Error DOES NOT EXIST' 
END

