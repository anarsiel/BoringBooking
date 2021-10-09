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

final class Restaurant: Model, Content {
    
    static let schema = ""
    
    @ID(key: .id)
    var id: UUID?
    
    init(){}
}
