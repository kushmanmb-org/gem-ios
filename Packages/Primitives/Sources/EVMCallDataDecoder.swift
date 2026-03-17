// Copyright (c). Gem Wallet. All rights reserved.

import Foundation

public struct EVMDecodedCallData: Equatable, Sendable {
    public let methodId: String
    public let signature: String?
    public let parameters: [String]

    public init(methodId: String, signature: String?, parameters: [String]) {
        self.methodId = methodId
        self.signature = signature
        self.parameters = parameters
    }
}

public struct EVMCallDataDecoder: Sendable {
    private static let knownSignatures: [String: String] = [
        "7065cb48": "addOwner(address)",
        "e318b52b": "addOwnerWithThreshold(address,uint256)",
        "f8dc5dd9": "removeOwner(address,address,uint256)",
        "d4d9bdcd": "approveHash(bytes32)",
        "6a761202": "execTransaction(address,uint256,bytes,uint8,uint256,uint256,uint256,address,address,bytes)",
        "095ea7b3": "approve(address,uint256)",
        "a9059cbb": "transfer(address,uint256)",
        "23b872dd": "transferFrom(address,address,uint256)",
        "40c10f19": "mint(address,uint256)",
        "42842e0e": "safeTransferFrom(address,address,uint256)",
        "b88d4fde": "safeTransferFrom(address,address,uint256,bytes)",
    ]

    public init() {}

    public func decode(_ data: Data) -> EVMDecodedCallData? {
        guard data.count >= 4 else { return nil }

        let methodIdBytes = data.prefix(4)
        let methodId = "0x" + methodIdBytes.map { String(format: "%02x", $0) }.joined()
        let methodIdKey = methodIdBytes.map { String(format: "%02x", $0) }.joined()
        let signature = Self.knownSignatures[methodIdKey]

        let paramData = data.dropFirst(4)
        var parameters: [String] = []
        var offset = paramData.startIndex
        while offset + 32 <= paramData.endIndex {
            let chunk = paramData[offset ..< offset + 32]
            parameters.append(chunk.map { String(format: "%02x", $0) }.joined())
            offset += 32
        }

        return EVMDecodedCallData(methodId: methodId, signature: signature, parameters: parameters)
    }
}
