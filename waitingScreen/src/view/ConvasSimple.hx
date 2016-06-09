package view;

import events.ConvasEvents;
import events.Observer;
import js.Browser;
import js.html.CanvasElement;

class ConvasSimple extends Observer
{
	var convas:CanvasElement;
	var context:Dynamic;
	
	private var displayList:Array<Drawable> = new Array<Drawable>();
	var width:Int;
	var height:Int;

	public function new() 
	{
		super();
	}
	
	public function addChild(drawable:Drawable):Void
	{
		displayList.push(drawable);
	}
	
	public function init(id:String):Void
	{
		convas = untyped Browser.document.getElementById(id);
		
		resize(Browser.window.innerWidth, Browser.window.innerHeight);
		
		var canvasSupported:Bool = isCanvasSupported();

		if(!canvasSupported && untyped __typeof__(G_vmlCanvasManager) != "undefined") 
		{
			untyped __js__('G_vmlCanvasManager.initElement({0})', convas);
			//limited_mode = true;
			canvasSupported = true;
		}

		if(canvasSupported) 
		{
			context = convas.getContext('2d');
		}
		
		render();
	}
	
	public function resize(width:Int, height:Int):Void
	{
		this.height = height;
		this.width = width;
		
		convas.width = width;
		convas.height = height;
	}
	
	function isCanvasSupported():Bool
	{
		return convas.getContext != null && convas.getContext('2d') != null;
	}
	
	public function render():Void
	{
		clear();
		
		if (width != Browser.window.innerWidth || height != Browser.window.innerHeight)
			resize(Browser.window.innerWidth, Browser.window.innerHeight);
		
		untyped __js__ ("requestAnimationFrame") (render);
		
		dispatchEvent(new ConvasEvents(ConvasEvents.PRE_RENDER));
		
		for (drawable in displayList)
		{
			drawable.draw(context);
		}
	}
	
	function clear() 
	{
		context.clearRect(0, 0, convas.width, convas.height);
	}
}