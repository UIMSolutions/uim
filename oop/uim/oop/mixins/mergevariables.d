module uim.oop.mixins.mergevariables;

import uim.oop;

@safe:

// Provides features for merging object properties recursively with parent classes.
mixin template TMergeVariables() {
  /**
     * Merge the list of myproperties with all parent classes of the current class.
     *
     * ### Options:
     *
     * - `associative` - A list of properties that should be treated as associative arrays.
     * Properties in this list will be passed through Hash.normalize() before merging.
     */
  protected void _mergeVars(string[] properties, Json[string] propertiesToMerge = null) {
    // TODO
    /* auto myclass = static.classname;
    auto myparents = null;
    while (true) {
      myparent = get_parent_class(myclass);
      if (!myparent) {
        break;
      }
      myparents ~= myparent;
      myclass = myparent;
    }
    properties
      .filter!(property => property_hasKey(this, aProperty))
      .each!((property) { 
        // TODO
        /* auto mythisValue = this. {property};
        if (mythisValue.isNull || mythisValue == false) {
          continue;
        }
        _mergeProperty(property, myparents, propertiesToMerge);  * /
      });

      */
  }

  // Merge a single property with the values declared in all parent classes.
  protected void _mergeProperty(string propertyName, Json[string] parentClasses, Json[string] mergingOptions) {
    // TODO 
    /* auto mythisValue = this.{propertyName};

    bool isAssoc = (
      mergingOptions.hasKey("associative") &&
        isIn(propertyName, mergingOptions.toArray("associative"), true)
   );

    if (isAssoc) {
      mythisValue = Hash.normalize(mythisValue);
    }
    
    parentClasses.each!((classname) {
      auto parentProperties = get_class_vars(classname);
      if (isEmpty(parentProperties[propertyName])) {
        continue;
      }

      auto parentProperty = parentProperties[propertyName];
      if (!isArray(parentProperty)) {
        continue;
      }

      mythisValue = _mergePropertyData(mythisValue, parentProperty, isAssoc);
    });

    // TODO this. {propertyName} = mythisValue;
    */
  }

  // Merge each of the keys in a property together.
  protected Json[string] _mergePropertyData(Json[string] currentData, Json[string] parentClassData, bool shouldMergeAssociaiative) {
    if (!shouldMergeAssociaiative) {
      return chain(parentClassData, currentData);
    }

    Hash.normalize(parentClassData).byKeyValue
      .filter!(kv => !currentData.hasKey(kv.key))
      .each!(key => currentData[kv.key] = kv.value);

    return currentData;
  }
}
