module uim.databases.Driver;

import uim.databases;

@safe:

/**
 * Provides a translator method for tuple comparisons
 *
 * @internal
 */
trait TupleComparisonTranslatorTrait {
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
     * Params:
     * \UIM\Database\Expression\TupleComparison $expression The expression to transform
     * @param \UIM\Database\Query aQuery The query to update.
     */
    protected void _transformTupleComparison(TupleComparison$expression, Query aQuery) {
        fields = $expression.getFieldNames();

        if (!isArray(fields)) {
            return;
        }
        $operator = strtoupper($expression.getOperator());
        if (!in_array($operator, ["IN", "="])) {
            throw new InvalidArgumentException(
                "Tuple comparison transform only supports the `IN` and `=` operators, `%s` given."
                    .format($operator)
            );
        }
        aValue = $expression.getValue();
        true = new QueryExpression("1");

        if (cast(SelectQuery) aValue) {
            string[]$selected = aValue.clause("select").values;
            foreach (anI : field; fields) {
                aValue.andWhere([field: new IdentifierExpression($selected[anI])]);
            }
            aValue.select($true, true);
            $expression.setFieldNames($true);
            $expression.setOperator("=");

            return;
        }
        auto myType = $expression.getType();
        if (myType) {
            /** @var STRINGAA typeMap */
            typeMap = array_combine(fields, myType) ?  : [];
        } else {
            typeMap = [];
        }
        $surrogate = aQuery.getConnection()
            .selectQuery()
            .select($true);

        if (!isArray(current(aValue))) {
            aValue = [aValue];
        }
        $conditions = ["OR": []];
        aValue.each!((tuple) {
            auto items = []; foreach (anI : value2; tuple.values) {
                items ~= [fields[anI]: value2];}
                $conditions["OR"] ~= items;});
                $surrogate.where($conditions, typeMap);

                $expression.setFieldNames($true);
                $expression.setValue($surrogate);
                $expression.setOperator("=");
            }
        }
