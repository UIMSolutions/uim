module uim.databases.mixins.caseexpression;

import uim.databases;

@safe:

/**
 * mixin template that holds shared functionality for case related expressions.
 *
 * @internal
 */
mixin template TCaseExpression() {
    /**
     * Infers the abstract type for the given value.
     * Params:
     * Json aValue The value for which to infer the type.
     */
    protected string inferType(Json aValue) {
        auto type = null;

        /** @psalm-suppress RedundantCondition */
        if (isString(aValue)) {
            type = "String";
        } else if (isInt(aValue)) {
            type = "integer";
        } else if (isFloat(aValue)) {
            type = "float";
        } else if (isBoolean(aValue)) {
            type = "boolean";
        } else if (cast(DChronosDate)aValue) {
            type = "date";
        } else if (cast(IDateTime)aValue) {
            type = "datetime";
        } else if (
            isObject(aValue) &&
            cast(DStringable)aValue
       ) {
            type = "String";
        } else if (
           !_typeMap.isNull &&
            cast(IdentifierExpression)aValue 
       ) {
            type = _typeMap.type(aValue.getIdentifier());
        } else if (aValue  ITypedResult) {
            type = aValue.getReturnType();
        }
        return type;
    }
    
    // Compiles a nullable value to SQL.
    protected string compileNullableValue(DValueBinder valueBinder, Json aValue, string valueType = null) {
        if (
            !valueType.isNull &&
            !(cast(IExpression)aValue)
       ) {
            aValue = _castToExpression(aValue, valueType);
        }
        if (aValue.isNull) {
            aValue = "NULL";
        } else if (cast(Query)aValue) {
            aValue = "(%s)".format(aValue.sql(aBinder));
        } else if (cast(IExpression)aValue) {
            aValue = aValue.sql(aBinder);
        } else {
            placeholder = aBinder.placeholder("c");
            aBinder.bind(placeholder, aValue, valueType);
            aValue = placeholder;
        }
        return aValue;
    } 
}
