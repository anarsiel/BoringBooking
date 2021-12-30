import Foundation
import Fluent
import Vapor

struct ReservationsController {
    
    func getAll(req: Request) throws -> EventLoopFuture<[Reservation]> {
        let _ = try req.auth.require(User.self)
        return Reservation.query(on: req.db).all()
    }
    
    func getById(req: Request) throws -> EventLoopFuture<Reservation> {
        let _ = try req.auth.require(User.self)
        let id = UUID(req.parameters.get("id") ?? "")
        return Reservation.find(id, on: req.db).unwrap(or: Abort(.notFound))
    }
    
    func getByUserId(req: Request) throws -> EventLoopFuture<[Reservation]> {
        let user = try req.auth.require(User.self)
        let userId = user.id!
        
        return Reservation.query(on: req.db)
            .filter(\.$user.$id == userId)
            .all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<Reservation> {
        let _ = try req.auth.require(User.self)
        let reservation = try req.content.decode(Reservation.self)
        return reservation.create(on: req.db).map {reservation}
    }
    
    func deleteById(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let _ = try req.auth.require(User.self)
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return Reservation.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .map { .ok }
    }
        
    init() {}
}
