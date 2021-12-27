import Foundation
import Vapor
import Fluent
import FluentPostgresDriver
import JWT

final class User: Model, Content {
    
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "login")
    var login: String
    
    // TODO: store passwordHash not password
    @Field(key: "password")
    var password: String
    
    @Children(for: \.$user)
    var reservations: [Reservation]
    
    init(){}
    
    init(id: UUID? = nil, login: String, password: String, reservations: [Reservation]) {
        self.id = id
        self.login = login
        self.password = password
        self.reservations = reservations
    }
}

extension User: ModelAuthenticatable {
    static var usernameKey: KeyPath<User, Field<String>> {
        return \User.$login
    }
    
    static var passwordHashKey: KeyPath<User, Field<String>> {
        return \User.$password
    }
    
    func verify(password: String) throws -> Bool {
        return try Bcrypt.verify(
            password,
            created: self.password
        )
    }
}
 
struct JWTBearerAuthenticator: JWTAuthenticator {
    typealias Payload = MyJwtPayload
    
    func authenticate(jwt: Payload, for request: Request) -> EventLoopFuture<Void> {
        do {
            try jwt.verify(using: request.application.jwt.signers.get()!)
            
            return User
                .find(jwt.id, on: request.db)
                .unwrap(or: Abort(.notFound))
                .map { user in
                    request.auth.login(user)
                }
        } catch {
            return request.eventLoop.makeSucceededFuture(())
        }
    }
}

extension User {
    
    func generateToken(_ app: Application) throws -> String {
        var expDate = Date()
        let oneDayInSeconds: Double = 3600 * 24
        expDate.addTimeInterval(oneDayInSeconds * 7)
        
        let exp = ExpirationClaim(value: expDate)
        
        return try app.jwt.signers.get(kid: .private)!
            .sign(MyJwtPayload(id: self.id, login: self.login, exp: exp)
        )
    }
}
