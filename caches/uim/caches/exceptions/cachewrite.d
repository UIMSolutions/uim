module caches.uim.caches.exceptions.cachewrite;

import uim.caches;

@safe:
// Exception raised when cache writing failed for some reason. Replaces triggering an error.
class CacheWriteException : DCachesException {
	mixin(ExceptionThis!("CacheWrite"));
}
mixin(ExceptionCalls!("CacheWrite"));
