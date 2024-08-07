<cfoutput>

<cfset thisUUID = createUUID()>
<cfset folder = listLast( getDirectoryFromPath(getCurrentTemplatePath()), "/\" )>
<cfset UDF = listLast(folder, "-")>

<cfinclude template="#UDF#.cfm">
<cffile action="read" file="#expandPath('./#UDF#.cfm')#" variable="udfContent">
<cfset udfContent = htmlEditFormat(udfContent)>

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
	Compared to the build-in SerializeJson() function, this function can:
	<ul>
		<li>Has the option to format the date/time or not to format it</li>
		<li>Has the option to convert a string number to a numeric, or not to convert it (stay as string)</li>
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
			<li><em>query</em>: Query will be represent as structure of array (the CF native format). Same as queryFormat="column" for the build-in SerializeJson() function.</li>
			<li><em>array</em>: Query will be represent as array of structure (a more "statndard" format similar to JS). Same as queryFormat="struct" for the build-in SerializeJson() function.</li>
		</ul>
	</li>
	<li>
		<strong>queryKeyCase</strong>: string default=lower (values:lower|upper) <br>
		Force the query column names to be either all lower case or all upper case
	</li>
	<li>
		<strong>stringNumbers</strong>: boolean default=false <br>
		Determine if numbers should be represent as string (1 => "1" and "1" => "1") or not (1 => 1 but "1" => 1)
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
&lt;cfset q = queryNew("id,title", "integer,varchar", [ {"id"=1,"title"="AAA"}, {"id"=2,"title"="BBB"} ])&gt;
&lt;cfset data = {
	a = 1,
	b = 1.1,
	c = "1",
	d = "test",
	e = true,
	f = "true",
	g = "Yes",
	h = now(),
	i = "2024/07/01  13:30:00",
	j = "2024/07/01",
	k = "13:30:00",
	q = q,
	t = [ 1, 2, q ]
}&gt;
&lt;cfdump var="##data##"&gt;
&lt;cfdump var="##jsonEncode(data)##"&gt;
</pre>

<cfset q = queryNew("id,title", "integer,varchar", [ {"id"=1,"title"="AAA"}, {"id"=2,"title"="BBB"} ])>
<cfset data = structNew("ordered")>
<cfset data["a"] = 1>
<cfset data["b"] = 1.1>
<cfset data["c"] = "1">
<cfset data["d"] = "test">
<cfset data["e"] = true>
<cfset data["f"] = "true">
<cfset data["g"] = "yes">
<cfset data["h"] = now()>
<cfset data["i"] = "2024/07/01 13:30:00">
<cfset data["j"] = "2024/07/01">
<cfset data["k"] = "13:30:00">
<cfset data["q"] = q>
<cfset data["t"] = [ 1, 2, q ]>
<h4>Data</h4>
<cfdump var="#data#">
<h4>This JsonEncode function</h4>
<pre>#jsonEncode(data=data)#</pre>
<h4>Build-in SerializeJson function</h4>
<pre>#SerializeJson(data)#</pre>

</body>
</html>
</cfoutput>