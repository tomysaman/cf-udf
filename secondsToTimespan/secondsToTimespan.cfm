<cfscript>
// secondsToTimespan(): Convert seconds into a structure of date/time part as Day, Hour, Minute, and Second - useful when you need to convert seconds for createTimeSpan(day, hour, minute, second) function
public any function secondsToTimespan(required numeric seconds, boolean returnUsingCreateTimeSpan=false) {
	var remainder = int(abs(arguments.seconds));
	var d = int(remainder/86400);
	remainder = remainder mod 86400;
	var h = int(remainder/3600);
	remainder = remainder mod 3600;
	var m = int(remainder/60);
	remainder = remainder mod 60;
	var s = remainder;
	if (arguments.returnUsingCreateTimeSpan) {
		return createTimeSpan(d, h, m, s);
	} else {
		return {
			day = d,
			hour = h,
			minute = m,
			second = s
		};
	}
}
</cfscript>