module uim.cake.core\Retry;

import uim.cake;

@safe:

/**
 * Used to instruct a CommandRetry object on whether a retry
 * for an action should be performed
 */
interface IRetryStrategy {
    /**
     * Returns true if the action can be retried, false otherwise.
     * Params:
     * \Exception exception The exception that caused the action to fail
     * @param int retryCount The number of times action has been retried
     */
    bool shouldRetry(Exception failException, int retryCount);
}
