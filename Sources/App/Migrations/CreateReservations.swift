//
//  File.swift
//
//
//  Created by Blagoi on 09.10.2021.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateReservations: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("reservations")
            .id()
            .field("restaurant_id", .uuid, .required, .references("restaurants", "id"))
            .field("table_id", .uuid, .required, .references("tables", "id"))
            .field("user_id", .uuid, .required, .references("users", "id"))
            .field("start_timestamp", .string, .required)
            .field("end_timestamp", .string, .required)
            .field("comment", .string)
            .create()
    }
    
    // undo
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("reservations").delete()
    }
}
