/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.enumerations.sort;enum SortTypes : string {    STRING = "string", // Default. Compare items as strings    REGULAR = "regular", // Compare items normally (don't change types)    NUMERIC = "numeric", // Compare items numerically    LOCALESTRING = "localstring" // Compare items as strings, based on current locale}