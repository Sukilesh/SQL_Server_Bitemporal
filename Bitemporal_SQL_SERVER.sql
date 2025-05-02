CREATE TABLE Employee_Bitemporal (
    EmployeeID     INT PRIMARY KEY,
    Name           NVARCHAR(100),
    Position       NVARCHAR(100),
    Salary         DECIMAL(10, 2),

    -- Valid Time (business/application-defined)
    ValidFrom      DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
    ValidTo        DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL,

    -- System Time (tracked automatically by SQL Server)
    SysStartTime   DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    SysEndTime     DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,

    PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime)
)
WITH (
    SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.Employee_Bitemporal_History)
);




INSERT INTO Employee_Bitemporal (EmployeeID, Name, Position, Salary, ValidFrom, ValidTo)
VALUES (1, 'Alice', 'Analyst', 60000.00, '2023-01-01', '2024-12-31');


-- Update position and salary with a new validity period
UPDATE Employee_Bitemporal
SET Position = 'Senior Analyst',
    Salary = 70000.00,
    ValidFrom = '2025-01-01',
    ValidTo = '9999-12-31'
WHERE EmployeeID = 1;


SELECT *
FROM Employee_Bitemporal
FOR SYSTEM_TIME ALL
WHERE EmployeeID = 1;
