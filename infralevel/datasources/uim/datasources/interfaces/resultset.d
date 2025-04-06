module uim.datasources.interfaces.resultset;

mixin(Version!"test_uim_datasources");

import uim.datasources;
@safe:

    // Describes how a collection of datasource results should look like
interface IDatasourceResultset : IObject {// }: ICollection, Countable, Serializable
}