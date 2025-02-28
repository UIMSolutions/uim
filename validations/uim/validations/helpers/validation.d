module uim.validations.helpers.validation;

import uim.validations;
@safe:

version (test_uim_validations) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
} 

class Validation {
    static bool lengthBetween(Json value, int minLength, int maxLength) {
        if (!value.isScalar) {
            return false;
        }
        return lengthBetween(value.getString, minLength, maxLength);
    }

    /**
     * Checks that a string length is within specified range.
     * Spaces are included in the character count.
     */
    static bool lengthBetween(string value, int minLength, int maxLength) {
        auto length = value.length;
        return length >= minLength && length <= maxLength;
    }
}