module uim.core.mixins.map;

import uim.core;

@safe:

/* template TMap {
    
}
 */
string mapUpdates(string keyType, string valueType, string[] updateTypes) {
    return updateTypes.map!(type => mapUpdates(keyType, valueType, type)).join("\n");
}

string mapUpdates(string keyType, string valueType, string updateType) {
    string mapType = valueType~`[`~keyType~`]`;

    return `
  `~mapType~` update(`~mapType~` items, `~mapType~` merges, `~keyType~`[] keys...) {
    return update(items, merges, keys.dup);
  }

  // Returns a new map with updated values for existing keys
  `~mapType~` update(`~mapType~` items, `~mapType~` merges, `~keyType~`[] keys = null) {
    keys.isNull
      ? merges
          .each!((key, value) => items.update(key, value)) 
      : keys
          .filter!(key => key in merges)
          .each!(key => items.update(key, merges[key]));

    return items;
  }

  // Returns a new map with updated values for existing keys
  `~mapType~` update(`~mapType~` items, `~keyType~`[] keys, `~updateType~` value) {
    keys
      .each!(key => items.update(key, value));
    return items;
  }

  // Returns a new map with updated values for existing keys
  `~mapType~` update(`~mapType~` items, `~keyType~` key, `~updateType~` value) {
    if (key in items) {
      items[key] = value;
    }
    return items;
  }
    `;
}
