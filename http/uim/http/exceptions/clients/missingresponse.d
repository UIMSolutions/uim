/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.exceptions.clients.missingresponse;/** * Used to indicate that a request did not have a matching mock response. */class MissingResponseException : DException {    protected string _messageTemplate = "Unable to find a mocked response for `%s` to `%s`.";}