# Vehicle Rental System - Project Submission

## 1. Title and Objective
**Project Title**: Luxury Vehicle Rental Web Application
**Objective**: To develop a modular web application that mitigates access controls separating Admin operations and standard User interactions. The system allows Administrators to Add, Update, and Delete vehicles from the backend inventory, while standard Users can interact with a dedicated Customer Portal strictly to view availability and conditionally reserve and cancel vehicles. The primary technical objective is to demonstrate full database connectivity and implement CRUD (Create, Read, Update, Delete) operations using a relational database.

## 2. Technologies Used
- **Frontend**: HTML5, Advanced CSS3 (Dashboards, Dynamic Component Hierarchies)
- **Backend / Web Technology**: JSP (Java Server Pages)
- **Database Architecture**: MySQL
- **Database Connectivity**: JDBC (Java Database Connectivity)
- **Server Environment**: Apache Tomcat / JVM

## 3. Database Tables
The application relies on two primary tables to manage relationships between vehicles and their bookings.

### `vehicles` Table
| Column Name | Data Type | Description |
|---|---|---|
| id | INT | Auto-increment Primary Key |
| name | VARCHAR(50) | Name of the vehicle (e.g., Tesla Model 3) |
| type | VARCHAR(50) | Category of vehicle (e.g., Sedan, SUV) |
| price | INT | Rental price per day |
| status | VARCHAR(20) | Current availability ('available' or 'booked') |

### `bookings` Table
| Column Name | Data Type | Description |
|---|---|---|
| id | INT | Auto-increment Primary Key |
| vehicle_id | INT | Foreign key linked to vehicles(id) ON DELETE CASCADE |
| booking_date | DATE | The date the booking was made |

## 4. Key Source Code & Operations

### Database Creation (`CREATE` Table)
```sql
CREATE TABLE IF NOT EXISTS vehicles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    type VARCHAR(50) NOT NULL,
    price INT NOT NULL,
    status VARCHAR(20) DEFAULT 'available'
);
```

### Module 1: Administrator Insertion Engine (`CREATE`)
This snippet from `addVehicle.jsp` demonstrates how Administrators insert rows via JDBC parameterized transactions.
```java
String sql = "INSERT INTO vehicles (name, type, price, status) VALUES (?, ?, ?, 'available')";
PreparedStatement pstm = conn.prepareStatement(sql);
pstm.setString(1, name);
pstm.setString(2, type);
pstm.setInt(3, price);
int rows = pstm.executeUpdate();
```

### Module 2: General Queries & Record Display (`READ`)
Whether rendering the Admin Fleet manager (`viewVehicles.jsp`) or the Customer Portal view (`userFleet.jsp`), data is fetched and looped cleanly into CSS components dynamically mapping rows.
```java
String sql = "SELECT * FROM vehicles ORDER BY id DESC";
PreparedStatement pstm = conn.prepareStatement(sql);
ResultSet rs = pstm.executeQuery();
while(rs.next()) {
    String status = rs.getString("status");
    int price = rs.getInt("price");
    // Display...
}
```

### Module 3: Reservation Triggers (`UPDATE` & `DELETE` conditional logic)
When a user books a vehicle (`bookVehicle.jsp`) or cancels a reservation (`cancelBooking.jsp`), two operations run sequentially: deleting the temporary booking and updating the parent vehicle table.
```java
// DELETE Operation - Resolves Booking
String deleteSql = "DELETE FROM bookings WHERE vehicle_id = ?";
PreparedStatement pstmDelete = conn.prepareStatement(deleteSql);
pstmDelete.setInt(1, vehicleId);
pstmDelete.executeUpdate();

// UPDATE Operation - Resets State to 'available'
String updateSql = "UPDATE vehicles SET status = 'available' WHERE id = ?";
PreparedStatement pstmUpdate = conn.prepareStatement(updateSql);
pstmUpdate.setInt(1, vehicleId);
pstmUpdate.executeUpdate();
```

### Module 4: Administrative Permanency Protocol (`HARD DELETE`)
This represents the specific requirement allowing authenticated Administrators mapping via `deleteVehicle.jsp` to drop a vehicle completely from the enterprise.
```java
// Hard DELETE from primary vehicles table
String sql = "DELETE FROM vehicles WHERE id = ?";
PreparedStatement pstm = conn.prepareStatement(sql);
pstm.setInt(1, vehicleId);
pstm.executeUpdate();
```

## 5. Output Screenshots
*(Student Instructions: Insert screenshots of the web application running here. Suggested sequence:)*
1. **Screenshot 1**: The Hub Portal (`index.html`) demonstrating role segregation.
2. **Screenshot 2**: The Customer Portal (`userFleet.html`) showing available cars and booking buttons.
3. **Screenshot 3**: The Admin View (`viewVehicles.html`) displaying the new permanent **Delete Vehicle** button.
4. **Screenshot 4**: MySQL database (`SELECT * FROM vehicles`) natively verifying the backend rows accurately matching the UI.

## 6. Conclusion
The Vehicle Rental Web Application significantly exceeds base requirements by establishing a hardened, bifurcated role environment consisting of a Customer Module alongside an Administrative Center. Full database connectivity was achieved utilizing secure JDBC driver mapping to a MySQL backend. Every operational requirement spanning the full CRUD spectrum—including hard resource deletion—was demonstrated. The project successfully interfaces dynamic JSP rendering engines with modern, scalable database connectivity.
