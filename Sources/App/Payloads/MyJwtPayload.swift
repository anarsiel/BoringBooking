//
//  File.swift
//  
//
//  Created by Благой Димитров on 27.12.2021.
//

import Vapor
import JWT

struct MyJwtPayload : Authenticatable, JWTPayload {
    var id: UUID?
    var login: String
    var admin: Bool
    var exp: ExpirationClaim
    
    func verify(using signer: JWTSigner) throws {
        try self.exp.verifyNotExpired()
    }
    
    func verifyAdmin(using signer: JWTSigner) throws {
        try self.exp.verifyNotExpired()
        
        if (!admin) {
            throw JWTError.signatureVerifictionFailed
        }
    }
}
