import Vapor
import CryptoSwift

extension Droplet {
    func setupRoutes() throws {
	post("savedata") { req in
		guard let json_data = req.json else {
			throw Abort(.badRequest, reason: "No json provided")
		}

		let message: String = try json_data.get("message")
		let json_uid = message.md5()

		let diggah: Diggah

		do {
			diggah = try Diggah(json_uid: json_uid, json_data: message)
		} catch {
			throw Abort(.badRequest, reason: "Something wrong.")
		}

		try diggah.save()

		return "Success! Here's Unique ID for your data \(json_uid). Just type /getalldata."
	}

	get("getdata", String.parameter) { req in
		let dataId = try req.parameters.next(String.self)

		guard let diggah = try Diggah.find(dataId) else {
			throw Abort(.badRequest, reason: "Data with id \(dataId) does not exist")
		}

		return try diggah.makeJSON()
	}

	get("getalldata") { req in
		let data = try Diggah.all()

		return try data.makeJSON()
	}
    }
}