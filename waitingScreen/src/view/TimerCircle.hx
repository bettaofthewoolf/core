package view;
import js.html.Element;

class TimerCircle extends Drawable
{
	var bindElement:Element;
	public var value:Float = 1.0;
	public var x:Float = 0;
	public var y:Float = 0;
	public var size:Float = 75;
	public var ccw:Bool = false;
	
	private var startAngle:Float = Math.PI * 1.5;
	
	public function new(bindElement:Element) 
	{
		super();
		
		this.bindElement = bindElement;
	}
	
	override public function draw(context:Dynamic):Void 
	{
		super.draw(context);
		
		x = bindElement.offsetLeft + (bindElement.offsetWidth / 2);
		y = bindElement.offsetTop + (bindElement.clientHeight - size) / 2;
		
		var fullCircle = 2 * Math.PI;
		
		context.beginPath(); 
		context.arc(x, y, size, 0, fullCircle, ccw);
		context.fillStyle = "rgba(255, 255, 255, 0.3)";
		context.fill();
		
		context.beginPath();
		context.arc(x, y, size, startAngle, startAngle + fullCircle * value, ccw);
		
		context.strokeStyle = "white";
		context.lineWidth=2;
		context.stroke();
	}
}