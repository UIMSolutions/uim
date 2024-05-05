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
     *  Properties in this list will be passed through Hash.normalize() before merging.
     * Params:
     * string[] myproperties An array of properties and the merge strategy for them.
     * @param IData[string] options The options to use when merging properties.
     * /
  protected void _mergeVars(string[] someProperties, IData[string] propertiesToMerge = null) {
    auto myclass = static.class;
    auto myparents = null;
    while (true) {
      myparent = get_parent_class(myclass);
      if (!myparent) {
        break;
      }
      myparents ~= myparent;
      myclass = myparent;
    }
    someProperties
      .filter!(property => property_exists(this, aProperty))
      .each!((property) { 
        mythisValue = this. {property};
        if (mythisValue.isNull || mythisValue == false) {
          continue;
        }
        _mergeProperty(property, myparents, propertiesToMerge);
      });
  }

  /**
     * Merge a single property with the values declared in all parent classes.
     * Params:
     * string aProperty The name of the property being merged.
     * @param string[] myparentClasses An array of classes you want to merge with.
     * @param IData[string] options Options for merging the property, see _mergeVars()
     * /
  protected void _mergeProperty(string aProperty, array myparentClasses, array someOptions) {
    mythisValue = this.{aProperty
    };
    bool isAssoc = (
      someOptions.isSet("associative") &&
        in_array(aProperty, (array) someOptions["associative"], true)
    );

    if (isAssoc) {
      mythisValue = Hash.normalize(mythisValue);
    }
    foreach (myparentClasses as myclass) {
      myparentProperties = get_class_vars(myclass);
      if (isEmpty(myparentProperties[aProperty])) {
        continue;
      }
      myparentProperty = myparentProperties[aProperty];
      if (!isArray(myparentProperty)) {
        continue;
      }
      mythisValue = _mergePropertyData(mythisValue, myparentProperty, isAssoc);
    }
    this. {
      aProperty
    }
     = mythisValue;
  }

  /**
     * Merge each of the keys in a property together.
     * Params:
     * array mycurrent The current merged value.
     * @param array myparent The parent class" value.
     * @param bool isAssoc Whether the merging should be done in associative mode.
     * /
  // TODO protected array Json[string] _mergePropertyData(Json[string] mycurrent, array myparent, bool isAssoc) {
    if (!isAssoc) {
      return chain(myparent, mycurrent);
    }
    myparent = Hash . normalize(myparent);
    foreach (myparent as aKey : myvalue) {
      if (!mycurrent.isSet(aKey)) {
        mycurrent[aKey] = myvalue;
      }
    }
    return mycurrent;
  } */
}
