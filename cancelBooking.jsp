<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String vehicleIdStr = request.getParameter("vehicle_id");
    String source = request.getParameter("source");
    String redirectPage = (source != null && source.equals("userFleet")) ? "userFleet.jsp" : "viewVehicles.jsp";

    if (vehicleIdStr != null && !vehicleIdStr.trim().isEmpty()) {
        Connection conn = null;
        PreparedStatement pstmDelete = null;
        PreparedStatement pstmUpdate = null;
        
        try {
            int vehicleId = Integer.parseInt(vehicleIdStr);
            
            // Database configuration
            String dbURL = "jdbc:mysql://localhost:3306/vehicle_rental";
            String dbUser = "root";
            String dbPass = ""; 
            
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            
            // Start Transaction
            conn.setAutoCommit(false);
            
            // 1. Delete from bookings table (Delete Operation -> Cancel Booking)
            String deleteSql = "DELETE FROM bookings WHERE vehicle_id = ?";
            pstmDelete = conn.prepareStatement(deleteSql);
            pstmDelete.setInt(1, vehicleId);
            pstmDelete.executeUpdate();
            
            // 2. Update status in vehicles table to available (Update Operation)
            String updateSql = "UPDATE vehicles SET status = 'available' WHERE id = ?";
            pstmUpdate = conn.prepareStatement(updateSql);
            pstmUpdate.setInt(1, vehicleId);
            pstmUpdate.executeUpdate();
            
            // Commit transaction
            conn.commit();
            
            // Redirect back to view page with a cancelled success message
            response.sendRedirect(redirectPage + "?msg=cancelled");
            
        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            out.println("<h3>Error cancelling booking: " + e.getMessage() + "</h3>");
            out.println("<p><a href='" + redirectPage + "'>Go Back</a></p>");
        } finally {
            try { if(pstmDelete != null) pstmDelete.close(); } catch(SQLException ignored) {}
            try { if(pstmUpdate != null) pstmUpdate.close(); } catch(SQLException ignored) {}
            try { if(conn != null) { conn.setAutoCommit(true); conn.close(); } } catch(SQLException ignored) {}
        }
    } else {
        response.sendRedirect(redirectPage);
    }
%>
