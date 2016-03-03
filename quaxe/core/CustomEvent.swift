/**
 * Quaxe for Swift
 * 
 * Copyright 2016 Disruptive Innovations
 * 
 * Original author:
 *   Daniel Glazman <daniel.glazman@disruptive-innovations.com>
 *
 * Contributors:
 * 
 */

import QuaxeCoreProtocols

/*
 * https://dom.spec.whatwg.org/#interface-customevent
 */
public class CustomEvent: Event, pCustomEvent {

  internal var mDetail: Any

  /*
   * https://dom.spec.whatwg.org/#dom-customevent-detail
   */
  public var detail: Any { return mDetail }

  /*
   * https://dom.spec.whatwg.org/#dom-customevent-initcustomevent
   */
  public func initCustomEvent(aType: DOMString, _ aBubbles: Bool, _ aCancelable: Bool, _ aDetail: Any) -> Void {
    if !hasFlag(Event.DISPATCH_FLAG) {
      super.initEvent(aType, aBubbles, aCancelable)
      mDetail = aDetail
    }
  }

  public required init(_ aType: DOMString, _ aEventInitDict: Dictionary<String, Any>,
                       _ aIsTrusted: Bool = false) {
    if let detail = aEventInitDict["detail"] {
      self.mDetail = detail
    }
    else {
      self.mDetail = 0
    }
    super.init(aType, aEventInitDict, false)
  }
}