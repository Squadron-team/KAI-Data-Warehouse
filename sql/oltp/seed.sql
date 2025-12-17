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
    description
    )
VALUES
    (1, '2024-12-01 08:00:00', 'Routine Check',
        'Engine', 'Mechanical',
        'Ahmad Wijaya',
        'Monthly engine inspection'),

    (2, '2024-12-05 09:00:00', 'Brake Repair',
        'Brake System', 'Mechanical',
        'Bambang Susilo',
        'Brake pad replacement'),

    (3, '2024-12-10 10:00:00', 'Electrical',
        'Signal System', 'Electrical',
        'Candra Putra',
        'Signal system inspection'),

    (4, '2024-12-15 11:00:00', 'Wheel Maintenance',
        'Wheel Assembly', 'Mechanical',
        'Dedi Kurniawan',
        'Wheel alignment check'),

    (5, '2024-12-20 13:00:00', 'Air Conditioning',
        'AC Unit', 'Electrical',
        'Edi Santoso',
        'AC system maintenance');
