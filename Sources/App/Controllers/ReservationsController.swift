import Foundation
import Fluent
import Vapor

struct ReservationsController {
    
    func getAll(req: Request) -> EventLoopFuture<[Reservation]> {
        return Reservation.query(on: req.db).all()
    }
    
    func getById(req: Request) -> EventLoopFuture<Reservation> {
        let id = UUID(req.parameters.get("id")!)
        return Reservation.find(id, on: req.db).unwrap(or: Abort(.notFound))
    }
    
    func getByUserId(req: Request) -> EventLoopFuture<[Reservation]> {
        let id = UUID(req.parameters.get("id")!)!
        return Reservation.query(on: req.db)
            .filter(\.$user.$id == id)
            .all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<Reservation> {
        let reservation = try req.content.decode(Reservation.self)
        return reservation.create(on: req.db).map {reservation}
    }
    
    func deleteById(req: Request) throws -> EventLoopFuture<HTTPStatus> {
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
