<!--- *********** START: Custom SerializeJson function *********** 
	Serialize native ColdFusion objects into a JSON formated string. Based on the JsonEncode function by Jehiah Czebotar (jehiah@gmail.com) from CFLib.org @ https://cflib.org/udf/jsonencode
	* Why? - Because of the limitations or qwerts of the build-in CF/Lucee SerializeJson() function
		- The build-in SerializeJson() function will always format the date value into US format, such as "July, 15 2024 14:00:00"
		- On some Lucee versions, the build-in SerializeJson() function will add the timezone / hour-offset of the server to the timestamp, such as "July, 15 2024 14:00:00 +1000"
	* Additions to the original JsonEncode function:
		- Supports 3 types of returned queryFormat (same as the 3 queryFormat types for the build-in SerializeJson() function) - row|column|struct
		- Ability to specify date/time format
		- Bug fixes
			-- Fixed bug when query ColumnList format set to array
	* Argument default values are set in the way so it works identical to the built-in SerializeJson() function with default argument values:
		- queryFormat="array", queryKeyCase="upper", formatDates=true, formatDateMask="mmmm, dd yyyy", formatTimeMask="HH:mm:ss", columnListFormat="array"
	* To produce a more "standard" JSON format, the arguments can be set to:
		- queryFormat="struct", queryKeyCase="lower", formatDates=true, formatDateMask="yyyy/mm/dd", formatTimeMask="h:mm:sstt", columnListFormat="array"
--->
<cffunction name="jsonEncode" access="public" returntype="string" output="No" hint="Converts data from CF to JSON format">
	<cfargument name="data" type="any" required="Yes">
	<cfargument name="queryFormat" type="string" required="No" default="array"> <!-- "query"/"column" (structure of array - the CF native format) or "struct" (array of structure - the more "statndard" format similar to JS) or "array"/"row" (array of array - the format BIF SerializeJson will produce) -->
	<cfargument name="queryKeyCase" type="string" required="No" default="upper"> <!-- Determine the query column case - options are lower|upper|original -->
	<cfargument name="stringNumbers" type="boolean" required="No" default=false> <!--- Determine if numbers should be represent as string (1 => "1" and "1" => "1") or not (1 => 1 but "1" => 1) --->
	<cfargument name="formatDates" type="boolean" required="No" default=true> <!--- Format date/time value or not --->
	<cfargument name="formatDateMask" type="string" required="No" default="mmmm, dd yyyy"> <!--- Mask for dateFormat --->
	<cfargument name="formatTimeMask" type="string" required="No" default="HH:mm:ss"> <!--- Mask for timeFormat --->
	<cfargument name="columnListFormat" type="string" required="No" default="array"> <!-- Query column list format - options are: string|array -->

	<!--- VARIABLE DECLARATION --->
	<cfset var jsonString = "">
	<cfset var tempVal = "">
	<cfset var arKeys = "">
	<cfset var colPos = 1>
	<cfset var i = 1>
	<cfset var column = "">
	<cfset var datakey = "">
	<cfset var recordcountkey = "">
	<cfset var columnlist = "">
	<cfset var columnlistAsJsonArray = "">
	<cfset var columnlistkey = "">
	<cfset var dJSONString = "">
	<cfset var escapeToVals = "\\,\"",\/,\b,\t,\n,\f,\r">
	<cfset var escapeVals = "\,"",/,#Chr(8)#,#Chr(9)#,#Chr(10)#,#Chr(12)#,#Chr(13)#">

	<cfset var _data = arguments.data>
	<cfset var classname = _data.getClass().getName()>

	<!--- STRING --->
	<cfif CompareNoCase(className, "java.lang.String") eq 0>
		<cfreturn '"' & ReplaceList(_data, escapeVals, escapeToVals) & '"'>

	<!--- BOOLEAN --->
	<cfelseif IsBoolean(_data) AND NOT IsNumeric(_data) AND NOT ListFindNoCase("Yes,No", _data)>
		<cfreturn LCase(ToString(_data))>

	<!--- NUMBER --->
	<cfelseif NOT stringNumbers AND IsNumeric(_data) AND NOT REFind("^0+[^\.]",_data)>
		<cfreturn ToString(_data)>

	<!--- DATE --->
	<cfelseif IsDate(_data) AND arguments.formatDates>
		<cfreturn '"#DateFormat(_data, "#arguments.formatDateMask#")# #TimeFormat(_data, "#arguments.formatTimeMask#")#"'>

	<!--- STRING --->
	<cfelseif IsSimpleValue(_data)>
		<cfreturn '"' & ReplaceList(_data, escapeVals, escapeToVals) & '"'>

	<!--- ARRAY --->
	<cfelseif IsArray(_data)>
		<cfset dJSONString = createObject('java','java.lang.StringBuffer').init("")>
		<cfloop from="1" to="#ArrayLen(_data)#" index="i">
			<cfset tempVal = jsonencode( _data[i], arguments.queryFormat, arguments.queryKeyCase, arguments.stringNumbers, arguments.formatDates, arguments.formatDateMask, arguments.formatTimeMask, arguments.columnListFormat )>
			<cfif dJSONString.toString() EQ "">
				<cfset dJSONString.append(tempVal)>
			<cfelse>
				<cfset dJSONString.append("," & tempVal)>
			</cfif>
		</cfloop>

		<cfreturn "[" & dJSONString.toString() & "]">

	<!--- STRUCT --->
	<cfelseif IsStruct(_data)>
		<cfset dJSONString = createObject('java','java.lang.StringBuffer').init("")>
		<cfset arKeys = StructKeyArray(_data)>
		<cfloop from="1" to="#ArrayLen(arKeys)#" index="i">
			<cfset tempVal = jsonencode( _data[ arKeys[i] ], arguments.queryFormat, arguments.queryKeyCase, arguments.stringNumbers, arguments.formatDates, arguments.formatDateMask, arguments.formatTimeMask, arguments.columnListFormat )>
			<cfif dJSONString.toString() EQ "">
				<cfset dJSONString.append('"' & arKeys[i] & '":' & tempVal)>
			<cfelse>
				<cfset dJSONString.append("," & '"' & arKeys[i] & '":' & tempVal)>
			</cfif>
		</cfloop>

		<cfreturn "{" & dJSONString.toString() & "}">

	<!--- QUERY --->
	<cfelseif IsQuery(_data)>
		<cfset dJSONString = createObject('java','java.lang.StringBuffer').init("")>

		<!--- Add query meta data --->
		<cfif arguments.queryKeyCase EQ "lower">
			<cfset recordcountKey = "recordcount">
			<cfset columnlistKey = "columns">
			<cfset columnlist = LCase(_data.columnlist)>
			<cfset dataKey = "data">
		<cfelseif arguments.queryKeyCase EQ "upper">
			<cfset recordcountKey = "RECORDCOUNT">
			<cfset columnlistKey = "COLUMNS">
			<cfset columnlist = uCase(_data.columnlist)>
			<cfset dataKey = "DATA">
		<cfelse>
			<cfset recordcountKey = "recordcount">
			<cfset columnlistKey = "columns">
			<cfset columnlist = _data.columnlist>
			<cfset dataKey = "data">
		</cfif>

		<cfset dJSONString.append('"#recordcountKey#":' & _data.recordcount)>
		<cfif arguments.columnListFormat EQ "array">
			<cfset columnlistAsJsonArray = "[" & ListQualify(columnlist, '"') & "]">
			<cfset dJSONString.append(',"#columnlistKey#":' & columnlistAsJsonArray)>
		<cfelse>
			<cfset dJSONString.append(',"#columnlistKey#":"' & columnlist & '"')>
		</cfif>
		<cfset dJSONString.append(',"#dataKey#":')>
		
		<cfif arguments.queryFormat EQ "query" OR arguments.queryFormat EQ "column">

			<!--- "query" or "column" - Make query a structure of array - the CF native format --->
			<cfset dJSONString.append("{")>
			<cfset colPos = 1>
			
			<cfloop list="#_data.columnlist#" delimiters="," index="column">
				<cfif colPos GT 1>
					<cfset dJSONString.append(",")>
				</cfif>
				<cfif arguments.queryKeyCase EQ "lower">
					<cfset column = LCase(column)>
				<cfelseif arguments.queryKeyCase EQ "upper">
					<cfset column = uCase(column)>
				</cfif>
				<cfset dJSONString.append('"' & column & '":[')>
				
				<cfloop from="1" to="#_data.recordcount#" index="i">
					<!--- Get cell value; recurse to get proper format depending on string/number/boolean data type --->
					<cfset tempVal = jsonencode( _data[column][i], arguments.queryFormat, arguments.queryKeyCase, arguments.stringNumbers, arguments.formatDates, arguments.formatDateMask, arguments.formatTimeMask, arguments.columnListFormat )>
					
					<cfif i GT 1>
						<cfset dJSONString.append(",")>
					</cfif>
					<cfset dJSONString.append(tempVal)>
				</cfloop>
				
				<cfset dJSONString.append("]")>
				
				<cfset colPos = colPos + 1>
			</cfloop>
			<cfset dJSONString.append("}")>

		<cfelseif arguments.queryFormat EQ "struct">

			<!--- "struct" - Make query an array of structure - the more "statndard" format similar to most JS would have --->
			<cfset dJSONString.append("[")>
			<cfloop query="_data">
				<cfif CurrentRow GT 1>
					<cfset dJSONString.append(",")>
				</cfif>
				<cfset dJSONString.append("{")>
				<cfset colPos = 1>
				<cfloop list="#columnlist#" delimiters="," index="column">
					<cfset tempVal = jsonencode( _data[column][CurrentRow], arguments.queryFormat, arguments.queryKeyCase, arguments.stringNumbers, arguments.formatDates, arguments.formatDateMask, arguments.formatTimeMask, arguments.columnListFormat )>
					
					<cfif colPos GT 1>
						<cfset dJSONString.append(",")>
					</cfif>
					
					<cfif arguments.queryKeyCase EQ "lower">
						<cfset column = LCase(column)>
					<cfelseif arguments.queryKeyCase EQ "upper">
						<cfset column = uCase(column)>
					</cfif>
					<cfset dJSONString.append('"' & column & '":' & tempVal)>
					
					<cfset colPos = colPos + 1>
				</cfloop>
				<cfset dJSONString.append("}")>
			</cfloop>
			<cfset dJSONString.append("]")>

		<cfelse>

			<!--- otherwise queryFormat is "array" (or "row") - Make query an array of array - the format CF & Lucee build-in function SerializeJson() will produce --->
			<cfset dJSONString.append("[")>
			<cfloop query="_data">
				<cfif CurrentRow GT 1>
					<cfset dJSONString.append(",")>
				</cfif>
				<!---<cfset dJSONString.append("{")>--->
				<cfset dJSONString.append("[")>
				<cfset colPos = 1>
				<cfloop list="#columnlist#" delimiters="," index="column">
					<cfset tempVal = jsonencode( _data[column][CurrentRow], arguments.queryFormat, arguments.queryKeyCase, arguments.stringNumbers, arguments.formatDates, arguments.formatDateMask, arguments.formatTimeMask, arguments.columnListFormat )>
					
					<cfif colPos GT 1>
						<cfset dJSONString.append(",")>
					</cfif>
					
					<cfif arguments.queryKeyCase EQ "lower">
						<cfset column = LCase(column)>
					<cfelseif arguments.queryKeyCase EQ "upper">
						<cfset column = uCase(column)>
					</cfif>
					<!---<cfset dJSONString.append('"' & column & '":' & tempVal)>--->
					<cfset dJSONString.append(tempVal)>
					
					<cfset colPos = colPos + 1>
				</cfloop>
				<!---<cfset dJSONString.append("}")>--->
				<cfset dJSONString.append("]")>
			</cfloop>
			<cfset dJSONString.append("]")>

		</cfif>

		<!--- Wrap all query data into an object --->
		<cfreturn "{" & dJSONString.toString() & "}">

	<!--- UNKNOWN OBJECT TYPE --->
	<cfelse>
		<cfreturn '"' & "unknown-obj" & '"'>
	</cfif>
</cffunction>
<!--- *********** END: Custom SerializeJson function *********** --->