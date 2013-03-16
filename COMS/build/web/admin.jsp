<%-- 
    Document   : admin
    Created on : 4 Nov, 2012, 2:35:22 AM
    Author     : Vamsi
--%>

<%@page import="connect.db_connect"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin-COMS</title>
        <link rel="stylesheet" href="./css/main.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="./css/admin.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
        <%
           HttpSession s = request.getSession();
           
           String adm_name = (String)s.getAttribute("name");
           String conf_name = (String)s.getAttribute("cname");
           String st_date = (String)s.getAttribute("sdate");
           String ed_date = (String)s.getAttribute("edate");
           String c_id = (String)s.getAttribute("conf_ID");
           System.out.println(c_id);
        %>
        
        
        
        <div id="header" >
                <div>
                    <div id="welcome" style="display:inline;">Welcome <span style="color:blue;"><%out.println(adm_name+'!');%></span></div>
                     <div style="float:right"><form action="logout" method="post"><button>Log out</button></form></div>
                     <div style="float:right"><button><a href="profile.jsp" style="text-decoration: none; margin-right: 5px; color: black">Edit Profile</a></button></div>
                            <div style="clear:both"></div>

                    
                    
                </div>
                <div id="conf_name"><span id="attr_conf">Conference :</span> <%out.println(conf_name);%> </div>
               
                <div id="dates"> 
                    <div id="left"><span id="attr_date">Start Date :</span> <%out.println(st_date);%> </div>
                    <div id="right"><span id="attr_date">End Date :</span> <%out.println(ed_date);%> </div>
                    <div id="clear"></div>
                </div>
            </div>
        
                    <hr>
                
        <%

         String QUERY1 = "select topic,title,reviews.paper_ID,rev.user_name,app.user_name,rating from papers,users as rev, users as app, reviews where papers.paper_ID = reviews.paper_ID and rev_ID = rev.user_ID and app_ID = app.user_ID and reviews.conf_ID="+c_id + " order by rating desc" ;
         String QUERY2 = "select rev_ID,status,user_name from rev_status,users where rev_status.rev_ID = users.user_ID and rev_status.status='Inactive' and users.conf_ID="+c_id + " order by rev_ID desc" ;
         String QUERY3 = "select rev_ID,status,user_name from rev_status,users where rev_status.rev_ID = users.user_ID and rev_status.status='Declined' and users.conf_ID="+c_id+" order by rev_ID desc";
         Connection con;
         con = null;
        try {
        db_connect x = new db_connect();
        con = x.connect();
        ResultSet rs = null;
        PreparedStatement prepStmt = null;
       
        
        %>
        <div id="body">
        <div id="body-left">
        <div id="p_reqs">
            <div id="bl-head">Pending Requests</div>
            <%
       prepStmt = con.prepareStatement(QUERY2);
       rs = prepStmt.executeQuery();
  if(!rs.next()) %> <p style="text-align:center;">No pending requests to display. </p> <%
        rs.previous();
        while(rs.next()) {
            %>
            <div class="rev" id="prv-item">
               <%
            int id = rs.getInt("rev_ID");
            String name1 = rs.getString("user_name");
           // out.println(id);
             %>
            <div id="rv-name">Rev Name: <%
            out.println(name1);
            %></div>
            <div style="width:200px; margin:auto;">
            <form action="accept_rev" name="frmLogin" method="post" onsubmit="accept_rev;" style="float: left">
                <input name="rev_id" size=15 type="hidden" value ="<%out.println(id);%>" float="left"/>
                <input name="url" size=15 type="hidden" value ="pending_reqs.jsp" float="left"/>
                <input type="submit" class="submit1" style="width:60px;" value="Accept"/>
            </form>
            <form action="decline_rev" name="frmLogin" method="post" onsubmit="decline_rev;" style="float:right">
                <input name="rev_id" size=15 type="hidden" value ="<%out.println(id);%>" float="left"/>
                <input name="url" size=15 type="hidden" value ="pending_reqs.jsp" float="left"/>
                <input type="submit" class="submit1" style="width:60px;" value="Decline"/>
            </form>
                
                <div style="clear:both"></div>
            </div>
            </div>
            
            <% }
                %>
           </div>
           
            <div id="d_reqs">
              <div id="bl-head">Declined Requests</div>
            <%
        prepStmt = con.prepareStatement(QUERY3);
        
        rs = prepStmt.executeQuery();
            if(!rs.next()) %> <p  style="text-align:center;">No declined requests to display. </p> <%
            rs.previous();
        while(rs.next()) {
            %>
            <div class="rev" id="drv-item">
                <%
            int id = rs.getInt("rev_ID");
            String name1 = rs.getString("user_name");
            //out.println(id);
             %>
            <div id="rv-name">Rev Name: <%
            out.println(name1);
            %></div>
            <div style="text-align:center;">
            <form action="accept_rev" name="frmLogin" method="post" onsubmit="accept_rev;">
                <input name="rev_id" size=15 type="hidden" value ="<%out.println(id);%>" float="left"/>
                 <input name="url" size=15 type="hidden" value ="declined_requests.jsp" float="left"/>
                 <input type="submit" class="submit1"  style="width:60px;height:20px;" value="Accept"/>
            </form>
                 </div>
            </div>
            
            <% }
            %>
          </div>
          
          </div>
          
          <div id="body-right">
          <div id="rating"> 
              <div id="br-head">Papers and Ratings</div>
        <%
             prepStmt = con.prepareStatement(QUERY1);
         rs = prepStmt.executeQuery();
        if(!rs.next()) %> <p>No papers to show. </p> <%
        rs.previous();
        while(rs.next()) {
        int id = rs.getInt("reviews.paper_ID");
        String rev = rs.getString("rev.user_name");
        String app = rs.getString("app.user_name");  
        String title = rs.getString("title");
        String topic = rs.getString("topic");
        int rating = rs.getInt("rating");
        %>
        <div id="paper-item" >
            <div style="text-align:center"><span style="color:#4d0015;"> <%
                out.println(title);
                            %></span><br>
                    ( <%
                out.println(rev);
                            %>)
            </div>
            <div><span style="color:#7d4900;margin:4px;">Applicant: </span><%
                out.println(app);
                            %></div>
             
                            <div style="margin:4px;">Rating: <%
                out.println(rating);
             %> ( By <%
                out.println(rev);
                            %>)</div></div>
        <% }
        %>
    
        </div>
         </div>   
         
          <%
                
                   }catch(Exception e){
                       System.out.println("Error: "+e.getMessage());
                   }
%>   
         
         </div>
      
    </body>
</html>