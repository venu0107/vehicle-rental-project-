<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String vehicleIdStr = request.getParameter("vehicle_id");

    if (vehicleIdStr != null && !vehicleIdStr.trim().isEmpty()) {
        Connection conn = null;
        PreparedStatement pstm = null;
        
        try {
            int vehicleId = Integer.parseInt(vehicleIdStr);
            
            // Database configuration
            String dbURL = "jdbc:mysql://localhost:3306/vehicle_rental";
            String dbUser = "root";
            String dbPass = ""; 
            
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            
            // Delete from vehicles table (Delete Operation)
            String sql = "DELETE FROM vehicles WHERE id = ?";
            pstm = conn.prepareStatement(sql);
            pstm.setInt(1, vehicleId);
            pstm.executeUpdate();
            
            // Redirect back to admin view with success message
            response.sendRedirect("viewVehicles.jsp?msg=deleted");
            
        } catch (Exception e) {
            out.println("<h3>Error deleting vehicle: " + e.getMessage() + "</h3>");
            out.println("<p><a href='viewVehicles.jsp'>Go Back</a></p>");
        } finally {
            try { if(pstm != null) pstm.close(); } catch(SQLException ignored) {}
            try { if(conn != null) conn.close(); } catch(SQLException ignored) {}
        }
    } else {
        response.sendRedirect("viewVehicles.jsp");
    }
%>
