-- -------------------------
-- DIM_DATE
-- -------------------------

INSERT INTO DIM_DATE
VALUES
    (20250101, '2025-01-01', 1, 1, 1, 2025, 1, TRUE),
    (20250102, '2025-01-02', 2, 1, 1, 2025, 1, FALSE),
    (20250103, '2025-01-03', 3, 1, 1, 2025, 1, FALSE),
    (20250104, '2025-01-04', 4, 1, 1, 2025, 1, TRUE),
    (20250105, '2025-01-05', 5, 1, 1, 2025, 1, TRUE),
    (20250106, '2025-01-06', 6, 1, 1, 2025, 2, FALSE),
    (20250107, '2025-01-07', 7, 1, 1, 2025, 2, FALSE),
    (20250108, '2025-01-08', 8, 1, 1, 2025, 2, FALSE),
    (20250109, '2025-01-09', 9, 1, 1, 2025, 2, FALSE),
    (20250110, '2025-01-10', 10, 1, 1, 2025, 2, FALSE),
    (20250111, '2025-01-11', 11, 1, 1, 2025, 2, TRUE),
    (20250112, '2025-01-12', 12, 1, 1, 2025, 2, TRUE);



-- -------------------------
-- DIM_PASSENGERS
-- -------------------------

INSERT INTO DIM_PASSENGER
    (
    passenger_id, full_name, gender, age_group,
    effective_date, end_date, is_current
    )
VALUES
    (1, 'Ahmad Pratama', 'Male', 'Adult', '2024-01-01', NULL, TRUE),
    (2, 'Siti Nurhaliza', 'Female', 'Adult', '2024-01-01', NULL, TRUE),
    (3, 'Budi Santoso', 'Male', 'Senior', '2024-01-01', NULL, TRUE),
    (4, 'Dewi Lestari', 'Female', 'Adult', '2024-01-01', NULL, TRUE),
    (5, 'Rizky Ramadhan', 'Male', 'Youth', '2024-01-01', NULL, TRUE),
    (6, 'Sri Wahyuni', 'Female', 'Senior', '2024-01-01', NULL, TRUE);


-- -------------------------
-- DIM_TECHNICIANS
-- -------------------------

INSERT INTO DIM_TECHNICIAN
    (
    technician_id, technician_name, skill_level,
    effective_date, end_date, is_current
    )
VALUES
    (1, 'Agus Setiawan', 'Senior', '2019-01-01', NULL, TRUE),
    (2, 'Rudi Hartono', 'Junior', '2021-01-01', NULL, TRUE),
    (3, 'Hendra Saputra', 'Senior', '2018-01-01', NULL, TRUE),
    (4, 'Fajar Nugroho', 'Intermediate', '2020-01-01', NULL, TRUE);


-- -------------------------
-- DIM_STATION
-- -------------------------

INSERT INTO DIM_STATION
    (
    station_id, station_code, station_name, city, region,
    effective_date, end_date, is_current
    )
VALUES
    (1, 'GMR', 'Gambir', 'Jakarta', 'DKI Jakarta', '2020-01-01', NULL, TRUE),
    (2, 'BD', 'Bandung', 'Bandung', 'West Java', '2020-01-01', NULL, TRUE),
    (3, 'YK', 'Yogyakarta', 'Yogyakarta', 'DI Yogyakarta', '2020-01-01', NULL, TRUE),
    (4, 'SGU', 'Surabaya Gubeng', 'Surabaya', 'East Java', '2020-01-01', NULL, TRUE);


-- -------------------------
-- DIM_TRAIN
-- -------------------------

INSERT INTO DIM_TRAIN
    (
    train_id, train_name, train_type, capacity, manufacture_year,
    effective_date, end_date, is_current
    )
VALUES
    (101, 'Argo Bromo Anggrek', 'Executive', 450, 2018, '2018-01-01', NULL, TRUE),
    (102, 'Taksaka', 'Executive', 400, 2016, '2016-01-01', NULL, TRUE),
    (103, 'Matarmaja', 'Economy', 600, 2015, '2015-01-01', NULL, TRUE);


-- -------------------------
-- DIM_ROUTE
-- -------------------------

INSERT INTO DIM_ROUTE
    (
    route_id, route_name, origin_station_id, destination_station_id, distance_km,
    effective_date, end_date, is_current
    )
VALUES
    (1, 'Jakarta - Bandung', 1, 2, 150, '2020-01-01', NULL, TRUE),
    (2, 'Jakarta - Yogyakarta', 1, 3, 560, '2020-01-01', NULL, TRUE),
    (3, 'Jakarta - Surabaya', 1, 4, 725, '2020-01-01', NULL, TRUE);


-- -------------------------
-- DIM_PAYMENT_METHOD
-- -------------------------

INSERT INTO DIM_PAYMENT_METHOD
VALUES
    (1, 'Mobile Banking'),
    (2, 'Credit Card'),
    (3, 'E-Wallet');


-- -------------------------
-- DIM_COMPONENT
-- -------------------------

INSERT INTO DIM_COMPONENT
    (
    component_name, category, effective_date, end_date, is_current
    )
VALUES
    ('Brake System', 'Safety', '2020-01-01', NULL, TRUE),
    ('Air Conditioner', 'Comfort', '2020-01-01', NULL, TRUE),
    ('Engine', 'Mechanical', '2020-01-01', NULL, TRUE);


-- -------------------------
-- DIM_MAINTENANCE_TYPE
-- -------------------------

INSERT INTO DIM_MAINTENANCE_TYPE
VALUES
    (1, 'Routine'),
    (2, 'Corrective'),
    (3, 'Emergency');


-- -------------------------
-- FACT_TICKET_SALES
-- -------------------------

INSERT INTO FACT_TICKET_SALES
    (
    date_id, train_id, route_id, passenger_id,
    payment_method_id, origin_station_id, destination_station_id,
    ticket_count, revenue
    )
VALUES
    (20250101, 101, 3, 1, 1, 1, 4, 1, 750000),
    (20250101, 102, 2, 2, 2, 1, 3, 2, 1200000),
    (20250102, 103, 1, 3, 3, 1, 2, 1, 250000),
    (20250106, 101, 3, 4, 1, 1, 4, 1, 750000),
    (20250106, 103, 1, 5, 3, 1, 2, 2, 500000),
    (20250107, 102, 2, 6, 2, 1, 3, 1, 600000),
    (20250111, 101, 3, 2, 1, 1, 4, 2, 1500000),
    (20250111, 102, 2, 4, 2, 1, 3, 2, 1200000),
    (20250112, 103, 1, 5, 3, 1, 2, 3, 750000);


-- -------------------------
-- FACT_PASSENGER_LOAD
-- -------------------------

INSERT INTO FACT_PASSENGER_LOAD
    (
    date_id, train_id, route_id, trip_id,
    passenger_count, seat_capacity, load_factor
    )
VALUES
    (20250101, 101, 3, 1, 420, 450, 93.33),
    (20250101, 102, 2, 1, 360, 400, 90.00),
    (20250102, 103, 1, 1, 500, 600, 83.33),
    (20250106, 101, 3, 1, 380, 450, 84.44),
    (20250106, 103, 1, 1, 460, 600, 76.67),
    (20250111, 101, 3, 1, 445, 450, 98.89),
    (20250111, 102, 2, 1, 395, 400, 98.75),
    (20250112, 103, 1, 1, 580, 600, 96.67);

-- -------------------------
-- FACT_OPERATIONAL_PERFORMANCE
-- -------------------------

INSERT INTO FACT_OPERATIONAL_PERFORMANCE
    (
    date_id, train_id, route_id,
    origin_station_id, destination_station_id,
    scheduled_departure, actual_departure,
    scheduled_arrival, actual_arrival,
    departure_delay_minutes, arrival_delay_minutes, is_ontime
    )
VALUES
    (20250101, 101, 3, 1, 4,
        '2025-01-01 08:00:00', '2025-01-01 08:05:00',
        '2025-01-01 16:00:00', '2025-01-01 16:10:00',
        5, 10, FALSE),
    (20250101, 102, 2, 1, 3,
        '2025-01-01 07:00:00', '2025-01-01 07:00:00',
        '2025-01-01 14:00:00', '2025-01-01 14:00:00',
        0, 0, TRUE),
    (20250106, 103, 1, 1, 2,
        '2025-01-06 09:00:00', '2025-01-06 09:10:00',
        '2025-01-06 11:30:00', '2025-01-06 11:40:00',
        10, 10, FALSE),
    (20250107, 102, 2, 1, 3,
        '2025-01-07 07:00:00', '2025-01-07 07:00:00',
        '2025-01-07 14:00:00', '2025-01-07 14:00:00',
        0, 0, TRUE),
    (20250111, 101, 3, 1, 4,
        '2025-01-11 08:00:00', '2025-01-11 08:25:00',
        '2025-01-11 16:00:00', '2025-01-11 16:40:00',
        25, 40, FALSE);


-- -------------------------
-- FACT_MAINTENANCE
-- -------------------------

INSERT INTO FACT_MAINTENANCE
    (
    date_id, train_id, component_id,
    maintenance_type_id, technician_id,
    repair_time_hours, downtime_hours, schedule_status
    )
VALUES
    (20250101, 101, 1, 1, 1, 2.5, 1.5, 'On Time'),
    (20250102, 102, 2, 2, 2, 4.0, 3.0, 'Late'),
    (20250106, 103, 2, 1, 4, 1.5, 1.0, 'On Time'),
    (20250107, 101, 1, 2, 3, 3.0, 2.5, 'Late'),
    (20250111, 102, 3, 3, 1, 6.5, 5.0, 'Late');
