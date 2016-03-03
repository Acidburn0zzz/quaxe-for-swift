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

public class DOMRange: pDOMRange {
  public var startContainer: pNode? // XXXX
  public var startOffset: ulong = 0
  public var endContainer: pNode?
  public var endOffset: ulong = 0
  public var collapsed: Bool = false
  public var commonAncestorContainer: pNode?

  public func setStart(node: pNode, _ offset: ulong)  {}
  public func setEnd(node: pNode, _ offset: ulong)  {}
  public func setStartBefore(node: pNode) -> Void {}
  public func setStartAfter(node: pNode) -> Void {}
  public func setEndBefore(node: pNode) -> Void {}
  public func setEndAfter(node: pNode) -> Void {}
  public func collapse(toStart: Bool) -> Void {}
  public func selectNode(nod: pNode) -> Void {}
  public func selectNodeContents(node: pNode) -> Void {}

  public func compareBoundaryPoints(how: ushort, _ sourceRange: pDOMRange) -> short {return 0}

  public func deleteContents() -> Void {}
  public func extractContents() -> pDocumentFragment { return DocumentFragment()}
  public func cloneContents() -> pDocumentFragment { return DocumentFragment()}
  public func insertNode(node: pNode) -> Void {}
  public func surroundContents(node: pNode) -> Void {}

  public func cloneRange() -> pDOMRange {return DOMRange()}
  public func detach() -> Void {}

  public func isPointInRange(node: pNode, offset: ulong) -> Bool {return false}
  public func comparePoint(node: pNode, offset: ulong) -> short {return 0}

  public func intersectsNode(node: pNode) -> Bool {return false}

  public func toString() -> DOMString {return ""}

  init() {}
}