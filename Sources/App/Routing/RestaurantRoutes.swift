import Fluent
import Vapor

func restaurantRoutes(_ app: Application) throws {
    
    let restaurantsController = RestaurantsController()
    let restaurants = app.grouped("restaurants").grouped(UserAuthenticator())
    
    // TODO to ME
    
    
    restaurants.group("me") { rstr in
        rstr.get(":id", use: restaurantsController.getById)
        rstr.get(use: restaurantsController.getAll)
    }
    
    restaurants.grouped(AdminAuthenticator()).group("admin") { rstr in
        rstr.post("create", use: restaurantsController.create)
        rstr.delete("delete", ":id", use: restaurantsController.deleteById)
    }
}
