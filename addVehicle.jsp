<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Insert Vehicle - AutoRent Pro</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script>
        function validateForm() {
            let name = document.forms["addForm"]["name"].value;
            let type = document.forms["addForm"]["type"].value;
            let price = document.forms["addForm"]["price"].value;
            if (name == "" || type == "" || price == "") {
                alert("All required fields must be filled out");
                return false;
            }
            if(isNaN(price) || price <= 0) {
                alert("Please enter a valid positive price.");
                return false;
            }
        }
    </script>
</head>
<body>

    <!-- Pro Sidebar Navigation -->
    <aside class="sidebar">
        <a href="index.jsp" class="brand">
            <i class="fa-solid fa-car-side"></i> AutoRent Pro
        </a>
        <ul class="nav-links">
            <li><a href="index.jsp"><i class="fa-solid fa-house"></i> Dashboard Home</a></li>
            <li><a href="viewVehicles.jsp"><i class="fa-solid fa-car"></i> Vehicle Fleet</a></li>
            <li><a href="addVehicle.jsp" class="active"><i class="fa-solid fa-circle-plus"></i> Add New Vehicle</a></li>
        </ul>
        <div style="margin-top: auto; color: #64748B; font-size: 0.8rem; text-align: center;">
            &copy; 2026 Admin Portal
        </div>
    </aside>

    <main class="main-content">
        <header class="top-header">
            <div>
                <h1 class="page-title">Vehicle Inventory Management</h1>
                <p style="color: var(--text-muted); margin-top: 5px;">Add a new vehicle to synchronize with the MySQL central database.</p>
            </div>
            <div class="user-profile">
                <span>System Admin</span>
                <img src="https://ui-avatars.com/api/?name=Admin&background=4F46E5&color=fff" alt="User">
            </div>
        </header>

        <%
            // JDBC Processing Logic
            String method = request.getMethod();
            if("POST".equalsIgnoreCase(method)) {
                String name = request.getParameter("name");
                String type = request.getParameter("type");
                String priceStr = request.getParameter("price");
                
                if(name != null && type != null && priceStr != null) {
                    try {
                        int price = Integer.parseInt(priceStr);
                        
                        String dbURL = "jdbc:mysql://localhost:3306/vehicle_rental";
                        String dbUser = "root";
                        String dbPass = ""; 
                        
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
                        
                        String sql = "INSERT INTO vehicles (name, type, price, status) VALUES (?, ?, ?, 'available')";
                        PreparedStatement pstm = conn.prepareStatement(sql);
                        pstm.setString(1, name);
                        pstm.setString(2, type);
                        pstm.setInt(3, price);
                        
                        int rows = pstm.executeUpdate();
                        if(rows > 0) {
                            out.println("<div style='background: #DCFCE7; color: #166534; padding: 1.5rem; border-radius: 12px; margin-bottom: 2rem; border-left: 5px solid #10B981; display:flex; align-items:center; gap: 15px;'>");
                            out.println("<i class='fa-solid fa-circle-check fa-2x'></i>");
                            out.println("<div><strong style='display:block;'>Transaction Successful!</strong>The vehicle was mapped to the database via JDBC.</div>");
                            out.println("</div>");
                        }
                        
                        pstm.close();
                        conn.close();
                    } catch (Exception e) {
                        out.println("<div style='background: #FEE2E2; color: #991B1B; padding: 1.5rem; border-radius: 12px; margin-bottom: 2rem; border-left: 5px solid #EF4444; display:flex; align-items:center; gap: 15px;'>");
                        out.println("<i class='fa-solid fa-circle-exclamation fa-2x'></i>");
                        out.println("<div><strong style='display:block;'>Database Connection Error</strong>" + e.getMessage() + "</div>");
                        out.println("</div>");
                    }
                }
            }
        %>

        <section class="content-card pro-form">
            <h3 style="margin-bottom: 2rem; font-size: 1.5rem;"><i class="fa-solid fa-file-invoice" style="color: var(--primary);"></i> Specification Form</h3>
            <form name="addForm" action="addVehicle.jsp" method="POST" onsubmit="return validateForm()">
                
                <div class="form-group">
                    <label class="form-label">Make & Model</label>
                    <input type="text" name="name" class="form-input" placeholder="e.g., Mercedes G-Wagon" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Classification Tag</label>
                    <input type="text" name="type" class="form-input" placeholder="e.g., Luxury SUV" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Daily Rental Rate ($) / JDBC INT</label>
                    <input type="number" name="price" class="form-input" placeholder="e.g., 400" required>
                </div>
                
                <button type="submit" class="btn btn-primary" style="margin-top: 1rem;">
                    <i class="fa-solid fa-cloud-arrow-up"></i> Execute INSERT Query
                </button>
            </form>
        </section>
    </main>

</body>
</html>
