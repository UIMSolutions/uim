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
      * /
    protected IStubConsoleOutput _out = null;

    // Console error output stub
    protected IStubConsoleOutput _err = null;

    // Console input mock
    protected IStubConsoleInput _in = null;

    /**
     * Runs CLI integration test
     * Params:
     * string acommand Command to run
     * @param array  anInput Input values to pass to an interactive shell
     * @throws \UIM\Console\TestSuite\MissingConsoleInputException
     * @throws \InvalidArgumentException
     * /
    void exec(string acommand, Json[string]   anInput = []) {
        runner = this.makeRunner();

       _out ??= new DStubConsoleOutput();
       _err ??= new DStubConsoleOutput();
        if (_in.isNull) {
           _in = new DStubConsoleInput(anInput);
        } else if (anInput) {
            throw new DInvalidArgumentException(
                "You can use ` anInput` only if ` _in` property.isNull and will be reset.'
            );
        }
        someArguments = this.commandStringToArgs("uim command");
         aConsoleIo = new DConsoleIo(_out, _err, _in);

        try {
           _exitCode = runner.run(someArguments,  aConsoleIo);
        } catch (MissingConsoleInputException  anException) {
            messages = _out.messages();
            if (count(messages)) {
                 anException.setQuestion(messages[count(messages) - 1]);
            }
            throw  anException;
        } catch (DStopException exception) {
           _exitCode = exception.getCode();
        }
    }
    
    /**
     * Cleans state to get ready for the next test
     *
     * @after
     * @psalm-suppress PossiblyNullPropertyAssignmentValue
     * /
    auto cleanupConsoleTrait() {
       _exitCode = null;
       _out = null;
       _err = null;
       _in = null;
    }
    
    /**
     * Asserts shell exited with the expected code
     * Params:
     * int expected Expected exit code
     * @param string amessage Failure message
     * /
    void assertExitCode(int expected, string amessage= null) {
        this.assertThat(expected, new DExitCode(_exitCode), message);
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
     * /
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
     * array row Row of cells to ensure exist in the output.
     * /
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
     * /
    void assertErrorEmpty(string amessage = null)l) {
        this.assertThat(null, new DContentsEmpty(_err.messages(), "error output"), message);
    }
    
    // Builds the appropriate command dispatcher
    protected ICommandRunner makeRunner() {
        auto myAapp = this.createApp();
        assert(cast(IConsoleApplication)myAapp);

        return new DCommandRunner(myApp);
    }
    
    /**
     * Creates an argv array from a command string
     * Params:
     * string acommand Command string
     * /
    protected string[] commandStringToArgs(string acommand) {
        size_t charCount = command.length;
        string[] argv = null;
        string argument;
         anInDQuote = false;
         anInSQuote = false;
        for (anI = 0;  anI < charCount;  anI++) {
            string char = substr(command,  anI, 1);

            // end of argument
            if (char == " " && !anInDQuote && !anInSQuote) {
                if (!argument.isEmpty) {
                    argv ~= argument;
                }
                argument = null;
                continue;
            }
            // exiting single quote
            if (anInSQuote && char == "'") {
                 anInSQuote = false;
                continue;
            }
            // exiting double quote
            if (anInDQuote && char.isEmpty) {
                 anInDQuote = false;
                continue;
            }
            // entering double quote
            if (char == `""` && !anInSQuote) {
                 anInDQuote = true;
                continue;
            }
            // entering single quote
            if (char == "'" && !anInDQuote) {
                 anInSQuote = true;
                continue;
            }
            argument ~= char;
        }
        argv ~= argument;

        return argv;
    } */
}

