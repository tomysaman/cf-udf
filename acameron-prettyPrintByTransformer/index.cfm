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
	This UDF pretty-formats a XML content/string.
</p>

<h2>Arguments</h2>

<ul>
	<li>
		<strong>xmlString</strong>: required string <br>
	</li>
	<li>
		<strong>indent</strong>: numeric default=4 <br>
		Number of spaces used for indentation
	</li>
	<li>
		<strong>ignoreDeclaration</strong>: boolean default=true <br>
		If true, the xml head/declaration will be stripped out from the output
	</li>
</ul>

<h2>Return Values</h2>

<p>Formatted XML</p>

<h2>Examples</h2>

<pre>
&lt;cfset xmlStr = '&lt;aaa&gt;&lt;bbb ccc="ddd"&gt;&lt;eee/&gt;&lt;/bbb&gt;&lt;/aaa&gt;'&gt;
&lt;cfset formattedXml = prettyPrintByTransformer(xmlStr)&gt;
&lt;cfdump var="##formattedXml##"&gt;
</pre>
<cfset xmlStr = '<aaa><bbb ccc="ddd"><eee/></bbb></aaa>'>
<cfset formattedXml = prettyPrintByTransformer(xmlStr)>
<pre>#htmlEditFormat(formattedXml)#</pre>

</body>
</html>
</cfoutput>