
/**


 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *

 * @since         3.0.0

 */module source.uim.myname.exceptions.missingdispatcherfilter;


/**
 * Exception raised when a Dispatcher filter could not be found
 */
class MissingDispatcherFilterException : UimException {
 
    protected string _messageTemplate = "Dispatcher filter `%s` could not be found.";
}
