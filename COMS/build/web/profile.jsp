<%-- 
    Document   : profile
    Created on : 7 Nov, 2012, 7:55:05 PM
    Author     : Vamsi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="./css/main.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="./css/profile.css" rel="stylesheet" type="text/css"/>
        <title>Edit Profile</title>
    </head>
    <body>
         <%@ page import="java.util.*" %>
        <%@ page import="javax.sql.*;" %>
        <%@ page import="connect.db_connect" %>
        <%
           HttpSession s = request.getSession();
           
            String name = (String)s.getAttribute("name");
           String adm_name = (String)s.getAttribute("name");
           String conf_name = (String)s.getAttribute("cname");
           String st_date = (String)s.getAttribute("sdate");
           String ed_date = (String)s.getAttribute("edate");
           //int c_id = (Integer)s.getAttribute("conf_ID");
        %>
        
        
        
        <div id="header" >
                <div>
                    <div id="welcome" style="display:inline;">Welcome <span style="color:blue;"><%out.println(adm_name+'!');%></span></div>
                    <div style="float:right"><form action="logout" method="post"><button>Log out</button></form></div>
                     <div style="clear:both"></div>
                    
                    
                </div>
                <div id="conf_name"><span id="attr_conf">Conference :</span> <%out.println(conf_name);%> </div>
               
                <div id="dates"> 
                    <div id="left"><span id="attr_date">Start Date :</span> <%out.println(st_date);%> </div>
                    <div id="right"><span id="attr_date">End Date :</span> <%out.println(ed_date);%> </div>
                    <div id="clear"></div>
                </div>
            </div>
        <% 
        
         %>      
       
        <%
        
        java.sql.Connection con = null;
        java.sql.PreparedStatement stmt = null;
        java.sql.ResultSet rs = null;
        
        try{
            db_connect cont = new db_connect();
            System.out.println("Connecting to a database...");
            con = cont.connect();
            System.out.println("Connected database successfully...");
            
            String sql = "select * from users where user_name=?";
            stmt = con.prepareStatement(sql);
            stmt.setString(1,name);
            System.out.println("select statement for user is : " + sql);
            rs= stmt.executeQuery();
            rs.next();
            
        %>
        
        <script type="text/javascript">
            function transform_page_for_edit(){
                
                document.getElementById('profile').innerHTML = "<div id=\"profile-head\">Edit Your Profile!</div>"+
                "<div id=\"prof_table_holder\"><form method='post' action='prof_edit' onsubmit='prof_edit'>" + 
                                 "<table id=\"prof_table\" style=\"width:450px;background:#f1f1f1\" cellspacing=\"0px\" cellpadding=\"6px\" border=\"0\"><tr><td id=\"tb_left\" width=\"35%\">Profile Name : </td><td><input type='text' name='pname' size='20' placeholder='<%= rs.getString("profile_name") %>' /></td></tr>" + 
                                 "<tr><td id=\"tb_left\" >Password : </td><td ><input type='text' name='password' size='20' placeholder='<%= rs.getString("password") %>' /></td></tr>" +       
                                 "<tr><td id=\"tb_left\" >Password Hint : </td><td><input type='text' name='phint' size='20' placeholder='<%= rs.getString("hint") %>' /></td></tr>" + 
                                 "<tr><td id=\"tb_left\" >Phone Number : </td><td><input type='text' name='phno' size='20' placeholder='<%= rs.getString("phno") %>' /></td></tr>" +
                                 "<tr><td id=\"tb_left\" >Email : </td><td><input type='text' name='email' size='20' placeholder='<%= rs.getString("email") %>' /></td></tr></table>" +
                                 "<input type='hidden' name='userid' value='<%= rs.getString("user_ID") %>' /><br>" + 
                                 "<input type='hidden' name='pname_ori' value='<%= rs.getString("profile_name") %>' />" +
                                 "<input type='hidden' name='password_ori' value='<%= rs.getString("password") %>' />" + 
                                 "<input type='hidden' name='phint_ori' value='<%= rs.getString("hint") %>' />" + 
                                 "<input type='hidden' name='phno_ori' value='<%= rs.getString("phno") %>' />" +
                                 "<input type='hidden' name='email_ori' value='<%= rs.getString("email") %>' />" +
                                 "<div style=\"text-align:center;\"><input type='submit' class='submit1' value='Save Changes'/></div></form></div>";
                             document.getElementById('profile').innerHTML += "<div style='text-align:center;margin:16px;'><button class='submit1' onclick='location.reload()'>Back</button></div>";
    }    
    </script>
            
            <div id="profile">
                <div id="profile-head">Your Profile!</div>
                <div id="prof_table_holder">
                <table id="prof_table" cellspacing="0px" cellpadding="6px" border="1" >
                    <tr>
                        <td id="tb_left" width="35%">Username : </td>
                        <td><span id="uname"><%= rs.getString("user_name") %></span></td>
                    </tr>
                    <tr>
                        <td id="tb_left">Profile Name : </td>
                        <td><span id="pname"><%= rs.getString("profile_name") %></span></td>
                    </tr>
                    <tr>
                        <td id="tb_left">Password Hint : </td>
                        <td><span id="phint"><%= rs.getString("hint") %></span></td>
                    </tr>
                    <tr>
                        <td id="tb_left">Email Address : </td>
                        <td><span id="email"><%= rs.getString("email") %></span></td>
                    </tr>
                    <tr>
                        <td id="tb_left">Phone Number : </td>
                        <td><span id="phno"><%= rs.getString("phno") %></span></td>
                    </tr>
                
                </table>
                    </div>
                    <div style="text-align:center;margin:16px;"><button class="submit1" onclick="transform_page_for_edit();">Edit Profile</button></div>
                    <div style='text-align:center;margin:16px;'><button class='submit1' onclick='javascript:history.back(-1)'>Back</button></div>
                </div>
            
            
            <%
        }
        catch(Exception e){
            System.out.println("Exception occured:" + e);
        }%>
        
    </body>
</html>
