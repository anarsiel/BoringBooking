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
            .field("userId", .uuid, .required, .references("users", "id"))
            .field("comment", .string)
            .create()
    }
    
    // undo
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("reservations").delete()
    }
}
