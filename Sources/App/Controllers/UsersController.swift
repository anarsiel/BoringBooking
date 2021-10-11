import Foundation
import Fluent
import Vapor

struct UsersController {
    func getAll(req: Request) -> EventLoopFuture<[User]> {
        return User.query(on: req.db).all()
    }
    
    func getById(req: Request) -> EventLoopFuture<User> {
        let id = UUID(req.parameters.get("id")!)
        return User.find(id, on: req.db).unwrap(or: Abort(.notFound))
    }
    
    func create(req: Request) throws -> EventLoopFuture<User> {
        let user = try req.content.decode(User.self)
        return user.create(on: req.db).map {user}
    }
    
    func deleteById(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return User.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .map { .ok }
    }
        
    init() {}
}
