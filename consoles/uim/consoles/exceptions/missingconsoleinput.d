/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.exceptions.missingconsoleinput;

import uim.consoles;

@safe:

// Exception class used to indicate missing console input.
class DMissingConsoleInputException : DConsoleException {
    mixin(ExceptionThis!("MissingConsoleInput"));

    // Update the exception message with the question text
    void setQuestion(string questionText) {
        // TODO this.message ~= "\nThe question asked was: " ~ questionText;
    }
}

mixin(ExceptionCalls!("MissingConsoleInput"));
