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
	This UDF extends the ability of reFind() & reFindNoCase that can return ALL the search results (instead of just the first one)
</p>

<h2>Arguments</h2>

<ul>
	<li>
		<strong>patern</strong>: required string <br>
		A regular expression to match
	</li>
	<li>
		<strong>string</strong>: required string <br>
		A string to find matches in
	</li>
	<li>
		<strong>all</strong>: boolean default=false <br>
		Whether to match all or to match one (default)
	</li>
	<li>
		<strong>start</strong>: numeric default=1 <br>
		The position in the string to start looking for matches
	</li>
	<li>
		<strong>caseSensitive</strong>: boolean default=false <br>
		Whether to do a case-sensitive or case-insensitive (default) match
	</li>
</ul>

<h2>Return Values</h2>

<p>An array of structs, similar to reFind() when set to return subexpressions</p>

<h2>Examples</h2>

<pre>
string = "This is a string that has words of differing lengths, and I'm gonna use stringFind() to return the words that are five or six characters long";
pattern = "\b(\w{5,6})\b";
result = stringFind(pattern, string, true, 1, false);
writeDump(result);
</pre>
<cfscript>
	string = "This is a string that has words of differing lengths, and I'm gonna use stringFind() to return the words that are five or six characters long";
	pattern = "\b(\w{5,6})\b";
	result = stringFind(pattern, string, true, 1, false);
	writeDump(result);
</cfscript>

</body>
</html>
</cfoutput>