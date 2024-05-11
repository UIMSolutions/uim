module uim.databases.classes.expressions.orderclause;

import uim.databases;

@safe:

// An expression object for complex ORDER BY clauses
class DOrderClauseExpression : DExpression { // TODO }, IField {
  mixin(ExpressionThis!("OrderClause"));
  mixin TField;

  // The direction of sorting.
  protected string _direction;

  /**
     * Constructor
     * Params:
     * \UIM\Database\IExpression|string fieldName The field to order on.
     */
  this(IExpression afield, string sortDirection) {
    // TODO
  }

  this(string fieldName, string sortDirection) {
    _field = fieldName;
    _direction = sortDirection.lower == "asc" ? "ASC" : "DESC";
  }

  string sql(DValueBinder aBinder) {
    field = _field;
    if (cast(Query)field) {
      field = "(%s)".format(field.sql(aBinder));
    }
    elseif(cast(IExpression)field) {
      field = field.sql(aBinder);
    }
    assert(isString(field));

    return "%s %s".format(field, _direction);
  }

  void traverse(Closure aCallback) {
    if (cast(IExpression) _field) {
      aCallback(_field);
      _field.traverse(aCallback);
    }
  }

  // Create a deep clone of the order clause.
  void clone() {
    if (cast(IExpression) _field) {
      _field = clone _field;
    }
  } */
}
mixin(ExpressionCalls!("OrderClause"));
