package insert;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import connect.db_connect;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author RAGHUTEJA
 */
@WebServlet(name = "new_conf", urlPatterns = {"/new_conf"})
public class new_conf extends HttpServlet {

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
            out.println("<title>Servlet new_conf</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet new_conf at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        } finally {
            out.close();
        }
    }

    
    public void print(HttpServletRequest request, HttpServletResponse response,String s)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            /* TODO output your page here. You may use following sample code. */
            out.println(s);
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
        String admin_name,password,re_password,hint,conf_name,st_date,ed_date,phno,email,location,description,profile_name;
        Connection con = null;
        Statement stmt = null;

        admin_name = request.getParameter("admin-name").toString();
        profile_name = request.getParameter("profile-name").toString();
        password = request.getParameter("password").toString();
        re_password = request.getParameter("re-password").toString();
        hint = request.getParameter("password-hint").toString();
        conf_name = request.getParameter("conference-name").toString();
        st_date = request.getParameter("start-date").toString();
        ed_date = request.getParameter("end-date").toString();
        phno = request.getParameter("phno").toString();
        email = request.getParameter("email").toString();
        location = request.getParameter("location").toString();
        description = request.getParameter("description").toString();
        String[] topics = request.getParameterValues("topics");
        
/*        for(int i=0; i<topics.length; i++){
            System.out.println(topics[i] + "--");
        }
        System.out.println(admin_name + "\n" + password + "\n" + re_password + "\n" +
                hint + "\n" + conf_name + "\n" + st_date + "\n" + ed_date);
*/
        
        String delims = "[/]";
        String[] sd = st_date.split(delims);
        st_date = sd[2] + "-" + sd[0] + "-" + sd[1];
        String[] ed = ed_date.split(delims);
        ed_date = ed[2] + "-" + ed[0] + "-" + ed[1];
        System.out.println(st_date + "\n" + ed_date);
        
        int lastInsertedId = 0;
        try{
            db_connect cont = new db_connect();
            System.out.println("Connecting to a database...");
            con = cont.connect();
            System.out.println("Connected database successfully...");
            System.out.println("Inserting records into the table...");
            stmt = con.createStatement();

            String sql = "INSERT INTO conference (conf_name,start_date,end_date,address,description) VALUES ('" +
                                conf_name + "','" + st_date + "','" + ed_date + "','" + location + "','" + description + "')";
            System.out.println("Insert statement for conference is : " + sql);
            stmt.executeUpdate(sql);
            
            ResultSet getKeyRs = stmt.executeQuery("SELECT LAST_INSERT_ID()");
            if (getKeyRs != null) {
               if (getKeyRs.next()) {
                   lastInsertedId=getKeyRs.getInt(1);
                }
                getKeyRs.close();
            }
            System.out.println("Last inserted conference ID = " + lastInsertedId);
            
            sql = "INSERT INTO users (user_name,profile_name,password,hint,phno,email,conf_ID,type) VALUES ('" +
              admin_name + "','" + profile_name + "','" + password + "','" + hint + "','" + phno + "','" + email + "','" + lastInsertedId + "','" + "admin" + "')";
            System.out.println("Insert statement for User is : " + sql);
            stmt.executeUpdate(sql);
            
            for(int i=0; i<topics.length; i++){
                sql = "INSERT INTO conf_topics (conf_ID,topic) VALUES ('" +
                        lastInsertedId + "','" + topics[i] + "')";
                System.out.println("Insert statement for a Topic is : " + sql);
                stmt.executeUpdate(sql);
            }
        }
        catch(Exception e){
            System.out.println("Exception occured:" + e);
        }
        PrintWriter out = response.getWriter();
        out.println("Proceeding to Conference Page...");
        String url = "conference.jsp?error=-1&lr=l&cid=" + lastInsertedId;
        System.out.println(url);
        response.sendRedirect(url);
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
