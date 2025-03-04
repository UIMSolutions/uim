/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.tests.stubconsoleoutput;

import uim.consoles;
@safe:

version (test_uim_consoles) {
    unittest {
        writeln("-----  ", __MODULE__, "\t  -----");
    }
}


/**
 * StubOutput makes testing shell commands/shell helpers easier.
 *
 * You can use this class by injecting it into a Console instance
 * that your command/task/helper uses:
 *
 * ```
 * output = new DStubOutputConsole();
 * aConsole = new DConsole(output);
 * ```
 */
class DStubOutputConsole : DOutput {
  // Buffered messages.
  protected string[] _output = null;

  // Write output to the buffer.
  override IOutput write(string[] outputMessage, uint newlinesToAppend = 1) {
    /* (array) */
    outputMessage.each!(line => _output ~= line);

    /* int newlinesToAppend--;
        while (newlinesToAppend > 0) {
            _output ~= "";
            newlinesToAppend--;
        } */
    return this;
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
