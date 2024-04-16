module uim.http.exceptions.clients.exception;

import uim.http;

@safe:

// Thrown when a request cannot be sent or response cannot be parsed into a PSR-7 response object.
class DClientException : RuntimeException, IClientException {
}
