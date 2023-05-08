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
	Pass me a string and I'll convert it into HTML-friendly ASCII characters
</p>

<h2>Arguments</h2>

<ul>
	<li>
		<strong>str</strong>: required string <br>
	</li>
</ul>

<h2>Return Values</h2>

<p>String</p>

<h2>Examples</h2>

<pre>
str = "I’ve ¼ got © some ™ funky € characters ? to ? convert ¥ into ® ASCII ¶ eh?"l
writedump(stringToAscii(str));
</pre>
<cfscript>
	str = "I’ve ¼ got © some ™ funky € characters ? to ? convert ¥ into ® ASCII ¶ eh?";
	writedump(stringToAscii(str));
</cfscript>

</body>
</html>
</cfoutput>