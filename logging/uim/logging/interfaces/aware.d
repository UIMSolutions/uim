/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.logging.interfaces.aware;import uim.logging;@safe:// Describes a logger-aware instance.interface ILoggerAware {  // Sets a logger instance on the object.  void logger(ILogger aLogger);}