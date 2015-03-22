CREATE TABLE tblWithdrawTransactions
(
TransactionID INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
TransactionType NVARCHAR(50),
WithdrawTransactionAmount INT,
TransactionTime DATETIME,
WithdrawTransactionReference NVARCHAR(50),
AccountNumber INT,
TransactionWithdrawDescription NVARCHAR(100)
)

CREATE PROC spWithdrawTransaction
@TransactionID INT OUTPUT,
@TransactionType NVARCHAR(50),
@WithdrawTransactionAmount INT,
@TransactionTime DATETIME,
@WithdrawTransactionReference NVARCHAR(50),
@AccountNumber INT,
@TransactionWithdrawDescription NVARCHAR(100)
AS
BEGIN
INSERT INTO tblWithdrawTransactions
(
TransactionType, 
WithdrawTransactionAmount,
TransactionTime,
WithdrawTransactionReference,
AccountNumber,
TransactionWithdrawDescription
)
VALUES
(
@TransactionType,
@WithdrawTransactionAmount,
@TransactionTime,
@WithdrawTransactionReference,
@AccountNumber,
@TransactionWithdrawDescription
)
SELECT @TransactionID = TransactionID FROM tblTransactions
END

GO


USE [DBSCreditUnion]
GO

/****** Object:  StoredProcedure [dbo].[spDepositTransaction]    Script Date: 09/03/2015 19:47:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*  Insert Into Deposit Transaction Table  */
CREATE TABLE tblDepositTransactions
(
TransactionID INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
TransactionType NVARCHAR(50),
DepositTransactionAmount INT,
TransactionTime DATETIME,
DepositTransactionReference NVARCHAR(50),
AccountNumber INT,
TransactionDepositDescription NVARCHAR(100)
)



CREATE PROC [dbo].[spDepositTransaction]
@TransactionID INT OUTPUT,
@TransactionType NVARCHAR(50),
@DepositTransactionAmount INT,
@TransactionTime DATETIME,
@DepositTransactionReference NVARCHAR(50),
@AccountNumber INT,
@TransactionDepositDescription NVARCHAR(100)
AS
BEGIN
INSERT INTO tblDepositTransactions
(
TransactionType, 
DepositTransactionAmount,
TransactionTime,
DepositTransactionReference,
AccountNumber,
TransactionDepositDescription
)
VALUES
(
@TransactionType,
@DepositTransactionAmount,
@TransactionTime,
@DepositTransactionReference,
@AccountNumber,
@TransactionDepositDescription
)
SELECT @TransactionID = TransactionID FROM tblTransactions
END

GO

CREATE TABLE tblTransferTransactions
(
TransactionID INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
TransactionType NVARCHAR(50),
TransferTransactionAmount INT,
TransactionTime DATETIME,
TransferTransactionReference NVARCHAR(50),
AccountNumber INT,
DestinationAccountNumber INT,
TransactionTransferDescription NVARCHAR(100)
)


CREATE PROC [dbo].[spTransferTransaction]
@TransactionID INT OUTPUT,
@TransactionType NVARCHAR(50),
@TransferTransactionAmount INT,
@TransactionTime DATETIME,
@TransferTransactionReference NVARCHAR(50),
@AccountNumber INT,
@DestinationAccountNumber INT,
@TransactionTransferDescription NVARCHAR(100)
AS
BEGIN
INSERT INTO tblTransferTransactions
(
TransactionType, 
TransferTransactionAmount,
TransactionTime,
TransferTransactionReference,
AccountNumber,
DestinationAccountNumber,
TransactionTransferDescription
)
VALUES
(
@TransactionType,
@TransferTransactionAmount,
@TransactionTime,
@TransferTransactionReference,
@AccountNumber,
@DestinationAccountNumber,
@TransactionTransferDescription
)
SELECT @TransactionID = TransactionID FROM tblTransactions
END

GO