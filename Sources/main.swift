// The Swift Programming Language
// https://docs.swift.org/swift-book

func main() {

	let chatMessageJSON = """
	{
	 "type" : 1,
	 "id" : "d4986bec-8026-462a-9a7a-f04eebcf7612",
	 "inReplyTo": "d4986bec-8026-462b-8a7a-f04dfbcf1115",
	 "message" : "mutta lopettakaa te hurjistelunne ja vierailkaa",
	 "user" : "telemakos",
	 "sent":16782697319
	}
	"""
	
	let errorMessageJSON = """
	{
	 "type": -1,
	 "error" : "Some error message here",
	 "clientshutdown": 0
	}
	"""
	
	do {
		if let message = try MessageHandler.parseMessage(chatMessageJSON) as? ChatMessage {
			print("ChatMessage: \(message.id) \(message.user), \(message.sent)")
		}
		if let message = try MessageHandler.parseMessage(errorMessageJSON) as? ErrorMessage {
			print("ErrorMessage: \(message.error) must close connection: \(message.clientshutdown != 0 ? "yes" : "no")")
		}
		let statusMessage = StatusMessage()
		statusMessage.status = "Channel has new users"
		let statusMessageJSON = try MessageHandler.toString(statusMessage)
		print("\(statusMessageJSON)")

	} catch {
		print("Error: \(error.localizedDescription)")
	}
}

main()
