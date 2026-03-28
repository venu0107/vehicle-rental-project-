<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Our Fleet - AutoRent User</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    
    <nav style="padding: 1.5rem 4rem; display: flex; justify-content: space-between; align-items: center;">
        <span class="brand" style="margin-bottom: 0; font-size: 1.5rem;"><i class="fa-solid fa-car-side"></i> AutoRental</span>
        <div style="display:flex; gap: 2rem;">
            <a href="userHome.jsp" style="color: #94A3B8; text-decoration: none; font-weight: 600;">Home Base</a>
            <a href="userFleet.jsp" style="color: #fff; text-decoration: none; font-weight: 600;">Fleet Gallery</a>
        </div>
        <a href="index.jsp" class="btn" style="background:rgba(255,255,255,0.1); border:1px solid rgba(255,255,255,0.2); color:#fff; width:auto; padding: 0.5rem 1rem;">Back to Portal</a>
    </nav>

    <main class="main-content" style="margin-left: 0; max-width: 1200px; margin: 0 auto;">
        <header class="top-header" style="background: transparent; border: none; padding: 0; margin-bottom: 2rem;">
            <div>
                <h1 class="page-title">Available Models</h1>
                <p style="color: var(--text-muted); margin-top: 5px;">Reserve your vehicle today leveraging JDBC backend routing.</p>
            </div>
            <div class="user-profile">
                <span>VIP Customer</span>
                <img src="https://ui-avatars.com/api/?name=Customer&background=10B981&color=fff" alt="User">
            </div>
        </header>

        <%
            String msg = request.getParameter("msg");
            if("booked".equals(msg)) {
                out.println("<div style='background: rgba(16, 185, 129, 0.15); color: #34D399; padding: 1rem 1.5rem; border-radius: 12px; margin-bottom: 2rem; border-left: 5px solid #10B981; display:flex; align-items:center; gap: 10px; border: 1px solid rgba(16, 185, 129, 0.3);'><i class='fa-solid fa-check-double'></i> Booking created and database status updated!</div>");
            } else if("cancelled".equals(msg)) {
                out.println("<div style='background: rgba(239, 68, 68, 0.15); color: #F87171; padding: 1rem 1.5rem; border-radius: 12px; margin-bottom: 2rem; border-left: 5px solid #EF4444; display:flex; align-items:center; gap: 10px; border: 1px solid rgba(239, 68, 68, 0.3);'><i class='fa-solid fa-rotate-left'></i> Booking deleted securely from database.</div>");
            }
        %>

        <section class="grid-3">
            <%
                Connection conn = null;
                PreparedStatement pstm = null;
                ResultSet rs = null;
                
                try {
                    String dbURL = "jdbc:mysql://localhost:3306/vehicle_rental";
                    String dbUser = "root";
                    String dbPass = ""; 
                    
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
                    
                    String sql = "SELECT * FROM vehicles ORDER BY id DESC";
                    pstm = conn.prepareStatement(sql);
                    rs = pstm.executeQuery();
                    
                    int count = 0;
                    while(rs.next()) {
                        count++;
                        int id = rs.getInt("id");
                        String name = rs.getString("name");
                        String type = rs.getString("type");
                        int price = rs.getInt("price");
                        String status = rs.getString("status");
                        
                        String statusClass = status.equalsIgnoreCase("available") ? "available" : "booked";
                        String iconClass = status.equalsIgnoreCase("available") ? "fa-solid fa-circle-check" : "fa-solid fa-circle-xmark";
                        
                        out.println("<div class='v-card'>");
                        out.println("  <div class='v-header'>");
                        out.println("    <div class='v-title'>" + name + "</div>");
                        out.println("    <span class='v-type'>" + type + "</span>");
                        out.println("  </div>");
                        
                        out.println("  <div class='v-body'>");
                        out.println("    <div class='v-row' style='margin-bottom: 1.5rem;'>");
                        out.println("      <span style='color:var(--text-muted); font-weight:600;'>Availability:</span>");
                        out.println("      <span class='badge " + statusClass + "'><i class='" + iconClass + "'></i> " + status + "</span>");
                        out.println("    </div>");
                        
                        out.println("    <div style='text-align:center; padding: 1.5rem 0; background:rgba(0,0,0,0.3); border-radius:12px; margin-bottom: 1.5rem; border: 1px solid rgba(255,255,255,0.05);'>");
                        out.println("      <div class='v-price'>$" + price + " <span>/ day</span></div>");
                        out.println("    </div>");
                        
                        out.println("    <div style='display:flex; gap: 10px; flex-direction:column;'>");
                        
                        if(status.equalsIgnoreCase("available")) {
                            out.println("      <form action='bookVehicle.jsp' method='POST' style='width:100%;'>");
                            out.println("        <input type='hidden' name='vehicle_id' value='" + id + "'>");
                            out.println("        <!-- A trick parameter so the backend knows where to redirect back to -->");
                            out.println("        <input type='hidden' name='source' value='userFleet'>");
                            out.println("        <button type='submit' class='btn btn-success'><i class='fa-solid fa-key'></i> Reserve Vehicle Now</button>");
                            out.println("      </form>");
                        } else {
                            out.println("      <form action='cancelBooking.jsp' method='POST' style='width:100%;'>");
                            out.println("        <input type='hidden' name='vehicle_id' value='" + id + "'>");
                            out.println("        <input type='hidden' name='source' value='userFleet'>");
                            out.println("        <button type='submit' class='btn' style='background: linear-gradient(135deg, #f59e0b, #d97706);'><i class='fa-solid fa-rotate-left'></i> Cancel My Reservation</button>");
                            out.println("      </form>");
                        }
                        
                        out.println("    </div>");
                        out.println("  </div>");
                        out.println("</div>");
                    }
                    if(count == 0) {
                         out.println("<div style='grid-column: 1 / -1; text-align:center; padding: 3rem; color: #64748B;'>We are currently out of stock. Please wait for admins to add vehicles.</div>");
                    }
                } catch (Exception e) {
                    out.println("<div style='background: rgba(239, 68, 68, 0.15); color: #F87171; padding: 1.5rem; border-radius: 12px; grid-column: 1 / -1; border-left: 5px solid #EF4444;'>");
                    out.println("<strong><i class='fa-solid fa-plug-circle-xmark'></i> JDBC Connection Failed:</strong><br><br> " + e.getMessage());
                    out.println("</div>");
                } finally {
                    try { if(rs != null) rs.close(); } catch(SQLException ignored) {}
                    try { if(pstm != null) pstm.close(); } catch(SQLException ignored) {}
                    try { if(conn != null) conn.close(); } catch(SQLException ignored) {}
                }
            %>
        </section>
    </main>

</body>
</html>
