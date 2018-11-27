#if os(Linux)
import Glibc
#elseif os(macOS)
import Darwin
#endif

import Foundation
import Bluetooth
import GATT

public final class CoreServer {

	public let peripheral: PeripheralProtocol
	public let ledServiceController: LedServiceController

	private var services: [GATTServiceController] {

		return [ledServiceController]
	}

	public init(peripheral: PeripheralProtocol) throws {

		self.peripheral = peripheral
		self.ledServiceController = try LedServiceController(peripheral: peripheral)

		self.peripheral.willRead = { [unowned self] in self.willRead($0) }
		self.peripheral.willWrite = { [unowned self] in self.willWrite($0) }
		self.peripheral.didWrite = { [unowned self] in self.didWrite($0) }	
	}

	private func willRead(_ request: GATTReadRequest) -> ATT.Error? {

		guard let service = services.first(where: {
			type(of: $0).service.characteristics.contains(where: {
					$0.uuid == request.uuid
				})
			}) 
			else { return nil }

		return service.willRead(request)
	}

	private func willWrite(_ request: GATTWriteRequest) -> ATT.Error? {

		guard let service = services.first(where: {
			type(of: $0).service.characteristics.contains(where: { $0.uuid == request.uuid })
			})
			else { return nil }

		return service.willWrite(request)
	}

	private func didWrite(_ confirmation: GATTWriteConfirmation) {

		guard let service = services.first(where: {
			type(of: $0).service.characteristics.contains(where: { $0.uuid == confirmation.uuid })
			})
			else { return }

		service.didWrite(confirmation)
	}
}