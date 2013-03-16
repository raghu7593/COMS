/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package insert;

import connect.db_connect;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.*;
import java.util.logging.*;
import java.util.logging.Level;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

/**
 *
 * @author raghuteja
 */
@WebServlet(name = "upload", urlPatterns = {"/upload"})
public class upload extends HttpServlet {

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
            out.println("<title>Servlet upload</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet upload at " + request.getContextPath() + "</h1>");
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
       response.setContentType("text/html");
     PrintWriter out = response.getWriter();

    String saveFile="";
    String contentType = request.getContentType();
    if((contentType != null)&&(contentType.indexOf("multipart/form-data") >= 0)){
    DataInputStream in = new DataInputStream(request.getInputStream());
    int formDataLength = request.getContentLength();
    byte dataBytes[] = new byte[formDataLength];
    int byteRead = 0;
    int totalBytesRead = 0;
    while(totalBytesRead < formDataLength){
    byteRead = in.read(dataBytes, totalBytesRead,formDataLength);
    totalBytesRead += byteRead;
   }
    String file = new String(dataBytes);
    saveFile = file.substring(file.indexOf("filename=\"") + 10);
    saveFile = saveFile.substring(0, saveFile.indexOf("\n"));
    saveFile = saveFile.substring(saveFile.lastIndexOf("\\") + 1,saveFile.indexOf("\""));
    int lastIndex = contentType.lastIndexOf("=");
    String boundary = contentType.substring(lastIndex + 1,contentType.length());
    int pos;
    pos = file.indexOf("filename=\"");
    pos = file.indexOf("\n", pos) + 1;
    pos = file.indexOf("\n", pos) + 1;
    pos = file.indexOf("\n", pos) + 1;
    int boundaryLocation = file.indexOf(boundary, pos) - 4;
    int startPos = ((file.substring(0, pos)).getBytes()).length;
    int endPos = ((file.substring(0, boundaryLocation)).getBytes()).length;
    File ff = new File(saveFile);
    FileOutputStream fileOut = new FileOutputStream(ff);
    fileOut.write(dataBytes, startPos, (endPos - startPos));
    fileOut.flush();
    fileOut.close();
    out.println("You have successfully upload the file:"+saveFile);
    Connection connection = null;
    ResultSet rs = null;
    PreparedStatement psmnt = null;
    FileInputStream fis;
    
    HttpSession session = request.getSession();
    String confid = (String)session.getAttribute("conf_ID").toString();
    String appid = (String)session.getAttribute("userid").toString();
    String title = (String)session.getAttribute("title").toString();
    String topic = (String)session.getAttribute("topic").toString();
    
    System.out.println(confid + "----" + appid + "----" + title + "----" + topic);
    
    db_connect cont = new db_connect();
        System.out.println("Connecting to a database...");
        try {
                try {
                    connection = cont.connect();
                } catch (Exception ex) {
                    Logger.getLogger(upload.class.getName()).log(Level.SEVERE, null, ex);
                }
                System.out.println("Connected database successfully...");
                File f = new File(saveFile);
                try {
                    psmnt = connection.prepareStatement("insert into papers(title,topic,app_ID,conf_ID,paper) values('" + title + "','" + topic + "','" + appid + "','" + confid + "',?)");
                } catch (SQLException ex) {
                    Logger.getLogger(upload.class.getName()).log(Level.SEVERE, null, ex);
                }
                fis = new FileInputStream(f);
                try {
                    psmnt.setBinaryStream(1, (InputStream)fis, (int)(f.length()));
                } catch (SQLException ex) {
                    Logger.getLogger(upload.class.getName()).log(Level.SEVERE, null, ex);
                }
                int s;
                s = 0;
                try {
                    s = psmnt.executeUpdate();
                } catch (SQLException ex) {
                    Logger.getLogger(upload.class.getName()).log(Level.SEVERE, null, ex);
                }
                if(s>0){
                System.out.println("Uploaded successfully !");
                
                int lastInsertedId = 0;
                Statement stmt = null;
                PreparedStatement pss = connection.prepareStatement("select paper_id from papers order by paper_id desc limit 1");
                ResultSet getKeyRs = pss.executeQuery();
                System.out.println("-----------here-----------");
                if (getKeyRs.next()) {
                    lastInsertedId=getKeyRs.getInt(1);
                 }
                System.out.println("Last inserted conference ID = " + lastInsertedId);
 
                
                String assign = "SELECT num_papers.rev_ID, num_papers FROM num_papers,rev_topics,users where num_papers.rev_ID = rev_topics.rev_ID and num_papers.rev_ID = users.user_ID and topic ='" + topic + "' and users.conf_ID = '" + confid + "' order by num_papers limit 1";
                PreparedStatement ps = connection.prepareStatement(assign);
                rs = ps.executeQuery();
                if(rs.next()) {
                    String rev_id = rs.getString("rev_ID");
                    int num_papers = rs.getInt("num_papers") + 1;
                    String update = "update num_papers set num_papers = " + num_papers + " where rev_ID = '" + rev_id + "'";
                    PreparedStatement ps1;
                    ps1 = connection.prepareStatement(update);
                    ps1.executeUpdate();
                    String push = "INSERT INTO reviews(rev_ID, paper_ID, conf_ID) VALUES (?,?,?)";
                    ps1 = connection.prepareStatement(push);
                    ps1.setString(1,rev_id);
                    ps1.setInt(2,lastInsertedId);
                    ps1.setString(3,confid);
                    System.out.println(push);
                    ps1.executeUpdate();
                }
                response.sendRedirect("applicant.jsp?u=1");
                }
                else{
                System.out.println("Error!");
                }
                
            }
            catch (Exception ex) {
                System.out.println("Exception occured");
            }
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
