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
	A custom function to serialize native ColdFusion objects (simple values, arrays, structures, queries) into a JSON format string. <br><br>
	Compare to the build-in SerializeJson() function, this function can:
	<ul>
		<li>Has the option to format the date/time or not to format it</li>
	</ul>
</p>

<h2>Arguments</h2>

<ul>
	<li>
		<strong>data</strong>: required any <br>
		The data to be serialised
	</li>
	<li>
		<strong>queryFormat</strong>: string default=query (values:query|array) <br>
		The format that CF query will be converted to:
		<ul>
			<li><strong>query</strong>: </li>
			<li><strong>array</strong>: </li>
		</ul>
	</li>
	<li>
		<strong>queryKeyCase</strong>: string default=lower (values:lower|upper) <br>
		Force the query column names to be either all lower case or all upper case
	</li>
	<li>
		<strong>stringNumbers</strong>: boolean default=false <br>
		
	</li>
	<li>
		<strong>formatDates</strong>: boolean default=false <br>
		Format date/time values or not
	</li>
	<li>
		<strong>columnListFormat</strong>: string default=string (values:string|array) <br>
		Determine the "Columns" item within a CF query to be either a list of columns (string) or an array of columns (array)
	</li>
</ul>

<h2>Return Values</h2>

<p>JSON string</p>

<h2>Examples</h2>

<pre>
&lt;cfset data = {
	a = 1,
	b = 1.1,
	c = "test",
	d = true,
	e = "Yes",
	f = "1",
	g = [ x=1, y=2, z=3 ],
	h = now()
}&gt;
&lt;cfdump var="##data##"&gt;
&lt;cfdump var="##jsonEncode(data)##"&gt;
</pre>

<cfset data = {
	a = 1,
	b = 1.1,
	c = "test",
	d = true,
	e = "Yes",
	f = "1",
	g = [ x=1, y=2, z=3 ],
	h = now()
}>
<cfdump var="#data#">
<pre>#jsonEncode(data)#</pre>

</body>
</html>
</cfoutput>