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
    train_sk INT AUTO_INCREMENT PRIMARY KEY,
    train_id INT NOT NULL, 
    train_name VARCHAR(100),
    train_type VARCHAR(50),
    capacity INT,
    manufacture_year INT,
    effective_date DATE,
    end_date DATE,
    is_current BOOLEAN
) ENGINE=InnoDB;

-- -------------------------
-- DIM_STATION
-- -------------------------
CREATE TABLE DIM_STATION (
    station_sk INT AUTO_INCREMENT PRIMARY KEY,
    station_id INT,
    station_code VARCHAR(10),
    station_name VARCHAR(100),
    city VARCHAR(100),
    region VARCHAR(100)
) ENGINE=InnoDB;

-- -------------------------
-- DIM_ROUTE
-- -------------------------
CREATE TABLE DIM_ROUTE (
    route_sk INT AUTO_INCREMENT PRIMARY KEY,
    route_id INT,
    route_name VARCHAR(100),
    origin_station_name VARCHAR(100),
    origin_city VARCHAR(100),
    destination_station_name VARCHAR(100),
    destination_city VARCHAR(100),
    distance_km INT,
    effective_date DATE,
    end_date DATE,
    is_current BOOLEAN
) ENGINE=InnoDB;

-- -------------------------
-- DIM_PASSENGER
-- -------------------------
CREATE TABLE DIM_PASSENGER (
    passenger_sk INT AUTO_INCREMENT PRIMARY KEY,
    passenger_id INT,
    full_name VARCHAR(100),
    phone VARCHAR(20),
    gender VARCHAR(10),
    age INT
) ENGINE=InnoDB;

-- -------------------------
-- DIM_PAYMENT_METHOD
-- -------------------------
CREATE TABLE DIM_PAYMENT_METHOD (
    payment_method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(50)
) ENGINE=InnoDB;

-- -------------------------
-- DIM_COMPONENT
-- -------------------------
CREATE TABLE DIM_COMPONENT (
    component_sk INT AUTO_INCREMENT PRIMARY KEY,
    component_id INT,
    component_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    effective_date DATE,
    end_date DATE,
    is_current BOOLEAN
) ENGINE=InnoDB;

-- -------------------------
-- DIM_MAINTENANCE_TYPE
-- -------------------------
CREATE TABLE DIM_MAINTENANCE_TYPE (
    maintenance_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50)
) ENGINE=InnoDB;

-- -------------------------
-- DIM_TECHNICIAN
-- -------------------------
CREATE TABLE DIM_TECHNICIAN (
    technician_sk INT AUTO_INCREMENT PRIMARY KEY,
    technician_id INT,
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
    train_sk INT NOT NULL,
    route_sk INT NOT NULL,
    passenger_sk INT NOT NULL,
    payment_method_id INT NOT NULL,
    origin_station_sk INT NOT NULL,
    destination_station_sk INT NOT NULL,
    ticket_count INT,
    revenue DECIMAL(15,2),

    FOREIGN KEY (date_id) REFERENCES DIM_DATE(date_id),
    FOREIGN KEY (train_sk) REFERENCES DIM_TRAIN(train_sk),
    FOREIGN KEY (route_sk) REFERENCES DIM_ROUTE(route_sk),
    FOREIGN KEY (passenger_sk) REFERENCES DIM_PASSENGER(passenger_sk),
    FOREIGN KEY (payment_method_id) REFERENCES DIM_PAYMENT_METHOD(payment_method_id),
    FOREIGN KEY (origin_station_sk) REFERENCES DIM_STATION(station_sk),
    FOREIGN KEY (destination_station_sk) REFERENCES DIM_STATION(station_sk)
) ENGINE=InnoDB;

-- -------------------------
-- FACT_PASSENGER_LOAD
-- -------------------------
CREATE TABLE FACT_PASSENGER_LOAD (
    passenger_load_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    date_id INT NOT NULL,
    train_sk INT NOT NULL,
    route_sk INT NOT NULL,
    trip_id INT,
    passenger_count INT,
    seat_capacity INT,
    load_factor DECIMAL(5,2),

    FOREIGN KEY (date_id) REFERENCES DIM_DATE(date_id),
    FOREIGN KEY (train_sk) REFERENCES DIM_TRAIN(train_sk),
    FOREIGN KEY (route_sk) REFERENCES DIM_ROUTE(route_sk)
) ENGINE=InnoDB;

-- -------------------------
-- FACT_OPERATIONAL_PERFORMANCE
-- -------------------------
CREATE TABLE FACT_OPERATIONAL_PERFORMANCE (
    operational_perf_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    date_id INT NOT NULL,
    train_sk INT NOT NULL,
    route_sk INT NOT NULL,
    origin_station_sk INT NOT NULL,
    destination_station_sk INT NOT NULL,
    scheduled_departure DATETIME,
    actual_departure DATETIME,
    scheduled_arrival DATETIME,
    actual_arrival DATETIME,
    departure_delay_minutes INT,
    arrival_delay_minutes INT,
    is_ontime BOOLEAN,

    FOREIGN KEY (date_id) REFERENCES DIM_DATE(date_id),
    FOREIGN KEY (train_sk) REFERENCES DIM_TRAIN(train_sk),
    FOREIGN KEY (route_sk) REFERENCES DIM_ROUTE(route_sk),
    FOREIGN KEY (origin_station_sk) REFERENCES DIM_STATION(station_sk),
    FOREIGN KEY (destination_station_sk) REFERENCES DIM_STATION(station_sk)
) ENGINE=InnoDB;

-- -------------------------
-- FACT_MAINTENANCE
-- -------------------------
CREATE TABLE FACT_MAINTENANCE (
    maintenance_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    date_id INT NOT NULL,
    train_sk INT NOT NULL,
    component_sk INT NOT NULL,
    maintenance_type_id INT NOT NULL,
    technician_sk INT NOT NULL,
    repair_time_hours DECIMAL(6,2),
    downtime_hours DECIMAL(6,2),
    schedule_status VARCHAR(30),

    FOREIGN KEY (date_id) REFERENCES DIM_DATE(date_id),
    FOREIGN KEY (train_sk) REFERENCES DIM_TRAIN(train_sk),
    FOREIGN KEY (component_sk) REFERENCES DIM_COMPONENT(component_sk),
    FOREIGN KEY (maintenance_type_id) REFERENCES DIM_MAINTENANCE_TYPE(maintenance_type_id),
    FOREIGN KEY (technician_sk) REFERENCES DIM_TECHNICIAN(technician_sk)
) ENGINE=InnoDB;

-- =====================================================
-- INDEXES (DW Query Optimization)
-- =====================================================

CREATE INDEX idx_sales_date ON FACT_TICKET_SALES(date_id);
CREATE INDEX idx_sales_train ON FACT_TICKET_SALES(train_sk);
CREATE INDEX idx_sales_route ON FACT_TICKET_SALES(route_sk);

CREATE INDEX idx_load_date ON FACT_PASSENGER_LOAD(date_id);
CREATE INDEX idx_load_train ON FACT_PASSENGER_LOAD(train_sk);

CREATE INDEX idx_op_date ON FACT_OPERATIONAL_PERFORMANCE(date_id);
CREATE INDEX idx_op_train ON FACT_OPERATIONAL_PERFORMANCE(train_sk);

CREATE INDEX idx_maint_date ON FACT_MAINTENANCE(date_id);
CREATE INDEX idx_maint_train ON FACT_MAINTENANCE(train_sk);
