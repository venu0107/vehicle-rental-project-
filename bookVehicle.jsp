<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDate" %>
<%
    String vehicleIdStr = request.getParameter("vehicle_id");
    String source = request.getParameter("source");
    String redirectPage = (source != null && source.equals("userFleet")) ? "userFleet.jsp" : "viewVehicles.jsp";

    if (vehicleIdStr != null && !vehicleIdStr.trim().isEmpty()) {
        Connection conn = null;
        PreparedStatement pstmInsert = null;
        PreparedStatement pstmUpdate = null;
        
        try {
            int vehicleId = Integer.parseInt(vehicleIdStr);
            LocalDate bookingDate = LocalDate.now();
            
            // Database configuration
            String dbURL = "jdbc:mysql://localhost:3306/vehicle_rental";
            String dbUser = "root";
            String dbPass = ""; 
            
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            
            // Transaction started
            conn.setAutoCommit(false);
            
            // 1. Insert into bookings table (Create Operation)
            String insertSql = "INSERT INTO bookings (vehicle_id, booking_date) VALUES (?, ?)";
            pstmInsert = conn.prepareStatement(insertSql);
            pstmInsert.setInt(1, vehicleId);
            pstmInsert.setDate(2, java.sql.Date.valueOf(bookingDate));
            pstmInsert.executeUpdate();
            
            // 2. Update status in vehicles table (Update Operation)
            String updateSql = "UPDATE vehicles SET status = 'booked' WHERE id = ?";
            pstmUpdate = conn.prepareStatement(updateSql);
            pstmUpdate.setInt(1, vehicleId);
            pstmUpdate.executeUpdate();
            
            // Commit transaction
            conn.commit();
            
            // Redirect back to view page with success message
            response.sendRedirect(redirectPage + "?msg=booked");
            
        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            out.println("<h3>Error during booking: " + e.getMessage() + "</h3>");
            out.println("<p><a href='" + redirectPage + "'>Go Back</a></p>");
        } finally {
            try { if(pstmInsert != null) pstmInsert.close(); } catch(SQLException ignored) {}
            try { if(pstmUpdate != null) pstmUpdate.close(); } catch(SQLException ignored) {}
            try { if(conn != null) { conn.setAutoCommit(true); conn.close(); } } catch(SQLException ignored) {}
        }
    } else {
        response.sendRedirect(redirectPage);
    }
%>
