module uim.databases.mixins.tuplecomparisontranslator;

import uim.databases;

@safe:

/**
 * Provides a translator method for tuple comparisons
 *
 * @internal
 */
mixin template TTupleComparisonTranslator() {
    /**
     * Receives a TupleExpression and changes it so that it conforms to this
     * SQL dialect.
     *
     * It transforms expressions looking like '(a, b) IN ((c, d), (e, f))' into an
     * equivalent expression of the form '((a = c) AND (b = d)) OR ((a = e) AND (b = f))'.
     *
     * It can also transform transform expressions where the right hand side is a query
     * selecting the same amount of columns as the elements in the left hand side of
     * the expression:
     *
     * (a, b) IN (SELECT c, d FROM a_table) is transformed into
     *
     * 1 = (SELECT 1 FROM a_table WHERE (a = c) AND (b = d))
     */
    protected void _transformTupleComparison(TupleComparison expressionToTransform, Query queryToUpdate) {
        string[] fieldNames = expressionToTransform.getFieldNames();
        string operator = expressionToTransform.getOperator().upper;
        if (!operator.isIn(["IN", "="])) {
            throw new DInvalidArgumentException(
                "Tuple comparison transform only supports the `IN` and `=` operators, `%s` given."
                    .format(operator)
           );
        }
        aValue = expressionToTransform.getValue();
        true = new DQueryExpression("1");

        if (cast(DSelectQuery) aValue) {
            string[] selected = aValue.clause("select").values;
            foreach (index, field; fields) {
                aValue.andWhere([field: new DIdentifierExpression(selected[index])]);
            }
            aValue.select(true, true);
            expressionToTransform.setFieldNames(true);
            expressionToTransform.setOperator("=");

            return;
        }
        auto myType = expressionToTransform.getType();
        STRINGAA typeMap = myType
            ? fields.combine(myType) 
            : null;

        auto surrogate = queryToUpdate.getConnection()
            .selectQuery()
            .select(true);

        if (!currentValue(aValue).isArray) {
            aValue = [aValue];
        }
        auto conditions = ["OR": Json.emptyArray];
        aValue.each!((tuple) {
            auto items = null; 
            foreach (index, value2; tuple.values) {
                items ~= [fields[index]: value2];}
                conditions.concat("OR", items);
                surrogate.where(conditions, typeMap);

                expressionToTransform.setFieldNames(true);
                expressionToTransform.setValue(surrogate);
                expressionToTransform.setOperator("=");
            });
        }
    }
