#  ClassHierarchyCodable

A simple example on how to create a Swift class hierarcy and then enable encoding and decoding objects from and to JSON.

The example is based on the implementation from: https://nefkens.net/swift-json-encoding-decoding-and-subclasses/

The domain is a chat app/server, where there is a common base class `Message`. Subclasses include, for example, `ChatMessage`, `ErrorMessage` and `StatusMessage`. These have some common properties, overridden by subclasses if/when necessary.

See `main.swift` for a simple example on how to encode and decode between JSON and objects.

`MessageHandler` does the actual encoding and decoding.

## Who did this

* Antti Juustila
* (c) Antti Juustila, 2023
* MIT Licence
