import Foundation
import Fluent
import FluentPostgresDriver

struct CreateRestaurants: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("restaurants")
            .id()
            .field("name", .string, .required)
            .unique(on: "name")
            .create()
    }
    
    // undo
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("restaurants").delete()
    }
}
