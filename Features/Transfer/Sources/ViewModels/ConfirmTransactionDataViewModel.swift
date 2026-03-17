// Copyright (c). Gem Wallet. All rights reserved.

import Components
import Localization
import Primitives

struct ConfirmTransactionDataViewModel {
    private let type: TransferDataType
    private let decoder: EVMCallDataDecoder

    init(type: TransferDataType, decoder: EVMCallDataDecoder = EVMCallDataDecoder()) {
        self.type = type
        self.decoder = decoder
    }
}

// MARK: - ItemModelProvidable

extension ConfirmTransactionDataViewModel: ItemModelProvidable {
    var itemModel: ConfirmTransferItemModel {
        guard case let .generic(_, _, extra) = type,
              let data = extra.data,
              let decoded = decoder.decode(data) else {
            return .empty
        }
        var rows: [ListItemModel] = []

        if let signature = decoded.signature {
            rows.append(ListItemModel(title: Localized.Transfer.Data.function, subtitle: signature))
        }

        rows.append(ListItemModel(title: Localized.Transfer.Data.methodId, subtitle: decoded.methodId))

        for (index, parameter) in decoded.parameters.enumerated() {
            rows.append(ListItemModel(title: "[\(index)]", subtitle: parameter))
        }

        return .transactionData(rows)
    }
}
