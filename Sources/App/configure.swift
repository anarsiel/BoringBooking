import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

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
    app.migrations.add(CreateReservations())

    // register routes
    try routes(app)
}
