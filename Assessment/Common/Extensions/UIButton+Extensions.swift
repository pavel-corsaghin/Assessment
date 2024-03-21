//
//  UIButton+Extensions.swift
//  Assessment
//
//  Created by HungNguyen on 2024/03/21.
//

import UIKit
import Combine

// Refernce: https://www.swiftbysundell.com/articles/building-custom-combine-publishers-in-swift/
extension UIControl {
  class EventSubscription<Target: Subscriber>: Subscription
  where Target.Input == Void {
    var target: Target?

    @objc func trigger() {
      _ = target?.receive(())
    }

    func request(_ demand: Subscribers.Demand) {}

    func cancel() {
      target = nil
    }
  }
}

extension UIControl {
  func publisher(for event: Event) -> EventPublisher {
    EventPublisher(
      control: self,
      event: event
    )
  }
}

extension UIButton {
  var tapPublisher: EventPublisher {
    publisher(for: .touchUpInside)
  }
  var touchDownPublisher: EventPublisher {
    publisher(for: .touchDown)
  }
}

extension UIControl {
  struct EventPublisher: Publisher {
    let control: UIControl
    let event: UIControl.Event

    func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Void == S.Input {
      let subscription = EventSubscription<S>()
      subscription.target = subscriber
      subscriber.receive(subscription: subscription)
      control.addTarget(subscription, action: #selector(subscription.trigger), for: event)
    }
  }
}

extension UIControl.EventPublisher {
  typealias Output = Void
  typealias Failure = Never
}
