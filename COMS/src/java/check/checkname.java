/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package check;

import connect.db_connect;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Vamsi
 */
@WebServlet(name = "checkname", urlPatterns = {"/checkname"})
public class checkname extends HttpServlet {

    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    
    private static final String LOGIN_QUERY = "select * from conference where conf_id=?";
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            /* TODO output your page here. You may use following sample code. */
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet checkName</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet checkName at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        } finally {            
            out.close();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP
     * <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP
     * <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    public boolean authenticateName(String confname, HttpSession s ) throws Exception {
        boolean isValid = false;
        Connection con;
        con = null;
    try {
        db_connect cont = new db_connect();
        System.out.println("Connecting to a database...");
        con = cont.connect();
        System.out.println("Connected database successfully...");
        PreparedStatement prepStmt = con.prepareStatement(LOGIN_QUERY);
        prepStmt.setString(1, confname.toString());
        ResultSet rs = prepStmt.executeQuery();
        if(rs.next()) {
            System.out.println(rs);
            String name = rs.getString("conf_name");
            String sdate= rs.getString("start_date");
            String edate = rs.getString("end_date");
            s.setAttribute("cname", name);
            s.setAttribute("sdate", sdate);
            s.setAttribute("edate", edate);
            isValid = true; 
        }
        
    }catch(Exception e) {
    System.out.println("validateLogon: Error while validating password: "+e.getMessage());
    throw e;
    } finally {
    con.close();
    }
return isValid;
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
