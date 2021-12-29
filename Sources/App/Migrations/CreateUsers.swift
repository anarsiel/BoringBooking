import Foundation
import Fluent
import FluentPostgresDriver

struct CreateUsers: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .id()
            .field("login", .string)
            .field("password", .string)
            .field("admin", .bool)
            .unique(on: "login")
            .create()
    }
    
    // undo
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}
