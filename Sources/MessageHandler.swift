//
//  MessageHandler.swift
//  ClassHierarchyCodable
//
//  Created by Antti Juustila on 11.10.2023.
//

import Foundation

enum MessageHandler {
	static func parseMessage(_ dataStr: String) throws -> Message? {
		guard let data = dataStr.data(using: .utf8) else {
			return nil
		}
		var message: Message?
		if let dict = try JSONSerialization.jsonObject(with: data) as? Dictionary<String, Any> {
			if let type = dict["type"] as? Int {
				let msgType = Message.MessageType.fromInt(type)
				switch msgType {
					case .status:
						message = try JSONDecoder().decode(StatusMessage.self, from: data)
					case .error:
						message = try JSONDecoder().decode(ErrorMessage.self, from: data)
					case .listChannels:
						message = try JSONDecoder().decode(ListChannelsMessage.self, from: data)
					case .changeTopic:
						message = try JSONDecoder().decode(ChangeTopicMessage.self, from: data)
					case .chat:
						message = try JSONDecoder().decode(ChatMessage.self, from: data)
					case .join:
						message = try JSONDecoder().decode(JoinMessage.self, from: data)
					default:
						break
				}
			}
		}
		return message
	}
	
	static func toString(_ message: Message) throws -> String {
		let encoder = JSONEncoder()
		let data = try encoder.encode(message)
		let dataString = String(data: data, encoding: .utf8)!
		return dataString
	}
	
}
