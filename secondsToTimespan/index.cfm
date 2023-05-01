<cfoutput>

<cfset thisUUID = createUUID()>
<cfset folder = listLast( getDirectoryFromPath(getCurrentTemplatePath()), "/\" )>
<cfset UDF = listLast(folder, "-")>

<cfinclude template="#UDF#.cfm">
<cffile action="read" file="#expandPath('./#UDF#.cfm')#" variable="udfContent">

<html>
<title>#UDF#</title>
<head>
	<link href="/_assets/styles.css?v=#thisUUID#" rel="stylesheet">
	<script src="/_assets/scripts.js?v=#thisUUID#"></script>
</head>
<body>

<h1>#UDF#</h1>

<p><a href="javascript:showHide('sources')">View Source</a></p>
<div id="sources"><pre>#trim(udfContent)#</pre></div>

<p>
	Convert seconds into a timespan, either as:
	<ul>
		<li>A struct with keys Day, Hour, Minute, and Second</li>
		<li>A timespan created by CreateTimeSpan()</li>
	</ul>
</p>

<h2>Arguments</h2>

<ul>
	<li>
		<strong>seconds</strong>: required numeric <br>
	</li>
	<li>
		<strong>returnUsingCreateTimeSpan</strong>: boolean default=false <br>
		If true, function will return a timespan using createTimeSpan() instead of returning a structure
	</li>
</ul>

<h2>Return Values</h2>

<p>Structure with keys Day, Hour, Minute, Second<br>Or a timespan value (as created by createTimeSpan() function)</p>

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