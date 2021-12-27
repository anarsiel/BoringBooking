//
//  File.swift
//  
//
//  Created by Благой Димитров on 27.12.2021.
//

import Vapor

struct Me: Content {
    var id: UUID?
    var login: String
}
