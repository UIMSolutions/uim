/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.caches.exceptions.invalidargument;import uim.caches;@safe:// Exception raised when cache keys are invalid.class DInvalidArgumentException : DCachesException /*, IInvalidArgument */ {  mixin(ExceptionThis!("InvalidArgument"));}mixin(ExceptionCalls!("InvalidArgument"));