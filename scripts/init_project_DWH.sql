/*
  Script Name: Reset and Initialize DataWarehouse Database

  Description:
  This script checks if a database named 'DataWarehouse' already exists. 
  If it does, the script sets the database to SINGLE_USER mode with immediate rollback 
  to terminate all existing connections, and then drops the database. 
  It subsequently creates a fresh 'DataWarehouse' database and initializes three schemas 
  commonly used in a medallion architecture: 'bronze', 'silver', and 'gold'.

  Usage:
  - Run this script in a SQL Server environment (e.g., SSMS).
  - Intended for development or testing environments where a clean 
    setup of the DataWarehouse is needed.

  Notes:
  - Be cautious when running this in production, as it irreversibly deletes the existing database.
  - Ensure proper permissions to drop and create databases.

  Author: Nancy N.
  Date: 2025-04-22
*/

IF EXISTS (SELECT 1 FROM sys.database WHERE name='DataWarehouse')
BEGIN
  ALTER DATABESE DataWarehouse SET SINGLE_USER WIRH ROLLBACK IMMEDIATE;
  DROP DATABASE DataWarehouse;
END;

--Create Database
GO
CREATE DATABASE DataWarehouse;
GO
USE DataWarehouse;
GO

  --- Create Schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
