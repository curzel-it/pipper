import Combine
import Foundation

enum RuntimeEvent {
    case loading
    case launching
    case closing
}

class RuntimeEvents {
    private let subject = CurrentValueSubject<RuntimeEvent, Never>(.loading)
    
    func send(_ event: RuntimeEvent) {
        subject.send(event)
    }
    
    func events() -> AnyPublisher<RuntimeEvent, Never> {
        subject.eraseToAnyPublisher()
    }
}
