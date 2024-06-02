/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
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
    // Log an error for an exception with optional request context.
    void logException(
        Throwable exception,
        IServerRequest currentRequest = null,
        bool anIncludeTrace = false
    );

    /**
     * Log an error to uim`s Log subsystem
     * Params:
     * \UIM\Error\UimError error The error to log.
     * @param \Psr\Http\Message\IServerRequest|null request The request if in an HTTP context.
     */
    void logError(
        UimError error,
        IServerRequest serverRequest = null,
        bool shouldLogIncludeTrace = false
    ); 
}
