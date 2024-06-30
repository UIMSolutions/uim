module uim.oop.interfaces.retrystrategy;

import uim.oop;

@safe:

/**
 * Used to instruct a CommandRetry object on whether a retry
 * for an action should be performed
 */
interface IRetryStrategy {
    // Returns true if the action can be retried, false otherwise.
    bool shouldRetry(DException failException, int retryCount);
}
