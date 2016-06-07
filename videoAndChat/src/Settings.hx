package;

/**
 * ...
 * @author ...
 */
class Settings
{
	static var _instance:Settings;
	
	public static function getInstance():Settings
	{
		if (_instance == null)
			_instance = new Settings();
		
		return _instance;
	}
	
	
	public var START_TIME:Float;
	public var TODAY_DAY:Int;
	public var TODAY:Float;
	public var TODAY_MONTH:Int;
	
	public function new() 
	{
		START_TIME = 0;
	}
	
}