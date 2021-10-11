import Fluent
import FluentPostgresDriver
import Vapor

public func configure(_ app: Application) throws {
    app.databases.use(
        .postgres(
            hostname: "localhost",
            username: "Vapor",
            password: "Vapor",
            database: "BoringBookingDB"
        ),
        as: .psql
    )

    app.migrations.add(CreateUsers())
    app.migrations.add(CreateRestaurants())
    app.migrations.add(CreateTables())
    app.migrations.add(CreateReservations())

    // register routes
    try reservationRoutes(app)
    try restaurantRoutes(app)
    try tableRoutes(app)
    try usersRoutes(app)
}
