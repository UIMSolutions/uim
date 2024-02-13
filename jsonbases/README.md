# uim-jsonbase

A **JSON database** is a type of **NoSQL database** that is ideal for storing **semi-structured data**.

**What Is It?**

- A JSON database stores data as **documents** rather than rigid tables.
- Each document is a **JSON object**, which is both human-readable and machine-friendly.
- Unlike traditional relational databases, JSON databases allow more flexibility in data modeling.

**Advantages**:

- **Flexibility**: JSON databases handle schema changes easily, even for small modifications.
- **Storage Flexibility**: NoSQL databases offer better indexing methods and storage flexibility.
- **Schema Flexibility**: You can store data in various ways—embedding objects within a document or linking them using unique identifiers.
- **Querying Nested Objects**: JSON databases allow straightforward querying of nested objects (like arrays or embedded documents).

**Storage Approaches**:

- **Embedding (One Document)**:
- **Referencing (Multiple Documents)**:

```
// Author document
{
    "_id": "ObjectId(1)",
    "name": "Herman Melville",
    "born": 1819
}

// Book document
{
    "_id": "ObjectId(55)",
    "title": "Moby Dick",
    "author": "ObjectId(1)"
}
```

```
{
    "title": "Moby Dick",
    "author": {
        "name": "Herman Melville",
        "born": 1819
    }
}
```

**Use Cases**:

- JSON databases are commonly used in web applications, content management systems, and projects with evolving data requirements.
