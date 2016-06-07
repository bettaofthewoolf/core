package;
import js.Browser;
import passkey.PassKeyChecker;
import passkey.PassKeyCheckerEvents;
import view.events.WaitingScreenEvent;
import view.WaitingScreen;

/**
 * ...
 * @author 
 */
class Main
{
	var mainView:WaitingScreen;
	var passKeyChecker:PassKeyChecker;

	public function new() 
	{
		mainView = new WaitingScreen();
		mainView.addEventListener(WaitingScreenEvent.WAITING_END, onTimerEnd);
		
		passKeyChecker = new PassKeyChecker();
		passKeyChecker.addEventListener(PassKeyCheckerEvents.CHECK_IS_OK, onKeyValidationPass);
		passKeyChecker.addEventListener(PassKeyCheckerEvents.KEY_CORRUPTED, onKeyCorrupted);
		passKeyChecker.addEventListener(PassKeyCheckerEvents.EVENT_END, onKeyIsOutDate);
		passKeyChecker.addEventListener(PassKeyCheckerEvents.WAIING_FOR_KEY, onWaitingForKey);
		
		passKeyChecker.check();
	}
	
	private function onTimerEnd(e:WaitingScreenEvent):Void 
	{
		trace('on timer is end');
		navigateTo(untyped __js__('getNextUrl({0})', passKeyChecker.passKey.encodedValue));
	}
	
	private function onWaitingForKey(e:PassKeyCheckerEvents):Void 
	{
		trace('show waiting');
		mainView.show();
	}
	
	private function onKeyIsOutDate(e:PassKeyCheckerEvents):Void 
	{
		trace('key out date');
		navigateTo(untyped __js__('getEndUrl()'));
	}
	
	private function onKeyCorrupted(e:PassKeyCheckerEvents):Void 
	{
		trace('key corrupted');
	}
	
	private function onKeyValidationPass(e:PassKeyCheckerEvents):Void 
	{
		trace('key is ok');
		navigateTo(untyped __js__('getNextUrl({0})', passKeyChecker.passKey.encodedValue));
	}
	
	function navigateTo(value:String) 
	{
		Browser.window.location.replace(value);
	}
	
}