CREATE TABLE [Clients] (
  [Id] INT IDENTITY(1,1) PRIMARY KEY,
  [OrganisationNumber] VARCHAR(20) NOT NULL UNIQUE,
  [CompanyName] NVARCHAR(120) NOT NULL,
  [Email] NVARCHAR(200) NOT NULL,
  [PhoneNumber] VARCHAR(20) NOT NULL
);

CREATE TABLE [Projects] (
    [Id] INT IDENTITY(1,1) PRIMARY KEY,
    [ClientId] INT NOT NULL REFERENCES [Clients]([Id]),
    [ProjectName] NVARCHAR(120) NOT NULL
);

CREATE TABLE [Consultants] (
    [Id] INT IDENTITY(1,1) PRIMARY KEY,
    [SocialSecurityNumber] VARCHAR(20) NOT NULL UNIQUE,
    [FirstName] NVARCHAR(40) NOT NULL,
    [LastName] NVARCHAR(40) NOT NULL,
    [HourlyRate] DECIMAL(7,2) NOT NULL,
    [Speciality] NVARCHAR(100) NOT NULL
);

CREATE TABLE [Assignments] (
    [Id] INT IDENTITY(1,1) PRIMARY KEY,
    [ConsultantId] INT NOT NULL REFERENCES [Consultants]([Id]),
    [ProjectId] INT NOT NULL REFERENCES [Projects]([Id]),
    [StartDate] DATETIME2 NOT NULL,
    [EndDate] DATETIME2 NOT NULL,
    [RoleDescription] NVARCHAR(120) NOT NULL
);

INSERT INTO [Clients] ([OrganisationNumber], [CompanyName], [Email], [PhoneNumber])
VALUES ('556000-0000', N'White Wolf Security AB', N'info@geralt.whitewolf.com', '08-000 00 00');

INSERT INTO [Clients] ([OrganisationNumber], [CompanyName], [Email], [PhoneNumber])
VALUES
    ('556000-1000', N'Yennefer Consulting AB', N'info@yennefer.consulting.com', '08-100 00 00'),
    ('556000-2000', N'Dandelion Digital AB', N'info@dandelion.digital.com', '08-200 00 00');

INSERT INTO [Consultants] ([SocialSecurityNumber], [FirstName], [LastName], [HourlyRate], [Speciality])
VALUES
    ('881203-4324', N'Gale', N'of Waterdeep', 1450.00, N'Cloud Architecture'),
    ('901021-5178', N'Astarion', N'Ancunín', 1200.00, N'Penetration Testing'),
    ('820614-7633', N'Halsin', N'the Archdruid', 1100.00, N'Cybersecurity');

INSERT INTO [Projects] ([ClientId], [ProjectName])
VALUES
    (
        (SELECT [Id] FROM [Clients] WHERE [OrganisationNumber] = '556000-0000'),
        N'API Security Review'
    ),
    (
        (SELECT [Id] FROM [Clients] WHERE [OrganisationNumber] = '556000-1000'),
        N'Cloud Migration'
    );

DECLARE @Today DATE = CAST(GETDATE() AS DATE);

INSERT INTO [Assignments] ([ConsultantId], [ProjectId], [StartDate], [EndDate], [RoleDescription])
VALUES
    (
        (SELECT [Id] FROM [Consultants] WHERE [SocialSecurityNumber] = '881203-4324'),
        (SELECT [Id] FROM [Projects] WHERE [ProjectName] = N'API Security Review'),
        DATEADD(day, -7, @Today),
        DATEADD(day, 14, @Today),
        N'Review the API architecture'
    ),
    (
        (SELECT [Id] FROM [Consultants] WHERE [SocialSecurityNumber] = '901021-5178'),
        (SELECT [Id] FROM [Projects] WHERE [ProjectName] = N'API Security Review'),
        DATEADD(day, -5, @Today),
        DATEADD(day, 10, @Today),
        N'Test API access controls'
    ),
    (
        (SELECT [Id] FROM [Consultants] WHERE [SocialSecurityNumber] = '820614-7633'),
        (SELECT [Id] FROM [Projects] WHERE [ProjectName] = N'API Security Review'),
        DATEADD(day, -30, @Today),
        DATEADD(day, -10, @Today),
        N'Review API security logs'
    ),
    (
        (SELECT [Id] FROM [Consultants] WHERE [SocialSecurityNumber] = '820614-7633'),
        (SELECT [Id] FROM [Projects] WHERE [ProjectName] = N'Cloud Migration'),
        DATEADD(day, -3, @Today),
        DATEADD(day, 21, @Today),
        N'Review cloud security settings'
    ),
    (
        (SELECT [Id] FROM [Consultants] WHERE [SocialSecurityNumber] = '881203-4324'),
        (SELECT [Id] FROM [Projects] WHERE [ProjectName] = N'Cloud Migration'),
        DATEADD(day, 7, @Today),
        DATEADD(day, 35, @Today),
        N'Design the cloud architecture'
    );

-- Query A

SELECT [FirstName], [LastName], [HourlyRate]
FROM [Consultants]
WHERE [HourlyRate] > 1200
ORDER BY [HourlyRate] DESC;

-- Query B
SELECT c.[CompanyName], co.[FirstName], co.[LastName], a.[StartDate], a.[EndDate]
FROM [Assignments] AS a
JOIN [Consultants] AS co ON a.[ConsultantId] = co.[Id]
JOIN [Projects] AS p ON a.[ProjectId] = p.[Id]
JOIN [Clients] AS c ON p.[ClientId] = c.[Id];

-- Query C
SELECT c.[CompanyName], COUNT(a.[Id]) AS [ActiveAssignments]
FROM [Clients] AS c
LEFT JOIN [Projects] AS p ON p.[ClientId] = c.[Id]
LEFT JOIN [Assignments] AS a ON a.[ProjectId] = p.[Id]
    AND CAST(GETDATE() AS DATE) BETWEEN CAST(a.[StartDate] AS DATE)
                                   AND CAST(a.[EndDate] AS DATE)
GROUP BY c.[Id], c.[CompanyName];

-- Query D
UPDATE [Consultants]
SET [HourlyRate] = 1300.00
WHERE [SocialSecurityNumber] = '901021-5178';

-- Query E
-- Delete the selected client only if they have no projects.
-- This guarantees they have no active assignments and preserves project history.
DELETE c
FROM [Clients] AS c
WHERE c.[OrganisationNumber] = '556000-2000'
  AND NOT EXISTS (
      SELECT 1
      FROM [Projects] AS p
      WHERE p.[ClientId] = c.[Id]
  );