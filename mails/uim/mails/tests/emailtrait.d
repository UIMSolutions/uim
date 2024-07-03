module uim.mails.tests.emailtrait;

import uim.oop;

@safe:

/**
 * Make assertions on emails sent through the UIM\TestSuite\TestEmailTransport
 *
 * After adding the template to your test case, all mail transports will be replaced
 * with TestEmailTransport which is used for making assertions and will *not* actually
 * send emails.
 */
mixin template TEmail() {
    /**
     * Replaces all transports with the test transport during test setup
     *
     * @before
     */
    void setupTransports() {
        TestEmailTransport.replaceAllTransports();
    }
    
    /**
     * Resets transport state
     *
     * @after
     */
    void cleanupEmailTrait() {
        TestEmailTransport.clearMessages();
    }
    
    // Asserts an expected number of emails were sent
    void assertMailCount(int emailCount, string message= null) {
        assertThat(emailCount, new DMailCount(), message);
    }
    
    // Asserts that no emails were sent
    void assertNoMailSent(string message= null) {
        assertThat(null, new DNoMailSent(), message);
    }
    
    // Asserts an email at a specific index was sent to an address
    void assertMailSentToAt(int emailIndex, string emailAddress, string message = null) {
        assertThat(emailAddress, new DMailSentTo(emailIndex), message);
    }
    
    /**
     * Asserts an email at a specific index was sent from an address
     * Params:
     * int at Email index
     * @param string amessage Message
     */
    void assertMailSentFromAt(int eMailIndex, string emailAddress, string amessage= null)) {
        assertThat(emailAddress, new DMailSentFrom(eMailIndex), message);
    }
    
    // Asserts an email at a specific index contains expected contents
    void assertMailContainsAt(int eMailIndex, string contents, string message = null) {
        assertThat(contents, new DMailContains(eMailIndex), message);
    }
    
    // Asserts an email at a specific index contains expected html contents
    void assertMailContainsHtmlAt(int eMailIndex, string contents, string amessage = null) {
        assertThat(contents, new DMailContainsHtml(eMailIndex), message);
    }
    
    // Asserts an email at a specific index contains expected text contents
    void assertMailContainsTextAt(int eMailIndex, string contents, string message = null) {
        assertThat(contents, new DMailContainsText(eMailIndex), message);
    }
    
    // Asserts an email at a specific index contains the expected value within an Email getter ("cc", "bcc")
    void assertMailSentWithAt(int eMailIndex, string aexpected, string emailGetter, string message= null) {
        assertThat(expected, new DMailSentWith(eMailIndex, emailGetter), message);
    }
    
    /**
     * Asserts an email was sent to an address
     * Params:
     * string aaddress Email address
     * @param string amessage Message
     */
    void assertMailSentTo(string aaddress, string amessage = null) {
        assertThat(address, new DMailSentTo(), message);
    }
    
    // Asserts an email was sent from an address
    void assertMailSentFrom(string[] emailAddress, string emailMessage = null) {
        assertThat(emailAddress, new DMailSentFrom(), emailMessage);
    }
    
    /**
     * Asserts an email contains expected contents
     * Params:
     * string acontents Contents
     */
    void assertMailContains(string acontents, string message = null) {
        assertThat(contents, new DMailContains(), message);
    }
    
    /**
     * Asserts an email contains expected attachment
     * Params:
     * string afilename Filename
     * @param Json[string] file Additional file properties
     */
    void assertMailContainsAttachment(string afilename, Json[string] file = [], string message = null) {
        assertThat([filename, file], new DMailContainsAttachment(), message);
    }
    
    // Asserts an email contains expected html contents
    void assertMailContainsHtml(string contents, string message = null) {
        assertThat(contents, new DMailContainsHtml(), message);
    }
    
    // Asserts an email contains an expected text content
    void assertMailContainsText(string expectedText, string message = null) {
        assertThat(expectedText, new DMailContainsText(), message);
    }
    
    /**
     * Asserts an email contains the expected value within an Email getter
     * Params:
     * string aexpected Contents
     * @param string aparameter Email getter parameter (e.g. "cc", "subject")
     * @param string amessage Message
     */
    void assertMailSentWith(string aexpected, string aparameter, string amessage = null) {
        assertThat(expected, new DMailSentWith(null, parameter), message);
    }
    
    /**
     * Asserts an email subject contains expected contents
     * Params:
     * string acontents Contents
     * @param string amessage Message
     */
    void assertMailSubjectContains(string acontents, string amessage = null) {
        assertThat(contents, new DMailSubjectContains(), message);
    }
    
    /**
     * Asserts an email at a specific index contains expected html contents
     * Params:
     * int at Email index
     * @param string acontents Contents
     * @param string amessage Message
     */
    void assertMailSubjectContainsAt(int eMailIndex, string acontents, string amessage = null) {
        assertThat(contents, new DMailSubjectContains(eMailIndex), message);
    }
}
