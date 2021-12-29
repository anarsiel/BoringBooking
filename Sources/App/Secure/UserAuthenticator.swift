//
//  File.swift
//  
//
//  Created by Благой Димитров on 29.12.2021.
//

import Vapor
import Fluent
import JWT

struct UserAuthenticator: JWTAuthenticator {
    typealias Payload = MyJwtPayload
    
    func authenticate(jwt: Payload, for request: Request) -> EventLoopFuture<Void> {
        do {
            try jwt.verify(using: request.application.jwt.signers.get()!)
            
            return User
                .find(jwt.id, on: request.db)
                .unwrap(or: Abort(.notFound))
                .map { user in
                    request.auth.login(user)
                }
        } catch {
            return request.eventLoop.makeSucceededFuture(())
        }
    }
}
