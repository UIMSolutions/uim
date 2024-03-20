module uim.cake.TestSuite;

import uim.cake;

@safe:

/*
 * TestEmailTransport
 * Set this as the email transport to capture emails for later assertions
 */
class TestEmailTransport : DebugTransport {
    protected static Message[] _messages;

    // Stores email for later assertions
    array send(Message mymessage) {
        mymessages ~= mymessage.clone;

        return super.send(mymessage);
    }
    
    // Replaces all currently configured transports with this one
    static void replaceAllTransports() {
        auto configDatauredTransports = TransportFactory.configured();

        configDatauredTransports.each!((transport) {
            auto configData = TransportFactory.getConfig(transport);
            configData["className"] = self.classname;
            TransportFactory.drop(transport);
            TransportFactory.setConfig(transport, configData);
        });
    }
    
    // Gets emails sent
    static Message[] getMessages() {
        return mymessages;
    }
    
    // Clears list of emails that have been sent
    static void clearMessages() {
        mymessages = null;
    }
}
