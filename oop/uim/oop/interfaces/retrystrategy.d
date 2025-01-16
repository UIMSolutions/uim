/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.interfaces.retrystrategy;

import uim.oop;

@safe:

/**
 * Used to instruct a CommandRetry object on whether a retry
 * for an action should be performed
 */
interface IRetryStrategy {
    // Returns true if the action can be retried, false otherwise.
    // bool shouldRetry(DException failException, int retryCount);
}
