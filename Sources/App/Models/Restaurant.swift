import Foundation
import Vapor
import Fluent
import FluentPostgresDriver

final class Restaurant: Model, Content {
    
    static let schema = "restaurants"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Children(for: \.$restaurant)
    var tables: [Table]
    
    @Children(for: \.$restaurant)
    var reservations: [Reservation]
    
    init(){}
    
    init(id: UUID? = nil, name: String, tables: [Table], reservations: [Reservation]) {
        self.id = id
        self.name = name
        self.tables = tables
        self.reservations = reservations
    }
}
