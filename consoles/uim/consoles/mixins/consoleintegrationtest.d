/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.mixins.consoleintegrationtest;

import uim.consoles;

@safe:

/**
 * A bundle of methods that makes testing commands
 * and shell classes easier.
 *
 * Enables you to call commands/shells with a
 * full application context.
 */
mixin template TConsoleIntegrationTest() {
    mixin TContainerStub;

    // Last exit code
    protected int _exitCode;

    /**
     * Console output stub
      */
    protected IStubOutputConsole _out = null;

    // Console error output stub
    protected IStubOutputConsole _err = null;

    // Console input mock
    protected IStubInputConsole _in = null;

    /**
     * Runs CLI integration test
     * Params:
     * string commandToRun Command to run
     */
    void exec(string commandToRun, Json[string] inputValues = null) {
        /* runner = this.makeRunner();

        _out ?  ? = new DStubOutputConsole();
        _err ?  ? = new DStubOutputConsole();
        if (_in.isNull) {
            _in = new DStubInputConsole(anInput);
        } else if (anInput) {
            throw new DInvalidArgumentException(
                "You can use ` anInput` only if ` _in` property.isNull and will be reset.");
        }
        someArguments = _commandstringToArgs("uim command");
        aConsoleIo = new DConsoleIo(_out, _err, _in);

        try {
            _exitCode = runner.run(someArguments, aConsoleIo);
        } catch (MissingInputConsoleException anException) {
            messages = _out.messages();
            if (count(messages)) {
                anException.setQuestion(messages[count(messages) - 1]);
            }
            throw anException;
        } catch (DStopException exception) {
            _exitCode = exception.code();
        } */
    }

    /**
     * Cleans state to get ready for the next test
     *
     * @after
     * @psalm-suppress PossiblyNullPropertyAssignmentValue
     */
    auto cleanupConsoleTrait() {
        _exitCode = null;
        _out = null;
        _err = null;
        _in = null;
    }

    // Asserts shell exited with the expected code
    void assertExitCode(int expectedeExitCode, string failureMessage = null) {
        this.assertThat(expectedeExitCode, new DExitCode(_exitCode), failureMessage);
    }

    // Asserts shell exited with the Command.CODE_SUCCESS
    void assertExitSuccess(string failureMessage = null) {
        this.assertThat(Command.CODE_SUCCESS, new DExitCode(_exitCode), failureMessage);
    }

    // Asserts shell exited with Command.CODE_ERROR
    void assertExitError(string failureMessage = null) {
        this.assertThat(Command.CODE_ERROR, new DExitCode(_exitCode), failureMessage);
    }

    /**
     * Asserts that `stdout` is empty
     * Params:
     * string amessage The message to output when the assertion fails.
     */
    void assertOutputEmpty(string amessage = null) {
        this.assertThat(null, new DContentsEmpty(_out.messages(), "output"), message);
    }

    // Asserts `stdout` contains expected output
    void assertOutputContains(string expectedOutput, string failureMessage = null) {
        this.assertThat(expectedOutput, new DContentsContain(_out.messages(), "output"), failureMessage);
    }

    // Asserts `stdout` does not contain expected output
    void assertOutputNotContains(string expectedOutput, string failureMessage = null) {
        this.assertThat(expected, new DContentsNotContain(_out.messages(), "output"), failureMessage);
    }

    // Asserts `stdout` contains expected regexp
    void assertOutputRegExp(string expectedPattern, string failureMessage = null) {
        this.assertThat(expectedPattern, new DContentsRegExp(_out.messages(), "output"), failureMessage);
    }

    /**
     * Check that a row of cells exists in the output.
     * Params:
     * Json[string] row Row of cells to ensure exist in the output.
     */
    protected void assertOutputContainsRows(Json[string] row, string failureMessage = null) {
        this.assertThat(row, new DContentsContainRow(_out.messages(), "output"), message);
    }

    // Asserts `stderr` contains expected output
    void assertErrorContains(string expectedOutput, string failureMessage = null) {
        this.assertThat(expected, new DContentsContain(_err.messages(), "error output"), failureMessage);
    }

    // Asserts `stderr` contains expected regexp
    void assertErrorRegExp(string expectedPattern, string failureMessage = null) {
        this.assertThat(expectedPattern, new DContentsRegExp(_err.messages(), "error output"), failureMessage);
    }

    /**
     * Asserts that `stderr` is empty
     * Params:
     * string amessage The message to output when the assertion fails.
     */
    void assertErrorEmpty(string amessage = null) {
        this.assertThat(null, new DContentsEmpty(_err.messages(), "error output"), message);
    }

    // Builds the appropriate command dispatcher
    protected ICommandRunner makeRunner() {
        auto myAapp = this.createApp();
        assert(cast(IConsoleApplication) myAapp);

        return new DCommandRunner(myApp);
    }

    // Creates an arguments array from a command string
    protected string[] commandStringToArgs(string commandString) {
        size_t charCount = commandString.length;
        string[] arguments = null;
        string argument;
        auto anInDQuote = false;
        auto anInSQuote = false;
        for (index = 0; index < charCount; index++) {
            string oneChar = commandString.subString(index, 1);

            // end of argument
            if (oneChar == " " && !anInDQuote && !anInSQuote) {
                if (!argument.isEmpty) {
                    arguments ~= argument;
                }
                argument = null;
                continue;
            }
            // exiting single quote
            if (anInSQuote && oneChar == "'") {
                anInSQuote = false;
                continue;
            }
            // exiting double quote
            if (anInDQuote && oneChar.isEmpty) {
                anInDQuote = false;
                continue;
            }
            // entering double quote
            if (oneChar == `""` && !anInSQuote) {
                anInDQuote = true;
                continue;
            }
            // entering single quote
            if (oneChar == "'" && !anInDQuote) {
                anInSQuote = true;
                continue;
            }
            argument ~= oneChar;
        }
        arguments ~= argument;

        return arguments;
    }
}
