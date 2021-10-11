import Fluent
import FluentPostgresDriver
import Vapor

public func configure(_ app: Application) throws {
    if let databaseURL = Environment.get("DATABASE_URL"), var postgresConfig = PostgresConfiguration(url: databaseURL) {
        postgresConfig.tlsConfiguration = .forClient(certificateVerification: .none)
        app.databases.use(.postgres(
            configuration: postgresConfig
        ), as: .psql)
    }
    else {
        app.databases.use(
            .postgres(
                hostname: "localhost",
                username: "Vapor",
                password: "Vapor",
                database: "BoringBookingDB"
            ),
            as: .psql
        )
    }

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
