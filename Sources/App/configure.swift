import Fluent
import FluentPostgresDriver
import Vapor
import JWT

extension String {
    var bytes: [UInt8] { .init(self.utf8) }
}

extension JWKIdentifier {
    static let `public` = JWKIdentifier(string: "public")
    static let `private` = JWKIdentifier(string: "private")
}

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
    
    let privateKey = try String(contentsOfFile: app.directory.workingDirectory + "jwt.key")
    let privateSigner = try JWTSigner.rs256(key: .private(pem: privateKey.bytes))
    
    let publicKey = try String(contentsOfFile: app.directory.workingDirectory + "jwt.key.pub")
    let publicSigner = try JWTSigner.rs256(key: .public(pem: publicKey.bytes))
    
    app.jwt.signers.use(privateSigner, kid: .private)
    app.jwt.signers.use(publicSigner, kid: .public, isDefault: true)

    // register routes
    try reservationRoutes(app)
    try restaurantRoutes(app)
    try tableRoutes(app)
    try usersRoutes(app)
}
