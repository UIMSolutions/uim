module uim.caches.exceptions.invalidargument;

import uim.caches;

@safe:

// Exception raised when cache keys are invalid.
class InvalidArgumentException : CacheException /*, IInvalidArgument */ {
	mixin(ExceptionThis!("InvalidArgumentException"));
}
// TODO define IValidArgument
