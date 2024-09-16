/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.logging.classes.engines.file;import uim.logging;@safe:// File Storage stream for Logging. Writes logs to different files based on the level of log it is.class DFileLogEngine : DLogEngine {    mixin(LogEngineThis!("File"));}mixin(LogEngineCalls!("File"));