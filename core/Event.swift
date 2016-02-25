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


import Foundation

public class Event: pEvent {
  static let NONE: ushort = 0
  static let CAPTURING_PHASE: ushort = 1
  static let AT_TARGET: ushort = 1
  static let BUBBLING_PHASE: ushort = 1

  static let STOP_PROPAGATION_FLAG: ushort            = 1
  static let STOP_IMMEDIATE_PROPAGATION_FLAGS: ushort = 2
  static let CANCELED_FLAG: ushort                    = 4
  static let INITIALIZED_FLAG: ushort                 = 8
  static let DISPATCH_FLAG: ushort                    = 16
  static let IN_PASSIVE_LISTENER_FLAG: ushort         = 32

  internal var mFlags: ushort = 0
  internal var flags: ushort {
    get { return mFlags }
    set { mFlags = newValue }
  }
  internal func hasFlag(flag: ushort) -> Bool {
    return 0 != (flags & flag)
  }
  internal func setFlag(flag: ushort) -> Void {
    flags = flags | flag
  }
  internal func unsetFlag(flag: ushort) -> Void {
    if hasFlag(flag) {
      flags = flags - flag
    }
  }
  internal func clearFlags() -> Void {
    flags = 0
  }

  internal var mType: DOMString
  internal var mTarget: pElement?
  internal var mCurrentTarget: pElement?
  internal var mEventPhase: ushort
  internal var mBubbles: Bool
  internal var mCancelable: Bool
  internal var mIsTrusted: Bool
  internal var mTimeStamp: DOMTimeStamp

  public var type: DOMString { return mType }
  public var target: pElement? { return mTarget }
  public var currentTarget: pElement? { return mCurrentTarget }
  public var eventPhase: ushort { return mEventPhase }

  public func stopPropagation() -> Void {
    flags = flags | Event.STOP_PROPAGATION_FLAG
  }

  public func stopImmediatePropagation() -> Void {
    flags = flags | Event.STOP_PROPAGATION_FLAG | Event.STOP_IMMEDIATE_PROPAGATION_FLAGS
  }

  public var bubbles: Bool { return mBubbles }
  public var cancelable: Bool { return mCancelable }

  public func preventDefault() -> Void {
    if cancelable && !hasFlag(Event.IN_PASSIVE_LISTENER_FLAG) {
      flags = flags | Event.CANCELED_FLAG
    }
  }

  public var defaultPrevented: Bool {
    return hasFlag(Event.CANCELED_FLAG)
  }

  public var isTrusted: Bool { return mIsTrusted }
  public var timeStamp: DOMTimeStamp { return mTimeStamp }

  public func initEvent(aType: DOMString, _ aBubbles: Bool, _ aCancelable: Bool) -> Void {
    if !hasFlag(Event.DISPATCH_FLAG) {
      mType  = aType
      mBubbles = aBubbles
      mCancelable = aCancelable
    }
  }

  public required init(_ aType: DOMString, _ aEventInitDict: Dictionary<String, Any>) {
    mType = aType
    mFlags = 0
    mTarget = nil
    mCurrentTarget = nil
    mEventPhase = Event.NONE
    mIsTrusted = false
    mBubbles = false
    mCancelable = false
    mTimeStamp = (UInt64(NSDate().timeIntervalSince1970) * 1000)
    
    if let _bubbles = aEventInitDict["bubbles"] {
      mBubbles = _bubbles as! Bool
    }
    if let _cancelable = aEventInitDict["cancelable"] {
      mCancelable = _cancelable as! Bool
    }
    setFlag(Event.INITIALIZED_FLAG)
  }

  // XXX
  convenience init() {
    self.init("", [:])
  }
}