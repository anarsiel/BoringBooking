import Foundation
import Fluent
import Vapor

struct RestaurantsController {
    func getAll(req: Request) -> EventLoopFuture<[Restaurant]> {
        return Restaurant.query(on: req.db).all()
    }
    
    func getById(req: Request) -> EventLoopFuture<Restaurant> {
        let id = UUID(req.parameters.get("id")!)
        return Restaurant.find(id, on: req.db).unwrap(or: Abort(.notFound))
    }
    
    func create(req: Request) throws -> EventLoopFuture<Restaurant> {
        let restaurant = try req.content.decode(Restaurant.self)
        return restaurant.create(on: req.db).map {restaurant}
    }
    
    func deleteById(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return Restaurant.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .map { .ok }
    }
        
    init() {}
}
