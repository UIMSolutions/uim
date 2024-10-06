/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.exceptions.notimplemented;import uim.http;@safe:// Not Implemented Exception - used when an API method is not implementedclass DNotImplementedException : DHttpException {    protected string _messageTemplate = "%s is not implemented.";    protected int _defaultCode = 501;}