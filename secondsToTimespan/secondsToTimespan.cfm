<!--- Author: Tomy Saman | tomywutoto@gmail.com --->
<cfscript>
// secondsToTimespan(): Convert seconds into a structure of date/time with keys as Day, Hour, Minute, and Second; or as a timespan created by createTimeSpan(day, hour, minute, second)
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