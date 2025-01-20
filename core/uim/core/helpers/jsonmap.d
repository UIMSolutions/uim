module uim.core.helpers.jsonmap;

@safe:
import uim.core;

class JsonMapHelper {
  static string toString(Json[string] aa) {
    return "%s".format(aa);
  }
}