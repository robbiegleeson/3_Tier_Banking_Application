CREATE PROCEDURE spUserLogin
	@UserName NVARCHAR(50),
	@Password NVARCHAR(256),
	@LastLogin DATETIME,
	@IsAdmin BIT OUTPUT
AS
	UPDATE tblUsers
	SET LastLogin = @LastLogin
	WHERE UserName = @UserName AND UserPassword = @Password
	SELECT IsAdmin = @IsAdmin FROM tblUsers
	WHERE UserName = @UserName AND UserPassword = @Password
GO
------------------------------------------------------------
CREATE PROCEDURE spViewTransactions
	@AccountNumber INT
AS
	SELECT * FROM tblTransactions
	WHERE AccountNumber = @AccountNumber
GO

------------------------------------------------------------

CREATE PROCEDURE spAddUser
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

------------------------------------------------------------

CREATE PROCEDURE spChangePassword
	@OldPassword NVARCHAR(256),
	@NewPassword NVARCHAR(256)
AS
	UPDATE tblUsers
	SET UserPassword = @NewPassword
	WHERE UserPassword = @OldPassword
GO

------------------------------------------------------------

CREATE PROCEDURE spGetCustomerInformation
	@CustomerNumber INT
AS
	SELECT * FROM tblCustomers
	WHERE @CustomerNumber = /*@@IDENTITY*/ CustomerID
GO

------------------------------------------------------------

CREATE PROCEDURE spCreateCustomer
	@FirstName NVARCHAR(50),
	@Surname NVARCHAR(50),
	@Email NVARCHAR(50),
	@Phone NVARCHAR(50),
	@AddressLine1 NVARCHAR(50),
	@AddressLine2 NVARCHAR(50),
	@City NVARCHAR(50),
	@County NVARCHAR(50),
	@CustomerID INT OUTPUT
AS
	INSERT INTO tblCustomers (FirstName,
							  Surname,
							  Email,
							  Phone,
							  AddressLine1,
							  AddressLine2,
							  City,
							  County)
	VALUES (@FirstName,
			@Surname,
			@Email,
			@Phone,
			@AddressLine1,
			@AddressLine2,
			@City,
			@County)
	SELECT @CustomerID = /*@@IDENTITY*/ CustomerID FROM tblCustomers
GO

------------------------------------------------------------

CREATE PROCEDURE spRecordTransaction
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

------------------------------------------------------------

CREATE PROCEDURE spCreateAccount
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