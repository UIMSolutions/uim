module consoles.uim.consoles.tests.constraints.exitcode;

import uim.consoles;

@safe:

/**
 * ExitCode constraint
 *
 * @internal
 */
class DExitCode : DConstraint {
    private int _exitCode = null;

    this(int exitCode) {
        _exitCode = exitCode;
    }
    
    /**
     * Checks if event is in fired array
     * Params:
     * IData other Constraint check
     */
   bool matches(IData other) {
        return other == this.exitCode;
    }
    
    // Assertion message string
    string toString() {
        return "matches exit code `%s`".format(this.exitCode ?? "null");
    }
    
    /**
     * Returns the description of the failure.
     * Params:
     * IData other Expected
     */
    string failureDescription(IData other) {
        return "`" ~ other ~ "` " ~ this.toString();
    }
}

