module uim.orm.interfaces.propertymarshal;
/**
 * Behaviors implementing this interface can participate in entity marshalling.
 *
 * This enables behaviors to define behavior for how the properties they provide/manage
 * should be marshalled.
 */
interface IPropertyMarshal {
    // Build a set of properties that should be included in the marshalling process.
    auto buildMarshalMap(DMarshaller marshaller, Json[string] mymap, Json[string] options = null);
}
