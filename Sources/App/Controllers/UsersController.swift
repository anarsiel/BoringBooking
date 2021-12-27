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
    
    func getByLogin(req: Request) -> EventLoopFuture<User> {
        let login = String(req.parameters.get("login")!)
        return User.query(on: req.db)
            .filter(\.$login == login)
            .first()
            .unwrap(or: Abort(.notFound))
    }
    
    func create(req: Request) throws -> EventLoopFuture<User> {
        let user = try req.content.decode(User.self)
        return user.create(on: req.db).map {user}
    }
    
    func login(req: Request) throws -> EventLoopFuture<String> {
        let userToLogin = try req.content.decode(UserLoginPayload.self)
        
        return User.query(on: req.db)
            .filter(\.$login == userToLogin.login)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing { dbUser in
                let verified = try dbUser.verify(password: userToLogin.password)
                
                if verified == false {
                    throw Abort(.unauthorized)
                }
                
                req.auth.login(dbUser)
                let user = try req.auth.require(User.self)
                return try user.generateToken(req.application)
            }
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
    
    func me(req: Request) throws -> EventLoopFuture<Me> {
        let user = try req.auth.require(User.self)
        let login = user.login
        
        return User.query(on: req.db)
            .filter(\.$login == login)
            .first()
            .unwrap(or: Abort(.notFound))
            .map { usr in
                return Me(id: UUID(), login: login)
            }
    }
        
    init() {}
}
