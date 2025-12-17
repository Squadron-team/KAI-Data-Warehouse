-- =====================================================
-- Database
-- =====================================================
CREATE DATABASE IF NOT EXISTS kai_dw_oltp;
USE kai_dw_oltp;

-- =====================================================
-- TRAIN
-- =====================================================
CREATE TABLE TRAIN (
    train_id INT AUTO_INCREMENT PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    train_type VARCHAR(50) NOT NULL,
    capacity INT NOT NULL,
    manufacture_year INT
) ENGINE=InnoDB;

-- =====================================================
-- STATION
-- =====================================================
CREATE TABLE STATION (
    station_id INT AUTO_INCREMENT PRIMARY KEY,
    station_code VARCHAR(10) NOT NULL UNIQUE,
    station_name VARCHAR(100) NOT NULL,
    city VARCHAR(100),
    region VARCHAR(100)
) ENGINE=InnoDB;

-- =====================================================
-- ROUTE
-- =====================================================
CREATE TABLE ROUTE (
    route_id INT AUTO_INCREMENT PRIMARY KEY,
    route_name VARCHAR(100) NOT NULL,
    origin_station_id INT NOT NULL,
    destination_station_id INT NOT NULL,
    distance_km INT,

    CONSTRAINT fk_route_origin
        FOREIGN KEY (origin_station_id)
        REFERENCES STATION(station_id),

    CONSTRAINT fk_route_destination
        FOREIGN KEY (destination_station_id)
        REFERENCES STATION(station_id)
) ENGINE=InnoDB;

-- =====================================================
-- TRAIN_SCHEDULE
-- =====================================================
CREATE TABLE TRAIN_SCHEDULE (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    train_id INT NOT NULL,
    route_id INT NOT NULL,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,

    CONSTRAINT fk_schedule_train
        FOREIGN KEY (train_id)
        REFERENCES TRAIN(train_id),

    CONSTRAINT fk_schedule_route
        FOREIGN KEY (route_id)
        REFERENCES ROUTE(route_id)
) ENGINE=InnoDB;

-- =====================================================
-- TRIP
-- =====================================================
CREATE TABLE TRIP (
    trip_id INT AUTO_INCREMENT PRIMARY KEY,
    schedule_id INT NOT NULL,
    actual_departure DATETIME,
    actual_arrival DATETIME,
    delay_minutes INT DEFAULT 0,
    status VARCHAR(30),

    CONSTRAINT fk_trip_schedule
        FOREIGN KEY (schedule_id)
        REFERENCES TRAIN_SCHEDULE(schedule_id)
) ENGINE=InnoDB;

-- =====================================================
-- PASSENGER
-- =====================================================
CREATE TABLE PASSENGER (
    passenger_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    gender VARCHAR(10),
    age INT
) ENGINE=InnoDB;

-- =====================================================
-- TICKET
-- =====================================================
CREATE TABLE TICKET (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    trip_id INT NOT NULL,
    passenger_id INT NOT NULL,
    purchase_time DATETIME NOT NULL,
    seat_number VARCHAR(10),
    price DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50),
    status VARCHAR(30),

    CONSTRAINT fk_ticket_trip
        FOREIGN KEY (trip_id)
        REFERENCES TRIP(trip_id),

    CONSTRAINT fk_ticket_passenger
        FOREIGN KEY (passenger_id)
        REFERENCES PASSENGER(passenger_id)
) ENGINE=InnoDB;

-- =====================================================
-- MAINTENANCE
-- =====================================================
CREATE TABLE MAINTENANCE (
    maintenance_id INT AUTO_INCREMENT PRIMARY KEY,
    train_id INT NOT NULL,
    maintenance_date DATETIME NOT NULL,
    maintenance_type VARCHAR(50) NOT NULL,
    component_name VARCHAR(100) NOT NULL,
    component_category VARCHAR(50) NOT NULL,
    technician_name VARCHAR(100) NOT NULL,

    description TEXT,

    CONSTRAINT fk_maintenance_train
        FOREIGN KEY (train_id)
        REFERENCES TRAIN(train_id)
) ENGINE=InnoDB;


-- =====================================================
-- Indexes for Performance (OLTP-friendly)
-- =====================================================
CREATE INDEX idx_route_origin ON ROUTE(origin_station_id);
CREATE INDEX idx_route_destination ON ROUTE(destination_station_id);

CREATE INDEX idx_schedule_train ON TRAIN_SCHEDULE(train_id);
CREATE INDEX idx_schedule_route ON TRAIN_SCHEDULE(route_id);

CREATE INDEX idx_trip_schedule ON TRIP(schedule_id);

CREATE INDEX idx_ticket_trip ON TICKET(trip_id);
CREATE INDEX idx_ticket_passenger ON TICKET(passenger_id);

CREATE INDEX idx_maintenance_train ON MAINTENANCE(train_id);
