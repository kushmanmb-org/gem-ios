// Copyright (c). Gem Wallet. All rights reserved.

import Foundation
import Testing
import Primitives

struct EVMCallDataDecoderTests {

    let decoder = EVMCallDataDecoder()

    @Test
    func addOwnerDecode() throws {
        // addOwner(address) call: methodId 0x7065cb48 + address param
        let hex = "7065cb480000000000000000000000006fb9e80ddd0f5dc99d7cb38b07e8b298a57bf253"
        let data = try #require(Data(fromHex: hex))
        let result = try #require(decoder.decode(data))

        #expect(result.methodId == "0x7065cb48")
        #expect(result.signature == "addOwner(address)")
        #expect(result.parameters.count == 1)
        #expect(result.parameters[0] == "0000000000000000000000006fb9e80ddd0f5dc99d7cb38b07e8b298a57bf253")
    }

    @Test
    func unknownMethodId() {
        let data = Data([0xde, 0xad, 0xbe, 0xef])
        let result = decoder.decode(data)

        #expect(result?.methodId == "0xdeadbeef")
        #expect(result?.signature == nil)
        #expect(result?.parameters.isEmpty == true)
    }

    @Test
    func tooShortData() {
        let data = Data([0x70, 0x65])
        #expect(decoder.decode(data) == nil)
    }

    @Test
    func methodIdOnlyNoParams() {
        let data = Data([0x70, 0x65, 0xcb, 0x48])
        let result = decoder.decode(data)

        #expect(result?.methodId == "0x7065cb48")
        #expect(result?.parameters.isEmpty == true)
    }
}
