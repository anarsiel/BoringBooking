import Fluent
import Vapor

func reservationRoutes(_ app: Application) throws {
    
    let reservationsController = ReservationsController()
    let reservations = app.grouped("reservations").grouped(UserAuthenticator())
    
    reservations.group("me") { rsrv in
        rsrv.get("get", "id", ":id", use: reservationsController.getById)
        rsrv.get("get", "userId", use: reservationsController.getByUserId)
        rsrv.post("create", use: reservationsController.create)
        rsrv.delete("delete", "id", ":id", use: reservationsController.deleteById)
    }
    
    reservations.grouped(AdminAuthenticator()).group("admin") { rsrv in
        rsrv.get(use: reservationsController.getAll)
    }
}
