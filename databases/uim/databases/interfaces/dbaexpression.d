/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.databases.interfaces.dbaexpression;

@safe:
import uim.databases;

//TODO 

// An interface used by Expression objects.
interface IDBAExpression {
    /**
     * Converts the Node into a SQL string fragment.
     *
     * @param uim.databases.ValueBinder aBinder Parameter binder
     */
    // TODO string sql(ValueBinder aBinder);

    /**
     * Iterates over each part of the expression recursively for every
     * level of the expressions tree and executes the callback callable
     * passing as first parameter the instance of the expression currently
     * being iterated.
     *
     * @param \Closure callback The callable to apply to all nodes.
     * @return this
     */
    // TODO IDBAExpression traverse(Closure aCallback);
}
