module uim.databases.classes.expressions.unary;

import uim.databases;

@safe:

// An expression object that represents an expression with only a single operand.
class DUnaryExpression : DExpression {
    mixin(ExpressionThis!("Unary"));

    // Indicates that the operation is in pre-order
    const int PREFIX = 0;

    // Indicates that the operation is in post-order
    const int POSTFIX = 1;

    // The operator this unary expression represents
    protected string _operator;

    // Holds the value which the unary expression operates
    protected Json _value;

    // Where to place the operator
    protected int _position;

    this(string expressionOperator, Json operandValue, int position = PREFIX) {
        _operator = expressionOperator;
        _value = operandValue;
        _position = position;
    }

    string sql(DValueBinder aBinder) {
        auto operand = _value;
        if (cast(IExpression) operand) {
            operand = operand.sql(aBinder);
        }
        if (this.position == self.POSTFIX) {
            return "(" ~ operand ~ ") " ~ _operator;
        }
        return _operator ~ " (" ~ operand ~ ")";
    }

    void traverse(Closure aCallback) {
        if (cast(IExpression) _value) {
            aCallback(_value);
            _value.traverse(aCallback);
        }
    }

    // Perform a deep clone of the inner expression.
    void clone() {
        if (cast(IExpression) _value) {
            _value = clone _value;
        }
    } */
}
