<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fleet Overview - AutoRent Admin</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

    <aside class="sidebar">
        <a href="index.jsp" class="brand">
            <i class="fa-solid fa-car-side"></i> AutoRental Admin
        </a>
        <ul class="nav-links">
            <li><a href="index.jsp"><i class="fa-solid fa-layer-group"></i> Dashboard Options</a></li>
            <li><a href="viewVehicles.jsp" class="active"><i class="fa-solid fa-car"></i> Manage Fleet</a></li>
            <li><a href="addVehicle.jsp"><i class="fa-solid fa-square-plus"></i> Add Vehicle</a></li>
        </ul>
    </aside>

    <main class="main-content">
        <header class="top-header">
            <div>
                <h1 class="page-title">Admin Fleet Manager</h1>
                <p style="color: var(--text-muted); margin-top: 5px;">Displaying all records dynamically using JDBC `SELECT * FROM vehicles`.</p>
            </div>
            <div class="user-profile">
                <span>System Admin</span>
                <img src="https://ui-avatars.com/api/?name=Admin&background=4F46E5&color=fff" alt="User">
            </div>
        </header>

        <%
            String msg = request.getParameter("msg");
            if("booked".equals(msg)) {
                out.println("<div style='background: #DCFCE7; color: #166534; padding: 1rem 1.5rem; border-radius: 12px; margin-bottom: 2rem; border-left: 5px solid #10B981; display:flex; align-items:center; gap: 10px;'><i class='fa-solid fa-check-double'></i> Booking created and status updated!</div>");
            } else if("cancelled".equals(msg)) {
                out.println("<div style='background: #DBEAFE; color: #1E40AF; padding: 1rem 1.5rem; border-radius: 12px; margin-bottom: 2rem; border-left: 5px solid #3B82F6; display:flex; align-items:center; gap: 10px;'><i class='fa-solid fa-rotate-left'></i> Booking deleted and status reset to available.</div>");
            } else if("deleted".equals(msg)) {
                out.println("<div style='background: #FEE2E2; color: #991B1B; padding: 1rem 1.5rem; border-radius: 12px; margin-bottom: 2rem; border-left: 5px solid #EF4444; display:flex; align-items:center; gap: 10px;'><i class='fa-solid fa-trash'></i> Vehicle permanently deleted from database.</div>");
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
                    
                    while(rs.next()) {
                        int id = rs.getInt("id");
                        String name = rs.getString("name");
                        String type = rs.getString("type");
                        int price = rs.getInt("price");
                        String status = rs.getString("status");
                        
                        String statusClass = status.equalsIgnoreCase("available") ? "available" : "booked";
                        String iconClass = status.equalsIgnoreCase("available") ? "fa-solid fa-circle-check" : "fa-solid fa-circle-xmark";
                        
                        out.println("<div class='v-card'>");
                        out.println("  <div class='v-header'>");
                        out.println("    <div class='v-title'>" + name + " <i class='fa-solid fa-car-rear' style='color:#CBD5E1'></i></div>");
                        out.println("    <span class='v-type'>" + type + "</span>");
                        out.println("  </div>");
                        
                        out.println("  <div class='v-body'>");
                        out.println("    <div class='v-row'>");
                        out.println("      <span style='color:var(--text-muted); font-weight:600;'>System ID:</span>");
                        out.println("      <span style='font-family:monospace; background:#e2e8f0; color:#0F172A; padding:2px 8px; border-radius:4px;'>#" + id + "</span>");
                        out.println("    </div>");
                        out.println("    <div class='v-row' style='margin-bottom: 1.5rem;'>");
                        out.println("      <span style='color:var(--text-muted); font-weight:600;'>Database State:</span>");
                        out.println("      <span class='badge " + statusClass + "'><i class='" + iconClass + "'></i> " + status + "</span>");
                        out.println("    </div>");
                        
                        out.println("    <div style='text-align:center; padding: 1.5rem 0; background:rgba(0,0,0,0.3); border-radius:12px; margin-bottom: 1.5rem; border: 1px solid rgba(255,255,255,0.05);'>");
                        out.println("      <div class='v-price'>$" + price + " <span>/ day</span></div>");
                        out.println("    </div>");
                        
                        out.println("    <div style='display:flex; gap: 10px; flex-direction:column;'>");
                        
                        // Book / Cancel Reserve Option
                        if(status.equalsIgnoreCase("available")) {
                            out.println("      <form action='bookVehicle.jsp' method='POST' style='width:100%;'>");
                            out.println("        <input type='hidden' name='vehicle_id' value='" + id + "'>");
                            out.println("        <button type='submit' class='btn btn-success'><i class='fa-solid fa-key'></i> Reserve Vehicle</button>");
                            out.println("      </form>");
                        } else {
                            out.println("      <form action='cancelBooking.jsp' method='POST' style='width:100%;'>");
                            out.println("        <input type='hidden' name='vehicle_id' value='" + id + "'>");
                            out.println("        <button type='submit' class='btn' style='background:#f59e0b; color:#111827;'><i class='fa-solid fa-rotate-left'></i> Cancel Reserve</button>");
                            out.println("      </form>");
                        }
                        
                        // NEW ALIEN DELETE OPTION (Admin Only)
                        out.println("      <form action='deleteVehicle.jsp' method='POST' style='width:100%;' onsubmit=\"return confirm('Are you certain you want to forever destroy this record from the database?');\">");
                        out.println("        <input type='hidden' name='vehicle_id' value='" + id + "'>");
                        out.println("        <button type='submit' class='btn' style='background:#fee2e2; color:#991b1b; border: 1px solid #fca5a5;'><i class='fa-solid fa-trash-can'></i> Delete Permanently</button>");
                        out.println("      </form>");
                        
                        out.println("    </div>");
                        out.println("  </div>");
                        out.println("</div>");
                    }
                } catch (Exception e) {
                    out.println("<div style='background: #FEE2E2; color: #991B1B; padding: 1.5rem; border-radius: 12px; grid-column: 1 / -1; border-left: 5px solid #EF4444;'>");
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
