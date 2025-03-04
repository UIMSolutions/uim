module uim.core.mixins.json;

template CheckJsonIs(string jsonType) {
  const char[] CheckJsonIs = `
bool all`~jsonType~`(Json value, string[] keys...) {
  return value.all`~jsonType~`(keys.dup);
}

bool all`~jsonType~`(Json value, string[] keys) {
  return keys.all!(key => value.is`~jsonType~`(key));
}

bool any`~jsonType~`(Json value, string[] keys...) {
  return value.any`~jsonType~`(keys.dup);
}

bool any`~jsonType~`(Json value, string[] keys) {
  return keys.any!(key => value.is`~jsonType~`(key));
}
`;
}
