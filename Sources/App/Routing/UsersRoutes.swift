import Fluent
import Vapor

func usersRoutes(_ app: Application) throws {
    
    let users = app.grouped("users")
    let usersController = UsersController()
    
    users.post("create", use: usersController.create)
    users.post("login", use: usersController.login)
    
    // TODO to admin
    users.get("byLogin", ":login", use: usersController.getByLogin)
    
    users.grouped(UserAuthenticator()).group("me") { usr in
        usr.get(use: usersController.me)
    }
    
    users.grouped(AdminAuthenticator()).group("admin") { usr in
        usr.get(use: usersController.getAll)
        usr.get(":id", use: usersController.getById)
        usr.delete("delete", ":id", use: usersController.deleteById)
    }
}
