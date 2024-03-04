module uim.orm.Exception;


// Used when a transaction was rolled back from a callback event.
class RolledbackTransactionException : UimException {
    protected string _messageTemplate = "The afterSave event in `%s` is aborting the transaction"
        ~ " before the save process is done.";
}
