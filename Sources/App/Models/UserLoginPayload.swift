//
//  File.swift
//  
//
//  Created by Благой Димитров on 27.12.2021.
//

import Vapor

final class UserLoginPayload: Content {
    var login: String
    var password: String
}
