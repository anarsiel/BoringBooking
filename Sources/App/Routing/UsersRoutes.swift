import Fluent
import Vapor

func usersRoutes(_ app: Application) throws {
    
    let users = app.grouped("users")
    let usersController = UsersController()
    
    users.post("create", use: usersController.create)
    users.post("login", use: usersController.login)
    users.post("create", "admin", use: usersController.createAdmin)
    
    users.grouped(UserAuthenticator()).group("me") { usr in
        usr.get(use: usersController.me)
    }
    
    users.grouped(AdminAuthenticator()).group("admin") { usr in
        usr.get(use: usersController.getAll)
        usr.get("find", "id", ":id", use: usersController.getById)
        usr.get("find", "login", ":login", use: usersController.getByLogin)
        usr.delete("delete", "id", ":id", use: usersController.deleteById)
    }
}
