module uim.logging.enumerations.level;

enum LogLevels : string {
  NONE = "none",
  EMERGENCY = "emergency",
  ALERT = "alert",
  CRITICAL = "critical",
  ERROR = "error",
  WARNING = "warning", // Unexpected condition that could indicate an error but has no direct consequences
  NOTICE = "notice",
  INFO = "info", // Informational message
	DEBUG = "debug", 
  TRACE = "trace", // Information for locating events when no useful stack traces are available
  DIAGNOSTIC = "diagnostic", // Extended information (e.g. for more detailed error information)
	ERROR = "error"      /// Normal error that is handled gracefully}
}
/* Vibe is using

LogLevels {
	trace,      /// Developer information for locating events when no useful stack traces are available
	debugV,     /// Developer information useful for algorithm debugging - for verbose output
	debug_,     /// Developer information useful for algorithm debugging
	diagnostic, /// Extended user information (e.g. for more detailed error information)
	info,       /// Informational message for normal user education
	warn,       /// Unexpected condition that could indicate an error but has no direct consequences
	error,      /// Normal error that is handled gracefully
	critical,   /// Error that severely influences the execution of the application
	fatal,      /// Error that forces the application to terminate
	none,       /// Special value used to indicate no logging when set as the minimum log level

	verbose1 = diagnostic, /// Alias for diagnostic messages
	verbose2 = debug_,     /// Alias for debug messages
	verbose3 = debugV,     /// Alias for verbose debug messages
	verbose4 = trace,      /// Alias for trace messages
}
*/
