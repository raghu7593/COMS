<%-- 
    Document   : index
    Created on : 1 Nov, 2012, 10:31:59 PM
    Author     : raghuteja
--%>

<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="connect.db_connect"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="check.checkname" %>
<%@ page import="java.io.IOException" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Conference</title>
        <link rel="stylesheet" href="./css/main1.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="./css/conference.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="./css/index.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="./css/reviewer.css" rel="stylesheet" type="text/css"/>
        <script type="text/javascript" charset="utf-8" src="./rating/js/jquery.min.js"></script>
	<script type="text/javascript" charset="utf-8" src="./rating/js/jquery.raty.min.js"></script>
        <script type="text/javascript">
            $(function() {
                    $('.big').raty({
                            half		: true,
                            path		: 'rating/img/',
                            size		: 24,
                            starOff		: 'star-off.png',
                            starOn		: 'star-on.png',
                            starHalf	: 'star-half.png',
                            click: function(score, evt) {
                                alert(score);
                                var paper_ID = $(this).siblings(".paper-ID").val();
                                $.post("rate", { rating: score, paper_ID: paper_ID },
                                function(data) {
                                    alert("You just have rated " + score + "for paper :" + paper_ID);
                                });
                            },
                            score: function() {
                                  return $(this).attr('data-rating');
                            }
                    });
            });
            function comment(id) {
                var com = $("#comment").val();
                $.post("comment", { paper_ID: id,comment:com }, 
                function(data) {
                    alert("Comment added");
                });
            }
        </script>
    </head>
        <body>
    <%  String conf_name=null,rev_name=null,st_date=null,ed_date=null;
        HttpSession s = request.getSession();
        String conf_ID = (String)session.getAttribute("conf_ID").toString();
        String rev_ID = (String)session.getAttribute("userid").toString();
        String type = (String)s.getAttribute("type").toString();
        String status;
         String rev_status = "Inactive";
        if(!type.equals("reviewer")){
        %>
                // redirect to error page ( ^^^ )
        <%
            } else {
                String act = "Select status from rev_status where rev_ID='" + rev_ID + "'";
                System.out.println(conf_ID +" " + rev_ID);
                String sql = "select * from users natural join conference where conf_ID = " + conf_ID + " and user_ID =" + rev_ID;
                Connection con = null;
                Statement stmt = null;
                db_connect cont = new db_connect();
                System.out.println("Connecting to a database...");
                try {
                    con = cont.connect();
                    System.out.println("Connected database successfully...");
                    System.out.println(sql);
                    PreparedStatement prepStmt = null;
                    prepStmt = con.prepareStatement(sql);
        //            prepStmt.setString(1, c_id);
                    ResultSet rs = prepStmt.executeQuery();
                    if(rs.next()) {
                        conf_name = rs.getString("conf_name");
                        rev_name = rs.getString("profile_name");
                        st_date = rs.getString("start_date");
                        ed_date = rs.getString("end_date");
                    }
                 prepStmt = con.prepareStatement(act);
                 rs = prepStmt.executeQuery();
                
                 if(rs.next()) {
                    rev_status = rs.getString("status");
                              }
                } catch (Exception ex) {
                    System.out.println("Execption occured");
                }
            if(rev_status.equals("Active")) {
            %>
                    <div id="header" >
                        <div>
                            <div id="welcome" style="display:inline;">Welcome <%out.println(rev_name);%>!</div>
                            <div style="float:right"><form action="logout" method="post"><button>Log out</button></form></div>
                            <div style="float:right"><button><a href="profile.jsp" style="text-decoration: none; margin-right: 5px;  color: black">Edit Profile</a></button></div>
                            <div style="clear:both"></div>


                        </div>
                        <div id="conf_name"><span id="attr_conf">Conference :</span> <%out.println(conf_name);%> </div>

                        <div id="dates"> 
                            <div id="left"><span id="attr_date">Start Date :</span> <%out.println(st_date);%> </div>
                            <div id="right"><span id="attr_date">End Date :</span> <%out.println(ed_date);%> </div>
                            <div id="clear"></div>
                        </div>
                    </div>
                    <div style="height:16px;"></div>
                    <%
                        
                    %>
                    <div id="body">
                        <div id="body-left" class="fl-left">
                            <div id="body-left-head">Rated Papers</div>
                            <%
                                con = null;
                                stmt = null;
                                ResultSet rs = null;
                                try{
                                    System.out.println("Connecting to a database...");
                                    con = cont.connect();
                                    System.out.println("Connected database successfully...");
                                    String query = "select * from reviews natural join papers where rating is not NULL and rev_ID=" + 
                                            rev_ID  + " order by last_updated DESC";
                                    System.out.println(query);
                                    stmt = con.createStatement();
                                    rs = stmt.executeQuery(query);
                                    int count = 0;
                                    
                                    while( rs.next() ){
                                        %>
                                        <div id="paper_item">
                                            <form action="download" method="post">
                                                <input type="hidden" name="paper_ID" value="<%= rs.getString("paper_ID") %>">
                                                <div id="paper_title" ><button ><%= rs.getString("title") %></button></div>
                                            </form> 
                                            <div id="paper_topic">(<%= rs.getString("topic") %>)</div>
                                            <div class="big" data-rating='<%= rs.getString("rating") %>' style="margin:4px;"></div>
                                            <input class="paper-ID" type="hidden" name="paper-ID" value="<%= rs.getString("paper_ID")  %>" />
                                            <div>
                                            <div style="text-align:left;float:left;"><textarea name="comment" id="comment" style="margin:4px;width:265px; height: 50px;"><%= rs.getString("comment") %> </textarea></div>
                                            <div style="margin:4px;float:right;margin-top:36px;"><input type="submit" value="Edit" class="submit1" onclick="javascript:comment(<%= rs.getString("paper_ID")  %>);"/></div>
                                            <div style="clear:both;"></div>
                                            </div>
                                        </div>
                                        
                                        <%
                                        count++;
                                    }
                                    if(count == 0){
                                        %>
                                        <h4>Nothing is Rated</h4>
                                        <%
                                    }
                                } catch (Exception e) {
                                    System.out.println("Exception occured:" + e);
                                }
                            %>
                        </div>
                        <div id="body-gap" class="fl-left"></div>
                        <div style="height:400px; width:0px; border:1px solid #ccc;float:left;margin-top:50px;"></div>
                        <div id="body-gap" class="fl-left"></div>
                        <div id="body-right" class="fl-right">
                            <div id="body-rit-head">Papers to be rated</div>
                            <%
                                con = null;
                                stmt = null;
                                rs = null;
                                try{
                                    System.out.println("Connecting to a database...");
                                    con = cont.connect();
                                    System.out.println("Connected database successfully...");
                                    String query = "select * from reviews natural join papers where rating is NULL and rev_ID=" + 
                                            rev_ID + " order by last_updated DESC";
                                    stmt = con.createStatement();
                                    rs = stmt.executeQuery(query);
                                    System.out.println(query);
                                    int count = 0;
                                    while( rs.next() ){
                                        %>

                                        <div id="paper_item">
                                            <form action="download" method="post">
                                                <input type="hidden" name="paper_ID" value="<%= rs.getString("paper_ID") %>">
                                                <div id="paper_title" ><button ><%= rs.getString("title") %></button></div>
                                            </form> 
                                            <div id="paper_topic">(<%= rs.getString("topic") %>)</div>
                                            <div class="big" data-rating='<%= rs.getString("rating") %>' style="margin:4px;"></div>
                                            <input class="paper-ID" type="hidden" name="paper-ID" value="<%= rs.getString("paper_ID")  %>" />
                                            <div>
                                            <div style="text-align:left;float:left;"><textarea name="comment" id="comment" style="margin:4px;width:265px; height: 50px;"><%= rs.getString("comment") %> </textarea></div>
                                            <div style="margin:4px;float:right;margin-top:36px;"><input type="submit" value="Edit" class="submit1" onclick="javascript:comment(<%= rs.getString("paper_ID")  %>);"/></div>
                                            <div style="clear:both;"></div>
                                            </div>
                                        </div>
                                        <%
                                        count++;
                                    }
                                    if(count == 0){
                                        %>
                                        <h4>Nothing to Rate</h4>
                                        <%
                                    }
                                } catch (Exception e) {
                                    System.out.println("Exception occured:" + e);
                                }
                            %>
                        </div>
                    </div>
                    <br /><br /><br />
         <% } else{
                            %> <h2> Sorry, the administrator for this conference has yet to accept your request. Please try again after some time </h2>
         <% }}%>
        </body>
</html>