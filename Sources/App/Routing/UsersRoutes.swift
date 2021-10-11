import Fluent
import Vapor

func usersRoutes(_ app: Application) throws {
    
    let users = app.grouped("users")
    let usersController = UsersController()
    
    users.get(use: usersController.getAll)
    users.get(":id", use: usersController.getById)
    users.post("create", use: usersController.create)
    users.delete("delete", ":id", use: usersController.deleteById)
}
