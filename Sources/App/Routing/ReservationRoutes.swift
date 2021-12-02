import Fluent
import Vapor

func reservationRoutes(_ app: Application) throws {
    
    let reservations = app.grouped("reservations")
    let reservationsController = ReservationsController()
    
    reservations.get(use: reservationsController.getAll)
    reservations.get(":id", use: reservationsController.getById)
    reservations.get("user", ":id", use: reservationsController.getByUserId)
    reservations.post("create", use: reservationsController.create)
    reservations.delete("delete", ":id", use: reservationsController.deleteById)
}
