/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.errors.interfaces.errorlogger;

import uim.errors;

@safe:

/**
 * Interface for error logging handlers.
 *
 * Used by the ErrorHandlerMiddleware and global error handlers to log exceptions and errors.
 */
interface IErrorLogger {
    /**
     * Log an error for an exception with optional request context.
     * Params:
     * \Throwable exception The exception to log a message for.
     * @param \Psr\Http\Message\IServerRequest|null request The current request if available.
     * @param bool anIncludeTrace Should the log message include a stacktrace.
     */
    void logException(
        Throwable exception,
        IServerRequest serverRequest = null,
        bool anIncludeTrace = false
    );

    /**
     * Log an error to uim`s Log subsystem
     * Params:
     * \UIM\Error\UimError error The error to log.
     * @param \Psr\Http\Message\IServerRequest|null request The request if in an HTTP context.
     * @param bool anIncludeTrace Should the log message include a stacktrace.
     */
    void logError(
        UimError error,
        IServerRequest serverRequest = null,
        bool anIncludeTrace = false
    ); 
}
