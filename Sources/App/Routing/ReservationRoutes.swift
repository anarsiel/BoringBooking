import Fluent
import Vapor

func reservationRoutes(_ app: Application) throws {
    
    let reservationsController = ReservationsController()
    let reservations = app.grouped("reservations").grouped(UserAuthenticator())
    
    reservations.group("me") { rsrv in
        rsrv.get("user", ":id", use: reservationsController.getByUserId)
        rsrv.post("create", use: reservationsController.create)
        rsrv.delete("delete", ":id", use: reservationsController.deleteById)
        rsrv.get(":id", use: reservationsController.getById)
    }
    
    reservations.grouped(AdminAuthenticator()).group("admin") { rsrv in
        rsrv.get(use: reservationsController.getAll)
    }
}
