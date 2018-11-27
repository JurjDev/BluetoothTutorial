import Foundation
import Bluetooth

public extension  LedProfile {
	
	public struct LedService: GATTProfileService {
		
		public static var uuid: BluetoothUUID = BluetoothUUID(rawValue: "de2648be-a651-47f1-bbf5-4295848ca79e")!
		public static var isPrimary: Bool = true
		public static var characteristics: [GATTProfileCharacteristics.Type] = [Command.self]

		public enum Command: UInt8, GATTProfileCharacteristics {

			public static let service: GATTProfileService.Type = LedService.self
			public static let uuid: BluetoothUUID = BluetoothUUID(rawValue: "842d1152-1525-41e2-8e78-6a894d01da7d")!
			internal static let length = 1

			case on = 0x01
			case off = 0x02
			//Dim

			public init?(data: Data) {

				guard data.count == type(of: self).length 
					else { return nil }
				guard let value = Command(rawValue: data[0]) 
					else { return nil }
				self = value
			}

			public var data: Data {

				return Data([rawValue])
			}
		}
	}
}					