/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.classes.callbackstream;

import uim.http;

@safe:

/**
 * Implementation of PSR HTTP streams.
 *
 * This differs from Laminas\Diactoros\Callback stream in that
 * it allows the use of `echo` inside the callback, and gracefully
 * handles the callback not returning a string.
 *
 * Ideally we can amend/update diactoros, but we need to figure
 * that out with the diactoros project. Until then we'll use this shim
 * to provide backwards compatibility with existing UIM apps.
 *
 * @internal
 */
class DCallbackStream { // }: BaseCallbackStream {
    string getContents() {
        string result = "";
        /*
        auto aCallback = this.detach();
        if (aCallback !is null) {
            result = aCallback();
        }
        if (!isString(result)) {
            return null;
        } */
        return result;
    }
} 
