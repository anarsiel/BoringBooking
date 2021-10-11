import Foundation
import Vapor
import Fluent
import FluentPostgresDriver

final class Table: Model, Content {
    
    static let schema = "tables"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "restaurant_id")
    var restaurant: Restaurant
    
    @Field(key: "number")
    var number: Int32
    
    @Group(key: "table_type")
    var tableType: TableType
    
    @Children(for: \.$table)
    var reservations: [Reservation]
    
    init(){}
    
    init(id: UUID? = nil, restaurant: Restaurant, number: Int32, tableType: TableType, reservations: [Reservation]) {
        self.id = id
        self.restaurant = restaurant
        self.number = number
        self.tableType = tableType
        self.reservations = reservations
    }
}

final class TableType: Fields {
    // уютное место
    @Field(key: "cosy")
    var cosy: Bool
    
    // не шумное место
    @Field(key: "silent")
    var silent: Bool
    
    // рядом с окошком
    @Field(key: "near_window")
    var nearWindow: Bool
    
    // с видом на кухню
    @Field(key: "kitchen_view")
    var kitchenView: Bool
    
    init(){}
    
    init(cosy: Bool = false, silent: Bool = false, nearWindow: Bool = false, kitchenView: Bool = false) {
        self.cosy = cosy
        self.silent = silent
        self.nearWindow = nearWindow
        self.kitchenView = kitchenView
    }
}

final class TableCoordinaties: Fields {
    @Group(key: "left_bottom_corner")
    var leftBottomCorner: Point
    
    @Group(key: "right_top_corner")
    var rightTopCorner: Point
    
    init(){}
    
    init(leftBottomCorner: Point, rightTopCorner: Point) {
        self.leftBottomCorner = leftBottomCorner
        self.rightTopCorner = rightTopCorner
    }
}

final class Point: Fields {
    @Field(key: "x")
    var x: Float
    
    @Field(key: "y")
    var y: Float
    
    init(){}
    
    init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
}
