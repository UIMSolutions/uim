/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.interfaces.adapter;import uim.http;@safe:// Http client adapter interface.interface IAdapter {    // Send a request and get a response back.    IResponse[] send(IRequest requestObjectToSend, Json[string] streamOptions = null);}