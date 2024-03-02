module source.uim.orm.exceptions.missingbehavior;


/**
 * Used when a behavior cannot be found.
 */
class MissingBehaviorException : UimException {
    protected string _messageTemplate = "Behavior class `%s` could not be found.";
}
