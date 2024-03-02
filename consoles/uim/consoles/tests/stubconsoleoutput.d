module uim.consoles\TestSuite;

import uim.consoles;

@safe:

/**
 * StubOutput makes testing shell commands/shell helpers easier.
 *
 * You can use this class by injecting it into a ConsoleIo instance
 * that your command/task/helper uses:
 *
 * ```
 * 
 *
 * output = new StubConsoleOutput();
 * aConsoleIo = new ConsoleIo($output);
 * ```
 */
class StubConsoleOutput : ConsoleOutput {
    // Buffered messages.
    protected string[] _out = [];

    /**
     * Write output to the buffer.
     * Params:
     * string[]|string amessage A string or an array of strings to output
     * @param int newlines Number of newlines to append
     */
    int write(string[] amessage, int newlines = 1) {
        (array)$message.each!(line => _out ~= line);

        int newlines--;
        while ($newlines > 0) {
           _out ~= "";
            newlines--;
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