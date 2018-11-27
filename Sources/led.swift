import Glibc
import Foundation
import SwiftyGPIO

//Mark - Led
public struct Led {

	let ledGPIO: GPIO
	let sleepDuration: TimeInterval

	init(ledGPIO: GPIO, sleepDuration: TimeInterval = 1.0) {
		ledGPIO.direction = .OUT
		self.ledGPIO = ledGPIO
		self.sleepDuration = sleepDuration
	}


	//Mark- private
	private func ledSleep(duration: TimeInterval) {
		let durationSeconds = UInt32(round(duration))
		sleep(durationSeconds)
	}

	private func setLedGPIO(state: GPIO.DigitalState, duration: TimeInterval?){

		ledGPIO.digitalState = state
		guard let duration = duration 
			else { return }
		ledSleep(duration: duration)
	}

	private func flipLed(withDuration duration:TimeInterval = 0.5) {
		ledGPIO.digitalState = ledGPIO.digitalState == .high ? .low : .high
		ledSleep(duration: duration)
	}


	// Mark - actions
	func blink(){
		while true {
			setLedGPIO(state: .high, duration: sleepDuration)
			flipLed(withDuration: sleepDuration)
		}
	}

	func setOn(){
		setLedGPIO(state: .high, duration: nil)
	}

	func setOff(){
		setLedGPIO(state: .low, duration: nil)
	}
}

// Mark - LedPWM
public struct LedPWM {

	let pwm: PWMOutput 
	let period: Int
	var duty: Float

	init(pwm: PWMOutput, period: Int = 100, duty: Float = 0) {
		self.pwm = pwm
		self.period = period
		self.duty = duty
		self.pwm.initPWM()
	}

	// Mark - actions
	func breath(){
		while true {
			for iduty in 0...99 {
				pwm.startPWM(period: period, duty:Float(iduty))
				usleep(5000)
			}
		sleep(UInt32(1))
			for iduty in stride(from: 100, to: 0, by: -1) {
				pwm.startPWM(period: period, duty:Float(iduty))
				usleep(5000)
			}
		}
	}
}