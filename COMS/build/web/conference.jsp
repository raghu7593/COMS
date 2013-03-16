<%-- 
    Document   : index
    Created on : 1 Nov, 2012, 10:31:59 PM
    Author     : Vamsi
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
        <link rel="stylesheet" href="./css/conference.css" rel="stylesheet" type="text/css"/>
        <script src="./plugins/jquery/jquery-latest.js"></script>
        <link rel="stylesheet" href="./plugins/chosen/chosen.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="./css/conferance.css" rel="stylesheet" type="text/css"/>
        <link href="./plugins/jquery/jquery-ui.css" rel="stylesheet" type="text/css"/>
        <script src="./plugins/jquery/jquery.min.js"></script>
        <script src="./plugins/jquery/jquery-ui.min.js"></script>
        <script src="./plugins/chosen/chosen.jquery.js" type="text/javascript"></script>
        <script src="./js/conference.js" type="text/javascript"></script>
        <script>
            function isname(){
                var uname = $('#username').val();
                if(uname != "") {
                    $.get('chk_usrnm?name=' + uname, function(data) {
                        if(data == 1){
                            alert("Username already exists in Database...");
                            $('#username').val("");
                        }
                    });
                }
            }
            function validate() {
                var user_name = $('#username').val();
                var password = $('#password').val();
                var repassword = $('#re-password').val();
                var password_hint = $('#password-hint').val();
                var profile_name = $('#profile-name').val();
                var phno = $('#phno').val();
                var email = $('#email').val();
                if(user_name == ""){
                        alert("Enter a valid user name");
                        return false;
                }
                if(profile_name == ""){
                        alert("Enter a valid profile name");
                        return false;
                }
                if(password == ""){
                        alert("Enter a valid password");
                        return false;
                }
                if(repassword != password){
                        alert("Passwords didnot match");
                        return false;
                }
                if(password_hint == ""){
                        alert("Enter a valid Password hint");
                        return false;
                }
                if(phno == ""){
                        alert("Enter a valid Phone Number");
                        return false;
                }
                if(email == ""){
                        alert("Enter a valid Email Address");
                        return false;
                }
                return true;
            }
            
            $(document).ready(function() {
                $("#login-error").show();
                $("#login-error").fadeOut(4000);
                $("#login-error-1").show();
                $("#login-error-1").fadeOut(4000);
                $("#reviewer").hide();
                $('#ar').change(function() {
                    var a = $(this).val();
                    if(a == "reviewer") {
                        $("#reviewer").show();
                       
                    } else {
                        $("#reviewer").hide();
                        
                    }
                });
            });
        </script>

    </head>
        <body>
    <% String c_id = request.getParameter("cid").toString();
        String error = request.getParameter("error").toString();
        String lr = request.getParameter("lr").toString();
    if(error.equals("1")){ %>
            <div id="login-error" class="sixteen columns">
                <div>Username/password is incorrect</div>
            </div>
            <%
        }
    if(error.equals("-1")){ %>
            <div id="login-error-1" class="sixteen columns">
                <div>Details have been added, Login below</div>
            </div>
            <%
        }
       if(c_id == null || c_id == "") {
           %>
           <h1>Sorry, you have not given a conference name </h1>
           <%
           }
           else {
              HttpSession s = request.getSession();
            checkname t= new checkname();
            if(t.authenticateName(c_id.toString(),s)){
            %>
            <%
            s.setAttribute("conf_ID",c_id);
            String name = (String)s.getAttribute("cname");
                String sdate = (String)s.getAttribute("sdate");
                    String edate = (String)s.getAttribute("edate");
            %>
            <div id="header" >
                <div id="welcome">Welcome!</div>
                <div id="conf_name"><span id="attr_conf">Conference :</span> <%out.println(name);%> </div>
               
                <div id="dates"> 
                    <div id="left"><span id="attr_date">Start Date :</span> <%out.println(sdate);%> </div>
                    <div id="right"><span id="attr_date">End Date :</span> <%out.println(edate);%> </div>
                    <div id="clear"></div>
                </div>
            </div>
                    <div id="reglog">
                        
                        <div id="left" class="reglogit"><p>Wanna be a part of this conference?</p><a href="conference.jsp?error&cid=<%out.println(c_id);%>&lr=r">Register</a></div>
                        <div id="right" class="reglogit""><p>Already a part of this conference?</p><a href="conference.jsp?error&cid=<%out.println(c_id);%>&lr=l">Login</a></div>
                        <div id="clear"></div>
                    </div>
            <br>
            <% if(lr.equals("l")){ %>
        <center>
            <div id="login" >
                <form action="checkLogin" name="frmLogin" method="post" onsubmit="checkLogin">
                    <div class="contain">
                        <fieldset>
                            <h3 style="text-align:center">Login to the conference</h3>
                            <br />
                            <table>
                                <tr>
                                    <td class="conf"> <input name="username" size=15 type="text" placeholder="User Name"/> </td> 
                                </tr>
                                <tr>
                                    <td class="conf"> <input name="password" size=15 type="password" placeholder="Password"/> </td> 
                                </tr>
                                <tr>
                                    <td class="conf"><input class="submit" type="submit" value="Login"/></td>
                                </tr>
                            </table>
                            <br />
                        </fieldset>
                    </div>
                </form>
            </div>
            <% } else if(lr.equals("r")) { %>
            <div id="register">
                <form method="post" action="conference"  onsubmit="javascript:return validate();">
                    <div class="contain">
                            <br />
                            <fieldset>
                                <h3 style="text-align:center;">Register for conference</h3>
                                    <br />
                                    <table>
                                        <tr>
                                            <td class="conf">
                                                <select name="ar" id="ar" style="width:315px;height:29px;">
                                                  
                                                     <option value="applicant" >Applicant</option>
                                                     <option value="reviewer" >Reviewer</option>
                                                
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                                <td class="conf"><input type="text" name="username" id="username" placeholder="User Name..." onchange="javascript:isname();"/></td>
                                        </tr>
                                        <tr>
                                                <td class="conf"><input type="text" name="profile-name" id="profile-name" placeholder="Profile Name..." /></td>
					</tr>
                                        <tr>
                                                <td class="conf"><input type="password" name="password" id="password" placeholder="Password "/></td>
                                        </tr>
                                        <tr>
                                                <td class="conf"><input type="password" name="re-password" id="re-password" placeholder="Retype Password..."/></td>
                                        </tr>
                                        <tr>
                                                <td class="conf"><input type="text" name="password-hint" id="password-hint" placeholder="Choose a Password Hint..."/></td>
                                        </tr>
                                        <tr>
                                            <td class="conf"><input type="text" name="phno" id="phno" placeholder="Phone Number..." /></td>
                                        </tr>
                                        <tr>
                                            <td class="conf"><input type="text" name="email" id="email" placeholder="Email Address..." /></td>
                                        </tr>
                                        <tr>
                                                <td class="conf" id="reviewer">
                                                        <select data-placeholder="Choose Topics..." class="chzn-select" multiple style="width:350px;" tabindex="4" name="topics" id="topics">
                                                            <option value=""></option> 
                                                            <%
                                                                String sql = "select * from conf_topics where conf_ID=?";
                                                                Connection con = null;
                                                                Statement stmt = null;
                                                                db_connect cont = new db_connect();
                                                                System.out.println("Connecting to a database...");
                                                                try {
                                                                    con = cont.connect();
                                                                    System.out.println("Connected database successfully...");
                                                                    PreparedStatement prepStmt = null;
                                                                    prepStmt = con.prepareStatement(sql);
                                                                    prepStmt.setString(1, c_id);
                                                                    ResultSet rs = prepStmt.executeQuery();
                                                                    while(rs.next()) {
                                                                        out.println("<option value='"+rs.getString("topic") + "'>" + rs.getString("topic") + "</option>");
                                                                    }
                                                                } catch (Exception ex) {
                                                                    System.out.println("Execption occured");
                                                                }
                                                            %>
                                                        </select>
                                                </td>
                                        </tr>
                                        <tr></tr><tr></tr><tr></tr><tr></tr>
                                        <tr>
                                                <td class="conf"><input class="submit" type="submit" value="Join Conference"></td>
                                        </tr>
                                    </table>
                                    <br />
                            </fieldset>
                    <script type="text/javascript"> $(".chzn-select").chosen(); $(".chzn-select-deselect").chosen({allow_single_deselect:true}); </script>
                    </div>
		</form>
            </div>
        </center>
        
        
        
         <%
                } else {
                    //Reload to error page
                }
            }
            else{
         %>
         <p>Sorry.. The conference with id <%out.println(c_id);%> doesn't exist</p>
             <% 
             }
             }
             %>
    </body>
</html>