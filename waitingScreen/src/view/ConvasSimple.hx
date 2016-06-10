package view;

import events.ConvasEvents;
import events.Observer;
import js.Browser;
import js.html.CanvasElement;
import js.html.Element;

class ConvasSimple extends Observer
{
	var convas:CanvasElement;
	var context:Dynamic;
	
	private var displayList:Array<Drawable> = new Array<Drawable>();
	public var width:Int;
	public var height:Int;
	var autoUpdate:Bool;

	public function new() 
	{
		super();
	}
	
	public function addChild(drawable:Drawable):Void
	{
		displayList.push(drawable);
	}
	
	public function initByClass(element:Element, clazz:String, autoUpdate:Bool = false):Void 
	{
		this.autoUpdate = autoUpdate;
		convas = untyped element.getElementsByClassName(clazz)[0];
		
		width = convas.width;
		height = convas.height;
		
		getContext();
		
		if (autoUpdate)
			render();
	}
	
	public function init(id:String, autoUpdate:Bool = false):Void
	{
		this.autoUpdate = autoUpdate;
		convas = untyped Browser.document.getElementById(id);
		
		
		
		getContext();
		//resize(Browser.window.innerWidth, Browser.window.innerHeight);
			
		if (autoUpdate)
			render();
	}
	
	function getContext() 
	{
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
		width = convas.width;
		height = convas.height;
		
		clear();
		
		if(autoUpdate)
			untyped __js__ ("requestAnimationFrame") (render);
		
		dispatchEvent(new ConvasEvents(ConvasEvents.PRE_RENDER));
		
		for (drawable in displayList)
			drawable.draw(context);
	}
	
	function clear() 
	{
		context.clearRect(0, 0, width, height);
	}
}