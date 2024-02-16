# Library 📚 uim-datasources

An **HTML form** is a fundamental component used to collect user input on a web page. It allows users to submit data to a server for processing.

**Form Basics**:

- A form is created using the `<form>` element.
- It acts as a container for various input elements, such as text fields, checkboxes, radio buttons, and submit buttons.
- Users fill out the form, and the data is sent to the server when they submit it.

**Input Elements**:

- Common input elements within a form:
  - **Text Fields**: Allow users to enter single-line or multi-line text.
  - **Radio Buttons**: Users can select one option from a group of choices.
  - **Checkboxes**: Users can select multiple options.
  - **Submit Buttons**: Trigger form submission.
  - **Other Elements**: Password fields, file upload fields, hidden fields, etc.

**Form Structure Example**:

- In this example:
  - The form sends data to the `/submit` URL using the `POST` method.
  - It includes text fields for username and password.
  - The submit button triggers form submission.

```html
<form action="/submit" method="post">
  <label for="username">Username:</label>
  <input type="text" id="username" name="username" /><br />

  <label for="password">Password:</label>
  <input type="password" id="password" name="password" /><br />

  <input type="submit" value="Submit" />
</form>
```

**Form Best Practices**:

- Use appropriate input types (text, password, email, etc.).
- Include labels for each input field using the `<label>` element.
- Validate user input on the client side (JavaScript) and server side.
- Consider accessibility by providing clear instructions and using semantic HTML.
