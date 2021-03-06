/**
 * Quaxe for Swift
 * 
 * Copyright 2016-2017 Disruptive Innovations
 * 
 * Original author:
 *   Daniel Glazman <daniel.glazman@disruptive-innovations.com>
 *
 * Contributors:
 * 
 */

public protocol pCSSValue {
  var cssText: DOMString { get }

  var type: ushort { get }
  var commaSeparated: Bool { get set }
  var length: ulong { get }

  func item(_ index: ulong) throws -> pCSSValue?
  func setFloatValue(_ floatValue: Double) throws -> Void
  func getFloatValue() throws -> Double
  func setStringValue(_ stringValue: DOMString) throws -> Void
  func getStringValue() throws -> DOMString
}
