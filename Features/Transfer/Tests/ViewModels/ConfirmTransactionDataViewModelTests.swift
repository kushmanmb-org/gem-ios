// Copyright (c). Gem Wallet. All rights reserved.

import Testing
import Localization
import Foundation
@testable import Transfer
@testable import Primitives
import PrimitivesTestKit
import TransferTestKit

struct ConfirmTransactionDataViewModelTests {

    @Test
    func genericWithCallData() throws {
        let callDataHex = "7065cb480000000000000000000000006fb9e80ddd0f5dc99d7cb38b07e8b298a57bf253"
        let extra = TransferDataExtra.mock(data: try #require(Data(fromHex: callDataHex)))
        let model = ConfirmTransactionDataViewModel(type: .generic(asset: .mock(), metadata: .mock(), extra: extra))

        guard case .transactionData(let rows) = model.itemModel else {
            Issue.record("Expected .transactionData")
            return
        }
        #expect(rows.count == 3)
        #expect(rows[0].title == Localized.Transfer.Data.function)
        #expect(rows[0].subtitle == "addOwner(address)")
        #expect(rows[1].title == Localized.Transfer.Data.methodId)
        #expect(rows[1].subtitle == "0x7065cb48")
        #expect(rows[2].title == "[0]")
    }

    @Test
    func genericWithUnknownCallData() {
        let extra = TransferDataExtra.mock(data: Data([0xde, 0xad, 0xbe, 0xef]))
        let model = ConfirmTransactionDataViewModel(type: .generic(asset: .mock(), metadata: .mock(), extra: extra))

        guard case .transactionData(let rows) = model.itemModel else {
            Issue.record("Expected .transactionData")
            return
        }
        #expect(rows.count == 1)
        #expect(rows[0].title == Localized.Transfer.Data.methodId)
        #expect(rows[0].subtitle == "0xdeadbeef")
    }

    @Test
    func genericWithNoData() {
        let model = ConfirmTransactionDataViewModel(type: .generic(asset: .mock(), metadata: .mock(), extra: .mock()))

        guard case .empty = model.itemModel else {
            Issue.record("Expected .empty")
            return
        }
    }

    @Test
    func transferReturnsEmpty() {
        let model = ConfirmTransactionDataViewModel(type: .transfer(.mock()))

        guard case .empty = model.itemModel else {
            Issue.record("Expected .empty")
            return
        }
    }
}
