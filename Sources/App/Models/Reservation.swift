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
    
    @Parent(key: "userId")
    var user: User
    
    @Field(key: "comment")
    var comment: String?
    
    init(){}
    
    init(id: UUID? = nil, user: User, comment: String? = nil) {
        self.id = id
        self.user = user
        self.comment = comment
    }
}
