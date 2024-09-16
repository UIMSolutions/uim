/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.logging.classes.engines.console;import uim.logging; @safe:// Console logging. Writes logs to console output.class DConsoleLogEngine : DLogEngine {    mixin(LogEngineThis!("Console"));}mixin(LogEngineCalls!("Console"));