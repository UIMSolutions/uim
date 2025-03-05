module uim.validations.classes.validators.validator;

import uim.validations;
@safe:

version (test_uim_validations) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
} 
class DValidator {
        // By using "create" you can make fields required when records are first created.
    const string WHEN_CREATE = "create";

    // By using "update", you can make fields required when they are updated.
    const string WHEN_UPDATE = "update";

    // Used to flag nested rules created with addNested() and addNestedMany()
    const string NESTED = "_nested";

    // A flag for allowEmptyFor()
    // When `null` is given, it will be recognized as empty.
    const long EMPTY_NULL = 0;

    // A flag for allowEmptyFor()
    // When an empty string is given, it will be recognized as empty.
    const long EMPTY_STRING = 1;

    // A flag for allowEmptyFor()
    // When an empty array is given, it will be recognized as empty.
    const long EMPTY_ARRAY = 2;

    /**
     * Contains the validation messages associated with checking the presence
     * for each corresponding field.
     */
    protected STRINGAA _presenceMessages = null;

    // Whether to use I18n functions for translating default error messages
    protected bool _useI18n = false;
}