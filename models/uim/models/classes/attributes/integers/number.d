/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.models.classes.attributes.integers.number;import uim.models;@safe:class DNumberAttribute : DIntegerAttribute {  mixin(AttributeThis!("Number"));}mixin(AttributeCalls!("Number"));version(test_uim_models) { unittest {    testAttribute(new DNumberAttribute);    testAttribute(NumberAttribute);  }}