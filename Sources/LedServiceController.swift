import Foundation
import Bluetooth
import GATT
import SwiftyGPIO

public class LedServiceController: GATTServiceController {

    public typealias LedService = LedProfile.LedService
    public typealias Command = LedProfile.LedService.Command

    public var peripheral: PeripheralProtocol
    internal let serviceHandle: UInt16
    internal let commandHandle: UInt16
    public static var service: GATTProfileService.Type { return LedService.self }
    private var led: Led?

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

    	let GPIOs = SwiftyGPIO.GPIOs(for: .RaspberryPi3)
        guard let ledGPIO = GPIOs[.P18] 
            else { fatalError("It has not been possible to initialized the LED GPIO pin")}

        /*guard let pwms = SwiftyGPIO.hardwarePWMs(for: .RaspberryPi3),
              let pwm = (pwms[0]?[.P18])
            else { fatalError("It has not been possible to initialized the PWM")}*/
        self.led = Led(ledGPIO: ledGPIO)

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
            self.led?.setOn()
            
        case .off:
            print("off")
            self.led?.setOff()
        }
    }
}