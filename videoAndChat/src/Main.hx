package;

import chatManagment.ChatController;
import events.DataEvent;
import external.DataLoader;
import js.Browser;
import passkey.PassKeyChecker;
import passkey.PassKeyCheckerEvents;
import view.data.MainViewModel;
import view.events.WaitingScreenEvent;
import view.MainView;

class Main
{
	var mainViewModel:MainViewModel;
	var mainView:MainView;
	
	public function new() 
	{
		var passKeyChecker:PassKeyChecker = new PassKeyChecker();
		passKeyChecker.addEventListener(PassKeyCheckerEvents.CHECK_IS_OK, onKeyValidationPass);
		passKeyChecker.addEventListener(PassKeyCheckerEvents.KEY_CORRUPTED, onKeyCorrupted);
		passKeyChecker.addEventListener(PassKeyCheckerEvents.EVENT_END, onKeyIsOutDate);
		passKeyChecker.addEventListener(PassKeyCheckerEvents.WAIING_FOR_KEY, onWaitingForKey);
		
		passKeyChecker.check();
		
		untyped __js__('addStartCallback({0})', startApp);
	}
	
	private function onWaitingForKey(e:PassKeyCheckerEvents):Void 
	{
		initView();
		showWaitingState();
	}
	
	private function onKeyCorrupted(e:PassKeyCheckerEvents):Void 
	{
		throw "pass key is corrupted";
	}
	
	private function onKeyIsOutDate(e:PassKeyCheckerEvents):Void 
	{
		initView();
		showEndState();
	}
	
	private function onKeyValidationPass(e:PassKeyCheckerEvents):Void 
	{
		initView();
		initVideo();
	}
	
	private function initView():Void
	{
		mainViewModel = new MainViewModel();
		mainView = new MainView(mainViewModel);
		
		var namesListLoader:external.DataLoader = new external.DataLoader();
		namesListLoader.addEventListener(DataEvent.ON_LOAD, onNamesListLoaded);
		namesListLoader.load("usersList.txt");
	}
	
	function initVideo(e:WaitingScreenEvent = null) 
	{
		var currentTime:Float = StableDate.currentTime;
		var videoStartTime:Float = (currentTime - Settings.getInstance().START_TIME) / 1000;
		
		if (videoStartTime < 0)
			videoStartTime = 0;
		
		untyped __js__('initVideo({0})', videoStartTime);
	}
	
	function showEndState() 
	{
		Browser.document.getElementById("eventEnd").hidden = false;
		mainView.hideAll();
		untyped __js__('onVideoEnded()');
	}
	
	function showWaitingState() 
	{
		mainView.waitingState();
		mainView.waitingScreen.addEventListener(WaitingScreenEvent.WAITING_END, initVideo);
	}
	
	public function startApp() 
	{
		mainView.appState();
	}
	
	private function onNamesListLoaded(e:DataEvent):Void 
	{
		var data:String = e.data;
		
		var namesList:Array<String>;
		
		if (data.indexOf("\r\n") != -1)
		{
			namesList = data.split("\r\n");
		}
		else
		{
			namesList = data.split("\n");
		}
		
		namesList.sort(sortOnTime);
		
		
		mainViewModel.userNamesList = namesList;
		mainViewModel.addUser("Вы", true);
		
		mainView.start();
		new ChatController(mainViewModel);
	}
	
	function sortOnTime(x:String, y:String):Int 
	{
		if (Math.random() > 0.5)
			return 1;
		else
			return -1;
	}
}