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
        } elseif (isInt(aValue)) {
            type = "integer";
        } elseif (isFloat(aValue)) {
            type = "float";
        } elseif (isBool(aValue)) {
            type = "boolean";
        } elseif (cast(DChronosDate)aValue) {
            type = "date";
        } elseif (cast(IDateTime)aValue) {
            type = "datetime";
        } elseif (
            isObject(aValue) &&
            cast(DStringable)aValue
        ) {
            type = "String";
        } elseif (
           !_typeMap.isNull &&
            cast(IdentifierExpression)aValue 
        ) {
            type = _typeMap.type(aValue.getIdentifier());
        } elseif (aValue  ITypedResult) {
            type = aValue.getReturnType();
        }
        return type;
    }
    
    /**
     * Compiles a nullable value to SQL.
     * Params:
     * \UIM\Database\DValueBinder aBinder The value binder to use.
     * @param \UIM\Database\IExpression|object|scalar|null aValue The value to compile.
     * @param string type The value type.
     */
    protected string compileNullableValue(DValueBinder aBinder, Json aValue, string atype = null) {
        if (
            type !isNull &&
            !(cast(IExpression)aValue )
        ) {
            aValue = _castToExpression(aValue, type);
        }
        if (aValue.isNull) {
            aValue = "NULL";
        } elseif (cast(Query)aValue) {
            aValue = "(%s)".format(aValue.sql(aBinder));
        } elseif (cast(IExpression)aValue) {
            aValue = aValue.sql(aBinder);
        } else {
            placeholder = aBinder.placeholder("c");
            aBinder.bind(placeholder, aValue, type);
            aValue = placeholder;
        }
        return aValue;
    } */
}
