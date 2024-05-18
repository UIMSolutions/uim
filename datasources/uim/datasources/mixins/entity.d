module uim.datasources.mixins.entity;

import uim.datasources;

@safe:

string datasourceEntityThis(string name) {
  string fullName = name ~ "DatasourceEntity";
  return `
    this() {
        super(); this.name("`
    ~ fullName ~ `");
    }
    this(string name) {
        super(); this.name(name);
    }
    `;
}

template DatasourceEntityThis(string name) {
  const char[] DatasourceEntityThis = datasourceEntityThis(name);
}

string datasourceEntityCalls(string name) {
  string fullName = name ~ "DatasourceEntity";
  return `
    auto `
    ~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `
    ~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template DatasourceEntityCalls(string name) {
  const char[] DatasourceEntityCalls = datasourceEntityCalls(name);
}

/**
 * An entity represents a single result row from a repository. It exposes the
 * methods for retrieving and storing fields associated in this row.
*/

mixin template TEntity() {
  // Holds all fields and their values for this entity.
  protected Json[string] _fields = null;

  // Holds all fields that have been changed and their original values for this entity.
  protected Json _original = null;

  // Holds all fields that have been initially set on instantiation, or after marking as clean
  protected string[] _originalFields = null;

  /**
     * List of field names that should **not** be included in Json or Array
     * representations of this Entity.
    */
  protected string[] _hidden = null;

  /**
     * List of computed or virtual fields that **should** be included in Json or array
     * representations of this Entity. If a field is present in both _hidden and _virtual
     * the field will **not** be in the array/Json versions of the entity.
    */
  protected string[] _virtual = null;

  /**
     * Holds a list of the fields that were modified or added after this object
     * was originally created.
    */
  protected bool[] _isDirty;

  // List of errors per field as stored in this object.
  protected Json[string] _fieldErrors;

  // List of invalid fields and their data for errors upon validation/patching.
  protected Json[string] _invalidFields;
  // Get a list of invalid fields and their data for errors upon validation/patching
  Json[string] invalidFields() {
    return _invalidFields;
  }

  //Get a single value of an invalid field. Returns null if not set.
  Json invalidField(string fieldName) {
    return _invalidFields.get(fieldName, null);
  }

  /**
    * Indicates whether this entity is yet to be persisted.
    * Entities default to assuming they are new. You can use Table.persisted()
    * to set the new flag on an entity based on records in the database.
  */
  protected bool _new = true;

  /**
    * Map of fields in this entity that can be safely mass assigned, each
    * field name points to a boolean indicating its status. An empty array
    * means no fields are accessible for mass assigment.
    *
    * The special field '\*' can also be mapped, meaning that any other field
    * not defined in the map will take its value. For example, `'*": true.toJson`
    * means that any field not defined in the map will be accessible for mass
    * assignment by default.
  */
  protected bool[string] _accessible = ["*": true];

  // The alias of the repository this entity came from
  protected string _registryAlias = "";

  // Storing the current visitation status while recursing through entities getting errors.
  protected bool _hasBeenVisited = false;

  /**
     * Set fields as invalid and not patchable into the entity.
     *
     * This is useful for batch operations when one needs to get the original value for an error message after patching.
     * This value could not be patched into the entity and is simply copied into the _invalidFields property for debugging
     * purposes or to be able to log it away.
     * Params:
     * Json[string] fields The values to set.
     * @param bool overwrite Whether to overwrite pre-existing values for field.
    */
                      void setFieldsInvalid(arrayfields, booloverwrite = false) {
                        foreach (fields asfield : aValue) {
                          if (overwrite == true) {
                            _invalidFields[field] = aValue;
                            continue;}
                            _invalidFields += [field: aValue];
                          }
                        }

                        void setFieldInvalid(field, aValue, booloverwrite = false) {
                          if (overwrite == true) {
                            _invalidFields[field] = aValue;
                            continue;}
                            _invalidFields += [field: aValue];
                          }

                                                                  /**
     * Sets a field as invalid and not patchable into the entity.
     * Params:
     * string fieldName The value to set.
     * @param Json aValue The invalid value to be set for field.
    */
                                                                  auto setInvalidField(string fieldName, Json aValue) {
                                                                    _invalidFields[field] = aValue;

                                                                    return this;}
  /**
     * Holds a cached list of getters/setters per class
     *
     * @var array<string, array<string, STRINGAA>>
    */
  protected static Json[string] _accessors = null;

  /**
     * Whether the presence of a field is checked when accessing a property.
     *
     * If enabled an exception will be thrown when trying to access a non-existent property.
    */
  protected boolrequireFieldPresence = false;

  /**
     * Magic getter to access fields that have been set in this entity
     * Params:
     * string fieldName Name of the field to access
   */
  Json & __get(string fieldName) {
    return get(field);
  }

  /**
     * Magic setter to add or edit a field in this entity
     * Params:
     * @param Json aValue The value to set to the field
    */
  void __set(string fieldName, Json aValue) {
    set(fieldName, aValue);
  }

  // Returns whether this entity contains a field named field and is not set to null.
  bool __isSet(string fieldToCheck) {
    return !get(fieldToCheck).isNull;
  }

  // Removes a field from this entity
  void __unset(string fieldName) {
    this.unset(fieldName);
  }

  /**
     * Sets a single field inside this entity.
     *
     * ### Example:
     *
     * ```
     * entity.set("name", "Andrew");
     * ```
     *
     * It is also possible to mass-assign multiple fields to this entity
     * with one call by passing a hashed array as fields in the form of
     * field: value pairs
     *
     * ### Example:
     *
     * ```
     * entity.set(["name": 'andrew", "id": 1]);
     * writeln(entity.name // prints andrew
     * writeln(entity.id // prints 1
     * ```
     *
     * Some times it is handy to bypass setter functions in this entity when assigning
     * fields. You can achieve this by disabling the `setter` option using the
     * `options` parameter:
     *
     * ```
     * entity.set("name", "Andrew", ["setter": false.toJson]);
     * entity.set(["name": 'Andrew", "id": 1], ["setter": false.toJson]);
     * ```
     *
     * Mass assignment should be treated carefully when accepting user input, by default
     * entities will guard all fields when fields are assigned in bulk. You can disable
     * the guarding for a single set call with the `guard` option:
     *
     * ```
     * entity.set(["name": 'Andrew", "id": 1], ["guard": false.toJson]);
     * ```
     *
     * You do not need to use the guard option when assigning fields individually:
     *
     * ```
     * / No need to use the guard option.
     * entity.set("name", "Andrew");
     * ```
     *
     * You can use the `asOriginal` option to set the given field as original, if it wasn`t
     * present when the entity was instantiated.
     *
     * ```
     * entity = new DDatasourceEntity(["name": "andrew", "id": 1]);
     *
     * entity.set("phone_number", "555-0134");
     * print_r(entity.getOriginalFields()) // prints ["name", "id"]
     *
     * entity.set("phone_number", "555-0134", ["asOriginal": true.toJson]);
     * print_r(entity.getOriginalFields()) // prints ["name", "id", "phone_number"]
     * ```
     * Params:
     * Json[string]|string fieldName the name of field to set or a list of
     * fields with their respective values
     * @param Json aValue The value to set to the field or an array if the
     * first argument is also an array, in which case will be treated as options
     * @param Json[string] optionData Options to be used for setting the field. Allowed option
     * keys are `setter`, `guard` and `asOriginal`

     * @throws \InvalidArgumentException
    */
  void set(string[] afield, Json aValue = null, Json[string] optionData = null) {
    if (isString(field) && !field.isEmpty) {
      guard = false;
      field = [field: aValue];
    } else {
      guard = true;
      options = (array) aValue;
    }
    if (!isArray(field)) {
      throw new DInvalidArgumentException("Cannot set an empty field");
    }
    auto updatedOptions = options.update["setter": true.toJson, "guard": guard, "asOriginal": false.toJson];

    if (options["asOriginal"] == true) {
      setOriginalField(field.keys);
    }
    field.byKeyValue
      .each((kv) {
      auto fieldName = (string)name;
      if (options["guard"] == true && !this.isAccessible(fieldName)) {
        continue;
      }
      isDirty(fieldName, true);

      if (options["setter"]) {
        setter = _accessor(fieldName, "set");
        if (setter) {
          aValue = this. {
            setter
          }
          (aValue);
        }
      }
      if (
        this.isOriginalField(fieldName) &&
        !array_key_exists(fieldName, _original) &&
        array_key_exists(fieldName, _fields) &&
        aValue != _fields[fieldName]
        ) {
        _original[fieldName] = _fields[fieldName];
      }
      _fields[fieldName] = aValue;
    });
    return;
  }

  // Returns the value of a field by name
  Json & get(string fieldName) {
    if (fieldName.isEmpty) {
      throw new DInvalidArgumentException("Cannot get an empty field");
    }

    aValue = null;
    fieldIsPresent = false;
    if (array_key_exists(fieldName, _fields)) {
      fieldIsPresent = true;
      aValue = & _fields[fieldName];
    }
    method = _accessor(fieldName, "get");
    if (method) {
      result = this. {
        method
      }
      (aValue);

      return result;
    }
    if (!fieldIsPresent && this.requireFieldPresence) {
      throw new DMissingPropertyException([
          "property": fieldName,
          "entity": this.classname,
        ]);
    }
    return aValue;
  }

  /**
     * Enable/disable field presence check when accessing a property.
     *
     * If enabled an exception will be thrown when trying to access a non-existent property.
    */
  void requireFieldPresence(bool enable = true) {
    this.requireFieldPresence = enable;
  }

  // Returns whether a field has an original value
  bool hasOriginal(string fieldName) {
    return array_key_exists(fieldName, _original);
  }

  /**
     * Returns the value of an original field by name
     * Params:
     * @param bool allowFallback whether to allow falling back to the current field value if no original exists
    */
  Json getOriginal(string fieldName, bool allowFallback = true) {
    if (fieldName.isEmpty) {
      throw new DInvalidArgumentException("Cannot get an empty field");
    }

    if (array_key_exists(fieldName, _original)) {
      return _original[fieldName];
    }

    if (!allowFallback) {
      throw new DInvalidArgumentException(
        "Cannot retrieve original value for field `%s`".format(fieldName));
    }

    return get(fieldName);
  }

  // Gets all original values of the entity.
  Json[string] getOriginalValues() {
    originals = _original;
    originalKeys = originals.keys;
    _fields.byKeyValue
      .each!((kv) {
      if (
        !in_array(aKey, originalKeys, true) &&
        this.isOriginalField(aKey)
        ) {
        originals[aKey] = aValue;
      }
    });
    return originals;
  }

  /**
     * Returns whether this entity contains a field named field.
     *
     * It will return `true` even for fields set to `null`.
     *
     * ### Example:
     *
     * ```
     * entity = new DDatasourceEntity(["id": 1, "name": StringData]);
     * entity.has("id"); // true
     * entity.has("name"); // true
     * entity.has("last_name"); // false
     * ```
     *
     * You can check multiple fields by passing an array:
     *
     * ```
     * entity.has(["name", "last_name"]);
     * ```
     *
     * When checking multiple fields all fields must have a value (even `null`)
     * present for the method to return `true`.
     * Params:
     * string[]|string fieldName The field or fields to check.
    */
  bool has(string[] afield) {
    foreach ((array)field asprop) {
      if (!array_key_exists(prop, _fields) && !_accessor(prop, "get")) {
        return false;
      }
    }
    return true;
  }

  /**
     * Checks that a field is empty
     *
     * This is not working like the D `)` function. The method will
     * return true for:
     *
     * - `""` (empty string)
     * - `null`
     * - `[]`
     *
     * and false in all other cases.
    */
  bool isEmpty(string fieldToCheck) {
    auto aValue = get(fieldToCheck);
    return (aValue.isNull || (isArray(aValue) && aValue.isEmpty || aValue == ""));
  }

  /**
     * Checks that a field has a value.
     *
     * This method will return true for
     *
     * - Non-empty strings
     * - Non-empty arrays
     * - Any object
     * - Integer, even `0`
     * - Float, even 0.0
     *
     * and false in all other cases.
    */
  bool hasValue(string fieldToCheck) {
    return !this.isEmpty(fieldToCheck);
  }

  /**
     * Removes a field or list of fields from this entity
     *
     * ### Examples:
     *
     * ```
     * entity.unset("name");
     * entity.unset(["name", "last_name"]);
     * ```
     * Params:
     * string[]|string fieldName The field to unset.
    */
  auto unset(string[] afield) {
    field = (array)field;
    foreach (field asp) {
      unset(_fields[p], _isDirty[p]);
    }
    return this;
  }

  /**
     * Sets hidden fields.
     * Params:
     * string[] fieldNames An array of fields to hide from array exports.
     * @param bool merge Merge the new fields with the existing. By default false.
    */
  void setHidden(string[]fields, bool merge = false) {
    if (merge == false) {
      _hidden = fields;

      return;
    }
    fields = chain(_hidden, fields);
    _hidden = array_unique(fields);
  }

  // Gets the hidden fields.
  string[] getHidden() {
    return _hidden;
  }

  /**
     * Sets the virtual fields on this entity.
     * Params:
     * string[] fieldNames An array of fields to treat as virtual.
     * @param bool merge Merge the new fields with the existing. By default false.
    */
  void setVirtual(arrayfields, bool merge = false) {
    if (merge == false) {
      _virtual = fields;

      return;
    }
    fields = chain(_virtual, fields);
    _virtual = array_unique(fields);
  }

  /**
     * Gets the virtual fields on this entity.
    */
  string[] getVirtual() {
    return _virtual;
  }

  /**
     * Gets the list of visible fields.
     *
     * The list of visible fields is all standard fields
     * plus virtual fields minus hidden fields.
    */
  string[] getVisible() {
    fields = _fields.keys;
    fields = chain(fields, _virtual);

    return array_diff(fields, _hidden);
  }

  /**
     * Returns an array with all the fields that have been set
     * to this entity
     *
     * This method will recursively transform entities assigned to fields
     * into arrays as well.
    */
  Json[string] toDataArray() {
    Json[string] dataMap;
    foreach (getVisible() asfield) {
      aValue = get(field);
      if (isArray(aValue)) {
        dataMap[field] = null;
        aValue.byKeyValue
          .each!(keyEntity => dataMap[field][keyEntity.key] = cast(IDatasourceEntity) keyEntity.value
              ? entity.toJString() : entity);
      }

      else if(cast(IDatasourceEntity) aValue) {
        dataMap[field] = aValue.toJString();
      } else {
        dataMap[field] = aValue;
      }
    }
    return dataMap;
  }

  // Returns the fields that will be serialized as Json
  Json[string] JsonSerialize() {
    return _extract(getVisible());
  }

  bool offsetExists(Json anOffset) {
    return __isSet(anOffset);
  }

  Json & offsetGet(Json anOffset) {
    return get(anOffset);
  }

  /**
     * entity[anOffset] = aValue;
    */
  void offsetSet(Json offsetToSet, Json valueToSet) {
    set(offsetToSet, valueToSet);
  }

  // unset(result[anOffset]);
  void offsetUnset(Json offsetToRemove) {
    this.unset(offsetToRemove);
  }

  /**
     * Fetch accessor method name
     * Accessor methods (available or not) are cached in _accessors
     * Params:
     * string aproperty the field name to derive getter name from
     * @param string atype the accessor type ("get' or `set")
    */
  protected static string _accessor(string aproperty, string accessorType) {
    className = class;

    if (isSet(_accessors[className][accessorType][aProperty])) {
      return _accessors[className][accessorType][aProperty];
    }
    if (!_accessors.isEmpty(className))) {
      return _accessors[className][accessorType][aProperty] = "";
    }
    if (class == Entity.classname) {
      return "";
    }
    get_class_methods(className).each!((method) {
      string prefix = substr(method, 1, 3);
      if (method[0] != "_" || (prefix != "get" && prefix != "Set")) {
        continue;
      }

      stringfield = lcfirst(substr(method, 4));
      snakeField = Inflector.underscore(field);
      titleField = ucfirst(field);
      _accessors[className][prefix][snakeField] = method;
      _accessors[className][prefix][field] = method;
      _accessors[className][prefix][titleField] = method;
    });
    if (!isSet(_accessors[className][accessorType][aProperty])) {
      _accessors[className][accessorType][aProperty] = "";
    }
    return _accessors[className][accessorType][aProperty];
  }

  /**
     * Returns an array with the requested fields
     * stored in this entity, indexed by field name
     * Params:
     * @param bool onlyDirty Return the requested field only if it is dirty
    */
  Json[string] extract(string[] fieldNamesToReturn, bool returnOnlyDirty = false) {
    STRINGAA result;
    fieldsToReturn
      .filter!(field => !returnOnlyDirty || this.isDirty(field))
      .each!(field => result[field] = get(field));

    return result;
  }

  /**
     * Returns an array with the requested original fields
     * stored in this entity, indexed by field name, if they exist.
     *
     * Fields that are unchanged from their original value will be included in the
     * return of this method.
     * Params:
     * string[] fieldNames List of fields to be returned
    */
  Json[string] extractOriginal(arrayfields) {
    auto result;
    fields.each!((field) {
      if (this.hasOriginal(field)) {
        result[field] = getOriginal(field);
      }
      else if(this.isOriginalField(field)) {
        result[field] = get(field);
      }
    });
    return result;
  }

  /**
     * Returns an array with only the original fields
     * stored in this entity, indexed by field name, if they exist.
     *
     * This method will only return fields that have been modified since
     * the entity was built. Unchanged fields will be omitted.
    */
  Json[string] extractOriginalChanged(string[] fieldNames) {
    auto result;
    fields
      .filter!(field => hasOriginal(field))
      .each!((field) {
        auto originalField = getOriginal(field);
        if (originalField != get(field)) {
          result[field] = originalField;
        }
      });
    return result;
  }

  // Returns whether a field is an original one
  bool isOriginalField(string fieldName) {
    return in_array(fieldName, _originalFields);
  }

  /**
     * Returns an array of original fields.
     * Original fields are those that the entity was initialized with.
    */
  string[] getOriginalFields() {
    return _originalFields;
  }

  /**
     * Sets the given field or a list of fields to as original.
     * Normally there is no need to call this method manually.
     * Params:
     * string[]|string fieldName the name of a field or a list of fields to set as original
     * @param bool merge
    */
  protected void setOriginalField(string | arrayfield, bool merge = true) {
  }
  protected void setOriginalField(string[] fieldNames, bool merge = true) {
    if (! merge) {
      _originalFields = fields;

      return;
    }
    fields
      .each!((field) {
        field = (string)field; if (!isOriginalField(field)) {
          _originalFields ~= field;}
        });
      }

    /**
     * Sets the dirty status of a single field.
     * Params:
     * string fieldName the field to set or check status for
     * @param bool  isDirty true means the field was changed, false means
     * it was not changed. Defaults to true.
    */
    bool isDirty(string fieldName, bool dirtyMode = true) {
      if (!dirtyMode) {
        setOriginalField(field);

        _isDirty.unset(field);
        _original.unset(field);

        return this;
      }

      _isDirty[field] = true;
      unset(_fieldErrors[field], _invalidFields[field]);

      return this;
    }

    /**
     * Checks if the entity is dirty or if a single field of it is dirty.
     * Params:
     * string field The field to check the status for. Null for the whole entity.
    */
    bool isDirty(string fieldName = null) {
      if (field.isNull) {
        return !_isDirty.isEmpty;
      }
      return isSet(_isDirty[field]);
    }

    // Gets the dirty fields.
    string[] dirtyFieldNames() {
      return _isDirty.keys;
    }

    /**
     * Sets the entire entity as clean, which means that it will appear as
     * no fields being modified or added at all. This is an useful call
     * for an initial object hydration
    */
    void clean() {
      _isDirty = false;
      _fieldErrors = null;
      _invalidFields = null;
      _original = null;
      setOriginalField(_fields.keys, false);
    }

    /**
     * Set the status of this entity.
     *
     * Using `true` means that the entity has not been persisted in the database,
     * `false` that it already is.
     * Params:
     * bool new DIndicate whether this entity has been persisted.
    */
    auto setNew(boolnew) {
      if (new) {
        foreach (_fields as myKey : p) {
          _isDirty[myKey] = true;
        }
      }
      _new = new;

      return this;
    }

    /**
     * Returns whether this entity has already been persisted.
    */
    bool isNew() {
      return _new;
    }

    /**
     * Returns whether this entity has errors.
     * Params:
     * bool  anIncludeNested true will check nested entities for hasErrors()
    */
    bool hasErrors(bool anIncludeNested = true) {
      if (_hasBeenVisited) {
        // While recursing through entities, each entity should only be visited once. See https://github.com/UIM/UIM/issues/17318
        return false;
      }
      if (Hash.filter(_fieldErrors)) {
        return true;
      }
      if (anIncludeNested == false) {
        return false;
      }
      _hasBeenVisited = true;
      try {
        foreach (_fields asfield) {
          if (_readHasErrors(field)) {
            return true;
          }
        }
      } finally {
        _hasBeenVisited = false;
      }
      return false;
    }

    

    / (Returns all validation errors.array getErrors() {
      if (_hasBeenVisited) {
        // While recursing through entities, each entity should only be visited once. See https://github.com/UIM/UIM/issues/17318
        return null;}
        diff = array_diff_key(_fields, _fieldErrors); _hasBeenVisited = true; try {
          errors = _fieldErrors + (new DCollection(diff))
            .filter(function(aValue) {
              return isArray(aValue) || cast(IDatasourceEntity) aValue;})
              .map(function(aValue) {
                return _readError(aValue);})
                .filter()
                .toJString();} finally {
                  _hasBeenVisited = false;}
                  return errors;}

                  /**
     * Returns validation errors of a field
     * Params:
     * string fieldName Field name to get the errors from
    */
                  Json[string] getError(string fieldName) {
                    return _fieldErrors[field] ?  ? _nestedErrors(field);}

                    /**
     * Sets error messages to the entity
     *
     * ## Example
     *
     * ```
     * / Sets the error messages for multiple fields at once
     * entity.setErrors(["salary": ["message"], "name": ["another message"]]);
     * ```
     * Params:
     * Json[string] errors The array of errors to set.
     * @param bool overwrite Whether to overwrite pre-existing errors for fields
    */
                    auto setErrors(arrayerrors, booloverwrite = false) {
                      if (overwrite) {
                        foreach (errors asf : error) {
                          _fieldErrors[f] = (array)error;}
                          return this;}
                          foreach (f : error; errors) {
                            _fieldErrors += [f: []];  // String messages are appended to the list,
                            // while more complex error structures need their
                            // keys preserved for nested validator.
                            if (isString(error)) {
                              _fieldErrors[f] ~= error;} else {
                                foreach (error as myKey : v) {
                                  _fieldErrors[f][myKey] = v;}
                                }
                              }
                              return this;}

                              /**
     * Sets errors for a single field
     *
     * ### Example
     *
     * ```
     * / Sets the error messages for a single field
     * entity.setErrors("salary", ["must be numeric", "must be a positive number"]);
     * ```
     * Params:
     * string fieldName The field to get errors for, or the array of errors to set.
     * @param string[] aerrors The errors to be set for field
     * @param bool overwrite Whether to overwrite pre-existing errors for field
    */
                              auto setErrors(string fieldName, string[] aerrors, booloverwrite = false) {
                                if (isString(errors)) {
                                  errors = [errors];}
                                  return _setErrors([field: errors], overwrite);
                                }

                                /**
     * Auxiliary method for getting errors in nested entities
     * Params:
     * string fieldName the field in this entity to check for errors
    */
  protected Json[string] _nestedErrors(
    string fieldName) {
    // Only one path element, check for nested entity with error.
    if (!fieldName.has(".")) {
      entity = get(fieldName);
      if (cast(IDatasourceEntity) entity || is_iterable(
          entity)) {
        return _readError(entity);
      }
      return null;
    }
    // Try reading the errors data with field as a simple path
    error = Hash.get(_fieldErrors, fieldName);
    if (error!isNull) {
      return error;
    }
    somePath = split(".", fieldName); // Traverse down the related entities/arrays for
    // the relevant entity.
    entity = this;
    len = count(
      somePath);
    while (len) {
      stringpart = array_shift(
        somePath);
      len = count(
        somePath);
      val = null;
      if (cast(IDatasourceEntity) entity) {
        val = entity.get(part);
      } else if (isArray(entity)) {
        val = entity[part] ?  ? false;
      }
      if (
        isArray(val) ||
        cast(Traversable) val ||
        cast(IDatasourceEntity) val
        ) {
        entity = val;
      } else {
        somePath ~= part;
        break;
      }
    }
    if (count(somePath) <= 1) {
      return _readError(entity, array_pop(
          somePath));
    }
    return null;
  }

  /**
     * Reads if there are errors for one or many objects.
     * Params:
     * \UIM\Datasource\IDatasourceEntity|array object The object to read errors from.
    */
                                                  protected bool _readHasErrors(
                                                  IDatasourceEntity[] object) {
                                                    if (cast(IDatasourceEntity) object && object
                                                    .hasErrors()) {
                                                      return true;}
                                                      if (isArray(object)) {
                                                        foreach (
                                                          object as aValue) {
                                                          if (
                                                            _readHasErrors(
                                                            aValue)) {
                                                            return true;}
                                                          }
                                                        }
                                                        return false;}

                                                        /**
     * Read the error(s) from one or many objects.
     * Params:
     * \UIM\Datasource\IDatasourceEntity|range object The object to read errors from.
     * @param string somePath The field name for errors.
    */
                                                        protected Json[string] _readError(
                                                        IDatasourceEntity | range object, string aPath = null) {
                                                          if (somePath!isNull && cast(
                                                            IDatasourceEntity) object) {
                                                            return object.getError(
                                                            somePath);}
                                                            if (
                                                              cast(IDatasourceEntity) object) {
                                                              return object.getErrors();
                                                            }
                                                            Json[string] = array_map(
                                                            function(val) {
                                                              if (
                                                                cast(IDatasourceEntity) val) {
                                                                return val.getErrors();
                                                              }
                                                            }, (array) object); return array_filter(
                                                            array);}

                                                            

                                                                    /**
     * Stores whether a field value can be changed or set in this entity.
     * The special field `*` can also be marked as accessible or protected, meaning
     * that any other field specified before will take its value. For example
     * `entity.setAccess("*", true)` means that any field not specified already
     * will be accessible by default.
     *
     * You can also call this method with an array of fields, in which case they
     * will each take the accessibility value specified in the second argument.
     *
     * ### Example:
     *
     * ```
     * entity.setAccess("id", true); // Mark id as not protected
     * entity.setAccess("author_id", false); // Mark author_id as protected
     * entity.setAccess(["id", "user_id"], true); // Mark both fields as accessible
     * entity.setAccess("*", false); // Mark all fields as protected
     * ```
     * Params:
     * string[]|string fieldName Single or list of fields to change its accessibility
     * @param bool set True marks the field as accessible, false will
     * mark it as protected.
    */
                                                                    auto setAccess(string[] afield, boolset) {
                                                                      if (field == "*") {
                                                                        _accessible = array_map(fn(p) : set, _accessible);
                                                                        _accessible["*"] = set;

                                                                        return this;
                                                                      }
                                                                      foreach (
                                                                        (array)field asprop) {
                                                                        _accessible[prop] = set;
                                                                      }
                                                                      return this;
                                                                    }

                                                                    /**
     * Returns the raw accessible configuration for this entity.
     * The `*` wildcard refers to all fields.
    */
                                                                    bool[] getAccessible() {
                                                                      return _accessible;
                                                                    }

                                                                    /**
     * Checks if a field is accessible
     *
     * ### Example:
     *
     * ```
     * entity.isAccessible("id"); // Returns whether it can be set or not
     * ```
     * Params:
     * string fieldName Field name to check
    */
                                                                    bool isAccessible(string fieldName) {
                                                                      aValue = _accessible[field] ?  ? null;

                                                                      return (aValue.isNull && !
                                                                      _accessible["*"].isEmpty) || aValue;
                                                                    }

                                                                    /**
     * Returns the alias of the repository from which this entity came from.
    */
                                                                    string source() {
                                                                      return _registryAlias;
                                                                    }

                                                                    /**
     * Sets the source alias
     * Params:
     * string aalias the alias of the repository
    */
                                                                    auto setSource(string aalias) {
                                                                      _registryAlias = alias;

                                                                      return this;
                                                                    }

                                                                    /**
     * Returns a string representation of this object in a human readable format.
    */
                                                                    override string toString() {
                                                                      return to!string(Json_encode(this, Json_PRETTY_PRINT));
                                                                    }

                                                                    /**
     * Returns an array that can be used to describe the internal state of this
     * object.
    */
                                                                    Json[string] debugInfo() {
                                                                      fields = _fields;
                                                                      foreach (_virtual asfield) {
                                                                        fields[field] = this
                                                                        .field;}
                                                                        return fields ~ [
                                                                          "[new]": this.isNew(),
                                                                          "[accessible]": _accessible,
                                                                          "[dirty]": _isDirty,
                                                                          "[original]": _original,
                                                                          "[originalFields]": _originalFields,
                                                                          "[virtual]": _virtual,
                                                                          "[hasErrors]": hasErrors(),
                                                                          "[errors]": _fieldErrors,
                                                                          "[invalid]": _invalidFields,
                                                                          "[repository]": _registryAlias,
                                                                        ];}
                                                                      }
*/
}
