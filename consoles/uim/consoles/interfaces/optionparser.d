/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.interfaces.optionparser;

interface IConsoleOptionParser {
    // Get or set the command name for shell/task.
    void merge(DConsoleOptionParser buildOptionParser); 
    void merge(Json[string] options);
}
