import Fluent
import Vapor

struct TodoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        /// vapordemo.com/todos
        let todos = routes.grouped("todos")
        todos.get(use: { try await index(req: $0) }) /// GET vapordemo.com/todos
        todos.post(use: create)
        /// vapordemo.com/todos/:todoID
        todos.group(":todoID") { todo in
            todo.delete(use: delete)
        }
    }

    func index(req: Request) async throws -> [Todo] {
        try await Todo.query(on: req.db).all()
    }

    func create(req: Request) async throws -> Todo {
        
        /// vapordemo.com/todos?limit=10&after=100
        
        let limit = try req.query.get(Int.self, at: "limit")
        /// vapordemo.com/todos/0000aaaa-0a00-bbbb-0000-0000aaaa0000
        let todoID = req.parameters.get("todoID")
        
        req.content
        
        let todo = try req.content.decode(Todo.self)
        try await todo.save(on: req.db)
        return todo
    }

    func delete(req: Request) async throws -> HTTPStatus {
        /// vapordemo.com/todos/0000aaaa-0a00-bbbb-0000-0000aaaa0000
        ///
        
        guard let todo = try await Todo.find(req.parameters.get("todoID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await todo.delete(on: req.db)
        return .noContent
    }
}
