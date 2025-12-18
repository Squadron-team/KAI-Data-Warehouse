USE kai_dw_oltp;

-- =====================================================
-- TRAIN
-- =====================================================
INSERT INTO TRAIN
    (model_name, train_type, capacity, manufacture_year)
VALUES
    ('Kereta Argo Bromo', 'Executive', 400, 2018),
    ('Kereta Taksaka', 'Executive', 380, 2017),
    ('Kereta Gajayana', 'Business', 420, 2016),
    ('Kereta Bengawan', 'Economy', 500, 2015),
    ('Kereta Lodaya', 'Business', 450, 2019);

-- =====================================================
-- STATION
-- =====================================================
INSERT INTO STATION
    (station_code, station_name, city, province)
VALUES
    ('GMR', 'Gambir', 'Jakarta', 'DKI Jakarta'),
    ('BD', 'Bandung', 'Bandung', 'West Java'),
    ('YK', 'Yogyakarta', 'Yogyakarta', 'DIY'),
    ('SGU', 'Surabaya Gubeng', 'Surabaya', 'East Java'),
    ('SMT', 'Semarang Tawang', 'Semarang', 'Central Java');

-- =====================================================
-- ROUTE
-- =====================================================
INSERT INTO ROUTE
    (route_name, origin_station_id, destination_station_id, distance_km)
VALUES
    ('Jakarta - Bandung', 1, 2, 150),
    ('Jakarta - Yogyakarta', 1, 3, 560),
    ('Jakarta - Surabaya', 1, 4, 720),
    ('Bandung - Yogyakarta', 2, 3, 390),
    ('Semarang - Surabaya', 5, 4, 350);

-- =====================================================
-- TRAIN_SCHEDULE
-- =====================================================
INSERT INTO TRAIN_SCHEDULE
    (train_id, route_id, departure_time, arrival_time)
VALUES
    (1, 1, '2025-01-01 06:00:00', '2025-01-01 09:00:00'),
    (2, 2, '2025-01-01 07:00:00', '2025-01-01 15:00:00'),
    (3, 3, '2025-01-01 08:00:00', '2025-01-01 18:00:00'),
    (4, 4, '2025-01-01 09:00:00', '2025-01-01 16:00:00'),
    (5, 5, '2025-01-01 10:00:00', '2025-01-01 14:00:00');

-- =====================================================
-- TRIP
-- =====================================================
INSERT INTO TRIP
    (schedule_id, actual_departure, actual_arrival, delay_minutes, status)
VALUES
    (1, '2025-01-01 06:05:00', '2025-01-01 09:10:00', 10, 'Completed'),
    (2, '2025-01-01 07:00:00', '2025-01-01 15:05:00', 5, 'Completed'),
    (3, '2025-01-01 08:20:00', '2025-01-01 18:40:00', 20, 'Delayed'),
    (4, '2025-01-01 09:00:00', '2025-01-01 16:00:00', 0, 'Completed'),
    (5, '2025-01-01 10:10:00', '2025-01-01 14:20:00', 10, 'Completed');

-- =====================================================
-- PASSENGER
-- =====================================================
INSERT INTO PASSENGER
    (full_name, phone, gender, age)
VALUES
    ('Andi Saputra', '081234567001', 'Male', 21),
    ('Budi Santoso', '081234567002', 'Male', 32),
    ('Citra Lestari', '081234567003', 'Female', 19),
    ('Dewi Anggraini', '081234567004', 'Female', 26),
    ('Eko Prasetyo', '081234567005', 'Male', 43);

-- =====================================================
-- TICKET
-- =====================================================
INSERT INTO TICKET
    (trip_id, passenger_id, purchase_time, seat_number, price, payment_method, status)
VALUES
    (1, 1, '2024-12-30 10:00:00', 'A1', 250000.00, 'Credit Card', 'Paid'),
    (1, 2, '2024-12-30 10:05:00', 'A2', 250000.00, 'QRIS', 'Paid'),
    (2, 3, '2024-12-30 11:00:00', 'B1', 450000.00, 'Transfer', 'Paid'),
    (3, 4, '2024-12-30 12:00:00', 'C3', 500000.00, 'Credit Card', 'Paid'),
    (4, 5, '2024-12-30 13:00:00', 'D4', 300000.00, 'Cash', 'Paid');

-- =====================================================
-- MAINTENANCE
-- =====================================================
INSERT INTO MAINTENANCE
(
    train_id,
    maintenance_date,
    maintenance_type,
    component_name,
    component_category,
    technician_name,
    status,
    description
)
VALUES
-- 6
(1, '2024-12-02 07:00:00', 'Routine Check', 'Brake System', 'Mechanical', 'Ahmad Wijaya', 'PLANNED', 'Weekly brake inspection'),

-- 7
(2, '2024-12-03 14:00:00', 'Corrective', 'Pantograph', 'Electrical', 'Bambang Susilo', 'PLANNED', 'Pantograph malfunction'),

-- 8
(3, '2024-12-04 22:00:00', 'Emergency Repair', 'Engine', 'Mechanical', 'Candra Putra', 'PLANNED', 'Unexpected engine failure'),

-- 9
(4, '2024-12-06 09:30:00', 'Routine Check', 'Door System', 'Mechanical', 'Dedi Kurniawan', 'PLANNED', 'Door sensor calibration'),

-- 10
(5, '2024-12-07 01:00:00', 'Electrical Repair', 'Lighting System', 'Electrical', 'Edi Santoso', 'PLANNED', 'Cabin lighting failure'),

-- 11
(1, '2024-12-08 16:00:00', 'Wheel Maintenance', 'Wheel Assembly', 'Mechanical', 'Fajar Pratama', 'PLANNED', 'Wheel vibration reported'),

-- 12
(2, '2024-12-09 08:00:00', 'Routine Check', 'Air Compressor', 'Mechanical', 'Gilang Ramadhan', 'PLANNED', 'Pressure stability check'),

-- 13
(3, '2024-12-11 11:00:00', 'Corrective', 'Signal System', 'Electrical', 'Hendra Saputra', 'PLANNED', 'Signal delay issue'),

-- 14
(4, '2024-12-12 19:30:00', 'Emergency Repair', 'Brake System', 'Mechanical', 'Indra Gunawan', 'PLANNED', 'Brake overheating'),

-- 15
(5, '2024-12-13 06:00:00', 'Routine Check', 'AC Unit', 'Electrical', 'Joko Santoso', 'PLANNED', 'Cooling performance check'),

-- 16
(1, '2024-12-14 23:00:00', 'Electrical Repair', 'Battery System', 'Electrical', 'Kevin Wijaya', 'PLANNED', 'Battery voltage drop'),

-- 17
(2, '2024-12-16 10:00:00', 'Corrective', 'Suspension', 'Mechanical', 'Lukman Hakim', 'PLANNED', 'Unusual vibration'),

-- 18
(3, '2024-12-18 15:30:00', 'Routine Check', 'Fuel System', 'Mechanical', 'Muhammad Rizki', 'PLANNED', 'Fuel efficiency inspection'),

-- 19
(4, '2024-12-19 03:00:00', 'Emergency Repair', 'Traction Motor', 'Electrical', 'Nanda Prakoso', 'PLANNED', 'Traction motor fault'),

-- 20
(5, '2024-12-21 09:00:00', 'Corrective', 'Cooling System', 'Mechanical', 'Oka Prasetyo', 'PLANNED', 'Overheating issue'),

-- 21
(3, '2024-12-22 17:00:00', 'Routine Check', 'Coupler', 'Mechanical', 'Putra Anugrah', 'PLANNED', 'Coupler wear inspection'),

-- 22
(1, '2024-12-23 05:30:00', 'Electrical Repair', 'Control Panel', 'Electrical', 'Rizal Firmansyah', 'PLANNED', 'Control panel malfunction'),

-- 23
(2, '2024-12-24 13:00:00', 'Wheel Maintenance', 'Wheel Assembly', 'Mechanical', 'Surya Mahendra', 'PLANNED', 'Wheel profile adjustment'),

-- 24
(4, '2024-12-26 21:00:00', 'Emergency Repair', 'Engine', 'Mechanical', 'Teguh Wibowo', 'PLANNED', 'Engine shutdown during operation'),

-- 25
(5, '2024-12-28 08:00:00', 'Routine Check', 'Brake System', 'Mechanical', 'Yoga Permana', 'PLANNED', 'Brake pad wear check');

-- Maintenance 6 (short routine)
UPDATE MAINTENANCE
SET
    repair_start_time = '2024-12-02 07:15:00',
    repair_end_time   = '2024-12-02 08:00:00',
    downtime_start_time = '2024-12-02 07:15:00',
    downtime_end_time   = '2024-12-02 08:15:00',
    status = 'COMPLETED'
WHERE maintenance_id = 6;

-- Maintenance 8 (long emergency)
UPDATE MAINTENANCE
SET
    repair_start_time = '2024-12-04 22:30:00',
    repair_end_time   = '2024-12-05 05:30:00',
    downtime_start_time = '2024-12-04 22:30:00',
    downtime_end_time   = '2024-12-05 06:00:00',
    status = 'COMPLETED'
WHERE maintenance_id = 8;

-- Maintenance 10 (night electrical)
UPDATE MAINTENANCE
SET
    repair_start_time = '2024-12-07 01:30:00',
    repair_end_time   = '2024-12-07 03:00:00',
    downtime_start_time = '2024-12-07 01:30:00',
    downtime_end_time   = '2024-12-07 03:15:00',
    status = 'COMPLETED'
WHERE maintenance_id = 10;

-- Maintenance 14 (delayed downtime)
UPDATE MAINTENANCE
SET
    repair_start_time = '2024-12-12 20:00:00',
    repair_end_time   = '2024-12-12 23:00:00',
    downtime_start_time = '2024-12-12 20:00:00',
    downtime_end_time   = '2024-12-13 01:30:00',
    status = 'COMPLETED'
WHERE maintenance_id = 14;

-- Maintenance 19 (still in progress)
UPDATE MAINTENANCE
SET
    repair_start_time = '2024-12-19 03:30:00',
    downtime_start_time = '2024-12-19 03:30:00',
    status = 'IN_PROGRESS'
WHERE maintenance_id = 19;
