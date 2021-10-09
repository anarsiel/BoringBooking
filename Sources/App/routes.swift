import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    app.get("reservations") { req in
        Reservation.query(on: req.db).all()
    }
    
    app.post("reservations") { req -> EventLoopFuture<Reservation> in
        let reservation = try req.content.decode(Reservation.self)
        return reservation.create(on: req.db).map {reservation}
    }
    
    app.post("users") { req -> EventLoopFuture<User> in
        let user = try req.content.decode(User.self)
        return user.create(on: req.db).map {user}
    }
}
