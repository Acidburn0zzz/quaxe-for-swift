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

public protocol pAttr: pNode {
  var namespaceURI: DOMString? { get }
  var prefix: DOMString? { get }
  var localName: DOMString { get }
  var name: DOMString { get }
  var value: DOMString { get set }

  var ownerElement: pElement? { get }

  var specified: Bool { get }
}
