module uim.datasources;

import uim.datasources;

@safe:

/**
 * Describes the methods that any class representing a data storage should
 * comply with.
 */
interface IInvalidProperty {
    // Get a list of invalid fields and their data for errors upon validation/patching
    array getInvalid();

    /**
     * Set fields as invalid and not patchable into the entity.
     *
     * This is useful for batch operations when one needs to get the original value for an error message after patching.
     * This value could not be patched into the entity and is simply copied into the _invalid property for debugging
     * purposes or to be able to log it away.
     * Params:
     * IData[string] fields The values to set.
     * @param bool $overwrite Whether to overwrite pre-existing values for field.
     */
    auto setFieldsInvalid(array fields, bool $overwrite = false);

    // Get a single value of an invalid field. Returns null if not set.
    Json getInvalidField(string fieldName) ;

    /**
     * Sets a field as invalid and not patchable into the entity.
     * Params:
     * @param Json aValue The invalid value to be set for field.
     */
    auto setInvalidField(string fieldName, Json aValue);
}
