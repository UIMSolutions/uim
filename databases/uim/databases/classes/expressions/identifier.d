module source.uim.databases.classes.expressions.identifier;

import uim.databases;

@safe:

/*
/**
 * Represents a single identifier name in the database.
 *
 * Identifier values are unsafe with user supplied data.
 * Values will be quoted when identifier quoting is enabled.
 *
 * @see \UIM\Database\Query.identifier()
 */
class IdentifierExpression : IExpression {
    this(string identifier, string Collation = null) {
       _identifier =  anIdentifier;
        _collation = collation;
    }
    
    // Gets/Sets the identifier this expression represents
    mixin(TProperty!("string", "identifier"));
    
    // Gets/Sets the identifier collation.
    mixin(TProperty!("string", "collation"));
 
    string sql(ValueBinder aBinder) {
        string sql = _identifier;
        if (this.collation) {
            sql ~= " COLLATE " ~ this.collation;
        }
        return sql;
    }
 
    void traverse(Closure aCallback) {
    }
}
