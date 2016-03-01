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

public class Node: EventTarget, pNode {

  static let ELEMENT_NODE: ushort                 = 1;
  static let ATTRIBUTE_NODE: ushort               = 2; // historical
  static let TEXT_NODE: ushort                    = 3;
  static let CDATA_SECTION_NODE: ushort           = 4; // historical
  static let ENTITY_REFERENCE_NODE: ushort        = 5; // historical
  static let ENTITY_NODE: ushort                  = 6; // historical
  static let PROCESSING_INSTRUCTION_NODE: ushort  = 7;
  static let COMMENT_NODE: ushort                 = 8;
  static let DOCUMENT_NODE: ushort                = 9;
  static let DOCUMENT_TYPE_NODE: ushort           = 10;
  static let DOCUMENT_FRAGMENT_NODE: ushort       = 11;
  static let NOTATION_NODE: ushort                = 12; // historical

  internal var mNodeType: ushort = 1
  internal var mOwnerDocument: pDocument?
  internal var mParentNode: pNode?
  internal var mFirstChild: pNode?
  internal var mLastChild: pNode?
  internal var mPreviousSibling: pNode?
  internal var mNextSibling: pNode?

  internal func _getTextContent(var node: pNode?) -> DOMString {
    var rv = ""
    while nil != node {
      switch nodeType {
        case Node.DOCUMENT_FRAGMENT_NODE,
             Node.ELEMENT_NODE:
          rv += _getTextContent(self.firstChild)
        case Node.TEXT_NODE,
             Node.PROCESSING_INSTRUCTION_NODE,
             Node.COMMENT_NODE:
          rv += (self as! pCharacterData).data
        default: break;
      }
      node = node!.nextSibling
    }
    return rv
  }

  internal func isInclusiveAncestorOf(candidate: pNode) -> Bool {
    var node: pNode? = candidate
    while nil != node {
      if self === (node as! Node) {
        return true
      }
      node = node!.parentNode
    }
    return false
  }

  internal func getCounts(inout elementCount: UInt, inout _ textCount: UInt) -> Void {
    var child = firstChild
    elementCount = 0
    textCount = 0
    while nil != child {
      switch child!.nodeType {
        case Node.ELEMENT_NODE: elementCount++
        case Node.TEXT_NODE:    textCount++
        default: break;
      }
      child = child!.nextSibling
    }
  }

  internal func getChildCount() -> UInt {
    var child = firstChild
    var count: UInt = 0
    while nil != child {
      count++
      child = child!.nextSibling
    }
    return count
  }

  internal func hasFollowingDoctype() -> Bool {
    var child = self.nextSibling
    while nil != child {
      switch child!.nodeType {
        case Node.DOCUMENT_TYPE_NODE: return true
        default: break;
      }
      child = child!.nextSibling
    }
    return false
  }

  internal func hasPrecedingElement() -> Bool {
    var child = self.previousSibling
    while nil != child {
      switch child!.nodeType {
        case Node.ELEMENT_NODE: return true
        default: break;
      }
      child = child!.previousSibling
    }
    return false
  }

  internal func hasDoctypeChild() -> Bool {
    var child = self.firstChild
    while nil != child {
      switch child!.nodeType {
        case Node.DOCUMENT_TYPE_NODE: return true
        default: break;
      }
      child = child!.nextSibling
    }
    return false
  }

  internal var index: ulong {
    var rv: ulong = 0
    var child: pNode? = self
    while nil != child {
      rv++
      child = child!.previousSibling
    }
    return rv
  }

  override internal func getParent(event: Event) -> EventTarget? {
    return self.parentNode as? EventTarget
  }

  /* public from pNode */

  public var nodeType: ushort { return mNodeType }

  public var nodeName: DOMString {
    switch nodeType {
      case Node.ELEMENT_NODE:
        return (self as! pElement).tagName
      case Node.TEXT_NODE:
        return "#text"
      case Node.PROCESSING_INSTRUCTION_NODE:
        return (self as! pProcessingInstruction).target
      case Node.COMMENT_NODE:
        return "#comment"
      case Node.DOCUMENT_NODE:
        return "#document"
      case Node.DOCUMENT_TYPE_NODE:
        return (self as! pDocumentType).name
      case Node.DOCUMENT_FRAGMENT_NODE:
        return "#document-fragment"
      default: return "" // should never happen in DOM 4
    }
  }

  public var baseURI: DOMString { return "about:blank" }

  public var ownerDocument: pDocument? {
    if Node.DOCUMENT_NODE == nodeType {
      return nil
    }
    return mOwnerDocument
  }

  public var parentNode: pNode? { return mParentNode }

  public var parentElement: pElement? {
    if let pe = mParentNode as? pElement {
      return pe
    }
    return nil
  }

  public func hasChildNodes() -> Bool {
    return nil != self.firstChild
  }

  public var childNodes: pNodeList {
    let list = NodeList()
    var child = self.firstChild
    while nil != child {
      list.mNodeArray.append(child!)
      child = child!.nextSibling
    }
    return list
  }

  public var firstChild: pNode? { return mFirstChild }
  public var lastChild: pNode? { return mLastChild }
  public var previousSibling: pNode? { return mPreviousSibling }
  public var nextSibling: pNode? { return mNextSibling }

  public var nodeValue: DOMString? {
    get {
      switch nodeType {
        case Node.TEXT_NODE,
             Node.PROCESSING_INSTRUCTION_NODE,
             Node.COMMENT_NODE:
          return (self as! pCharacterData).data
        default: return nil
      }
    }
    set {
      let n: DOMString = (nil == newValue) ? "" : newValue!
      switch nodeType {
        case Node.TEXT_NODE,
             Node.PROCESSING_INSTRUCTION_NODE,
             Node.COMMENT_NODE:
          var characterData = (self as! pCharacterData)
          characterData.data = n
        default: break;
      }
    }
  }

  public var textContent: DOMString? {
    get {
      switch nodeType {
        case Node.DOCUMENT_FRAGMENT_NODE,
             Node.ELEMENT_NODE:
          return _getTextContent(self.firstChild)
        case Node.TEXT_NODE,
             Node.PROCESSING_INSTRUCTION_NODE,
             Node.COMMENT_NODE:
          return (self as! pCharacterData).data
        default: return nil
      }
    }
    set {
      let n: DOMString = (nil == newValue) ? "" : newValue!
      switch nodeType {
        case Node.DOCUMENT_FRAGMENT_NODE,
             Node.ELEMENT_NODE:
          var node: pNode? = nil
          if !n.isEmpty {
            node = Text(n)
          }
          // XXX we are force to ignore if replaceAll() throws because
          // Swift computed properties don't allow to throw yet...
          let _ = try? MutationAlgorithms.replaceAll(node as? Node, self)
        case Node.TEXT_NODE,
             Node.PROCESSING_INSTRUCTION_NODE,
             Node.COMMENT_NODE:
          let characterData = (self as! CharacterData)
          // XXX we are force to ignore if replaceAll() throws because
          // Swift computed properties don't allow to throw yet...
          let _ = try? CharacterData._replaceData(characterData, 0, characterData.length, n)
        default: break;
      }
      // TODO
    }
  }

  /*
   * https://dom.spec.whatwg.org/#dom-node-normalize
   */
  public func normalize() throws -> Void {
    var node = self.firstChild
    while node != nil {
      switch (node!.nodeType) {
        case Node.TEXT_NODE:
          // Step 2
          var length = (node as! Text).length
          if 0 == length {
            // Step 3
            MutationAlgorithms.remove(node as! Node, node!.parentNode as! Node)
          }
          else {
            // Step 4
            var data: DOMString = (node as! Text).data
            var child = node!.nextSibling
            while nil != child && child!.nodeType == Node.TEXT_NODE {
              data += (child as! Text).data
              child = child!.nextSibling
            }

            // Step 5
            try CharacterData._replaceData(node as! CharacterData, length, 0, data)

            // Step 6
            var currentNode = node!.nextSibling

            // Step 7
            let rangeCollection = ((node as! Node).ownerDocument as! Document).rangeCollection
            while nil != currentNode && currentNode!.nodeType == Node.TEXT_NODE {
              // Step 7.1
              rangeCollection.forEach( {
                if $0.startContainer as! Node === currentNode as! Node {
                  $0.setStart(node!, $0.startOffset + length);
                }
              })

              // Step 7.2
              rangeCollection.forEach( {
                if $0.endContainer as! Node === currentNode as! Node {
                  $0.setEnd(node!, $0.endOffset + length);
                }
              })

              // Step 7.3
              rangeCollection.forEach( {
                if $0.startContainer as! Node === currentNode!.parentNode as! Node &&
                   $0.startOffset == (currentNode as! Node).index {
                  $0.setStart(node!, length);
                }
              })

              // Step 7.4
              rangeCollection.forEach( {
                if $0.endContainer as! Node === currentNode!.parentNode as! Node &&
                   $0.endOffset == (currentNode as! Node).index {
                  $0.setStart(node!, length);
                }
              })

              // Step 7.5
              length += (currentNode as! Text).length

              // Step 7.6
              currentNode = currentNode!.nextSibling
            }

            // Step 8
            var textNode = node!.nextSibling
            while nil != textNode && textNode!.nodeType == Node.TEXT_NODE {
              let tmp = textNode!.nextSibling
              MutationAlgorithms.remove(textNode as! Node, textNode!.parentNode as! Node)
              textNode = tmp
            }
          }
        case Node.ELEMENT_NODE:
          try node!.normalize()
        default: break
      }
      node = node!.nextSibling as? Node
    }
  }

  public func cloneNode(deep: Bool) -> pNode { return Node()}
  public func isEqualNode(otherNode: pNode?) -> Bool {return false}

  static let DOCUMENT_POSITION_DISCONNECTED: ushort = 0x01
  static let DOCUMENT_POSITION_PRECEDING: ushort = 0x02
  static let DOCUMENT_POSITION_FOLLOWING: ushort = 0x04
  static let DOCUMENT_POSITION_CONTAINS: ushort = 0x08
  static let DOCUMENT_POSITION_CONTAINED_BY: ushort = 0x10
  static let DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC: ushort = 0x20
  public func compareDocumentPosition(other: pNode) -> ushort {return 0}
  public func contains(other: pNode?) -> Bool {return false}

  public func lookupPrefix(namespace: DOMString?) -> DOMString? {return nil}
  public func lookupNamespaceURI(prefix: DOMString?) -> DOMString? {return nil}
  public func isDefaultNamespace(namespace: DOMString?) -> Bool {return false}

  public func insertBefore(node: pNode, _ child: pNode?) -> pNode { return Node()}
  public func appendChild(node: pNode) -> pNode { return Node()}
  public func replaceChild(node: pNode, _ child: pNode) -> pNode { return Node()}
  public func removeChild(child: pNode) -> pNode { return Node()}


  override init() {
  }
}
