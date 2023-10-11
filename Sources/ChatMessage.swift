//
//  ChatMessage.swift
//  SwiftChatClient
//
//  Created by Antti Juustila on 27.2.2021.
//

// Inspiration from: https://nefkens.net/swift-json-encoding-decoding-and-subclasses/

import Foundation

class Message: Codable {

	enum MessageType: Int, Codable, Hashable {
		case unknown = -999
		case error = -1
		case status = 0
		case chat = 1
		case join = 2
		case changeTopic = 3
		case listChannels = 4

		func hash(hasher: inout Hasher) {
			hasher.combine(self)
		}

		static func fromInt(_ value: Int) -> MessageType {
			switch value {
				case -1:
					return .error
				case 0:
					return .status
				case 1:
					return .chat
				case 2:
					return .join
				case 3:
					return .changeTopic
				case 4:
					return .listChannels
				default:
					return .unknown
			}
		}
	}

	var type: MessageType = .unknown

	init() {
		// empty
	}

	private enum CodingKeys: CodingKey {
		case type
	}

	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		type = try container.decode(MessageType.self, forKey: .type)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(type, forKey: .type)
	}
	
	var specialSymbol: String {
		""
	}

	var origin: String {
		"server"
	}

	var content: String {
		""
	}

	var time: Date {
		Date.now
	}

	var isDirectMessage: Bool {
		false
	}

}

class StatusMessage: Message  {
	var status: String

	private  enum CodingKeys: CodingKey {
		case status
	}

	override init() {
		status = ""
		super.init()
		type = .status
	}

	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		status = try container.decode(String.self, forKey: .status)
		try super.init(from: decoder)
	}

	override public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(status, forKey: .status)
		try super.encode(to: encoder)
	}
	
	override var specialSymbol: String {
		"info.circle.fill"
	}

	override var origin: String {
		"server says:"
	}

	override var content: String {
		return status
	}

}

class ErrorMessage: Message {
	var error: String
	var clientshutdown: Int

	private  enum CodingKeys: CodingKey {
		case error, clientshutdown
	}

	override init() {
		error = ""
		clientshutdown = 0
		super.init()
		type = .error
	}

	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		error = try container.decode(String.self, forKey: .error)
		clientshutdown = try container.decode(Int.self, forKey: .clientshutdown)
		try super.init(from: decoder)
	}

	override public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(error, forKey: .error)
		try container.encode(clientshutdown, forKey: .clientshutdown)
		try super.encode(to: encoder)
	}
	
	override var specialSymbol: String {
		"exclamationmark.bubble"
	}
	
	override var origin: String {
		"server error!:"
	}

	override var content: String {
		return error
	}

}

class ListChannelsMessage: Message {
	var channels: [String]?

	private  enum CodingKeys: CodingKey {
		case channels
	}

	override init() {
		channels = nil
		super.init()
		type = .listChannels
	}

	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		channels = try container.decode([String]?.self, forKey: .channels)
		try super.init(from: decoder)
	}

	override public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		if let channels {
			try container.encode(channels, forKey: .channels)
		}
		try super.encode(to: encoder)
	}
	
	override var specialSymbol: String {
		"list.star"
	}

	override var origin: String {
		"channels in server:"
	}

	override var content: String {
		if let channels {
			return channels.joined(separator: ", ")
		}
		return ""
	}

}

class ChangeTopicMessage: Message {
	var topic: String

	private  enum CodingKeys: CodingKey {
		case topic
	}

	override init() {
		topic = ""
		super.init()
		type = .changeTopic
	}

	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		topic = try container.decode(String.self, forKey: .topic)
		try super.init(from: decoder)
	}

	override public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(topic, forKey: .topic)
		try super.encode(to: encoder)
	}
	
	override var specialSymbol: String {
		"bubble.left.and.bubble.right"
	}

	override var origin: String {
		"channel topic is:"
	}

	override var content: String {
		return topic
	}

}

class JoinMessage: Message {
	var channel: String

	private  enum CodingKeys: CodingKey {
		case channel
	}

	override init() {
		channel = ""
		super.init()
		type = .join
	}

	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		channel = try container.decode(String.self, forKey: .channel)
		try super.init(from: decoder)
	}

	override public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(channel, forKey: .channel)
		try super.encode(to: encoder)
	}
	
	override var specialSymbol: String {
		"checkmark.bubble.fill"
	}

	override var content: String {
		return channel
	}

}

class ChatMessage: Message {
	var id: String
	var inReplyTo: String?
	var directMessageTo: String?
   var user: String
   var message: String
   var sent: Date

	private  enum CodingKeys: CodingKey {
		case id, inReplyTo, directMessageTo, user, message, sent
	}

	override init() {
		id = UUID().uuidString
		inReplyTo = nil
		user = ""
		message = ""
		sent = Date.now
		super.init()
		type = .chat
	}

	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decode(String.self, forKey: .id)
		inReplyTo = try container.decodeIfPresent(String.self, forKey: .inReplyTo)
		directMessageTo = try container.decodeIfPresent(String.self, forKey: .directMessageTo)
		user = try container.decode(String.self, forKey: .user)
		message = try container.decode(String.self, forKey: .message)
		let timeStamp = try container.decode(Int.self, forKey: .sent)
		sent = Date(timeIntervalSince1970: TimeInterval(timeStamp))
		try super.init(from: decoder)
	}

	override public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		if let inReplyTo {
			try container.encode(inReplyTo, forKey: .inReplyTo)
		}
		if let directMessageTo {
			try container.encode(directMessageTo, forKey: .directMessageTo)
		}
		try container.encode(user, forKey: .user)
		try container.encode(message, forKey: .message)
		try container.encode(Int(sent.timeIntervalSince1970), forKey: .sent)
		try super.encode(to: encoder)
	}
	
	override var specialSymbol: String {
		if directMessageTo != nil {
			return "lock.shield"
		}
		return "quote.bubble"
	}

	override var origin: String {
		user
	}

	override var content: String {
		message
	}

	func time() -> Date {
		return sent
	}

	override var isDirectMessage: Bool {
		directMessageTo != nil
	}
}
