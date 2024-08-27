import ballerina/http;

// Define a type for the book structure
type Book record {
    readonly string id;
    string title;
    string author;
    int year;
};

// In-memory store for books
isolated table<Book> key(id) bookStore = table [];

// HTTP service endpoint for books
service / on new http:Listener(8080) {
    // POST method to add a new book
    isolated resource function post addBook(http:Caller caller, http:Request req) returns error? {
        json|error payload = req.getJsonPayload();
        if payload is json {
            Book|error newBook = payload.cloneWithType(Book);
            if newBook is Book {
                lock {
                    bookStore.add(newBook.clone());
                }
                http:Response response = new;
                response.statusCode = http:STATUS_CREATED;
                response.setJsonPayload({message: "Book added successfully", book: newBook.toJson()});
                check caller->respond(response);
            } else {
                http:Response response = new;
                response.statusCode = 400;
                response.setJsonPayload({message: "Invalid book data"});
                check caller->respond(response);
            }
        } else {
            http:Response response = new;
            response.statusCode = 400;
            response.setJsonPayload({message: "Invalid JSON payload"});
            check caller->respond(response);
        }
    }

    // GET method to retrieve all books
    isolated resource function get getAllBooks(http:Caller caller, http:Request req) returns error? {
        json bookList;
        lock {
            bookList = bookStore.toArray().toJson().clone();
        }
        check caller->respond(bookList);
    }

    // PUT method to update a book by ID
    isolated resource function put updateBook(http:Caller caller, http:Request req, string id) returns error? {
        json|error payload = req.getJsonPayload();
        if payload is json {
            Book|error updatedBook = payload.cloneWithType(Book);
            if updatedBook is Book {
                lock {
                    Book|error removedBook = bookStore.remove(id);
                    if removedBook is Book {
                        bookStore.add(updatedBook.clone());

                        http:Response response = new;
                        response.statusCode = http:STATUS_CREATED;
                        response.setJsonPayload({message: "Book updated successfully"});
                        check caller->respond(response);
                    } else {
                        http:Response response = new;
                        response.statusCode = 400;
                        response.setJsonPayload({message: "Error updating book"});
                        check caller->respond(response);
                    }
                }
            } else {
                http:Response response = new;
                response.statusCode = 400;
                response.setJsonPayload({message: "Error updating book"});
                check caller->respond(response);
            }
        } else {
            http:Response response = new;
            response.statusCode = 400;
            response.setJsonPayload({message: "Inavalid JSON Payload"});
            check caller->respond(response);
        }
    }

    // DELETE method to delete a book by ID
    isolated resource function delete deleteBook(http:Caller caller, string id) returns error? {
        lock {
            // Check if the book exists with the given id
            Book? existingBook = bookStore[id];
            if existingBook is Book {
                // If the book exists, remove it
                Book _ = bookStore.remove(id);
                http:Response response = new;
                response.statusCode = 200;
                response.setJsonPayload({message: "Successfully deleted book record"});
                check caller->respond(response);
            } else {
                // If the book does not exist, return a 404 Not Found response
                http:Response response = new;
                response.statusCode = 404;
                response.setJsonPayload({message: "No book found with the provided ID"});
                check caller->respond(response);
            }
        }
    }
}
