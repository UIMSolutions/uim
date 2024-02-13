# Package 📦 uim.oop.interfaces

In **programming**, a **class interface** refers to the **public contract** exposed by a class.

**Definition**:

- An interface defines the **methods** (or **messages**) that an instance of a class implementing that interface must provide.
- It acts as a **blueprint** for the behavior that other parts of the program can expect from objects of that class.
- The interface specifies what operations are available without revealing the internal details or implementation.

**Key Points**:

- **Abstraction**: An interface abstracts away the implementation details, focusing on what an object can do rather than how it does it.
- **Method Signatures**: Interfaces declare method signatures (names, parameters, return types) without providing the actual code.
- **Multiple Interfaces**: A class can implement multiple interfaces, allowing it to fulfill various contracts.
- **Language-Specific Variations**:
  - In **Java**, an interface is a specific construct with language-specific semantics. It defines a set of method declarations without implementation.
  - In other languages (like **C++**), there are no explicit interfaces, but classes can still adhere to an interface by implementing the required methods.

**Example**:

- Suppose we have an interface called `Drawable`:
- Any class that implements `Drawable` must provide its own implementation of the `draw()` method.

```java
interface Drawable {
    void draw();
}
```

**Benefits**:

- **Modularity**: Interfaces allow components to interact without knowing the internal details.
- **Flexibility**: Different implementations can be swapped out as long as they adhere to the same interface.
- **Code Contracts**: Interfaces serve as contracts, ensuring consistency and compatibility.
