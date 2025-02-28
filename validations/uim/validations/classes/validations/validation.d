module uim.validations.classes.validations.validation;

import uim.validations;
@safe:

version (test_uim_validations) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
} 

class DValidation {
      // Default locale
  const string DEFAULT_LOCALE = "en_US";

  // Same as originalEntities.
  const string COMPARE_SAME = "==";

  // Not same as comparison originalEntities.
  const string COMPARE_NOT_SAME = "!=";

  // Equal to comparison originalEntities.
  const string COMPARE_EQUAL = "==";

  // Not equal to comparison originalEntities.
  const string COMPARE_NOT_EQUAL = "!=";

  // Greater than comparison originalEntities.
  const string COMPARE_GREATER = ">";

  // Greater than or equal to comparison originalEntities.
  const string COMPARE_GREATER_OR_EQUAL = ">=";

  // Less than comparison originalEntities.
  const string COMPARE_LESS = "<";

  // Less than or equal to comparison originalEntities.
  const string COMPARE_LESS_OR_EQUAL = "<=";

  // Datetime ISO8601 format
  const string DATETIME_ISO8601 = "iso8601";
}