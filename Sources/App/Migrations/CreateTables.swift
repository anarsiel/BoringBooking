//
//  File.swift
//  
//
//  Created by Blagoi on 09.10.2021.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateTables: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tables")
            .id()
            .field("restaurant_id", .uuid, .required, .references("restaurants", "id"))
            .field("number", .int32, .required)
            .field("table_type_cosy", .bool, .required)
            .field("table_type_silent", .bool, .required)
            .field("table_type_near_window", .bool, .required)
            .field("table_type_kitchen_view", .bool, .required)
            .create()
    }
    
    // undo
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tables").delete()
    }
}

