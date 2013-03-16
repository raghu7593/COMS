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
        <link rel="stylesheet" href="./css/main.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="./css/applicant.css" rel="stylesheet" type="text/css"/>
        <script type="text/javascript" charset="utf-8" src="./rating/js/jquery.min.js"></script>
	<script type="text/javascript" charset="utf-8" src="./rating/js/jquery.raty.min.js"></script>
        <script type="text/javascript">
            $(function() {
                    $("#login-error-1").show();
                    $("#login-error-1").fadeOut(4000);
                    $('.big').raty({
                            readOnly            : true,
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
            function store() {
                var title = $("#title").val();
                var topic = $("#topic").val();
                $.post("status", { title: title, topic:topic },
                function(data) {
                });
            }
        </script>
    </head>
        <body>
    <%  String conf_name=null,rev_name=null,st_date=null,ed_date=null;
        HttpSession s = request.getSession();
        String conf_ID = (String)session.getAttribute("conf_ID").toString();
        String app_ID = (String)session.getAttribute("userid").toString();
        String type = (String)s.getAttribute("type").toString();
        String u = request.getParameter("u").toString();
        if(u.equals("1")){ %>
            <div id="login-error-1" class="sixteen columns">
                <div>File Uploaded successfully</div>
            </div>
    <%
        }
        if(!type.equals("applicant")){
        %>
                // redirect to error page ( ^^^ )
        <%
            } else {
                System.out.println(conf_ID +" " + app_ID);
                String sql = "select * from users natural join conference where conf_ID = " + conf_ID + " and user_ID =" + app_ID;
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
                } catch (Exception ex) {
                    System.out.println("Execption occured");
                }
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
                    <div id="body">
                        <div id="body-left" class="fl-left">
                            <div id="body-left-head">Papers Uploaded</div>
                            <%
                                con = null;
                                stmt = null;
                                ResultSet rs = null;
                                try{
                                    System.out.println("Connecting to a database...");
                                    con = cont.connect();
                                    System.out.println("Connected database successfully...");
                                    String query = "select * from reviews natural join papers where app_ID=" + 
                                            app_ID  + " order by last_updated DESC";
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
                                            <textarea name="comment" id="comment" style="margin:4px;width:384px; height: 50px;" readonly="readonly">
                                                <%= rs.getString("comment") %>
                                            </textarea>
                                        </div>
                                        <br><br>
                                        <%
                                        count++;
                                    }
                                    if(count == 0){
                                        %>
                                        <h4>0 Papers Uploaded...</h4>
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
                            <div id="body-rit-head">Upload a paper</div>
                            <FORM ENCTYPE="multipart/form-data" ACTION="upload" METHOD=POST>
                                <div style="font-size:14px;text-align:center;">Choose the file To Upload:</div>
                                <div style="margin:4px;text-align:center;"><INPUT style="width:180px;" NAME="file" TYPE="file" ></div>
                                <div style="text-align:center;margin:8px;"><input type ="text" name="title" id="title" placeholder="Paper Title.."/></div>
                                <div style="text-align:center;margin:8px;"><select style="width:350px;" tabindex="4" name="topic" id="topic">
                                    <option value="">Choose Topic...</option> 
                                    <%
                                        sql = "select * from conf_topics where conf_ID=?";
                                        con = null;
                                        stmt = null;
                                        System.out.println("Connecting to a database...");
                                        try {
                                            con = cont.connect();
                                            System.out.println("Connected database successfully...");
                                            PreparedStatement prepStmt = null;
                                            prepStmt = con.prepareStatement(sql);
                                            prepStmt.setString(1, conf_ID);
                                            rs = prepStmt.executeQuery();
                                            while(rs.next()) {
                                                out.println("<option value='"+rs.getString("topic") + "'>" + rs.getString("topic") + "</option>");
                                            }
                                        } catch (Exception ex) {
                                            System.out.println("Execption occured");
                                        }
                                    %>
                                </select>
                                </div>
                                <div style="text-align:center;margin:8px;"><input type="submit" value="Send File" class="submit1" onclick="javascript:store();"></div>
                            </FORM>
                        </div>
                    </div>
                    <br /><br /><br />
         <% } %>
    </body>
</html>