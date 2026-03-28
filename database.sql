-- Database creation for Vehicle Rental Project
CREATE DATABASE IF NOT EXISTS vehicle_rental;
USE vehicle_rental;

-- 1. Vehicles table - Stores all vehicles
CREATE TABLE IF NOT EXISTS vehicles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    type VARCHAR(50) NOT NULL,
    price INT NOT NULL,
    status VARCHAR(20) DEFAULT 'available' -- available or booked
);

-- 2. Bookings table - Stores bookings
CREATE TABLE IF NOT EXISTS bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT NOT NULL,
    booking_date DATE,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE
);

-- Insert some dummy data for initial testing
INSERT INTO vehicles (name, type, price, status) VALUES 
('Honda Civic', 'Sedan', 500, 'available'),
('Toyota Fortuner', 'SUV', 1500, 'available'),
('Yamaha R15', 'Two-wheeler', 300, 'available');
