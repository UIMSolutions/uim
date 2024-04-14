module uim.databases.classes.expressions.identifier;

import uim.databases;

@safe:

/**
 * Represents a single identifier name in the database.
 *
 * Identifier values are unsafe with user supplied data.
 * Values will be quoted when identifier quoting is enabled.
 *
 * @see \UIM\Database\Query.identifier()
 */
class DIdentifierExpression : DExpression {
    mixin(ExpressionThis!("Identifier"));

    this(string newIdentifier, string newCollation = null) {
        this.identifier(newIdentifier);
        this.collation(newCollation);
    }

    // Gets/Sets the identifier this expression represents
    mixin(TProperty!("string", "identifier"));

    // Gets/Sets the identifier collation.
    mixin(TProperty!("string", "collation"));

    /*
    string sql(DValueBinder aBinder) {
        string sql = this.identifier;
        return this.collation
            ? sql ~ " COLLATE " ~ this.collation
            : sql;
    }

    // TODO 
    /*
    void traverse(Closure aCallback) {
    } */
}
mixin(ExpressionCalls!("Identifier"));
