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



/*
 * https://dom.spec.whatwg.org/#NonDocumentTypeChildNode
 */
public class NonDocumentTypeChildNode {

  func previousElementSibling(n: Node) -> pElement? {return nil}
  func nextElementSibling(n: Node) -> pElement? {return nil}

  init() {}
}

/*
 * extending Element, CharacterData
 */

extension CharacterData: pNonDocumentTypeChildNode {
  public var previousElementSibling: pElement? {
    if nil == mTearoffs.indexForKey("NonDocumentTypeChildNode") { mTearoffs["NonDocumentTypeChildNode"] = NonDocumentTypeChildNode() }
    return (mTearoffs["NonDocumentTypeChildNode"] as! NonDocumentTypeChildNode).previousElementSibling(self)
  }
  public var nextElementSibling:     pElement? {
    if nil == mTearoffs.indexForKey("NonDocumentTypeChildNode") { mTearoffs["NonDocumentTypeChildNode"] = NonDocumentTypeChildNode() }
    return (mTearoffs["NonDocumentTypeChildNode"] as! NonDocumentTypeChildNode).nextElementSibling(self)
  }
}

extension Element: pNonDocumentTypeChildNode {
  public var previousElementSibling: pElement? {
    if nil == mTearoffs.indexForKey("NonDocumentTypeChildNode") { mTearoffs["NonDocumentTypeChildNode"] = NonDocumentTypeChildNode() }
    return (mTearoffs["NonDocumentTypeChildNode"] as! NonDocumentTypeChildNode).previousElementSibling(self)
  }
  public var nextElementSibling:     pElement? {
    if nil == mTearoffs.indexForKey("NonDocumentTypeChildNode") { mTearoffs["NonDocumentTypeChildNode"] = NonDocumentTypeChildNode() }
    return (mTearoffs["NonDocumentTypeChildNode"] as! NonDocumentTypeChildNode).nextElementSibling(self)
  }
}