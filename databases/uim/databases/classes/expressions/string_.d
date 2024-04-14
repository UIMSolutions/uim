module uim.databases.classes.expressions.string_;

import uim.databases;

@safe:

// String expression with collation.
class DStringExpression : DExpression {
    mixin(ExpressionThis!("String"));

    protected string _string;

    protected string aCollation;

    /*
    this(string newString, string aCollation) {
        _string = newString;
        this.collation(aCollation);
    }

    // Sets the string collation.
    void collation(string aCollation) {
        _collation = aCollation;
    }

    // Returns the string collation.
    string collation() {
        return this.collation;
    }

    string sql(DValueBinder aBinder) {
        auto placeholder = aBinder.placeholder("c");
        aBinder.bind(placeholder, this.string, "string");

        return placeholder ~ " COLLATE " ~ this.collation;
    }

    /* 
    void traverse(Closure aCallback) {
    }
    */
}
