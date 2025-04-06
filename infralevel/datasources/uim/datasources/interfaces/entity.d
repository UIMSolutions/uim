module uim.datasources.interfaces.entity;

mixin(Version!"test_uim_datasources");

import uim.datasources;
@safe:

    /**
 * Describes the methods that any class representing a data storage should
 * comply with.
 *
 * @property Json anId Alias for commonly used primary key.
 * @template-extends \ArrayAccess<string, mixed>
 */
interface IDatasourceEntity : IObject { // : ArrayAccess, JsonSerializable
  // Sets hidden fields.
  /*
  void hiddenFields(string[] fieldNames, bool shouldMerge = false);

  // Gets the hidden fields.
  string[] hiddenFields();

  // Sets the virtual fields on this entity.
  void setVirtual(string[] fieldNames, bool canMergeExisting = false);

  // Gets the virtual fields on this entity.
  string[] virtualFields();

  /**
     * Returns whether a field is an original one.
     * Original fields are those that an entity was instantiated with.
     * /
  bool isOriginalField(string fieldName);

  /**
     * Returns an array of original fields.
     * Original fields are those that an entity was initialized with.
     * /
  string[] getOriginalFieldNames();

  // Sets the dirty status of a single field.
  void setFieldDirty(string fieldName, bool isDirtyMode = true);

  // Checks if the entity is dirty
  bool isChanged();

  // Checks if a field of it is dirty.
  bool isFieldDirty(string fieldName = null);

  // Gets the dirty fields.
  string[] changedFieldNames();

  // Returns whether this entity has errors.
  bool hasErrors(bool includeNested = true);

  // Returns all validation errors.
  Json[string] getErrors();

  // Returns validation errors of a field
  Json[string] getError(string fieldName);

  // Sets error messages to the entity
  void setErrors(Json[string] errors, bool shouldOoverwrite = false);

  //Sets errors for a single field
  IDatasourceEntity setErrors(string fieldName, string[] FieldErrors, bool shouldOverwrite = false);

  /**
     * Stores whether a field value can be changed or set in this entity.
     * /
  void setAccess(string[] fieldNames, bool set);

  // Accessible configuration for this entity.
  bool[] getAccessible();

  // Checks if a field is accessible
  bool isAccessible(string fieldName);

  // Sets the source alias
  void setSource(string sourceAlias);

  // Returns the alias of the repository from which this entity came from.
  string source();

  /**
     * Returns an array with the requested original fields
     * stored in this entity, indexed by field name.
     * /
  Json[string] extractOriginal(string[] fieldNames);

  /**
     * Returns an array with only the original fields
     * stored in this entity, indexed by field name.
     * /
  Json[string] extractOriginalChanged(string[] fieldNames);

  // Sets one or multiple fields to the specified value
  void set(string[] fieldNames, Json valueToSet = null, Json[string] options = new Json[string]);

  // Returns the value of a field by name
  Json get(string fieldName);

  /**
     * Enable/disable field presence check when accessing a property.
     *
     * If enabled an exception will be thrown when trying to access a non-existent property.
     * /
  void requireFieldPresence(bool enableField = true);

  // Returns whether a field has an original value
  bool hasOriginal(string fieldName);

  // Returns the original value of a field.
  Json getOriginal(string fieldName, bool allowFallback = true);

  // Gets all original values of the entity.
  Json[string] getOriginalValues();

  /**
     * Returns whether this entity contains a field named field.
     *
     * The method will return `true` even when the field is set to `null`.
     * Params:
     * string[]|string fieldName The field to check.
     * /
  bool has(string[] fieldName);
  bool has(string[] fieldNames);

  // Removes a field or list of fields from this entity
  void removeKey(string[] fieldName...);
  void removeKey(string[] fieldNames);

  // Get the list of visible fields.
  string[] visibleFields();

  /**
     * Returns an array with all the visible fields set in this entity.
     *
     * *Note* hidden fields are not visible, and will not be output
     * by toArray().
     * /
  Json[string] toArray();

  // Returns an array with the requested fields stored in this entity, indexed by field name
  Json[string] extract(string[] fieldNames, bool onlyDirty = false);

  /**
     * Sets the entire entity as clean, which means that it will appear as
     * no fields being modified or added at all. This is an useful call
     * for an initial object hydration
     * /
  void clean();

  /**
     * Set the status of this entity.
     *
     * Using `true` means that the entity has not been persisted in the database,
     * `false` indicates that the entity has been persisted.
     * Params:
     * bool new DIndicate whether this entity has been persisted.
     * /
  // TODO void setNew(bool new);

  // Returns whether this entity has already been persisted.
  // bool isNew();
  */
}