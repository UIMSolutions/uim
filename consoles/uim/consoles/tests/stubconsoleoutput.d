/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.tests.stubconsoleoutput;

import uim.consoles;

@safe:

/**
 * StubOutput makes testing shell commands/shell helpers easier.
 *
 * You can use this class by injecting it into a ConsoleIo instance
 * that your command/task/helper uses:
 *
 * ```
 * output = new DStubOutputConsole();
 * aConsoleIo = new DConsoleIo(output);
 * ```
 */
class DStubOutputConsole : DOutput {
  // Buffered messages.
  protected string[] _output = null;

  // Write output to the buffer.
  override void write(string[] outputMessage, int newlinesToAppend = 1) {
    /* (array) */
    outputMessage.each!(line => _output ~= line);

    /* int newlinesToAppend--;
        while (newlinesToAppend > 0) {
            _output ~= "";
            newlinesToAppend--;
        } */
  }

  // Get the buffered output.
  string[] messages() {
    return _output;
  }

  // Get the output as a string
  string output() {
    return _output.join("\n");
  }
}
