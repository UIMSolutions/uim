module uim.html.elements.time;

@safe:
import uim.html;
import std.datetime;

// Wrapper for <time> - represents a specific period in time. It may include the datetime attribute to translate dates into machine-readable format, allowing for better search engine results or custom features such as reminders.
class DH5Time : DH5Obj {
	mixin(H5This!"time");
	
	mixin(MyAttribute!"datetime");
	// 0 datetime(this O)(Date value) {
		// return datetime(value.toString);
	// }
}
mixin(H5Short!"Time");

version(test_uim_html) { unittest {
  testH5Obj(H5Time, "time");
}}
