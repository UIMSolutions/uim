# Package 📦 uim.oop.errors

The UIM library has error and exception handling capabilities. Errors are caught, displayed or logged.
Exceptions, however, are handled in the program flow.

Errors are managed via the configurable ErrorHandler class. The error handling of the application can be adjusted via the ErrorHandler.

The following options are supported:

* errorLevel – int
  The error level to capture. Error constants and bit masks are available for interested parties to select the error level. E_ALL^ERRORS.USER_DEPRECATED can be used to deactivate deprecated warnings.
* Trace – bool
  With "True" stack traces for errors can be included in log files. After each error, stack traces are added to the log. This is useful for figuring out where/when errors occur.
* ExceptionRenderer - String
  Is a class responsible for rendering uncaught exceptions. This class must implement a render() method.
* log – bool
  If true, exceptions and stack traces are logged.
* skipLog – Array
  An array of names of each exception class that should not be logged.
* extraFatalErrorMemory – int
  Sets the number of megabytes to increase the memory limit when a fatal error occurs.

By default, errors are displayed when Debug is true and logged when Debug is false. The ErrorHandler for fatal errors is called regardless of the debug level or errorLevel configuration.
However, the result shown varies depending on the debug level. The default behavior for fatal errors is to display an internal server error page (debug disabled) or a message, file and line page (debug enabled).
