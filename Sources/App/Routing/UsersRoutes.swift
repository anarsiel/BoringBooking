import Fluent
import Vapor

func usersRoutes(_ app: Application) throws {
    
    let users = app.grouped("users")
    let usersController = UsersController()
    
    users.get(use: usersController.getAll)
    users.get(":id", use: usersController.getById)
    users.get("byLogin", ":login", use: usersController.getByLogin)
    users.post("create", use: usersController.create)
    users.post("login", use: usersController.login)
    users.delete("delete", ":id", use: usersController.deleteById)
    
    users.grouped(JWTBearerAuthenticator()).group("me") { usr in
        usr.get(use: usersController.me)
    }
}
