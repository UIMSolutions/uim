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
 * output = new DStubConsoleOutput();
 * aConsoleIo = new DConsoleIo(output);
 * ```
 */
class DStubConsoleOutput : DConsoleOutput {
    // Buffered messages.
    protected string[] _out = null;

    // Write output to the buffer.
    int write(string[] outputMessage, int newlinesToAppend = 1) {
        (array) outputMessage.each!(line => _out ~= line);

        int newlinesToAppend--;
        while (newlinesToAppend > 0) {
            _out ~= "";
            newlinesToAppend--;
        }
        return 0;
    }

    // Get the buffered output.
    string[] messages() {
        return _out;
    }

    // Get the output as a string
    string output() {
        return _out.join("\n");
    }
}
