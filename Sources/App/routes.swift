import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    app.get("show_all_reservations") { req in
        Reservation.query(on: req.db).all()
    }
    
    app.post("create_reservation") { req -> EventLoopFuture<Reservation> in
        let reservation = try req.content.decode(Reservation.self)
        return reservation.create(on: req.db).map {reservation}
    }
    
    app.post("create_user") { req -> EventLoopFuture<User> in
        let user = try req.content.decode(User.self)
        return user.create(on: req.db).map {user}
    }
    
    app.post("create_restaurant") { req -> EventLoopFuture<Restaurant> in
        let restaurant = try req.content.decode(Restaurant.self)
        return restaurant.create(on: req.db).map {restaurant}
    }
    
    app.post("create_table") { req -> EventLoopFuture<Table> in
        let table = try req.content.decode(Table.self)
        return table.create(on: req.db).map {table}
    }
}
