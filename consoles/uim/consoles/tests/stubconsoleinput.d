/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.tests.stubconsoleinput;

import uim.consoles;
@safe:

version (test_uim_consoles) {
    unittest {
        writeln("-----  ", __MODULE__, "\t  -----");
    }
}


/**
 * Stub class used by the console integration harness.
 *
 * This class enables input to be stubbed and have exceptions
 * raised when no answer is available.
 */
class DStubInputConsole : DInput {
  // Reply values for ask() and askChoice()
  protected string[] _replies;

  // Current message index
  protected size_t _currentIndex = -1;

  this(string[] repliesForRead) {
    super();
    _replies = repliesForRead;
  }

  // Read a reply
  override string read() {
    _currentIndex += 1;

    /* if (!_replies.hasKey(_currentIndex)) {
            auto total = count(_replies);
            auto formatter = new NumberFormatters("en", NumberFormatters.ORDINAL);
            auto nth = formatter.format(_currentIndex + 1);
            auto repliesText = replies.join(", ");
            
            string message = (
                "There are no more input replies available. This is the {nth} %s read operation, " ~
                "only {total} %s replies were set.\nThe provided replies are: {repliesText} %s")
                .format(nth, total, repliesText);
            throw new DMissingInputConsoleException(message);
        } */
    return _replies[_currentIndex];
  }

  //  Check if data is available on stdin
  bool dataAvailable(int timeToWait = 0) {
    return true;
  }
}
