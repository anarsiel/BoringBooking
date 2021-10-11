import Fluent
import Vapor

func restaurantRoutes(_ app: Application) throws {
    
    let restaurants = app.grouped("restaurants")
    let restaurantsController = RestaurantsController()
    
    restaurants.get(use: restaurantsController.getAll)
    restaurants.get(":id", use: restaurantsController.getById)
    restaurants.post("create", use: restaurantsController.create)
    restaurants.delete("delete", ":id", use: restaurantsController.deleteById)
}
