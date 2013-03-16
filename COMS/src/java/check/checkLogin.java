/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
import connect.db_connect;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
@WebServlet(name = "checkLogin", urlPatterns = {"/checkLogin"})
public class checkLogin extends HttpServlet {

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
    private static final String LOGIN_QUERY = "select * from users where user_name=? and password=? and conf_ID=?";
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            /* TODO output your page here. You may use following sample code. */
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet checkLogin</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet checkLogin at " + request.getContextPath() + "</h1>");
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
            String strUserName;
            strUserName = request.getParameter("username").toString();
            String strPassword = request.getParameter("password").toString();
            System.out.println(strUserName);
            String strErrMsg = null;
            HttpSession session = request.getSession();
            String conf_ID = (String)session.getAttribute("conf_ID");
            boolean isValidLogon = false;
            try {
            isValidLogon = authenticateLogin(strUserName, strPassword,conf_ID,request);
            if(isValidLogon) {
            session.setAttribute("userName", strUserName);
            } else {
                strErrMsg = "User name or Password is invalid. Please try again.";
            }
            } catch(Exception e) {
            strErrMsg = "Unable to validate user / password in database";
            }
 
            if(isValidLogon) {
                String type = session.getAttribute("type").toString();
                
                if(type.equals("reviewer")) { response.sendRedirect("reviewer.jsp"); }
                else if(type.equals("admin")) { response.sendRedirect("admin.jsp"); }
                else if(type.equals("applicant")){ response.sendRedirect("applicant.jsp?u"); }
                else {
                    session.setAttribute("Notavaliduser", strErrMsg);
                    response.sendRedirect("error.jsp");
                }
            } else {
                session.setAttribute("errorMsg", strErrMsg);
                    response.sendRedirect("conference.jsp?error=1&lr=l&cid=" + conf_ID);
            }
    }
    

    private boolean authenticateLogin(String strUserName, String strPassword,String conf_ID,HttpServletRequest request) throws Exception {
        boolean isValid = false;
        Connection con;
        con = null;
       try {
        db_connect cont = new db_connect();
        System.out.println("Connecting to a database...");
        con = cont.connect();
        System.out.println("Connected database successfully...");
        PreparedStatement prepStmt = con.prepareStatement(LOGIN_QUERY);
        prepStmt.setString(1, strUserName);
        prepStmt.setString(2, strPassword);
        prepStmt.setString(3, conf_ID);
        ResultSet rs = prepStmt.executeQuery();
        System.out.println(strUserName + strPassword + conf_ID);
        if(rs.next()) {
        System.out.println("User login is valid in DB");
        isValid = true; 
        HttpSession session = request.getSession();
        String type = rs.getString("type");
        String name = rs.getString("user_name");
        int userid = rs.getInt("user_ID");
        session.setAttribute("type", type);
        session.setAttribute("userid", userid);
        session.setAttribute("name", name);
         System.out.println(type);
          }
} catch(Exception e) {
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
