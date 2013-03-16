/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package insert;

import connect.db_connect;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author raghuteja
 */
@WebServlet(name = "conference", urlPatterns = {"/conference"})
public class conference extends HttpServlet {

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
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            /* TODO output your page here. You may use following sample code. */
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet conference</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet conference at " + request.getContextPath() + "</h1>");
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
//        processRequest(request, response);
        String username,password,re_password,hint,ar,profile_name,phno,email;
        HttpSession session = request.getSession();
        String conf_id = session.getAttribute("conf_ID").toString();
        Connection con = null;
        Statement stmt = null;
        
        ar = request.getParameter("ar").toString();
        username = request.getParameter("username").toString();
        profile_name = request.getParameter("profile-name").toString();
        password = request.getParameter("password").toString();
        re_password = request.getParameter("re-password").toString();
        hint = request.getParameter("password-hint").toString();
        phno = request.getParameter("phno").toString();
        email = request.getParameter("email").toString();
        
        db_connect cont = new db_connect();
        System.out.println("Connecting to a database...");
        try {
            con = cont.connect();
        } catch (Exception ex) {
            Logger.getLogger(conference.class.getName()).log(Level.SEVERE, null, ex);
        }
        System.out.println("Connected database successfully...");
        System.out.println("Inserting records into the table...");
        try {
            stmt = con.createStatement();
        } catch (SQLException ex) {
            Logger.getLogger(conference.class.getName()).log(Level.SEVERE, null, ex);
        }
        if(ar.equals("applicant")){
            String sql = "INSERT INTO users (user_name,password,hint,conf_ID,type,profile_name,phno,email) VALUES ('" +
                                username + "','" + password + "','" + hint + "','" + conf_id + "','applicant" + "','" + profile_name + "','" + phno + "','" + email + "')";
            System.out.println("Insert statement for applicant is : " + sql);
            try {
                stmt.executeUpdate(sql);
            } catch (SQLException ex) {
                Logger.getLogger(conference.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        else {
            String sql = "INSERT INTO users (user_name,password,hint,conf_ID,type,profile_name,phno,email) VALUES ('" +
                                username + "','" + password + "','" + hint + "','" + conf_id + "','reviewer" + "','" + profile_name + "','" + phno + "','" + email + "')";
            System.out.println("Insert statement for reviewer is : " + sql);
            String[] topics = request.getParameterValues("topics");
            try {
                stmt.executeUpdate(sql);
            } catch (SQLException ex) {
                Logger.getLogger(conference.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            int lastInsertedId = 0;
            ResultSet getKeyRs = null;
            try {
                getKeyRs = stmt.executeQuery("SELECT LAST_INSERT_ID()");
            } catch (SQLException ex) {
                Logger.getLogger(conference.class.getName()).log(Level.SEVERE, null, ex);
            }
            if (getKeyRs != null) {
                try {
                    if (getKeyRs.next()) {
                        lastInsertedId=getKeyRs.getInt(1);
                     }
                } catch (SQLException ex) {
                    Logger.getLogger(conference.class.getName()).log(Level.SEVERE, null, ex);
                }
                try {
                    getKeyRs.close();
                } catch (SQLException ex) {
                    Logger.getLogger(conference.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            System.out.println("Last inserted conference ID = " + lastInsertedId);
            
            for(int i=0; i<topics.length; i++){
                sql = "INSERT INTO rev_topics (rev_ID,topic) VALUES ('" +
                                lastInsertedId + "','" + topics[i] + "')";
                try {
                    stmt.executeUpdate(sql);
                } catch (SQLException ex) {
                    Logger.getLogger(conference.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            
            sql = "INSERT INTO rev_status (rev_ID,status) VALUES ('" +
                    lastInsertedId + "','Inactive')";
            try {
                stmt.executeUpdate(sql);
            } catch (SQLException ex) {
                Logger.getLogger(conference.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        response.sendRedirect("conference.jsp?error&lr=l&cid=" + conf_id);
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
