//: A UIKit based Playground for presenting user interface

/*

 Copyright (c) 2018 Andrew L. Jaffee, microIT Infrastructure, LLC, and iosbrain.com.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
*/
  
import UIKit
import PlaygroundSupport

//
// NOTE: I LEFT UNCOMMENTED THE LAST EXAMPLE IN MY ARTICLE.
// EVERYTHING UNCOMMENTED RUNS FROM THE GET-GO.
//
// SCROLL DOWN TO THE BOTTOM OF THIS PLAYGROUND TO FIND
// ALL CODE FROM THE ARTICLE. SOME CODE IS COMMENTED OUT SO
// THERE ARE NO NAMING COLLISIONS AND MY UNCOMMENTED CODE RUNS.
//

protocol DefaultInitializable {
    
    init()
    
}

//
// This just ain't possible:
//
//protocol DeInitializable {
//    deinit
//}

protocol Allocatable: class {
    
    // Give a name to your instance.
    var tag: String { get }
    // Call in initializers.
    func onAllocate()
    // Call in deinitializers.
    func onDeallocate()
    
}

extension Allocatable {
    
    func onAllocate() {
        print("Instance \(tag) of type \(typeIs()) allocated.")
    }
    
    func typeIs() -> String {
        return String(describing: type(of: self))
    }
    
    func onDeallocate() {
        print("Instance \(tag) of type \(typeIs()) deallocated.")
    }
    
} // end extension Allocatable

class Line: Allocatable, DefaultInitializable, Equatable {
    
    var beginPoint: CGPoint
    var endPoint: CGPoint
    let tag: String
    
    // "Initializer requirement 'init()' can only be satisfied
    // by a `required` initializer in non-final class 'Line'"
    // resolved with "required" prefix
    required init() {
        // Defines a straight vertical line in the upper, center
        // of an iPhone 8
        beginPoint = CGPoint( x: 187.5, y: 40.0 )
        endPoint = CGPoint( x: 187.5, y: 300.0 )
        tag = "Untagged"
        
        onAllocate()
    }
    
    init( beginPoint:CGPoint, endPoint:CGPoint, tag: String ) {
        
        self.beginPoint = CGPoint( x: beginPoint.x, y: beginPoint.y )
        self.endPoint = CGPoint( x: endPoint.x, y: endPoint.y )
        self.tag = tag
        
        onAllocate()
    }
    
    // The line length formula is based on the Pythagorean theorem.
    func length () -> CGFloat
    {
        let length = sqrt( pow(endPoint.x - beginPoint.x, 2) + pow(endPoint.y - beginPoint.y, 2) )
        return length
    }
    
    static func == ( lhs: Line, rhs: Line ) -> Bool {
        return (lhs.length() == rhs.length())
    }

    deinit {
        onDeallocate()
    }
    
} // end class Line

class DrawableLine: Line {
    
    var color: UIColor
    var width: CGFloat
    
    // "'required' modifier must be present on all overrides of a
    // required initializer" resolved with "required" prefix
    //
    // "Overriding declaration requires an 'override' keyword"
    // resolved when I marked parent init() as "required"
    required init() {
        color = UIColor.black
        width = 1.0
        
        super.init()
    }
    
    required init( beginPoint:CGPoint,
                   endPoint:CGPoint,
                   color: UIColor,
                   width: CGFloat,
                   tag: String ) {
        
        self.color = color
        self.width = width
        
        super.init( beginPoint: beginPoint, endPoint: endPoint, tag: tag )
    }
    
} // end class DrawableLine

// do {
let line = Line()
let drawableLine1 = DrawableLine(beginPoint: CGPoint(x: 40.0, y: 40.0), endPoint: CGPoint(x: 40.0, y: 300.0), color: UIColor.red, width: 8.0, tag: "Line 1")
let drawableLine2 = DrawableLine(beginPoint: CGPoint(x: 40.0, y: 300.0), endPoint: CGPoint(x: 300.0, y: 300.0), color: UIColor.red, width: 8.0, tag: "Line 2")
let drawableLine3 = DrawableLine()
//}

drawableLine1 == drawableLine3
drawableLine1 != drawableLine3
drawableLine1 == drawableLine2

class LineDrawingView: UIView
{
    override func draw(_ rect: CGRect)
    {
        let currGraphicsContext = UIGraphicsGetCurrentContext()
        
        currGraphicsContext?.setLineWidth(drawableLine1.width)
        currGraphicsContext?.setStrokeColor(drawableLine1.color.cgColor)
        // "Begins a new subpath [e.g., line] at the specified point."
        currGraphicsContext?.move(to: drawableLine1.beginPoint)
        // "Appends a straight line segment from the current point to the specified point."
        currGraphicsContext?.addLine(to: drawableLine1.endPoint)
        // "Paints a line along the current path."
        currGraphicsContext?.strokePath()
        
        currGraphicsContext?.setLineWidth(drawableLine2.width)
        currGraphicsContext?.setStrokeColor(drawableLine2.color.cgColor)
        // "Begins a new subpath [e.g., line] at the specified point."
        currGraphicsContext?.move(to: drawableLine2.beginPoint)
        // "Appends a straight line segment from the current point to the specified point."
        currGraphicsContext?.addLine(to: drawableLine2.endPoint)
        // "Paints a line along the current path."
        currGraphicsContext?.strokePath()

        currGraphicsContext?.setLineWidth(drawableLine3.width)
        currGraphicsContext?.setStrokeColor(drawableLine3.color.cgColor)
        // "Begins a new subpath [e.g., line] at the specified point."
        currGraphicsContext?.move(to: drawableLine3.beginPoint)
        // "Appends a straight line segment from the current point to the specified point."
        currGraphicsContext?.addLine(to: drawableLine3.endPoint)
        // "Paints a line along the current path."
        currGraphicsContext?.strokePath()

        UIGraphicsEndImageContext()
    }
}

class MyViewController : UIViewController {
    override func loadView() {
        let view = LineDrawingView()
        view.backgroundColor = .white
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

///////////////////////////////////////////////////////////////////////////////

/*
class Coordinate
{
    var x: Float
    var y: Float
    
    init( x: Float, y: Float ) {
        self.x = x
        self.y = y
    }
}

var coordinate = Coordinate(x: 2.0, y: 4.0)
print("coordinate:  (\(coordinate.x), \(coordinate.y))")
// coordinate:  (2.0, 4.0)

// Unintended mutation?
var coordinate1 = coordinate
coordinate1.y = 0.0

print("coordinate:  (\(coordinate.x), \(coordinate.y))")
// coordinate:  (2.0, 0.0)

print("coordinate1: (\(coordinate1.x), \(coordinate1.y))")
// coordinate1: (2.0, 0.0)

coordinate === coordinate1
// true
*/

/*
protocol Copyable: class {
    
    func copy() -> Self
    
}

class Line : Copyable {
    
    var beginPoint: CGPoint
    var endPoint: CGPoint
    
    init( beginPoint: CGPoint, endPoint: CGPoint ) {
        
        self.beginPoint = CGPoint( x: beginPoint.x, y: beginPoint.y )
        self.endPoint = CGPoint( x: endPoint.x, y: endPoint.y )
        
    }
    
    func copy() -> Self {
        
        return type(of: self).init( beginPoint: self.beginPoint,
                                    endPoint: self.endPoint )
        
    }
    
} // end class Line
*/

/*
protocol Copyable: class {
    
    func copy() -> Self
    
}

class Line : Copyable {
    
    var beginPoint: CGPoint
    var endPoint: CGPoint
    
    required init( beginPoint: CGPoint, endPoint: CGPoint ) {
        
        self.beginPoint = CGPoint( x: beginPoint.x, y: beginPoint.y )
        self.endPoint = CGPoint( x: endPoint.x, y: endPoint.y )
        
    }
    
    func copy() -> Self {
        
        return type(of: self).init( beginPoint: self.beginPoint,
                                    endPoint: self.endPoint )
        
    }
    
} // end class Line

let line1 = Line(beginPoint: CGPoint(x: 20, y: 20), endPoint: CGPoint(x: 20, y: 200))
let lineCopy = line1.copy()
let line2 = line1
line2.beginPoint.x = 80
// line2.beginPoint = {x 80 y 20}
line1.beginPoint
// line1.beginPoint = {x 80 y 20}
lineCopy.beginPoint
// lineCopy.beginPoint = {x 20 y 20}
 
line1 === line2
// true
lineCopy === line1
// false
*/

/*
class DrawableLine: Line
{
    
    var color: UIColor
    var width: CGFloat
    
    init( beginPoint: CGPoint, endPoint: CGPoint, color: UIColor, width: CGFloat )
    {
        self.color = color
        self.width = width
        super.init(beginPoint: beginPoint, endPoint: endPoint)
    }
    
    func copy() -> Self
    {
        return type(of: self).init( beginPoint: beginPoint,
                                    endPoint: endPoint,
                                    color: color,
                                    width: width )
    }
    
} // end class DrawableLine
*/

/*
class DrawableLine: Line
{
    
    var color: UIColor
    var width: CGFloat
    
    // We must implement this init tangentially because of Copyable.
    // The "'required' initializer 'init(beginPoint:endPoint:)' must
    // be provided by subclass of 'Line'" error is then resolved.
    // Think of this as a convenience constructor -- shorthand
    // for rapid prototyping.
    required init( beginPoint: CGPoint, endPoint: CGPoint ) {
        self.color = UIColor.black
        self.width = 1.0
        super.init( beginPoint: beginPoint, endPoint: endPoint )
    }
    
    // Prefxing this init with the "required" keyword resolves the
    // "Constructing an object of class type 'Self' with
    // a metatype value must use a 'required' initializer" error.
    required init( beginPoint: CGPoint, endPoint: CGPoint, color: UIColor, width: CGFloat )
    {
        self.color = color
        self.width = width
        super.init( beginPoint: beginPoint, endPoint: endPoint )
    }
    
    // Prefixing the method with the "override" keyword resolves the
    // "Overriding declaration requires an 'override' keyword" error.
    // We must provide a copy of DrawableLine, not Line.
    override func copy() -> Self
    {
        return type(of: self).init( beginPoint: beginPoint,
                                    endPoint: endPoint,
                                    color: color,
                                    width: width )
    }
    
} // end class DrawableLine
*/

/*
let thinBlackLine = DrawableLine(beginPoint: CGPoint(x: 187.5, y: 40.0), endPoint: CGPoint(x: 187.5, y: 300.0))
let thinLineCopy = thinBlackLine.copy()
thinLineCopy.color = UIColor.red
thinBlackLine.color
// UIColor.black
thinBlackLine === thinLineCopy
// false
*/

/*
class LineDrawingView: UIView
{
    override func draw(_ rect: CGRect)
    {
        let currGraphicsContext = UIGraphicsGetCurrentContext()
        currGraphicsContext?.setLineWidth(thinBlackLine.width)
        currGraphicsContext?.setStrokeColor(thinBlackLine.color.cgColor)
        // "Begins a new subpath [e.g., line] at the specified point."
        currGraphicsContext?.move(to: thinBlackLine.beginPoint)
        // "Appends a straight line segment from the current point to the specified point."
        currGraphicsContext?.addLine(to: thinBlackLine.endPoint)
        // "Paints a line along the current path."
        currGraphicsContext?.strokePath()
        UIGraphicsEndImageContext()
    }
}

class MyViewController : UIViewController {
    override func loadView() {
        let view = LineDrawingView()
        view.backgroundColor = .white
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
*/

/*
class Line {
    
    var beginPoint: CGPoint?
    var endPoint: CGPoint?
    
}

let line = Line() // Line
line.beginPoint // nil
line.endPoint // nil
*/

/*
protocol Allocatable: class {
    
    // Give a name to your instance.
    var tag: String { get }
    // Call in initializers.
    func onAllocate()
    // Call in deinitializers.
    func onDeallocate()
    
}

extension Allocatable {
    
    func onAllocate() {
        print("Instance \(tag) of type \(typeIs()) allocated.")
    }
    
    func typeIs() -> String {
        return String(describing: type(of: self))
    }
    
    func onDeallocate() {
        print("Instance \(tag) of type \(typeIs()) deallocated.")
    }
    
} // end extension Allocatable
*/

/*
protocol Allocatable: class {
    
    // Give a name to your instance.
    var tag: String { get }
    // Call this in initializers.
    func onAllocate()
    // Call this in deinitializers.
    func onDeallocate()
    
}

extension Allocatable {
    
    func onAllocate() {
        print("Instance \(tag) of type \(typeIs()) allocated.")
    }
    
    func typeIs() -> String {
        return String(describing: type(of: self))
    }
    
    func onDeallocate() {
        print("Instance \(tag) of type \(typeIs()) deallocated.")
    }
    
} // end extension Allocatable

class Line: Allocatable, DefaultInitializable {
    
    var beginPoint: CGPoint
    var endPoint: CGPoint
    let tag: String
    
    // "Initializer requirement 'init()' can only be satisfied
    // by a 'required' initializer in non-final class 'Line'"
    // resolved with "required" prefix
    required init() {
        // Defines a straight vertical line in the upper, center
        // of an iPhone 8
        beginPoint = CGPoint( x: 187.5, y: 40.0 )
        endPoint = CGPoint( x: 187.5, y: 300.0 )
        tag = "Untagged"
        
        onAllocate()
    }
    
    init( beginPoint:CGPoint, endPoint:CGPoint, tag: String ) {
        
        self.beginPoint = CGPoint( x: beginPoint.x, y: beginPoint.y )
        self.endPoint = CGPoint( x: endPoint.x, y: endPoint.y )
        self.tag = tag
        
        onAllocate()
    }
    
    deinit {
        onDeallocate()
    }
    
} // end class Line

class DrawableLine: Line {
    
    var color: UIColor
    var width: CGFloat
    
    // "'required' modifier must be present on all overrides of a
    // required initializer" resolved with "required" prefix
    //
    // "Overriding declaration requires an 'override' keyword"
    // resolved when I marked parent init() as "required"
    required init() {
        color = UIColor.black
        width = 1.0
        
        super.init()
    }
    
    required init( beginPoint:CGPoint,
                   endPoint:CGPoint,
                   color: UIColor,
                   width: CGFloat,
                   tag: String ) {
        
        self.color = color
        self.width = width
        
        super.init( beginPoint: beginPoint, endPoint: endPoint, tag: tag )
    }
    
} // end class DrawableLine

let line = Line()
let drawableLine1 = DrawableLine(beginPoint: CGPoint(x: 40.0, y: 40.0), endPoint: CGPoint(x: 40.0, y: 300.0), color: UIColor.red, width: 8.0, tag: "Line 1")
let drawableLine2 = DrawableLine(beginPoint: CGPoint(x: 40.0, y: 300.0), endPoint: CGPoint(x: 300.0, y: 300.0), color: UIColor.red, width: 8.0, tag: "Line 2")
let drawableLine3 = DrawableLine()

class LineDrawingView: UIView
{
    override func draw(_ rect: CGRect)
    {
        let currGraphicsContext = UIGraphicsGetCurrentContext()
        
        currGraphicsContext?.setLineWidth(drawableLine1.width)
        currGraphicsContext?.setStrokeColor(drawableLine1.color.cgColor)
        // "Begins a new subpath [e.g., line] at the specified point."
        currGraphicsContext?.move(to: drawableLine1.beginPoint)
        // "Appends a straight line segment from the current point to the specified point."
        currGraphicsContext?.addLine(to: drawableLine1.endPoint)
        // "Paints a line along the current path."
        currGraphicsContext?.strokePath()
        
        currGraphicsContext?.setLineWidth(drawableLine2.width)
        currGraphicsContext?.setStrokeColor(drawableLine2.color.cgColor)
        // "Begins a new subpath [e.g., line] at the specified point."
        currGraphicsContext?.move(to: drawableLine2.beginPoint)
        // "Appends a straight line segment from the current point to the specified point."
        currGraphicsContext?.addLine(to: drawableLine2.endPoint)
        // "Paints a line along the current path."
        currGraphicsContext?.strokePath()
        
        currGraphicsContext?.setLineWidth(drawableLine3.width)
        currGraphicsContext?.setStrokeColor(drawableLine3.color.cgColor)
        // "Begins a new subpath [e.g., line] at the specified point."
        currGraphicsContext?.move(to: drawableLine3.beginPoint)
        // "Appends a straight line segment from the current point to the specified point."
        currGraphicsContext?.addLine(to: drawableLine3.endPoint)
        // "Paints a line along the current path."
        currGraphicsContext?.strokePath()
        
        UIGraphicsEndImageContext()
    }
}

class MyViewController : UIViewController {
    override func loadView() {
        let view = LineDrawingView()
        view.backgroundColor = .white
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
*/

/*
do {
    let line = Line()
    let drawableLine1 = DrawableLine(beginPoint: CGPoint(x: 40.0, y: 40.0), endPoint: CGPoint(x: 40.0, y: 300.0), color: UIColor.red, width: 8.0, tag: "Line 1")
    let drawableLine2 = DrawableLine(beginPoint: CGPoint(x: 40.0, y: 300.0), endPoint: CGPoint(x: 300.0, y: 300.0), color: UIColor.red, width: 8.0, tag: "Line 2")
    let drawableLine3 = DrawableLine()
}
*/

/*
class Line: Allocatable, DefaultInitializable, Equatable {
    
    var beginPoint: CGPoint
    var endPoint: CGPoint
    let tag: String
    
    // "Initializer requirement 'init()' can only be satisfied
    // by a 'required' initializer in non-final class 'Line'"
    // resolved with "required" prefix
    required init() {
        // Defines a straight vertical line in the upper, center
        // of an iPhone 8
        beginPoint = CGPoint( x: 187.5, y: 40.0 )
        endPoint = CGPoint( x: 187.5, y: 300.0 )
        tag = "Untagged"
        
        onAllocate()
    }
    
    init( beginPoint:CGPoint, endPoint:CGPoint, tag: String ) {
        
        self.beginPoint = CGPoint( x: beginPoint.x, y: beginPoint.y )
        self.endPoint = CGPoint( x: endPoint.x, y: endPoint.y )
        self.tag = tag
        
        onAllocate()
    }
    
    // The line length formula is based on the Pythagorean theorem.
    func length () -> CGFloat
    {
        let length = sqrt( pow(endPoint.x - beginPoint.x, 2) + pow(endPoint.y - beginPoint.y, 2) )
        return length
    }
    
    static func == ( lhs: Line, rhs: Line ) -> Bool {
        return (lhs.length() == rhs.length())
    }
    
    deinit {
        onDeallocate()
    }
    
} // end class Line
*/

/*
drawableLine1 == drawableLine3 // true
drawableLine1 != drawableLine3 // false
drawableLine1 == drawableLine2 // true
*/
