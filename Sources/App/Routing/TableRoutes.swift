import Fluent
import Vapor

func tableRoutes(_ app: Application) throws {
    
    let tables = app.grouped("tables")
    let tablesController = TablesController()
    
    tables.get(use: tablesController.getAll)
    tables.get(":id", use: tablesController.getById)
    tables.get("filter", ":restId", ":cosy", ":silent", ":nearWindow", ":kitchenView", use: tablesController.getAndFilterByType)
    tables.post("create", use: tablesController.create)
    tables.delete("delete", ":id", use: tablesController.deleteById)
}

