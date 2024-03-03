module uim.caches.exceptions.invalidargument;

import uim.caches;

@safe:

// Exception raised when cache keys are invalid.
class DInvalidArgumentException : DCachesException /*, IInvalidArgument */ {
	mixin(ExceptionThis!("InvalidArgument"));
}
mixin(ExceptioncALLS!("InvalidArgument"));
