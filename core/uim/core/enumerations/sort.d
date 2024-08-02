module uim.core.enumerations.sort;

enum SortTypes : string {
    STRING = "string", // Default. Compare items as strings
    REGULAR = "regular", // Compare items normally (don't change types)
    NUMERIC = "numeric", // Compare items numerically
    LOCALESTRING = "localstring" // Compare items as strings, based on current locale
}