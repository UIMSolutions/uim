module uim.oop.uim.core.retries.commandretry;

import uim.oop;

@safe:

/**
 * Allows any action to be retried in case of an exception.
 *
 * This class DCan be parametrized with a strategy, which will be followed
 * to determine whether the action should be retried.
 */
class DCommandRetry {
    /*enum MyEnum {
        init,
    }
    // The strategy to follow should the executed action fail.
    protected IRetryStrategy strategy;

    protected int maxRetries;

    protected int numRetries;

    /**
     * Creates the CommandRetry object with the given strategy and retry count
     * Params:
     * \UIM\Core\Retry\IRetryStrategy strategy The strategy to follow should the action fail
     * @param int maxRetries The maximum number of retry attempts allowed
     */
    this(IRetryStrategy strategy, int maxRetries = 1) {
        this.strategy = strategy;
        this.maxRetries = maxRetries;
    }
    
    /**
     * The number of retries to perform in case of failure
     * Params:
     * \Closure action Callback to run for each attempt
     */
    Json run(Closure action) {
        this.numRetries = 0;
        while (true) {
            try {
                return action();
            } catch (Exception  anException) {
                if (
                    this.numRetries < this.maxRetries &&
                    this.strategy.shouldRetry(anException, this.numRetries)
                ) {
                    this.numRetries++;
                    continue;
                }
                throw  anException;
            }
        }
    }
    
    // Returns the last number of retry attemps.
    int getRetries() {
        return _numRetries;
    } */
}
