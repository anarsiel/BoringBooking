//
//  File.swift
//  
//
//  Created by Blagoi on 09.10.2021.
//

import Foundation
import Vapor
import Fluent
import FluentPostgresDriver

final class Reservation: Model, Content {
    
    static let schema = "reservations"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "restaurant_id")
    var restaurant: Restaurant
    
    @Parent(key: "table_id")
    var table: Table
    
    @Parent(key: "user_id")
    var user: User
    
    @Field(key: "start_timestamp")
    var startTimestamp: String
    
    @Field(key: "end_timestamp")
    var endTimestamp: String
    
    @Field(key: "comment")
    var comment: String?
    
    init(){}
    
    init(id: UUID? = nil,
         restaurant: Restaurant,
         table: Table,
         user: User,
         startTimestamp: String,
         endTimestamp: String,
         comment: String? = nil) {
        self.id = id
        self.restaurant = restaurant
        self.table = table
        self.user = user
        self.startTimestamp = startTimestamp
        self.endTimestamp = endTimestamp
        self.comment = comment
    }
}
