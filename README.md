# CO528-Assignment-01-E18285
CO528 -Applied Software Architecture Assignment 01 (REST Application)

# Book Management REST API

This is a Ballerina-based REST API for managing a collection of books. The API supports the following operations:
- Add a new book
- Retrieve all books
- Update an existing book by ID
- Delete a book by ID

## Prerequisites

- Docker
- Ballerina

## Project Structure

```plaintext
.
├── Ballerina.toml
├── main.bal
├── Dockerfile

```
## Setting Up the Application

```
git clone https://github.com/TharinduChamod/CO528-Assignment-01-E18285.git
cd CO528-Assignment-01-E18285
```

```
bal build --cloud="docker"
```

```
docker run -d -p 8080:8080 assignment_1_e18285/server:v0.1.0
```

## CURL Requests for Testing

# Add a new book
```
curl -X POST http://localhost:8080/addBook \
-H "Content-Type: application/json" \
-d '{
      "id": "1",
      "title": "The Great Gatsby",
      "author": "F. Scott Fitzgerald",
      "year": 1925
    }'

```

# Get All Books in the server
```
curl -X GET http://localhost:8080/getAllBooks
```

# Edit Book Details in a selected book
```
curl -X PUT http://localhost:8080/updateBook?id=1 \
-H "Content-Type: application/json" \
-d '{
      "id": "1",
      "title": "The Great Gatsby - Updated",
      "author": "F. Scott Fitzgerald",
      "year": 1925
    }'
```

# Delete Book
```
curl -X DELETE http://localhost:8080/deleteBook?id=1
```
