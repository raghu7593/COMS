<%-- 
    Document   : index
    Created on : Nov 2, 2012, 10:08:39 PM
    Author     : RAGHUTEJA
--%>

<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.*"%>
<%@page import="java.text.DateFormat"%>
<%@page import="connect.db_connect"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="connect.db_connect"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Conference</title>
        <script src="./plugins/jquery/jquery-latest.js"></script>
        <link rel="stylesheet" href="./css/main.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="./plugins/chosen/chosen.css" rel="stylesheet" type="text/css"/>
        <link href="./plugins/jquery/jquery-ui.css" rel="stylesheet" type="text/css"/>
        <link href="./css/search.css" rel="stylesheet" type="text/css"/>
        <script src="./plugins/jquery/jquery.min.js"></script>
        <script src="./plugins/jquery/jquery-ui.min.js"></script>
        <script src="./plugins/chosen/chosen.jquery.js" type="text/javascript"></script>
        <script src="./js/conference.js" type="text/javascript"></script>
        <script type="text/javascript">
            $(document).ready(function() {
                $("#conf").show();
                $('#type').change(function() {
                    var a = $(this).val();
                    if(a == "conference") {
                        $("#conf").show();
                        $("#topic").hide();
                    } else {
                        $("#conf").hide();
                        $(".result").hide();
                        $("#topic").show();
                    }
                });
                $("#conf-search").keyup(function(){
                    var search_term = $(this).attr("value");
                    $.post('search', {conference:search_term}, function(data) {
                        $('.result').html(data);
                        $('.result li').click(function() {
                            var result_value = 	$(this).text();
                            $('#conf-search').attr('value',result_value);
                            $('.result').html('');
			});
                    });
                });
            });
        </script>
    </head>
    <body>
        <div id="drop-down" ></div>
        <div id="header">
            <div class="head-elem" style="font-size:36px;">COMS</div>
            <div class="head-elem" style="font-size:12px;">
                A one-stop solution for all your conference-management troubles
            </div>
        </div>
        <div id="search">
        <form action="search.jsp" method="get" >
            <div class="fl-left" style="width:20px;height:4px"></div>
            <div class="fl-left">
                <select name="type" id="type" style="width:200px;height:29px;">
                <option value="conference" >By conference</option>
                <option value="topic" >By Topic</option>
            </select>
            </div>
            <div class="fl-left" style="width:50px;height:4px"></div>
            <div class="fl-left">
            <div id="conf"  style="display:block;">
                <input type="text" id="conf-search" name="conference" placeholder=" Enter a conference name..." style="width:342px; height:19px;margin-bottom:5px;"/>
            </div>
            <div id="topic"  style="display:none;">
                
                <select data-placeholder="Choose Topics..." class="chzn-select" multiple style="width:350px;" tabindex="4" name="topics" id="topics">
                    <option value=""> Choose a topic...</option> 
                    <option value="Aeronautical and Aerospace Structures">Aeronautical and Aerospace Structures</option>
                    <option value="Applied Probability">Applied Probability</option>
                    <option value="Bayesian Methods">Bayesian Methods</option>
                    <option value="Biomechanics and Bioengineering">Biomechanics and Bioengineering</option>
                    <option value="Bridges, Buildings and Industrial Facilities">Bridges, Buildings and Industrial Facilities</option>
                    <option value="Climate Change">Climate Change</option>
                    <option value="Computational Methods">Computational Methods</option>
                    <option value="Damage Analysis and Assessment">Damage Analysis and Assessment</option>
                    <option value="Deterioration Modeling">Deterioration Modeling</option>
                    <option value="Earthquake Engineering">Earthquake Engineering</option>
                    <option value="Environmental Risk Assessment">Environmental Risk Assessment</option>
                    <option value="Fatigue and Fracture">Fatigue and Fracture</option>
                    <option value="Flood Analysis and Prevention">Flood Analysis and Prevention</option>
                    <option value="Fuzzy and Interval Analysis">Fuzzy and Interval Analysis</option>
                    <option value="Geographical Information Systems Based Risk Analysis">Geographical Information Systems Based Risk Analysis</option>
                    <option value="Geotechnical Engineering and Geomechanics">Geotechnical Engineering and Geomechanics</option>
                    <option value="Geostatistics">Geostatistics</option>
                    <option value="Hazards Analysis">Hazards Analysis</option>
                    <option value="Human Factors">Human Factors</option>
                    <option value="Inspection, Quality Control and Assurance">Inspection, Quality Control and Assurance</option>
                    <option value="Insurance, Reinsurance, and Management of Risk">Insurance, Reinsurance, and Management of Risk</option>
                    <option value="Life Cycle Performance Analysis and Cost">Life Cycle Performance Analysis and Cost</option>
                    <option value="Life Extension">Life Extension</option>
                    <option value="Lifeline Risk Assessment">Lifeline Risk Assessment</option>
                    <option value="Loads and Load Combinations">Loads and Load Combinations</option>
                    <option value="Loss Analysis">Loss Analysis</option>
                    <option value="Materials">Materials</option>
                    <option value="Monitoring and Maintenance Systems">Monitoring and Maintenance Systems</option>
                    <option value="Multicriteria Optimization">Multicriteria Optimization</option>
                    <option value="Nuclear Structures">Nuclear Structures</option>
                    <option value="Offshore and Marine Structures">Offshore and Marine Structures</option>
                    <option value="Optimization under Uncertainty">Optimization under Uncertainty</option>
                    <option value="Passive and Active Structural Control">Passive and Active Structural Control</option>
                    <option value="Performance-Based Engineering">Performance-Based Engineering</option>
                    <option value="Probabilistic Materials Analysis">Probabilistic Materials Analysis</option>
                    <option value="Probabilistic Risk Analysis">Probabilistic Risk Analysis</option>
                    <option value="Probability and Statistics (theory and applications)">Probability and Statistics (theory and applications)</option>
                    <option value="Random Vibration (linear and nonlinear)">Random Vibration (linear and nonlinear)</option>
                    <option value="Reliability-Based Design and Regulations">Reliability-Based Design and Regulations</option>
                    <option value="Reliability-Based Optimization and Control">Reliability-Based Optimization and Control</option>
                    <option value="Reliability Theory">Reliability Theory</option>
                    <option value="Resilience of Structures, Networks and Communities">Resilience of Structures, Networks and Communities</option>
                    <option value="Risk Analysis and Risk-Informed Decision Making">Risk Analysis and Risk-Informed Decision Making</option>
                    <option value="Risk Perception and Communication">Risk Perception and Communication</option>
                    <option value="Simulation Methods">Simulation Methods</option>
                    <option value="Social Science / Urban Planning">Social Science / Urban Planning</option>
                    <option value="Statistical Design Analysis">Statistical Design Analysis</option>
                    <option value="Stochastic Computational Mechanics">Stochastic Computational Mechanics</option>
                    <option value="Stochastic Finite Elements">Stochastic Finite Elements</option>
                    <option value="Stochastic Fracture Mechanics">Stochastic Fracture Mechanics</option>
                    <option value="Stochastic Processes and Fields (theory and applications)">Stochastic Processes and Fields (theory and applications)</option>
                    <option value="Structural Health Monitoring">Structural Health Monitoring</option>
                    <option value="Structural Systems">Structural Systems</option>
                    <option value="Sustainability under Global Warming">Sustainability under Global Warming</option>
                    <option value="System Identification">System Identification</option>
                    <option value="System Reliability">System Reliability</option>
                    <option value="Transportation Systems">Transportation Systems</option>
                    <option value="Uncertainty Quantification and Analysis">Uncertainty Quantification and Analysis</option>
                    <option value="Wind Engineering">Wind Engineering</option>
                </select>
                <script type="text/javascript"> $(".chzn-select").chosen(); $(".chzn-select-deselect").chosen({allow_single_deselect:true}); </script>
            </div>
                <div id="drop-down" ><ul class="result" ></ul></div>
        </div>
            <div class="fl-left" style="width:50px;height:4px"></div>
            <div class="fl-left">
            <input type="submit" class="submit" value="search" style="height:29px;width:100px;"/>
            </div>
            <div class="fl-clear"></div>
        </form>
        </div>
        <div style="height:16px;"></div>
        <div id="body-left" >
                <div id="body-left-head">Search Results</div>
                
                
                
                <%
            if(request.getParameter("type") != null){
                String type = request.getParameter("type").toString();
                if(type.equals("conference")){
                    if(request.getParameter("conference") != null){
                        String name = request.getParameter("conference").toString();
                        name.replace(" ", "%");
                        name = "%" + name + "%";
                        Connection con = null;
                        db_connect cont = new db_connect();
                        System.out.println("Connecting to a database...");
                        con = cont.connect();
                        System.out.println("Connected database successfully...");
                        String sql = "select * from conference natural join users where type='admin' and conf_name LIKE ?";
                        PreparedStatement prepStmt = con.prepareStatement(sql);
                        prepStmt.setString(1, name);
                        ResultSet rs = prepStmt.executeQuery();
                        int i = 0;
                        while(rs.next()) {
                            String link = "conference.jsp?error&lr=l&cid=" + rs.getString("conf_ID");
                            String conf_name = rs.getString("conf_name");
                            String st_date = rs.getString("start_date");
                            String ed_date = rs.getString("end_date");
                            String location = rs.getString("address");
                            String admin = rs.getString("profile_name");
                            out.println("<a id='conf-link' href='" + link +"'><div id='conf-item'>");
                            out.println("<div id='conf-name'>" + conf_name +"</div>");
                            out.println("<div id='conf-det'>");
                            out.println("<div class='fl-left' id='conf-det-lit'><span style='color:blue'>Start:</span>" + st_date +"</div> ");
                            out.println("<div class='fl-right' id='conf-det-rit'><span style='color:blue'>End:</span>" + ed_date +"</div>");
                            out.println("<div class='fl-clear'></div>");
                            out.println("</div>");
                            out.println("<div id='conf-det'>");
                            out.println("<div id='conf-det-lit' class='fl-left'><span style='color:blue'>Location:</span>" + location + "</div> ");
                            out.println("<div id='conf-det-rit' class='fl-right'><span style='color:blue'>Admin:</span>" + admin + "</div>");
                            out.println("<div class='fl-clear'></div>");
                            out.println("</div>");
                            out.println("</div>");
                            out.println("</a>");
                            i++;
                        }
                        if(i == 0) out.println("No results found");
                    }
                    else {
                        out.println("Enter the value of Conference Name in Search field");
                    }
                }
                else if(type.equals("topic")){
                    String[] topics = request.getParameterValues("topics");
                    String t = "(";
                    int i = 0;
                    for(i=0; i<topics.length-1; i++){
                        t = t + "'" + topics[i] + "',";
                    }
                    t = t + "'" + topics[i] + "')";
                    System.out.println(t);
                    Connection con = null;
                    db_connect cont = new db_connect();
                    System.out.println("Connecting to a database...");
                    con = cont.connect();
                    System.out.println("Connected database successfully...");
                    String sql = "select distinct * from (conference natural join conf_topics) natural join users where type='admin' and topic IN " + t ;
                    PreparedStatement prepStmt = con.prepareStatement(sql);
                    System.out.println(sql);
//                    prepStmt.setString(1, t);
                    ResultSet rs = prepStmt.executeQuery();
                    i = 0;
                    while(rs.next()) {
                        String link = "conference.jsp?error&lr=l&cid=" + rs.getString("conf_ID");
                        String conf_name = rs.getString("conf_name");
                        String st_date = rs.getString("start_date");
                        String ed_date = rs.getString("end_date");
                        String location = rs.getString("address");
                        String admin = rs.getString("profile_name");
                        out.println("<a id='conf-link' href='" + link +"'><div id='conf-item'>");
                        out.println("<div id='conf-name'>" + conf_name +"</div>");
                        out.println("<div id='conf-det'>");
                        out.println("<div class='fl-left' id='conf-det-lit'><span style='color:blue'>Start:</span>" + st_date +"</div> ");
                        out.println("<div class='fl-right' id='conf-det-rit'><span style='color:blue'>End:</span>" + ed_date +"</div>");
                        out.println("<div class='fl-clear'></div>");
                        out.println("</div>");
                        out.println("<div id='conf-det'>");
                        out.println("<div id='conf-det-lit' class='fl-left'><span style='color:blue'>Location:</span>" + location + "</div> ");
                        out.println("<div id='conf-det-rit' class='fl-right'><span style='color:blue'>Admin:</span>" + admin + "</div>");
                        out.println("<div class='fl-clear'></div>");
                        out.println("</div>");
                        out.println("</div>");
                        out.println("</a>");
                        i++;
                    }
                    if(i == 0) out.println("No results found");
                }
                else{
                    out.println("Enter a valid type in URL");
                }
            }
        %>
       </div>
    </body>
</html>