module uim.consoles.exceptions.stop;

import uim.consoles;

@safe:

// Exception class for halting errors in console tasks
class DStopException : DConsoleException {
	mixin(ExceptionThis!("Stop"));
}
mixin(ExceptionCalls!("Stop"));

