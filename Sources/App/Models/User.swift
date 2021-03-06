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
    
    @Field(key: "passwordHash")
    var password: String
    
    @Field(key: "admin")
    var admin: Bool?
    
    @Children(for: \.$user)
    var reservations: [Reservation]
    
    init(){}
    
    init(id: UUID? = nil, login: String, passwordHash: String, reservations: [Reservation]) {
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

extension User {
    
    func generateToken(_ app: Application) throws -> String {
        var expDate = Date()
        let oneDayInSeconds: Double = 3600 * 24
        expDate.addTimeInterval(oneDayInSeconds * 7)
        
        let exp = ExpirationClaim(value: expDate)
        
        return try app.jwt.signers.get(kid: .private)!
            .sign(MyJwtPayload(id: self.id, login: self.login, admin: self.admin ?? false, exp: exp)
        )
    }
}
