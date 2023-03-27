<cfoutput>

<cfset UDF = "secondsToTimespan">
<cfinclude template="#UDF#.cfm">

<html>
<title>#UDF#</title>
<head>
	<link href="/_assets/styles.css" rel="stylesheet">
	<script src="/_assets/scripts.js"></script>
</head>
<body>

<h1>#UDF#</h1>


<p><a href="javascript:showHide('sources')">View Source</a></p>

<cffile action="read" file="#expandPath('./#UDF#.cfm')#" variable="udfContent">
<div id="sources" style="display:none;"><pre>#udfContent#</pre></div>


<p>
	Convert seconds into a timespan, either as:
	<ul>
		<li>A struct with keys <strong>Day</strong>, <strong>Hour</strong>, <strong>Minute</strong>, and <strong>Second</strong></li>
		<li>A timespan created by CreateTimeSpan()</li>
	</ul>
</p>


<h2>Examples</h2>

<pre>
&lt;cfset timespanData = secondsToTimespan(94757, false)&gt;
&lt;cfdump var="##timespanData##"&gt;
</pre>
<cfset timespanData = secondsToTimespan(94757, false)>
<cfdump var="#timespanData#">

<pre>
&lt;cfset timespanValue = secondsToTimespan(94757, true)&gt;
&lt;cfdump var="##timespanValue##"&gt;
</pre>
<cfset timespanValue = secondsToTimespan(94757, true)>
<cfdump var="#timespanValue#">

</body>
</html>
</cfoutput>