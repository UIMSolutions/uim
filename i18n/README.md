# Library 📚 uim-i18n

**Internationalization (i18n)** in software development refers to designing a program in a way that it can be easily adapted to other languages and cultures without requiring changes to the source code. The term “i18n” is often used as an abbreviation for internationalization (since there are 18 letters between the first letter “i” and the last letter “n” in the word “internationalization”).

**Scope of Internationalization**:

- **Language**: Translations of text data are stored in external files and dynamically loaded. This includes not only regular text but also speech output and text within graphical elements (such as images and videos with subtitles).
- **Graphical Representation**: The program logic is independent of the user interface and output media (e.g., printer).
- **Text Encoding**: Modern systems use the Unicode character set, solving encoding issues by supporting a much larger character repertoire.
- **Bidirectional Text**: Different writing directions may be required based on the script (e.g., left-to-right or right-to-left).
- **Fonts**: Some languages have different script variants (e.g., Serbian in Cyrillic or Latin script).
- **Text Processing Rules**: Concepts like capitalization rules vary across languages. Text wrapping rules differ as well.

**Difference Between Internationalization and Localization**:

- **Internationalization (i18n)**: The process of designing a program so that these changes do not need to be made by the programmer. It includes tasks like externalizing description texts (instead of hardcoding them in the source code) and using variables that are read from a source at runtime.
- **Localization (l10n)**: The subsequent step involves translating texts into a specific language. It refers to the pure translation of, for example, texts into a national language.

**Business Process of Software Internationalization**:

- **Design**: Create a program that does not require further changes for internationalization.
- **Localization**: Translate texts into the target language. This step should not require further intervention by the programmer.

**Programming Practices**:

- Use external files for translations.
- Avoid hardcoding descriptions in the source code.
- Ensure proper handling of character encodings.
- Consider bidirectional text and cultural differences.
