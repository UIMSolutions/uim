/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.interfaces.optionparser;

import uim.consoles;

@safe:

interface IConsoleOptionParser {
  // #region description
  // Sets the description text for shell/task.
  string description();
  IConsoleOptionParser description(string[] descriptions...);
  IConsoleOptionParser description(string[] descriptions);
  // #endregion description

  // Get or set the command name for shell/task.
  IConsoleOptionParser merge(IConsoleOptionParser buildOptionParser);
  IConsoleOptionParser merge(Json[string] options);

  IConsoleOptionParser addArgument(DInputArgument inputArgument, Json[string] argumentParameters = null);
  IConsoleOptionParser addArgument(string name, Json[string] params = null);
}
