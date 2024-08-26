module uim.core.containers.maps.keys.map;

@safe:
import uim.core;

unittest {
  writeln("-----  ", __MODULE__ , "\t  -----");
}

// #region replaceKey
V[K] replaceKey(K, V)(V[K] entries, K[] originalPath, K[] newPath) {
  if (originalPath.length != newPath.length) {
    return entries;
  }

  // TODO 
  return entries;
}

V[K] replaceKey(K, V)(V[K] entries, K originalKey, K newKey) {
  if (!entries.hasKey(originalKey)) {
    return entries;
  }

  V value = entries.get(originalKey);
  entries.remove(originalKey);
  entries.set(newKey, value);

  return entries;
}

///
unittest {
  auto testMap = createMap!(string, Json)
    .set("a", "A")
    .set("obj", createMap!(string, Json).set("b", "B"));

  assert(!testMap.hasKey("A"));
  assert(testMap.getString("a") == "A");
  assert(testMap.replaceKey("a", "A"));
  assert(testMap.hasKey("A"));
  assert(testMap.getString("A") == "A");
}
// #endregion replaceKey
