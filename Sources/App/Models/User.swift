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
