-- =====================================================
-- SCD Type 0 (insert once, never changes)
-- =====================================================

-- -------------------------
-- DIM_DATE
-- -------------------------

INSERT INTO kai_dw_olap.DIM_DATE (
    date_id,
    date_value,
    day,
    month,
    quarter,
    year,
    week_of_year,
    is_weekend
)
SELECT
    DATE_FORMAT(d, '%Y%m%d') AS date_id,
    d AS date_value,
    DAY(d),
    MONTH(d),
    QUARTER(d),
    YEAR(d),
    WEEK(d),
    CASE WHEN DAYOFWEEK(d) IN (1,7) THEN TRUE ELSE FALSE END
FROM (
    SELECT DISTINCT DATE(departure_time) AS d
    FROM kai_dw_oltp.TRAIN_SCHEDULE
) src
WHERE NOT EXISTS (
    SELECT 1 FROM kai_dw_olap.DIM_DATE dd
    WHERE dd.date_value = src.d
);

-- -------------------------
-- DIM_PAYMENT_METHOD
-- -------------------------

INSERT INTO kai_dw_olap.DIM_PAYMENT_METHOD (payment_method_id, method_name)
SELECT DISTINCT
    ROW_NUMBER() OVER (ORDER BY payment_method),
    payment_method
FROM kai_dw_oltp.TICKET
WHERE payment_method IS NOT NULL;


-- =====================================================
-- SCD Type 1 (overwrite old values)
-- =====================================================

-- -------------------------
-- DIM_PASSENGER
-- -------------------------

INSERT INTO kai_dw_olap.DIM_PASSENGER (
    passenger_id,
    full_name,
    gender,
    age_group,
    effective_date,
    end_date,
    is_current
)
SELECT
    p.passenger_id,
    p.full_name,
    p.gender,
    CASE
        WHEN TIMESTAMPDIFF(YEAR, '1990-01-01', CURDATE()) < 18 THEN 'Under 18'
        WHEN TIMESTAMPDIFF(YEAR, '1990-01-01', CURDATE()) BETWEEN 18 AND 40 THEN '18-40'
        ELSE '40+'
    END,
    CURDATE(),
    NULL,
    TRUE
FROM kai_dw_oltp.PASSENGER p
ON DUPLICATE KEY UPDATE
    full_name = VALUES(full_name),
    gender = VALUES(gender),
    age_group = VALUES(age_group),
    effective_date = CURDATE(),
    end_date = NULL,
    is_current = TRUE;

-- -------------------------
-- DIM_PASSENGER
-- -------------------------

INSERT INTO kai_dw_olap.DIM_TECHNICIAN (
    technician_id,
    technician_name,
    skill_level,
    effective_date,
    end_date,
    is_current
)
SELECT DISTINCT
    ROW_NUMBER() OVER (ORDER BY technician_name) AS technician_id,
    technician_name,
    'Intermediate' AS skill_level,
    CURDATE() AS effective_date,
    NULL AS end_date,
    TRUE AS is_current
FROM kai_dw_oltp.MAINTENANCE
WHERE technician_name IS NOT NULL
ON DUPLICATE KEY UPDATE
    technician_name = VALUES(technician_name),
    skill_level = VALUES(skill_level),
    effective_date = CURDATE(),
    end_date = NULL,
    is_current = TRUE;

-- -------------------------
-- DIM_STATION
-- -------------------------

INSERT INTO kai_dw_olap.DIM_STATION (
    station_id,
    station_code,
    station_name,
    city,
    region,
    effective_date,
    end_date,
    is_current
)
SELECT
    station_id,
    station_code,
    station_name,
    city,
    region,
    CURDATE() AS effective_date,
    NULL AS end_date,
    TRUE AS is_current
FROM kai_dw_oltp.STATION
ON DUPLICATE KEY UPDATE
    station_code = VALUES(station_code),
    station_name = VALUES(station_name),
    city = VALUES(city),
    region = VALUES(region),
    effective_date = CURDATE(),
    end_date = NULL,
    is_current = TRUE;


-- =====================================================
-- SCD Type 2 (full history tracking)
-- =====================================================

-- -------------------------
-- DIM_TRAIN
-- -------------------------

UPDATE kai_dw_olap.DIM_TRAIN dt
JOIN kai_dw_oltp.TRAIN t
  ON dt.train_id = t.train_id
SET
    dt.end_date = CURDATE() - INTERVAL 1 DAY,
    dt.is_current = FALSE
WHERE dt.is_current = TRUE
  AND (
        dt.train_type <> t.train_type
     OR dt.capacity <> t.capacity
     OR dt.manufacture_year <> t.manufacture_year
  );

INSERT INTO kai_dw_olap.DIM_TRAIN (
    train_id,
    train_name,
    train_type,
    capacity,
    manufacture_year,
    effective_date,
    end_date,
    is_current
)
SELECT
    t.train_id,
    t.model_name,
    t.train_type,
    t.capacity,
    t.manufacture_year,
    CURDATE(),
    NULL,
    TRUE
FROM kai_dw_oltp.TRAIN t
LEFT JOIN kai_dw_olap.DIM_TRAIN dt
  ON dt.train_id = t.train_id
 AND dt.is_current = TRUE
WHERE dt.train_id IS NULL
   OR (
        dt.train_type <> t.train_type
     OR dt.capacity <> t.capacity
     OR dt.manufacture_year <> t.manufacture_year
   );

-- -------------------------
-- DIM_ROUTE
-- -------------------------

UPDATE kai_dw_olap.DIM_ROUTE dr
JOIN kai_dw_oltp.ROUTE r
  ON dr.route_id = r.route_id
SET
    dr.end_date = CURDATE() - INTERVAL 1 DAY,
    dr.is_current = FALSE
WHERE dr.is_current = TRUE
  AND (
       dr.distance_km <> r.distance_km
    OR dr.origin_station_id <> r.origin_station_id
    OR dr.destination_station_id <> r.destination_station_id
  );

INSERT INTO kai_dw_olap.DIM_ROUTE (
    route_id,
    route_name,
    origin_station_id,
    destination_station_id,
    distance_km,
    effective_date,
    end_date,
    is_current
)
SELECT
    r.route_id,
    r.route_name,
    r.origin_station_id,
    r.destination_station_id,
    r.distance_km,
    CURDATE(),
    NULL,
    TRUE
FROM kai_dw_oltp.ROUTE r
LEFT JOIN kai_dw_olap.DIM_ROUTE dr
  ON dr.route_id = r.route_id
 AND dr.is_current = TRUE
WHERE dr.route_id IS NULL
   OR (
       dr.distance_km <> r.distance_km
    OR dr.origin_station_id <> r.origin_station_id
    OR dr.destination_station_id <> r.destination_station_id
   );


-- -------------------------
-- DIM_COMPONENT
-- -------------------------

UPDATE kai_dw_olap.DIM_COMPONENT dc
JOIN (
    SELECT DISTINCT
        component_name,
        component_category
    FROM kai_dw_oltp.MAINTENANCE
    WHERE component_name IS NOT NULL
) src
  ON dc.component_name = src.component_name
SET
    dc.end_date = CURDATE() - INTERVAL 1 DAY,
    dc.is_current = FALSE
WHERE dc.is_current = TRUE
  AND dc.category <> src.component_category;

INSERT INTO kai_dw_olap.DIM_COMPONENT (
    component_name,
    category,
    effective_date,
    end_date,
    is_current
)
SELECT
    src.component_name,
    src.component_category,
    CURDATE() AS effective_date,
    NULL AS end_date,
    TRUE AS is_current
FROM (
    SELECT DISTINCT
        component_name,
        component_category
    FROM kai_dw_oltp.MAINTENANCE
    WHERE component_name IS NOT NULL
) src
LEFT JOIN kai_dw_olap.DIM_COMPONENT dc
  ON dc.component_name = src.component_name
 AND dc.is_current = TRUE
WHERE dc.component_id IS NULL
   OR dc.category <> src.component_category;



-- =====================================================
-- FACT TABLES
-- =====================================================

-- -------------------------
-- FACT_TICKET_SALES
-- -------------------------

INSERT INTO kai_dw_olap.FACT_TICKET_SALES (
    date_id,
    train_id,
    route_id,
    passenger_id,
    payment_method_id,
    origin_station_id,
    destination_station_id,
    ticket_count,
    revenue
)
SELECT
    DATE_FORMAT(t.purchase_time, '%Y%m%d') AS date_id,
    ts.train_id,
    ts.route_id,
    t.passenger_id,
    pm.payment_method_id,
    r.origin_station_id,
    r.destination_station_id,
    COUNT(*) AS ticket_count,
    SUM(t.price) AS revenue
FROM kai_dw_oltp.TICKET t
JOIN kai_dw_oltp.TRIP tr ON t.trip_id = tr.trip_id
JOIN kai_dw_oltp.TRAIN_SCHEDULE ts ON tr.schedule_id = ts.schedule_id
JOIN kai_dw_oltp.ROUTE r ON ts.route_id = r.route_id
JOIN kai_dw_olap.DIM_PAYMENT_METHOD pm
  ON pm.method_name = t.payment_method
GROUP BY
    date_id,
    ts.train_id,
    ts.route_id,
    t.passenger_id,
    pm.payment_method_id,
    r.origin_station_id,
    r.destination_station_id;
