import Foundation
import Bluetooth
import GATT

public class LedServiceController: GATTServiceController {

    public typealias LedService = LedProfile.LedService
    public typealias Command = LedProfile.LedService.Command

    public var peripheral: PeripheralProtocol
    internal let serviceHandle: UInt16
    internal let commandHandle: UInt16
    public static var service: GATTProfileService.Type { return LedService.self }
    //private var led

    public required init(peripheral: PeripheralProtocol) throws {

    	self.peripheral = peripheral

    	let notifyDescriptors = [GATTClientCharacteristicConfiguration().descriptor]

    	let characteristics = [
    		GATT.Characteristic(uuid: Command.uuid,
    							 value: Data(),
    							 permissions: [.write],
    							 properties: [.write],
    							 descriptors: notifyDescriptors)
    	]

    	let service = GATT.Service(uuid: LedService.uuid,
    							   primary: true,
    							   characteristics: characteristics)

    	self.serviceHandle = try peripheral.add(service: service)
    	self.commandHandle = peripheral.characteristics(for: Command.uuid)[0]

    	//led config
    }

    deinit {
    	self.peripheral.remove(service: serviceHandle)
    }

    public func willRead(_ request: GATTReadRequest) -> ATT.Error? {
        
        return nil
    }
    
    public func willWrite(_ request: GATTWriteRequest) -> ATT.Error? {
        
        return nil
    }
    
    public func didWrite(_ write: GATTWriteConfirmation) {
        
        switch write.uuid {
        case Command.uuid:
            handleCommand(write)
            
        default:
            break
        }
    }
    
    private func handleCommand(_ write: GATTWriteConfirmation) {
        
        guard let command = Command(data: write.value) else {
            print("Invalid data received"); return
        }
        
        switch command {
        case .on:
            print("on")
            
        case .off:
            print("off")
        }
    }
}