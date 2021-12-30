import Foundation
import Fluent
import Vapor

struct TablesController {
    func getAll(req: Request) throws -> EventLoopFuture<[Table]> {
        let _ = try req.auth.require(User.self)
        return Table.query(on: req.db).all()
    }
    
    func getById(req: Request) throws -> EventLoopFuture<Table> {
        let _ = try req.auth.require(User.self)
        let id = UUID(req.parameters.get("id") ?? "")
        return Table.find(id, on: req.db).unwrap(or: Abort(.notFound))
    }
    
    func getAndFilterByType(req: Request) throws -> EventLoopFuture<[Table]> {
        let _ = try req.auth.require(User.self)
        
        let restId = UUID(req.parameters.get("restId") ?? "") ?? UUID()
        let cosy = Bool(req.parameters.get("cosy") ?? "false") ?? false
        let silent = Bool(req.parameters.get("silent") ?? "false") ?? false
        let nearWindow = Bool(req.parameters.get("nearWindow") ?? "false") ?? false
        let kitchenView = Bool(req.parameters.get("kitchenView") ?? "false") ?? false
        
        return Table.query(on: req.db)
            .filter(\.$restaurant.$id == restId)
            .filter(\.$tableType.$cosy >= cosy)
            .filter(\.$tableType.$silent >= silent)
            .filter(\.$tableType.$nearWindow >= nearWindow)
            .filter(\.$tableType.$kitchenView >= kitchenView)
            .all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<Table> {
        let _ = try req.auth.require(User.self)
        
        let table = try req.content.decode(Table.self)
        return table.create(on: req.db).map {table}
    }
    
    func deleteById(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let _ = try req.auth.require(User.self)
        
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return Table.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .map { .ok }
    }
        
    init() {}
}
