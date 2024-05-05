module uim.orm.interfaces.propertymarshal;
/**
 * Behaviors implementing this interface can participate in entity marshalling.
 *
 * This enables behaviors to define behavior for how the properties they provide/manage
 * should be marshalled.
 */
interface IPropertyMarshal {
    /**
     * Build a set of properties that should be included in the marshalling process.
     * Params:
     * \ORM\DMarshaller mymarshaller The marhshaller of the table the behavior is attached to.
     * @param array mymap The property map being built.
     * @param Json[string] options The options array used in the marshalling call.
     */
    // array buildMarshalMap(DMarshaller mymarshaller, Json[string] mymap, Json[string] options);
}
