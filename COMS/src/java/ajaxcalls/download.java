/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ajaxcalls;

import connect.db_connect;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author raghuteja
 */
@WebServlet(name = "download", urlPatterns = {"/download"})
public class download extends HttpServlet {

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
            out.println("<title>Servlet download</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet download at " + request.getContextPath() + "</h1>");
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
 //       processRequest(request, response);
        String paperid = request.getParameter("paper_ID").toString();
        System.out.println(paperid);
        Connection con = null;
        Statement stmt= null;
        ResultSet res = null;
        response.setContentType("application/octet-stream");
         
             db_connect cont = new db_connect();
             System.out.println("Connecting to a database...");
        try {
            con = cont.connect();
            stmt=con.createStatement();
            String sql = "select * from papers where paper_ID='" + paperid + "'";
            System.out.println(sql);
             res =stmt.executeQuery(sql);
        } catch (Exception ex) {
            Logger.getLogger(download.class.getName()).log(Level.SEVERE, null, ex);
        }
              Blob blob = null;
        try {
            if(res.next()){
      try {
          System.out.println(res.getString("paper_ID"));
          blob = res.getBlob("paper");
          System.out.println((int) blob.length());
          byte[] bFile = new byte[(int) blob.length()];
          
          //to server
          File image = new File("/home/raghuteja/Desktop/test.txt");
                FileOutputStream fos = new FileOutputStream(image);
                
                 InputStream is = res.getBinaryStream("paper");
                while (is.read(bFile) > 0) {
                    fos.write(bFile);
                }
 
                fos.close();
          
    
          
          
          
          //To client
          response.setContentType( "text/plain" );
          response.setHeader("Content-Disposition","attachment; filename=\""+"paper"+"\"");
            response.setHeader("cache-control", "no-cache");
            response.setHeader("cache-control", "must-revalidate");
          ServletOutputStream outs = response.getOutputStream();
            outs.write(bFile);
            outs.flush();
            outs.close();
          

          System.out.println("Done");
      } catch (SQLException ex) {
          Logger.getLogger(download.class.getName()).log(Level.SEVERE, null, ex);
      }
            }
        } catch (SQLException ex) {
            Logger.getLogger(download.class.getName()).log(Level.SEVERE, null, ex);
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
