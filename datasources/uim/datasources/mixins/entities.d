module uim.datasources.mixins.entities;

import uim.datasources;

@safe:

/**
 * An entity represents a single result row from a repository. It exposes the
 * methods for retrieving and storing fields associated in this row.
*/

mixin template TEntity() {
  // Holds all fields and their values for this entity.
  protected Json[string] _fields = null;

  // Holds all fields that have been changed and their original values for this entity.
  protected Json _originalFields = null;

  // Holds all fields that have been initially set on instantiation, or after marking as clean
  protected string[] _originalFieldsFields = null;

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
  protected bool[] _isChangedFields;

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
  protected bool _isNew = true;

  /**
    * MapHelper of fields in this entity that can be safely mass assigned, each
    * field name points to a boolean indicating its status. An empty array
    * means no fields are accessible for mass assigment.
    *
    * The special field '\*' can also be mapped, meaning that any other field
    * not defined in the map will take its value. For example, `'*": true`
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
    */
  void setFieldsInvalid(Json[string] fields, bool shouldOverwrite = false) {
    /* foreach (fields as field : aValue) {
      if (shouldOverwrite == true) {
        _invalidFields.set(field, aValue);
        continue;
      }
      _invalidFields += [field: aValue];
    } */
  }

  void setFieldInvalid(field, aValue, booloverwrite = false) {
    if (overwrite == true) {
      _invalidFields.set(field, aValue);
      continue;
    }
    _invalidFields += [field: aValue];
  }

  // Sets a field as invalid and not patchable into the entity.
  void setInvalidField(string fieldName, Json invalidValue) {
    _invalidFields.set(field, aValue);
  }

  // Holds a cached list of getters/setters per class
  protected static Json[string] _accessors = null;

  /**
     * Whether the presence of a field is checked when accessing a property.
     *
     * If enabled an exception will be thrown when trying to access a non-existent property.
    */
  protected bool requireFieldPresence = false;

  /**
     * Magic getter to access fields that have been set in this entity
     * Params:
     * string fieldName Name of the field to access
   */
  /* Json & __get(string fieldName) {
    return get(field);
  } */

  // Magic setter to add or edit a field in this entity
  void __set(string fieldName, Json valueToSet) {
    set(fieldName, aValue);
  }

  // Returns whether this entity contains a field named field and is not set to null.
  bool __isSet(string fieldToCheck) {
    return !get(fieldToCheck).isNull;
  }

  // Removes a field from this entity
  void __removeKey(string fieldName) {
    this.removeKey(fieldName);
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
     * entity.setPath(["name": 'andrew", "id": 1]);
     * writeln(entity.name // prints andrew
     * writeln(entity.id // prints 1
     * ```
     *
     * Some times it is handy to bypass setter functions in this entity when assigning
     * fields. You can achieve this by disabling the `setter` option using the
     * `options` parameter:
     *
     * ```
     * entity.set("name", "Andrew", ["setter": false]);
     * entity.setPath(["name": 'Andrew", "id": 1], ["setter": false]);
     * ```
     *
     * Mass assignment should be treated carefully when accepting user input, by default
     * entities will guard all fields when fields are assigned in bulk. You can disable
     * the guarding for a single set call with the `guard` option:
     *
     * ```
     * entity.setPath(["name": 'Andrew", "id": 1], ["guard": false]);
     * ```
     *
     * You do not need to use the guard option when assigning fields individually:
     *
     * ```
     * No need to use the guard option.
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
     * entity.set("phone_number", "555-0134", ["asOriginal": true]);
     * print_r(entity.getOriginalFields()) // prints ["name", "id", "phone_number"]
     * ```
     * Params:
     * Json[string]|string fieldName the name of field to set or a list of
     * fields with their respective values
    */
  void set(string[] fieldName, Json valueToSet = null, Json[string] options = null) {
  }

  void set(string[] fieldName, Json valueToSet = null, Json[string] options = null) {
    bool guard;
    if (fieldName.isString && !fieldName.isEmpty) {
      guard = false;
      fieldName = [fieldName: valueToSet];
    } else {
      guard = true;
      options =  /* (array) */ valueToSet;
    }
    if (!fieldName.isArray) {
      throw new DInvalidArgumentException("Cannot set an empty field");
    }
    options
      .merge("setter", true)
      .merge("guard", guard)
      .merge("asOriginal", false);

    if (options.getBoolean("asOriginal")) {
      setOriginalField(fieldName.keys);
    }
    /*  fieldName.byKeyValue
      .each((kv) {
        auto fieldName =  /* (string)  */
    name;
    if (options.getBoolean("guard") && !this.isAccessible(fieldName)) {
      continue;
    }
    isChanged(fieldName, true);

    /* if (options.hasey("setter")) {
          setter = _accessor(fieldName, "set");
          if (setter) {
            valueToSet = this. {
              setter
            }
            (valueToSet);
          }
        } */
    /* if (
          this.isOriginalField(fieldName) && !hasKey(fieldName, _originalFields) &&
        hasKey(fieldName, _fields) && valueToSet != _fields[fieldName]
          ) {
          _originalFields[fieldName] = _fields[fieldName];
        } * /
        _fields[fieldName] = valueToSet;
      }); */
  }

  // Returns the value of a field by name
  Json get(string fieldName) {
    if (fieldName.isEmpty) {
      throw new DInvalidArgumentException("Cannot get an empty field");
    }

    Json aValue = null;
    auto fieldIsPresent = false;
    if (hasKey(fieldName, _fields)) {
      fieldIsPresent = true;
      aValue = &_fields[fieldName];
    }

    auto method = _accessor(fieldName, "get");
    if (method) {
      /* return this. {
        method
      }
      (aValue); */
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
     * If enabled an exception will be thrown when trying to access a non-existent property.
    */
  void requireFieldPresence(bool enable = true) {
    this.requireFieldPresence = enable;
  }

  // Returns whether a field has an original value
  bool hasOriginal(string fieldName) {
    return hasKey(fieldName, _originalFields);
  }

  // Returns the value of an original field by name
  Json getOriginal(string fieldName, bool allowFallback = true) {
    if (fieldName.isEmpty) {
      throw new DInvalidArgumentException("Cannot get an empty field");
    }

    if (hasKey(fieldName, _originalFields)) {
      return _originalFields[fieldName];
    }

    if (!allowFallback) {
      throw new DInvalidArgumentException(
        "Cannot retrieve original value for field `%s`".format(fieldName));
    }

    return get(fieldName);
  }

  // Gets all original values of the entity.
  Json[string] getOriginalValues() {
    originals = _originalFields;
    originalKeys = originals.keys;
    _fields.byKeyValue
      .each!((kv) {
        if (
          !isIn(aKey, originalKeys, true) &&
        this.isOriginalField(aKey)
          ) {
          originals.set(aKey, aValue);
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
     * entity.contains("id"); // true
     * entity.contains("name"); // true
     * entity.contains("last_name"); // false
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
  bool has( /* string  */ string[] fieldNames) {
    foreach ( /* (array) */ fieldName; fieldNames) {
      /* if (!hasKey(fieldName, _fields) && !_accessor(fieldName, "get")) {
        return false;
      } */
    }
    return true;
  }

  /**
     * Checks that a field is empty
     *
     * This is not working like the UIM `)` function. The method will
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
    return (aValue.isNull || (isArray(aValue) && aValue.isEmpty || aValue is null));
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
     * entity.removeKey("name");
     * entity.removePath(["name", "last_name"]);
     * ```
     * Params:
     * string[]|string fieldName The field to unset.
    */
  auto removeKey(string[] afield) {
    field =  /* (array) */ field;
    foreach (p; field) {
      removeKey(_fields[p], _isChangedFields[p]);
    }
    return this;
  }

  // Sets hidden fields.
  void hiddenFields(string[] fieldsToHide, bool shouldMerge = false) {
    if (shouldMerge == false) {
      _hidden = fieldsToHide;
      return;
    }

    auto mergedFields = chain(_hidden, fieldsToHide);
    _hidden = mergedFields.unique;
  }

  // Gets the hidden fields.
  string[] hiddenFields() {
    return _hidden;
  }

  // Sets the virtual fields on this entity.
  void setVirtual(string[] fieldNames, bool shouldMerge = false) {
    if (shouldMerge == false) {
      _virtual = fieldNames;

      return;
    }
    fieldNames = chain(_virtual, fieldNames);
    _virtual = fieldNames.unique;
  }

  // Gets the virtual fields on this entity.
  string[] virtualFields() {
    return _virtual;
  }

  /**
     * Gets the list of visible fields.
     * The list of visible fields is all standard fields plus virtual fields minus hidden fields.
    */
  string[] visibleFields() {
    auto fieldKeys = chain(_fields.keys, _virtual);
    return fieldKeys.diff(_hidden);
  }

  /**
     * Returns an array with all the fields that have been set
     * to this entity
     *
     * This method will recursively transform entities assigned to fields
     * into arrays as well.
    */
  Json[string] toArray() {
    Json[string] dataMap;
    visibleFields.each!((field) {
      auto aValue = get(field);
      if (aValue.isArray) {
        dataMap[field] = null;
        aValue.byKeyValue
          .each!(keyEntity => dataMap[field][keyEntity.key] = cast(IDatasourceEntity) keyEntity.value
            ? entity.toJString() : entity);
      } else if (cast(IDatasourceEntity) aValue) {
        dataMap[field] = aValue.toJString();
      } else {
        dataMap[field] = aValue;
      }
    });
    return dataMap;
  }

  // Returns the fields that will be serialized as Json
  Json[string] JsonSerialize() {
    return _extract(visibleFields());
  }

  bool offsethasKey(Json anOffset) {
    return __isSet(anOffset);
  }

  Json offsetGet(Json anOffset) {
    return get(anOffset);
  }

  // entity[anOffset] = aValue;
  void offsetSet(Json offsetToSet, Json valueToSet) {
    set(offsetToSet, valueToSet);
  }

  // removeKey(result[anOffset]);
  void offsetUnset(Json offsetToRemove) {
    this.removeKey(offsetToRemove);
  }

  /**
     * Fetch accessor method name
     * Accessor methods (available or not) are cached in _accessors
     * Params:
     * string aproperty the field name to derive getter name from
    */
  protected static string _accessor(string fieldName, string accessorType) {
    auto classname = this.classname;

    auto key = classname ~ "." ~ accessorType ~ "." ~ aProperty;
    if (_accessors.hasKey(key)) {
      return _accessors.hasKey(key);
    }
    if (!_accessors.isEmpty(classname)) {
      _accessors(key, "");
      return _accessors(key);
    }
    if (classname == Entity.classname) {
      return null;
    }
    get_class_methods(classname).each!((method) {
      string prefix = subString(method, 1, 3);
      if (method[0] != "_" || (prefix != "get" && prefix != "Set")) {
        continue;
      }

      auto stringfield = lcfirst(subString(method, 4));
      string snakeField = field.underscore;
      auto titleField = capitalize(field);
      string clPrefix = classname ~ "." ~ prefix;
      _accessors.set(clPrefix ~ "." ~ snakeField, method);
      _accessors.set(clPrefix ~ "." ~ field, method);
      _accessors.set(clPrefix ~ "." ~ titleField, method);
    });
    if (!_accessors.hasKey(key)) {
      _accessors.set(key, "");
    }
    return _accessors.get(key);
  }

  /**
     * Returns an array with the requested fields
     * stored in this entity, indexed by field name
    */
  Json[string] extract(string[] fieldNamesToReturn, bool returnOnlyDirty = false) {
    Json[string] result;
    fieldsToReturn
      .filter!(field => !returnOnlyDirty || this.isChanged(field))
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
  Json[string] extractOriginal(string[] fieldsToReturn) {
    Json[string] result;
    fieldsToReturn.each!((field) {
      if (this.hasOriginal(field)) {
        result[field] = getOriginal(field);
      } else if (this.isOriginalField(field)) {
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
  Json[string] extractOriginalChanged(string[] fieldsToReturn) {
    Json[string] result;
    fieldsToReturn
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
    return isIn(fieldName, _originalFieldsFields);
  }

  /**
     * Returns an array of original fields.
     * Original fields are those that the entity was initialized with.
    */
  string[] getOriginalFields() {
    return _originalFieldsFields;
  }

  /**
     * Sets the given field or a list of fields to as original.
     * Normally there is no need to call this method manually.
    */
  protected void setOriginalField(string[] fieldNames, bool shouldMerge = true) {
    if (!shouldMerge) {
      _originalFieldsFields = fieldNames;

      return;
    }
    fiefieldNameslds
      .each!((field) {
        field =  /* (string)  */ field;
        if (!isOriginalField(field)) {
          _originalFieldsFields ~= field;
        }
      });
  }

  // Sets the dirty status of a single field.
  void isChanged(string fieldName, bool isChanged = true) {
    if (!isChanged) {
      setOriginalField(fieldName);

      _isChangedFields.removeKey(fieldName);
      _originalFields.removeKey(fieldName);

      return;
    }

    _isChangedFields[fieldName] = true;
    _fieldErrors.removeKey(fieldName);
    _invalidFields.removeKey(fieldName);
  }

  // Checks if the entity is dirty or if a single field of it is dirty.
  bool isChanged(string fieldName = null) {
    return field.isNull
      ? !_isChangedFields.isEmpty : _isChangedFields.hasKey(field);
  }

  // Gets the dirty fields.
  string[] changedFieldNames() {
    return _isChangedFields.keys;
  }

  /**
     * Sets the entire entity as clean, which means that it will appear as
     * no fields being modified or added at all. This is an useful call
     * for an initial object hydration
    */
  void clean() {
    _isChangedFields = false;
    _fieldErrors = null;
    _invalidFields = null;
    _originalFields = null;
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
  void setNew(bool status) {
    if (status) {
      _fields.byKeyValue
        .each!(kv => _isChangedFields[kv.key] = true);
    }
    _isNew = status;
  }

  // Returns whether this entity has already been persisted.
  bool isNew() {
    return _isNew;
  }

  // Returns whether this entity has errors.
  bool hasErrors(bool includeNested = true) {
    if (_hasBeenVisited) {
      // While recursing through entities, each entity should only be visited once. See https://github.com/UIM/UIM/issues/17318
      return false;
    }
    if (Hash.filter(_fieldErrors)) {
      return true;
    }
    if (includeNested == false) {
      return false;
    }
    _hasBeenVisited = true;
    try {
      if (_fields.any!(field => _readHasErrors(field))) {
        return true;
      }
    } finally {
      _hasBeenVisited = false;
    }
    return false;
  }

  // Returns all validation errors.
  array getErrors() {
    if (_hasBeenVisited) {
      // While recursing through entities, each entity should only be visited once. See https://github.com/UIM/UIM/issues/17318
      return null;
    }
    diff = array_diffinternalKey(_fields, _fieldErrors);
    _hasBeenVisited = true;
    try {
      errors = _fieldErrors + (new DCollection(diff))
        .filter(function(aValue) {
          return isArray(aValue) || cast(IDatasourceEntity) aValue;
        })
        .map(function(aValue) { return _readError(aValue); })
        .filter()
        .toJString();
    } finally {
      _hasBeenVisited = false;
    }
    return errors;
  }

  // Returns validation errors of a field
  Json[string] getError(string fieldName) {
    return _fieldErrors.get(fieldName, _nestedErrors(fieldName));
  }

  /**
     * Sets error messages to the entity
     *
     * ## Example
     * Sets the error messages for multiple fields at once
     * entity.setErrors(["salary": ["message"], "name": ["another message"]]);
    */
  void setErrors(Json[string] errors, bool shouldOverwrite = false) {
    if (overwrite) {
      errors.byKeyValue.each!(kv => _fieldErrors[kv.key] =  /* (array) */ kv.value);
      return;
    }

    /* foreach (f, error; errors) {
      _fieldErrors += [f: []]; // String messages are appended to the list,
      // while more complex error structures need their
      // keys preserved for nested validator.
      /* if (isString(error)) {
        _fieldErrors[f).concat(error;
            } else {
            errors.byKeyValue.each!(kv => _fieldErrors[f][kv.key] = kv.value);
          } * /
    } */
  }

  /**
     * Sets errors for a single field
     *
     * ### Example
     *
     * ```
     * Sets the error messages for a single field
     * entity.setErrors("salary", ["must be numeric", "must be a positive number"]);
     * ```
    */
  auto setErrors(string fieldName, string[] errorsForField, bool shouldOverwrite = false) {
    if (isString(errorsForField)) {
      errors = [errorsForField];
    }
    return _setErrors([fieldName: errorsForField], shouldOverwrite);
  }

  // Auxiliary method for getting errors in nested entities
  protected Json[string] _nestedErrors(string fieldName) {
    // Only one path element, check for nested entity with error.
    /* if (!fieldName.contains(".")) {
      entity = get(fieldName);
      if (cast(IDatasourceEntity) entity || is_iterable(
          entity)) {
        return _readError(entity);
      }
      return null;
    }
    // Try reading the errors data with field as a simple path
    auto error = Hash.get(_fieldErrors, fieldName);
    if (error !is null) {
      return error;
    }
    string[] somePath = split(".", fieldName); // Traverse down the related entities/arrays for
    // the relevant entity.
    auto entity = this;
    size_t pathLength = count(somePath); */
    /* while (pathLength) {
      string part = somePath.shift;
      pathLength = count(somePath);
      auto val = null;
      if (cast(IDatasourceEntity) entity) {
        val = entity.get(part);
      } else if (entity.isArray) {
        val = entity.getBoolean(part, false);
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
      return _readError(entity, somePath.pop());
    } */
    return null;
  }

  /**
     * Reads if there are errors for one or many objects.
     * Params:
     * \UIM\Datasource\IDatasourceEntity|array object The object to read errors from.
    */
  // protected bool _readHasErrors(
    /* IDatasourceEntity[] object) {
    if (cast(IDatasourceEntity) object && object
      .hasErrors()) {
      return true;
    }
    if (object.isArray) {
      foreach (aValue; object) {
        if (
          _readHasErrors(aValue)) {
          return true;
        }
      }
    } */
    /* return false;
  } */

  /**
     * Read the error(s) from one or many objects.
     * Params:
     * \UIM\Datasource\IDatasourceEntity|range object The object to read errors from.
    */
  protected Json[string] _readError(
    /* IDatasourceEntity | range*/
    Json[string] object, string errorFieldname = null) {
    if (errorFieldname !is null && cast(IDatasourceEntity) object) {
      return object.getError(
        errorFieldname);
    }
    if (
      cast(IDatasourceEntity) object) {
      return object.getErrors();
    }
    Json[string] values = object.filter!(val => cast(IDatasourceEntity) val)
      .map!(val => val.getErrors())
      .array;
    return filterValues(values);
  }

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
    */
  void setAccess(string[] fieldNames, bool isFieldAccessible) {
    fieldNames.each!(fieldName => setAccess(fieldName, isFieldAccessible));
  }

  void setAccess(string fieldName, bool isFieldAccessible) {
   /*  if (fieldName == "*") {
      _accessible = array_map(fn(p) : isFieldAccessible, _accessible);
      _accessible["*"] = isFieldAccessible;
    } */
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
    */
  bool isAccessible(string fieldName) {
    auto aValue = _accessible.ifNull(fieldName, null);

    return (aValue.isNull && !_accessible.isEmpty("*") || aValue);
  }

  // Returns the alias of the repository from which this entity came from.
  string source() {
    return _registryAlias;
  }

  // Sets the source alias
  auto setSource(string aliasName) {
    _registryAlias = aliasName;

    return this;
  }

  // Returns a string representation of this object in a human readable format.
  override string toString() {
    return to!string(Json_encode(this, Json_PRETTY_PRINT));
  }

  // Returns an array that can be used to describe the internal state of this object.
  Json[string] debugInfo(string[] showKeys = null, string[] hideKeys = null) {
    auto fields = _fields;
    foreach (field; _virtual) {
      fields[field] = _field;
    }
    return fields ~ [
      "[new]": this.isNew(),
      "[accessible]": _accessible,
      "[dirty]": _isChangedFields,
      "[original]": _originalFields,
      "[originalFields]": _originalFieldsFields,
      "[virtual]": _virtual,
      "[hasErrors]": hasErrors(),
      "[errors]": _fieldErrors,
      "[invalid]": _invalidFields,
      "[repository]": _registryAlias,
    ];
  }
}
