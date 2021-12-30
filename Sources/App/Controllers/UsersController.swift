import Foundation
import Fluent
import Vapor
import JWT
import CBcrypt

struct UsersController {
    func getAll(req: Request) throws -> EventLoopFuture<[User]> {
        let _ = try req.auth.require(User.self)
        return User.query(on: req.db).all()
    }
    
    func getById(req: Request) throws -> EventLoopFuture<User> {
        let _ = try req.auth.require(User.self)
        let id = UUID(req.parameters.get("id") ?? "")
        return User.find(id, on: req.db).unwrap(or: Abort(.notFound))
    }
    
    func getByLogin(req: Request) throws -> EventLoopFuture<User> {
        let _ = try req.auth.require(User.self)
        let login = String(req.parameters.get("login") ?? "")
        return User.query(on: req.db)
            .filter(\.$login == login)
            .first()
            .unwrap(or: Abort(.notFound))
    }
    
    func create(req: Request) throws -> EventLoopFuture<User> {
        let user = try req.content.decode(User.self)
        user.admin = false
        user.password = try req.password.hash(user.password)
        return user.create(on: req.db).map {user}
    }
    
    func createAdmin(req: Request) throws -> EventLoopFuture<User> {
        let user = try req.content.decode(User.self)
        
        if (try !checkKeyWord(req: req)) {
            throw Abort(.unauthorized, reason: "Wrong key-word")
        }
        
        user.admin = true
        user.password = try req.password.hash(user.password)
        return user.create(on: req.db).map {user}
    }
    
    func checkKeyWord(req: Request) throws -> Bool {
        var keyWord: String = ""
        
        for kv in req.headers {
            if (kv.0 == "Key-Word") {
                keyWord = kv.1
            }
        }
        
        return try Bcrypt.verify(
            keyWord,
            created: try Bcrypt.hash("abobus")
        )
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
        let _ = try req.auth.require(User.self)
        
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
        
        return User.query(on: req.db)
            .filter(\.$login == user.login)
            .first()
            .unwrap(or: Abort(.notFound))
            .map { usr in
                return Me(id: user.id, login: user.login)
            }
    }
        
    init() {}
}
