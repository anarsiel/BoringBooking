import Fluent
import Vapor

func tableRoutes(_ app: Application) throws {
    
    let tablesController = TablesController()
    let tables = app.grouped("tables").grouped(UserAuthenticator())
    
    tables.group("me") { tbls in
        tbls.get("filter", ":restId", ":cosy", ":silent", ":nearWindow", ":kitchenView", use: tablesController.getAndFilterByType)
    }
    
    tables.grouped(AdminAuthenticator()).group("admin") { tbls in
        tbls.get(use: tablesController.getAll)
        tbls.get("get", "id", ":id", use: tablesController.getById)
        tbls.post("create", use: tablesController.create)
        tbls.delete("delete", "id", ":id", use: tablesController.deleteById)
    }
}

