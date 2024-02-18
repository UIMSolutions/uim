module uim.databases;

import uim.databases;

@safe:

// An interface used by Expression objects.
interface IExpression {
    // Converts the Node into a SQL string fragment.
    string sql(ValueBinder parameterBinder);

    /**
     * Iterates over each part of the expression recursively for every
     * level of the expressions tree and executes the callback,
     * passing as first parameter the instance of the expression currently
     * being iterated.
     */
    auto traverse(Closure callbackToRunNodes);
}
