-- =====================================================
-- DATABASE
-- =====================================================
CREATE DATABASE IF NOT EXISTS kai_dw_olap;
USE kai_dw_olap;

-- =====================================================
-- DIMENSION TABLES
-- =====================================================

-- -------------------------
-- DIM_DATE
-- -------------------------
CREATE TABLE DIM_DATE (
    date_id INT PRIMARY KEY,
    date_value DATE NOT NULL,
    day INT,
    month INT,
    quarter INT,
    year INT,
    week_of_year INT,
    is_weekend BOOLEAN
) ENGINE=InnoDB;

-- -------------------------
-- DIM_TRAIN
-- -------------------------
CREATE TABLE DIM_TRAIN (
    train_id INT PRIMARY KEY,
    train_name VARCHAR(100),
    train_type VARCHAR(50),
    capacity INT,
    manufacture_year INT
) ENGINE=InnoDB;

-- -------------------------
-- DIM_STATION
-- -------------------------
CREATE TABLE DIM_STATION (
    station_id INT PRIMARY KEY,
    station_code VARCHAR(10),
    station_name VARCHAR(100),
    city VARCHAR(100),
    region VARCHAR(100)
) ENGINE=InnoDB;

-- -------------------------
-- DIM_ROUTE (Snowflake to Station)
-- -------------------------
CREATE TABLE DIM_ROUTE (
    route_id INT PRIMARY KEY,
    route_name VARCHAR(100),
    origin_station_id INT,
    destination_station_id INT,
    distance_km INT,

    CONSTRAINT fk_dim_route_origin
        FOREIGN KEY (origin_station_id)
        REFERENCES DIM_STATION(station_id),

    CONSTRAINT fk_dim_route_destination
        FOREIGN KEY (destination_station_id)
        REFERENCES DIM_STATION(station_id)
) ENGINE=InnoDB;

-- -------------------------
-- DIM_PASSENGER
-- -------------------------
CREATE TABLE DIM_PASSENGER (
    passenger_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    gender VARCHAR(10),
    age_group VARCHAR(20)
) ENGINE=InnoDB;

-- -------------------------
-- DIM_PAYMENT_METHOD
-- -------------------------
CREATE TABLE DIM_PAYMENT_METHOD (
    payment_method_id INT PRIMARY KEY,
    method_name VARCHAR(50)
) ENGINE=InnoDB;

-- -------------------------
-- DIM_COMPONENT
-- -------------------------
CREATE TABLE DIM_COMPONENT (
    component_id INT AUTO_INCREMENT PRIMARY KEY,
    component_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

-- -------------------------
-- DIM_MAINTENANCE_TYPE
-- -------------------------
CREATE TABLE DIM_MAINTENANCE_TYPE (
    maintenance_type_id INT PRIMARY KEY,
    type_name VARCHAR(50)
) ENGINE=InnoDB;

-- -------------------------
-- DIM_TECHNICIAN
-- -------------------------
CREATE TABLE DIM_TECHNICIAN (
    technician_id INT PRIMARY KEY,
    technician_name VARCHAR(100),
    skill_level VARCHAR(50)
) ENGINE=InnoDB;

-- =====================================================
-- FACT TABLES
-- =====================================================

-- -------------------------
-- FACT_TICKET_SALES
-- -------------------------
CREATE TABLE FACT_TICKET_SALES (
    ticket_sales_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    date_id INT NOT NULL,
    train_id INT NOT NULL,
    route_id INT NOT NULL,
    passenger_id INT NOT NULL,
    payment_method_id INT NOT NULL,
    origin_station_id INT NOT NULL,
    destination_station_id INT NOT NULL,
    ticket_count INT,
    revenue DECIMAL(15,2),

    FOREIGN KEY (date_id) REFERENCES DIM_DATE(date_id),
    FOREIGN KEY (train_id) REFERENCES DIM_TRAIN(train_id),
    FOREIGN KEY (route_id) REFERENCES DIM_ROUTE(route_id),
    FOREIGN KEY (passenger_id) REFERENCES DIM_PASSENGER(passenger_id),
    FOREIGN KEY (payment_method_id) REFERENCES DIM_PAYMENT_METHOD(payment_method_id),
    FOREIGN KEY (origin_station_id) REFERENCES DIM_STATION(station_id),
    FOREIGN KEY (destination_station_id) REFERENCES DIM_STATION(station_id)
) ENGINE=InnoDB;

-- -------------------------
-- FACT_PASSENGER_LOAD
-- -------------------------
CREATE TABLE FACT_PASSENGER_LOAD (
    passenger_load_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    date_id INT NOT NULL,
    train_id INT NOT NULL,
    route_id INT NOT NULL,
    trip_id INT,
    passenger_count INT,
    seat_capacity INT,
    load_factor DECIMAL(5,2),

    FOREIGN KEY (date_id) REFERENCES DIM_DATE(date_id),
    FOREIGN KEY (train_id) REFERENCES DIM_TRAIN(train_id),
    FOREIGN KEY (route_id) REFERENCES DIM_ROUTE(route_id)
) ENGINE=InnoDB;

-- -------------------------
-- FACT_OPERATIONAL_PERFORMANCE
-- -------------------------
CREATE TABLE FACT_OPERATIONAL_PERFORMANCE (
    operational_perf_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    date_id INT NOT NULL,
    train_id INT NOT NULL,
    route_id INT NOT NULL,
    origin_station_id INT NOT NULL,
    destination_station_id INT NOT NULL,
    scheduled_departure DATETIME,
    actual_departure DATETIME,
    scheduled_arrival DATETIME,
    actual_arrival DATETIME,
    departure_delay_minutes INT,
    arrival_delay_minutes INT,
    is_ontime BOOLEAN,

    FOREIGN KEY (date_id) REFERENCES DIM_DATE(date_id),
    FOREIGN KEY (train_id) REFERENCES DIM_TRAIN(train_id),
    FOREIGN KEY (route_id) REFERENCES DIM_ROUTE(route_id),
    FOREIGN KEY (origin_station_id) REFERENCES DIM_STATION(station_id),
    FOREIGN KEY (destination_station_id) REFERENCES DIM_STATION(station_id)
) ENGINE=InnoDB;

-- -------------------------
-- FACT_MAINTENANCE
-- -------------------------
CREATE TABLE FACT_MAINTENANCE (
    maintenance_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    date_id INT NOT NULL,
    train_id INT NOT NULL,
    component_id INT NOT NULL,
    maintenance_type_id INT NOT NULL,
    technician_id INT NOT NULL,
    repair_time_hours DECIMAL(6,2),
    downtime_hours DECIMAL(6,2),
    schedule_status VARCHAR(30),

    FOREIGN KEY (date_id) REFERENCES DIM_DATE(date_id),
    FOREIGN KEY (train_id) REFERENCES DIM_TRAIN(train_id),
    FOREIGN KEY (component_id) REFERENCES DIM_COMPONENT(component_id),
    FOREIGN KEY (maintenance_type_id) REFERENCES DIM_MAINTENANCE_TYPE(maintenance_type_id),
    FOREIGN KEY (technician_id) REFERENCES DIM_TECHNICIAN(technician_id)
) ENGINE=InnoDB;

-- =====================================================
-- INDEXES (DW Query Optimization)
-- =====================================================

CREATE INDEX idx_sales_date ON FACT_TICKET_SALES(date_id);
CREATE INDEX idx_sales_train ON FACT_TICKET_SALES(train_id);
CREATE INDEX idx_sales_route ON FACT_TICKET_SALES(route_id);

CREATE INDEX idx_load_date ON FACT_PASSENGER_LOAD(date_id);
CREATE INDEX idx_load_train ON FACT_PASSENGER_LOAD(train_id);

CREATE INDEX idx_op_date ON FACT_OPERATIONAL_PERFORMANCE(date_id);
CREATE INDEX idx_op_train ON FACT_OPERATIONAL_PERFORMANCE(train_id);

CREATE INDEX idx_maint_date ON FACT_MAINTENANCE(date_id);
CREATE INDEX idx_maint_train ON FACT_MAINTENANCE(train_id);


-- SCD fields for Type 1 & Type 2 dimensions
ALTER TABLE DIM_PASSENGER
ADD effective_date DATE,
ADD end_date DATE,
ADD is_current BOOLEAN;

ALTER TABLE DIM_TECHNICIAN
ADD effective_date DATE,
ADD end_date DATE,
ADD is_current BOOLEAN;

ALTER TABLE DIM_STATION
ADD effective_date DATE,
ADD end_date DATE,
ADD is_current BOOLEAN;

ALTER TABLE DIM_TRAIN
ADD effective_date DATE,
ADD end_date DATE,
ADD is_current BOOLEAN;

ALTER TABLE DIM_ROUTE
ADD effective_date DATE,
ADD end_date DATE,
ADD is_current BOOLEAN;

ALTER TABLE DIM_COMPONENT
ADD effective_date DATE,
ADD end_date DATE,
ADD is_current BOOLEAN;
