import Glibc
import SwiftyGPIO

extension GPIO {

	enum DigitalState: Int {
		case high 	= 1
		case low 	= 0
	}

	var digitalState: DigitalState? {
		set {
			if let newValue = newValue {

				self.value = newValue.rawValue
			} else {

				self.value = 0
			}
		}

		get {
			return DigitalState(rawValue: self.value)
		}
	}
}