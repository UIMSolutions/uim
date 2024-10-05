/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.exceptions.missingcontroller;

import uim.http;

@safe:

// Exception used when a controller cannot be found.
class MissingControllerException : UIMException {
 
    protected int _defaultCode = 404;

    protected string _messageTemplate = "Controller class `%s` could not be found.";
}
