package;

/**
 * ...
 * @author 
 */
class DateHelper
{

	public function new() 
	{
		
	}
		
	public static function getTimezoneDate():Date
	{
		var date:Date = Date.now();
		
		var timeOffset:Int = date.getTimezoneOffset();
		
		if (timeOffset != -180)
		{
			date = Date.fromTime(date.getTime() + (timeOffset * 60 * 1000) + (180 * 60 * 1000));
		}
		
		return date;
	}
}