/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.exceptions.clients.exception;import uim.http;@safe:// Thrown when a request cannot be sent or response cannot be parsed into a PSR-7 response object.class DClientException : UIMException, IClientException {    mixin(ExceptionThis!("Client"));}mixin(ExceptionCalls!("Client"));unittest {    testException(ClientException);}