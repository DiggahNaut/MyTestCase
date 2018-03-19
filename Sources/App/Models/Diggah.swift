import Vapor
import FluentProvider
import PostgreSQLProvider
import HTTP

final class Diggah: Model {
	var storage = Storage()

	var json_uid: String
	var json_data: String

	init(json_uid: String, json_data: String) {
		self.json_uid = json_uid
		self.json_data = json_data
	}

	init(row: Row) throws {
		self.json_uid = try row.get("json_uid")
		self.json_data = try row.get("json_data")
	}

	func makeRow() throws -> Row {
		var row = Row()
		try row.set("json_uid", json_uid)
		try row.set("json_data", json_data)
		return row
	}
}

extension Diggah: Preparation {
	static func prepare(_ database: Database) throws {
		try database.create(self) { builder in
			builder.id()
			builder.string("json_uid")
			builder.string("json_data")
		}
	}

	public static func revert(_ database: Database) throws {
		try database.delete(self)
	}
}

extension Diggah: NodeRepresentable {
	func makeNode(context: Context) throws -> Node {
		return try Node(node: [
			"json_uid": json_uid,
			"json_data": json_data
		])
	}
}

extension Diggah: JSONConvertible {
	convenience init(json: JSON) throws {
		self.init(
			json_uid: try json.get("json_uid"),
			json_data: try json.get("json_data")
		)
	}
	
	func makeJSON() throws -> JSON {
		var json = JSON()
		try json.set(Diggah.idKey, id)
		try json.set("json_uid", json_uid)
		try json.set("json_data", json_data)
		return json
	}
}