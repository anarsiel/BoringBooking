import Foundation
import Fluent
import Vapor

struct RestaurantsController {
    func getAll(req: Request) throws -> EventLoopFuture<[Restaurant]> {
        let _ = try req.auth.require(User.self)
        return Restaurant.query(on: req.db).all()
    }
    
    func getById(req: Request) throws -> EventLoopFuture<Restaurant> {
        let _ = try req.auth.require(User.self)
        let id = UUID(req.parameters.get("id") ?? "")
        
        return Restaurant.find(id, on: req.db).unwrap(or: Abort(.notFound))
    }
    
    func create(req: Request) throws -> EventLoopFuture<Restaurant> {
        let _ = try req.auth.require(User.self)
        
        let restaurant = try req.content.decode(Restaurant.self)
        return restaurant.create(on: req.db).map {restaurant}
    }
    
    func deleteById(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let _ = try req.auth.require(User.self)
        
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
