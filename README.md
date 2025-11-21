# kafka-connect

## Overview
This project demonstrates a complete CDC (Change Data Capture) data pipeline using Kafka Connect.
Data flows from MySQL → Kafka Topics → PostgreSQL using Debezium MySQL Source Connector and JDBC Sink Connector.
The setup runs entirely using Docker.

## Architecture
MySQL → Kafka Connect (Source) → Kafka Topics → Kafka Connect (Sink) → PostgreSQL

## Folder Structure
kafka-connect/
├── docker-compose.yml
├── connectors/
│   ├── mysql-source.json
│   └── postgres-sink.json
├── README.md

## How to Run

### Start Docker
docker compose up -d --build

### Register the Connectors (wait ~1 minute)

#### MySQL Source Connector
curl -X POST -H "Content-Type: application/json" \
  --data @connectors/mysql-source.json \
  http://localhost:8083/connectors

#### Postgres Sink Connector
curl -X POST -H "Content-Type: application/json" \
  --data @connectors/postgres-sink.json \
  http://localhost:8083/connectors

## Check Status

#### MySQL Source Status
curl -X GET http://localhost:8083/connectors/mysql-source-connector/status

#### Postgres Sink Status
curl -X GET http://localhost:8083/connectors/postgres-sink-connector/status

#### Expected Output
{"name":"mysql-source-connector","connector":{"state":"RUNNING","worker_id":"kafka-connect:8083"},"tasks":[{"id":0,"state":"RUNNING","worker_id":"kafka-connect:8083"}],"type":"source"}

{"name":"postgres-sink-connector","connector":{"state":"RUNNING","worker_id":"kafka-connect:8083"},"tasks":[{"id":0,"state":"RUNNING","worker_id":"kafka-connect:8083"}],"type":"sink"}

### Insert new data into MySQL
docker exec -it mysql mysql -u root -prootpass \
  -e "USE kafka_db; INSERT INTO customers (first_name, last_name, email) VALUES ('Novo', 'Cliente', 'novo@example.com');"

### Verify data in PostgreSQL
docker exec -it postgres psql -U kafka -d kafka_db \
  -c "SELECT * FROM customers;"

#### Expected Output
 id | first_name | last_name |           email            |      created_at      
----+------------+-----------+----------------------------+----------------------
  1 | John       | Doe       | john.doe@example.com       | 2025-04-19T20:40:15Z
  2 | Jane       | Smith     | jane.smith@example.com     | 2025-04-19T20:40:15Z
  3 | Robert     | Johnson   | robert.johnson@example.com | 2025-04-19T20:40:15Z
  4 | Novo       | Cliente   | novo@example.com           | 2025-04-19T20:42:16Z
(4 rows)
