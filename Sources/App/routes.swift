import Fluent
import Vapor

func routes(_ app: Application) throws {
    /// vapordemo.com == http://127.0.0.1:8080
    
    /// vapordemo.com
    app.get { req async throws in
        try await req.view.render("index", ["title": "Hello Vapor!"])
    }

    /// vapordemo.com/hello
    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    try app.register(collection: TodoController())
}
