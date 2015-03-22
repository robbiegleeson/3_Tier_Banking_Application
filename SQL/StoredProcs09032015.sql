
/* Add USER */
CREATE PROCEDURE [dbo].[spAddUser]
	@UserName NVARCHAR(50),
	@Password NVARCHAR(256),
	@FullName NVARCHAR(50),
	@IsAdmin BIT,
	@UserID INT OUTPUT
AS
	INSERT INTO tblUsers (UserName,
						 UserPassword,
						 FullName,
						 IsAdmin)
	VALUES (@UserName,
			@Password,
			@FullName,
			@IsAdmin)
	SELECT @UserID = @@IDENTITY
GO

/* Change User Password */
CREATE PROCEDURE [dbo].[spChangePassword]
	@OldPassword NVARCHAR(256),
	@NewPassword NVARCHAR(256)
AS
	UPDATE tblUsers
	SET UserPassword = @NewPassword
	WHERE UserPassword = @OldPassword
GO

/* Create ACCOUNT */
CREATE PROCEDURE [dbo].[spCreateAccount]
	@AccountType NVARCHAR(50),
	@SortCode INT,
	@InitialBalance INT,
	@OverDraft INT,
	@CustomerID INT,
	@AccountNumber INT OUTPUT
AS
	INSERT INTO tblAccounts (AccountType,
							 SortCode,
							 Balance,
							 CustomerID,
							 OverDraftLimit)
	VALUES (@AccountType,
			@SortCode,
			@InitialBalance,
			@CustomerID,
			@OverDraft)
	SELECT @AccountNumber = @@IDENTITY
GO

/* Create CustomerID */
CREATE PROCEDURE [dbo].[spCreateCustomer]
	@FirstName NVARCHAR(50),
	@Surname NVARCHAR(50),
	@Email NVARCHAR(50),
	@Phone NVARCHAR(50),
	@AddressLine1 NVARCHAR(50),
	@AddressLine2 NVARCHAR(50),
	@City NVARCHAR(50),
	@County NVARCHAR(50),
	@CustomerID INT OUTPUT,
	@OnlineCustomer BIT
AS
	INSERT INTO tblCustomers (FirstName,
							  Surname,
							  Email,
							  Phone,
							  AddressLine1,
							  AddressLine2,
							  City,
							  County,
							  OnlineCustomer)
	VALUES (@FirstName,
			@Surname,
			@Email,
			@Phone,
			@AddressLine1,
			@AddressLine2,
			@City,
			@County,
			@OnlineCustomer)
	SELECT @CustomerID = /*@@IDENTITY*/ CustomerID FROM tblCustomers
GO

/* SP Deposit  */
CREATE PROC [dbo].[spDeposit]
@CustomerID INTEGER,
@DepositAmount INTEGER,
@NewBalance INTEGER,
@Balance INTEGER
AS
UPDATE tblAccounts
SET Balance = @Balance + @DepositAmount
WHERE CustomerID = @CustomerID

GO

/* SP Deposit Amount  */
CREATE PROC [dbo].[spDepositAmount]
@CustomerID INTEGER,
@DepositAmount INTEGER,
@NewBalance INTEGER,
@Balance INTEGER
AS
UPDATE tblAccounts
SET Balance = @Balance + @DepositAmount
WHERE CustomerID = @CustomerID

GO

/* SP Get Acc Information  */
CREATE PROC [dbo].[spGetAccInformation]
@AccountNumber INTEGER
AS
BEGIN
SET NOCOUNT ON
SELECT
a.AccountType,
a.Balance,
a.OverDraftLimit
FROM
tblAccounts a
WHERE
a.AccountNumber = @AccountNumber
END
GO

/*  SP Get Account Details  */
CREATE PROC [dbo].[spGetAccountDetails]
@CustomerID INTEGER
AS
BEGIN
SET NOCOUNT ON
SELECT
a.FirstName,
a.Surname,
a.Email,
a.Phone,
a.AddressLine1,
a.AddressLine2,
a.City,
a.County
FROM
tblCustomers a
WHERE
a.CustomerID = @CustomerID
END
GO

/* SP Get Customer Information  */
CREATE PROC [dbo].[spGetCustomerInformation]
@CustomerID INTEGER
AS 
BEGIN
SET NOCOUNT ON
SELECT
a.Firstname,
a.Surname,
a.Email,
a.Phone,
a.AddressLine1,
a.AddressLine2,
a.City,
County
FROM 
tblCustomers a
WHERE
a.CustomerID = @CustomerID
END

GO

/*  SP Get Details for Main Grid  */
CREATE PROC [dbo].[spGetDetailsForMainGrid]
AS
BEGIN
SELECT * FROM
tblCustomers
INNER JOIN tblAccounts
ON tblCustomers.CustomerID = tblAccounts.CustomerID
END

GO

/*  SP Load View Customer  */
	CREATE PROC [dbo].[spLoadViewCustomer]
	@AccountNumber INTEGER
	AS 
	BEGIN
	SET NOCOUNT ON
	SELECT Firstname, Surname, Email, Phone, AddressLine1, AddressLine2, City, County, AccountType, Balance, AccountNumber
	FROM
	tblCustomers
	INNER JOIN
	tblAccounts
	ON
	tblCustomers.CustomerID = tblAccounts.CustomerID
	WHERE
	@AccountNumber = AccountNumber 
	END
	GO

/*  SP Record Transaction  */
CREATE PROCEDURE [dbo].[spRecordTransaction]
	@TransactionType NVARCHAR(50),
	@Amount INT,
	@TransactionDate DATETIME,
	@Description NVARCHAR(256),
	@Reference NVARCHAR(50),
	@DestinationAccount INT,
	@DestinationSortCode INT,
	@AccountNumber INT
AS
	INSERT INTO tblTransactions(TransactionType,
								Amount,
								TransactionDate,
								TransactionDescription,
								TransactionReference,
								DestinationAccount,
								DestinationSortCode,
								AccountNumber)
	VALUES (@TransactionType,
			@Amount,
			@TransactionDate,
			@Description,
			@Reference,
			@DestinationAccount,
			@DestinationSortCode,
			@AccountNumber)
	IF @TransactionType = 'Deposit'
	UPDATE tblAccounts
	SET Balance = Balance + @Amount

	ELSE IF @TransactionType = 'Withdrawl'
	UPDATE tblAccounts
	SET Balance = Balance - @Amount

	ELSE IF @TransactionType = 'Transfer'
	UPDATE tblAccounts
	SET Balance = Balance - @Amount
	WHERE AccountNumber = @AccountNumber
	UPDATE tblAccounts
	SET Balance = Balance + @Amount
	WHERE AccountNumber = @DestinationAccount

GO

/*  SP Update Balance  */
CREATE PROC [dbo].[spUpdateBalance]
@CustomerID INTEGER,
@Balance INTEGER
AS
BEGIN
SET NOCOUNT ON
UPDATE
tblAccounts
SET Balance = @Balance
WHERE
CustomerID = @CustomerID
END

GO

/*  SP User Login  */
CREATE PROCEDURE [dbo].[spUserLogin]
	@UserName NVARCHAR(50),
	@Password NVARCHAR(256),
	@LastLogin DATETIME,
	@IsAdmin BIT OUTPUT
AS
	UPDATE tblUsers
	SET LastLogin = @LastLogin
	WHERE UserName = @UserName AND UserPassword = @Password
	SELECT @IsAdmin = IsAdmin FROM tblUsers
	WHERE UserName = @UserName AND UserPassword = @Password

GO

/*  SP View TRANSACTION  */

CREATE PROCEDURE [dbo].[spViewTransactions]
	@AccountNumber INT
AS
	SELECT * FROM tblTransactions
	WHERE AccountNumber = @AccountNumber

GO