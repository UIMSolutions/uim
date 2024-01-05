# Package 📦 uim.oop.errors

UIM applications come with error and exception handling setup for you. UIM errors are trapped and displayed or logged. Uncaught exceptions are rendered into error pages automatically.

Error configuration is done in the application.  By default, an ErrorHandler is used to handle both errors and exceptions by default.  With the error configuration the error handling of the application can be adjusted.  The following options are supported:

 errorLevel - int - The error level you want to capture.  Use the built-in error constants and bitmasks to select the error level that interests you.  You can set this to E_ALL^E_USER_DEPRECATED to disable deprecated warnings.

 Trace - bool - Include stack traces for errors in log files.  Stack traces are included in the log after each error.  This is useful for finding out where/when errors occur.

  ExceptionRenderer - String - The class responsible for rendering uncaught exceptions.  If you choose a custom class, you should place the file for that class in src/Error.  This class must implement a render() method.

  log - bool - If true, exceptions and their stack traces are logged to Cake\Log\Log.

  skipLog - Array - An array of exception class names that should not be logged.  This is useful for removing NotFoundExceptions or other common but uninteresting log messages.

  extraFatalErrorMemory – int – Set the number of megabytes to increase the memory limit when a fatal error occurs.  This gives scope for full logging or error handling.

 By default, errors are displayed when debug is true and logged when debug is false.  The fatal error handler is invoked regardless of the debug level or errorLevel configuration, but the result varies depending on the debug level.  The default behavior for fatal errors is to display an internal server error page (debug disabled) or a message, file, and line page (debug enabled).
