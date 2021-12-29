import Fluent
import Vapor

func restaurantRoutes(_ app: Application) throws {
    
    let restaurantsController = RestaurantsController()
    let restaurants = app.grouped("restaurants")
    
    restaurants.grouped(UserAuthenticator()).group("me") { rstr in
        rstr.get("get", "id", ":id", use: restaurantsController.getById)
        rstr.get("getAll", use: restaurantsController.getAll)
    }
    
    restaurants.grouped(AdminAuthenticator()).group("admin") { rstr in
        rstr.post("create", use: restaurantsController.create)
        rstr.delete("delete", "id" ,":id", use: restaurantsController.deleteById)
    }
}
