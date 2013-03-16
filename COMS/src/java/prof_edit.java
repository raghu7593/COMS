/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import connect.db_connect;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Vamsi
 */
@WebServlet(name = "prof_edit", urlPatterns = {"/prof_edit"})
public class prof_edit extends HttpServlet {

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
            out.println("<title>Servlet prof_edit</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet prof_edit at " + request.getContextPath() + "</h1>");
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
        //processRequest(request, response);
    String pname,phint,email,phno,pname_ori,email_ori,phno_ori,pname_new,phint_ori,phint_new,email_new,phno_new,pass,pass_ori,pass_new;
        int userid;
        Connection con = null;
        Statement stmt = null;
        
        pname_new = request.getParameter("pname").toString();
        phint_new = request.getParameter("phint").toString();
        phno_new = request.getParameter("phno").toString();
        email_new = request.getParameter("email").toString();
        pass_new = request.getParameter("password").toString();
        userid = Integer.parseInt(request.getParameter("userid"));
        pname_ori = request.getParameter("pname_ori").toString();
        phint_ori = request.getParameter("phint_ori").toString();
        phno_ori = request.getParameter("phno_ori").toString();
        email_ori = request.getParameter("email_ori").toString();
        pass_ori = request.getParameter("password_ori").toString();
        
        if(pname_new.equals("")) {pname = pname_ori;}
        else {pname = pname_new;}
        
        if(pass_new.equals("")) {pass = pass_ori;}
        else {pass = pass_new;}
        
        if(phint_new.equals("")) {phint = phint_ori;}
        else {phint = phint_new;}
        
        if(phno_new.equals("")) {phno = phno_ori;}
        else {phno = phno_new;}
        
        if(email_new.equals("")) {email = email_ori;}
        else {email = email_new;}
        
        try{
            db_connect cont = new db_connect();
            System.out.println("Connecting to a database...");
            con = cont.connect();
            System.out.println("Connected database successfully...");
            System.out.println("Updating user profile...");
            stmt = con.createStatement();
            String sql = "update users set password = '" + pass + "', phno = '" + phno + "', email = '" + email + "', profile_name = '" + pname + "', hint = '" + phint + "' where user_ID = " + userid;
            System.out.println("Update statement for users is : " + sql);
            stmt.executeUpdate(sql);
            String contextpath = request.getContextPath();
            String url = contextpath + "/profile.jsp";
            response.sendRedirect(url) ;
            
        }
        catch(Exception e){
            System.out.println("Exception occured:" + e);
        }
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
