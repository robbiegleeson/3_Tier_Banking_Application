CREATE TABLE tblUsers(
	UserID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	UserName NVARCHAR(50) NOT NULL,
	UserPassword NVARCHAR(256) NOT NULL,
	FullName NVARCHAR(50) NOT NULL,
	IsAdmin BIT NOT NULL,
	LastLogin DATETIME
)

CREATE TABLE tblCustomers(
	CustomerID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	FirstName NVARCHAR(50) NOT NULL,
	Surname NVARCHAR(50) NOT NULL,
	Email NVARCHAR(50) NOT NULL,
	Phone NVARCHAR(50) NOT NULL,
	AddressLine1 NVARCHAR(50) NOT NULL,
	AddressLine2 NVARCHAR(50),
	City NVARCHAR(50) NOT NULL,
	County NVARCHAR(50) NOT NULL,
	OnlineCustomer BIT NOT NULL,
	UserName NVARCHAR(50),
	CustomerPassword NVARCHAR(256)
)

CREATE TABLE tblAccounts(
	AccountNumber INT NOT NULL IDENTITY(10000000,1) PRIMARY KEY,
	AccountType NVARCHAR(50) NOT NULL,
	SortCode INT NOT NULL,
	Balance INT NOT NULL,
	CustomerID INT NOT NULL,
	CONSTRAINT FK_CustomersAccount FOREIGN KEY (CustomerID) REFERENCES tblCustomers(CustomerID)
)

CREATE TABLE tblTransactions(
	TransactionID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	TransactionType NVARCHAR(50) NOT NULL,
	Amount INT NOT NULL,
	TransactionDate DATETIME NOT NULL,
	TransactionDescription NVARCHAR(256) NOT NULL,
	TransactionReference NVARCHAR(50) NOT NULL,
	DestinationAccount INT NOT NULL,
	DestinationSortCode INT NOT NULL,
	AccountNumber INT NOT NULL,
	CONSTRAINT FK_AccountTransactions FOREIGN KEY (AccountNumber) REFERENCES tblAccounts(AccountNumber)
)