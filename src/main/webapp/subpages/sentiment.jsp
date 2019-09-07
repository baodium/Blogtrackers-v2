<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%@page import="util.*"%>
<%@page import="java.io.File"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.net.URI"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
	<%
	Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");
	Object tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");

	Object user = (null == session.getAttribute("username")) ? "" : session.getAttribute("username");
	String key= request.getParameter("key").replaceAll("\\<.*?\\>", "");
	String value= request.getParameter("value").replaceAll("\\<.*?\\>", "");
	String source = request.getParameter("source").replaceAll("\\<.*?\\>", "");
	String section = request.getParameter("section").replaceAll("\\<.*?\\>", "");
	String color = request.getParameter("color");
	String postno = request.getParameter("postno");
	String dt= request.getParameter("date_from");
	String dte= request.getParameter("date_to");
	
	JSONArray sentimentpost = new JSONArray();
	
	Blogposts bp = new Blogposts();  
	String output="";
	int death =0;
	int work =0;
	int leisure =0;
	int religion =0;
	int home =0;
	int money =0;
	int focuspast=0;
	int focuspresent =0;
	int focusfuture=0;
	int affiliation=0;
	int achieve=0;
	int risk=0;
	int reward =0;
	int power=0;
	int insight=0;
	int differ=0;
	int cause=0;
	int discrep=0;
	int certain=0;
	int tentat=0;
	int analytic=0;
	int tone=0;
	int clout=0;
	int authentic=0;
	int posemo=0;
	int negemo=0;
	int anger=0;
	int anx=0;
	int sad=0;
	try {
		ArrayList posts = bp._getPost(key,value);
		if(posts.size()>0){
			if(source.equals("sentiment") && section.equals("time_orientation")) {

				for (int p = 0; p < posts.size(); p++) {
					String bstr = posts.get(p).toString();
					JSONObject bjj = new JSONObject(bstr);
					bstr = bjj.get("_source").toString();
					bjj = new JSONObject(bstr);
					
					sentimentpost.put(bjj.get("blogpost_id").toString());	
					
					ArrayList sentimentor = new Liwc()._searchByRange("date", dt, dte, sentimentpost);
					
					//System.out.println("sentimentor here="+sentimentor);
					if(sentimentor.size()>0){
						for(int v=0; v<sentimentor.size();v++){
							String bstrr = sentimentor.get(v).toString();
							JSONObject bj = new JSONObject(bstrr);
							bstrr = bj.get("_source").toString();
							bj = new JSONObject(bstrr);
							
							death += Integer.parseInt(bj.get("death").toString());
							work += Integer.parseInt(bj.get("work").toString());
							leisure+=Integer.parseInt(bj.get("leisure").toString());
							religion+=Integer.parseInt(bj.get("religion").toString());
							home+=Integer.parseInt(bj.get("home").toString());
							money+=Integer.parseInt(bj.get("money").toString());
							
							focuspast+=Integer.parseInt(bj.get("focuspast").toString());
							focuspresent+=Integer.parseInt(bj.get("focuspresent").toString());
							focusfuture+=Integer.parseInt(bj.get("focusfuture").toString());
							affiliation+=Integer.parseInt(bj.get("affiliation").toString());
							achieve+=Integer.parseInt(bj.get("achieve").toString());
							risk+=Integer.parseInt(bj.get("risk").toString());
							reward+=Integer.parseInt(bj.get("reward").toString());
							power+=Integer.parseInt(bj.get("power").toString());
							insight+=Integer.parseInt(bj.get("insight").toString());
							differ+=Integer.parseInt(bj.get("differ").toString());
							cause+=Integer.parseInt(bj.get("cause").toString());
							discrep+=Integer.parseInt(bj.get("discrep").toString());
							certain+=Integer.parseInt(bj.get("certain").toString());
							tentat+=Integer.parseInt(bj.get("tentat").toString());
							analytic+=Integer.parseInt(bj.get("analytic").toString());
							tone+=Integer.parseInt(bj.get("tone").toString());
							clout+=Integer.parseInt(bj.get("clout").toString());
							authentic+=Integer.parseInt(bj.get("authentic").toString());
							posemo+=Integer.parseInt(bj.get("posemo").toString());
							negemo+=Integer.parseInt(bj.get("negemo").toString());
							anger+=Integer.parseInt(bj.get("anger").toString());
							anx+=Integer.parseInt(bj.get("anx").toString());
							sad+=Integer.parseInt(bj.get("sad").toString());
						}
					}
					
				}
				

			}
		}else {
			
		}	
	}catch(Exception e) {
		
	 }	

%>

					<!-- <div class="p20 pt0 pb20 text-blog-content text-primary" style="height:586px;">
          <h5 class="text-primary p20 pt0 pb0 text-center">Personal Content</h5>
          	<div class="personalcontent"></div>
         </div> -->

					<div id="carouselExampleIndicators" class="carousel slide"
						data-ride="carousel">
						<ol class="carousel-indicators">
							<li data-target="#carouselExampleIndicators" data-slide-to="0"
								class="active" data-toggle="tooltip" data-placement="top"
								title="Personal Content"></li>
							<li data-target="#carouselExampleIndicators" data-slide-to="1"
								data-toggle="tooltip" data-placement="top"
								title="Time Orientation"></li>
							<li data-target="#carouselExampleIndicators" data-slide-to="2"
								data-toggle="tooltip" data-placement="top"
								title="Core Drive and Need"></li>
							<li data-target="#carouselExampleIndicators" data-slide-to="3"
								data-toggle="tooltip" data-placement="top"
								title="Cognitive Process"></li>
							<li data-target="#carouselExampleIndicators" data-slide-to="4"
								data-toggle="tooltip" data-placement="top"
								title="Summary Variable"></li>
							<li data-target="#carouselExampleIndicators" data-slide-to="5"
								data-toggle="tooltip" data-placement="top"
								title="Sentiment/Emotion"></li>

						</ol>
						<div class="carousel-inner" id="carouseller">
							<div class="carousel-item active">
								<div class="p20 pt0 pb20 text-blog-content text-primary"
									style="height: 586px;">
									<h5 class="text-primary p20 pt0 pb0 text-center">Personal
										Content - Post #<%=postno%></h5>
									<div class="personalcontent2"></div>
								</div>
							</div>
							<div class="carousel-item">
								<div class="p20 pt0 pb20 text-blog-content text-primary"
									style="height: 586px;">
									<h5 class="text-primary p20 pt0 pb0 text-center">Time
										Orientation - Post #<%=postno%></h5>
									<div class="timeorientation2"></div>
								</div>
							</div>
							<div class="carousel-item">
								<div class="p20 pt0 pb20 text-blog-content text-primary"
									style="height: 586px;">
									<h5 class="text-primary p20 pt0 pb0 text-center">Core
										Drive and Need - Post #<%=postno%></h5>
									<div class="coredriveandneed2"></div>
								</div>
							</div>
							<div class="carousel-item">
								<div class="p20 pt0 pb20 text-blog-content text-primary"
									style="height: 586px;">
									<h5 class="text-primary p20 pt0 pb0 text-center">Cognitive
										Process - Post #<%=postno%></h5>
									<div class="cognitiveprocess2"></div>
								</div>
							</div>
							<div class="carousel-item">
								<div class="p20 pt0 pb20 text-blog-content text-primary"
									style="height: 586px;">
									<h5 class="text-primary p20 pt0 pb0 text-center">Summary
										Variable - Post #<%=postno%></h5>
									<div class="summaryvariable2"></div>
								</div>
							</div>
							<div class="carousel-item">
								<div class="p20 pt0 pb20 text-blog-content text-primary"
									style="height: 586px;">
									<h5 class="text-primary p20 pt0 pb0 text-center">Sentiment/Emotion - Post #<%=postno%></h5>
									<div class="sentimentemotion2"></div>
								</div>
							</div>
						</div>
						<a class="carousel-control-prev" href="#carouselExampleIndicators"
							role="button" data-slide="prev"> <span
							class="carousel-control-prev-icon" aria-hidden="true"></span> <span
							class="sr-only">Previous</span>
						</a> <a class="carousel-control-next"
							href="#carouselExampleIndicators" role="button" data-slide="next">
							<span class="carousel-control-next-icon" aria-hidden="true"></span>
							<span class="sr-only">Next</span>
						</a>
					</div>


	<script>
$(function () {
    /* Radar chart design created by Nadieh Bremer - VisualCinnamon.com */

    //////////////////////////////////////////////////////////////
    //////////////////////// Set-Up //////////////////////////////
    //////////////////////////////////////////////////////////////

    var margin = {top: 100, right: 100, bottom: 100, left: 100},
      width = Math.min(450, window.innerWidth - 10) - margin.left - margin.right,
      height = Math.min(width, window.innerHeight - margin.top - margin.bottom - 20);



    //////////////////////////////////////////////////////////////
    ////////////////////////// Data //////////////////////////////
    //////////////////////////////////////////////////////////////

    var personalcontent = [
          [//iPhone
          {axis:"Death",value:<%=death%>},
          {axis:"Work",value:<%=work%>},
          {axis:"Leisure",value:<%=leisure%>},
          {axis:"Religion",value:<%=religion%>},
          {axis:"Home",value:<%=home%>},
          {axis:"Money",value:<%=money%>}
          ]
        ];
	

        var timeorientation = [
              [//iPhone
              {axis:"Past Focus",value:<%=focuspast%>},
              {axis:"Present Focus",value:<%=focuspresent%>},
              {axis:"Future Focus",value:<%=focusfuture%>}
              ]
            ];

            var coredriveandneed = [
                  [//iPhone
                  {axis:"Affiliation",value:<%=affiliation%>},
                  {axis:"Achievement",value:<%=achieve%>},
                  {axis:"Risk/Prevention Focus",value:<%=risk%>},
                  {axis:"Reward Focus",value:<%=reward%>},
                  {axis:"Power",value:<%=power%>},
                  ]
                ];
        
                var cognitiveprocess = [
                      [//iPhone
                      {axis:"Insight",value:<%=insight%>},
                      {axis:"Differentiation",value:<%=differ%>},
                      {axis:"Cause",value:<%=cause%>},
                      {axis:"Discrepancies",value:<%=discrep%>},
                      {axis:"Certainty",value:<%=certain%>},
                      {axis:"Tentativeness",value:<%=tentat%>}
                      ]
                    ];

                    var summaryvariable = [
                          [//iPhone
                          {axis:"Analytical Thinking",value:<%=analytic%>},
                          {axis:"Emotional Tone",value:<%=tone%>},
                          {axis:"Clout",value:<%=clout%>},
                          {axis:"Authentic",value:<%=authentic%>}
                          ]
                        ];

                        var sentimentemotion = [
                              [//iPhone
                              {axis:"Positive Emotion",value:<%=posemo%>},
                              {axis:"Sadness",value:<%=sad%>},
                              {axis:"Negative Emotion",value:<%=anger%>},
                              {axis:"Anger",value:<%=anger%>},
                              {axis:"Anxiety",value:<%=anx%>}
                              ]
                            ];
    //////////////////////////////////////////////////////////////
    //////////////////// Draw the Chart //////////////////////////
    //////////////////////////////////////////////////////////////

   <%--  var color = d3.scale.ordinal()
      .range(["<%=color%>","#CC333F","#00A0B0"]); --%>
      var color = d3.scale.ordinal()
      .range(["<%=color%>","#0080CC","#0080CC"]);

    var radarChartOptions1 = {
      w: width,
      h: height,
      margin: margin,
      maxValue: 0.5,
      levels: 5,
      roundStrokes: true,
      color: color
    };
    var radarChartOptions2 = {
      w: width,
      h: height,
      margin: margin,
      maxValue: 0.5,
      levels: 5,
      roundStrokes: true,
      color: color
    };
    var radarChartOptions3 = {
      w: width,
      h: height,
      margin: margin,
      maxValue: 0.5,
      levels: 5,
      roundStrokes: true,
      color: color
    };
    var radarChartOptions4 = {
      w: width,
      h: height,
      margin: margin,
      maxValue: 0.5,
      levels: 5,
      roundStrokes: true,
      color: color
    };
    var radarChartOptions5 = {
      w: width,
      h: height,
      margin: margin,
      maxValue: 0.5,
      levels: 5,
      roundStrokes: true,
      color: color
    };
    var radarChartOptions6 = {
      w: width,
      h: height,
      margin: margin,
      maxValue: 0.5,
      levels: 5,
      roundStrokes: true,
      color: color
    };
    //Call function to draw the Radar chart

      RadarChart(".personalcontent2", personalcontent, radarChartOptions1);
      RadarChart(".timeorientation2", timeorientation, radarChartOptions2);
      RadarChart(".coredriveandneed2", coredriveandneed, radarChartOptions3);
      RadarChart(".cognitiveprocess2", cognitiveprocess, radarChartOptions4);
      RadarChart(".summaryvariable2", summaryvariable, radarChartOptions5);
      RadarChart(".sentimentemotion2", sentimentemotion, radarChartOptions6);

});
  </script>
 

	<script>
  $('.carousel').carousel({
      interval: false
  });
  </script>

