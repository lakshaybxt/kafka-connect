-- Creation of the database and tables
CREATE DATABASE IF NOT EXISTS kafka_db;

USE kafka_db;

CREATE TABLE customers (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert initial data
INSERT INTO customers (first_name, last_name, email) VALUES
('John', 'Doe', 'john.doe@example.com'),
('Jane', 'Smith', 'jane.smith@example.com'),
('Robert', 'Johnson', 'robert.johnson@example.com');

-- Removes the user if it already exists (to recreate it with the correct settings)
DROP USER IF EXISTS 'kafka'@'%';

-- Create user with mysql_native_password authentication (most compatible)
CREATE USER 'kafka'@'%' IDENTIFIED WITH mysql_native_password BY 'kafka';

-- Grants the allowed permissions (fixed syntax)
GRANT RELOAD, REPLICATION CLIENT, REPLICATION SLAVE ON *.* TO 'kafka'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON kafka_db.* TO 'kafka'@'%';
FLUSH PRIVILEGES;
