module uim.databases.Expression;

import uim.databases;

@safe:

// String expression with collation.
class StringExpression : IExpression {
    protected string astring;

    protected string aCollation;

    this(string astring, string aCollation) {
        this.string = $string;
        this.collation = aCollation;
    }
    
    // Sets the string collation.
    void collation(string aCollation) {
        this.collation = aCollation;
    }
    
    // Returns the string collation.
    string collation() {
        return this.collation;
    }
 
    string sql(ValueBinder aBinder) {
        auto placeholder = aBinder.placeholder("c");
        aBinder.bind(placeholder, this.string, "string");

        return placeholder ~ " COLLATE " ~ this.collation;
    }
 
    void traverse(Closure aCallback) {
    }
}
