module uim.caches.exceptions.cachewrite;

import uim.caches;

@safe:
// Exception raised when cache writing failed for some reason. Replaces triggering an error.
class CacheWriteException : UimException {
	mixin(ExceptionThis!("CacheWriteException"));
}
