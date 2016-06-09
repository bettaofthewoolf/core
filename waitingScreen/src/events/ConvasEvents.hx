package events;

class ConvasEvents extends Event
{
	static public inline var PRE_RENDER:String = "preRender";

	public function new(type:String) 
	{
		super(type);
	}
	
}