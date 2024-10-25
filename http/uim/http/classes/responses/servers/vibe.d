module uim.http.classes.responses.servers.vibe;

import uim.http;

@safe:

// Server response based on vibe implementation
class DVibeServerResponse {
  mixin(ResponseThis!("VibeServer"));
}

mixin(ResponseCalls!("VibeServer"));
