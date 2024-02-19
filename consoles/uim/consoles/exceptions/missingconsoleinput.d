module source.uim.consoles.exceptions.missingconsoleinput;

import uim.consoles;

@safe:

// Exception class used to indicate missing console input.
class DMissingConsoleInputException : DConsoleException {
    mixin(ExceptionThis!("MissingConsoleInput"));

    // Update the exception message with the question text
    void setQuestion(string questionText) {
        this.message ~= "\nThe question asked was: " ~ questionText;
    }
}
mixin(ExceptionCalls!("MissingConsoleInput"));
