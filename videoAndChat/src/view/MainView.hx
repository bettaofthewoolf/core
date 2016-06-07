package view;

import haxe.Timer;
import js.Browser;
import js.html.Element;
import js.html.InputElement;
import view.data.MainViewModel;
import view.events.ChatEvent;
import view.events.UserListEvent;

class MainView
{
	var viewModel:MainViewModel;
	
	private var userlistBlockHeaderPattern:String;
	
	public var waitingScreen:WaitingScreen;
	
	var usersListContainer:Element;
	var usersList:Element;
	var usersListHeader:Element;
	
	var showDiv:Element;
	
	var chatContainer:Element;
	var chatMessages:Element;
	var chatTextInput:InputElement;
	var sendButton:Element;
	
	private var usersCount:Int = 0;
	var usersUpdateTimer:Timer;
	
	public function new(viewModel:MainViewModel) 
	{
		this.viewModel = viewModel;
		initialize();
	}
	
	public function hideAll()
	{
		waitingScreen.hide();
		
		chatContainer.hidden = true;
		usersListContainer.hidden = true;
	}
	
	public function waitingState() 
	{
		waitingScreen.show();
		
		chatContainer.hidden = false;
		usersListContainer.hidden = false;
	}
	
	public function appState() 
	{
		waitingScreen.hide();
		
		chatContainer.hidden = false;
		usersListContainer.hidden = false;
	}
	
	function initialize() 
	{
		buildUi();
		
		userlistBlockHeaderPattern = usersListHeader.innerText;
		
		chatTextInput.addEventListener("keyup", onInputKeyPress);
		sendButton.onclick = sendMessage;
		
		viewModel.addEventListener(UserListEvent.USER_LIST_CHANGE, updateUsersList);
		viewModel.addEventListener(ChatEvent.MESSAGE_ADD, updateMessagesLists);
	}
	
	public function start()
	{
		var state:Int = getUsersToTimeState();
		var count:Int = 0;
		lastState = state;
		
		if (state == 0)
			count += 10 + Math.floor(Math.random() * 20);
		else if (state == 1)
			count += 50 + Math.floor(Math.random() * 50);
		else if (state == 2)
			count += 140 + Math.floor(Math.random() * 20);
			
		for (i in 0...count)
		{
			viewModel.addUser(getRandomName(), true);
		}
			
		usersCount += count;
			
		getUsersUpdateTimer();
		
		onUsersCountUpdate();
		
		updateUsersList();
	}
	
	function getUsersToTimeState():Int
	{
		var currentTime:Float = StableDate.currentTime;
		
		if(Settings.getInstance().START_TIME - currentTime > 120 * 60 * 1000)
		{
			return -1;
		}
		else if (Settings.getInstance().START_TIME - currentTime > 30 * 60 * 1000)
		{
			return 0;
		}
		else if (Settings.getInstance().START_TIME - currentTime < 30 * 60 * 100 && Settings.getInstance().START_TIME - currentTime > 5 * 60 * 1000)
		{
			return 1;
		}
		else
			return 2;
	}
	
	function getUsersUpdateTimer() 
	{
		var state:Int = getUsersToTimeState();
		var interval:Int = 0;
		
		if (state == 0)
			interval = 2 * 60 * 1000;
		else if (state == 1)
			interval = Math.floor(0.5 * 60 * 1000);
		else if (state == 2)
			interval = Std.int((1000 * 60 * 60) / (300 / 100 * 35));
			
		if (usersUpdateTimer != null)
			usersUpdateTimer.stop();
			
		usersUpdateTimer = new Timer(interval);
		usersUpdateTimer.run = onUsersCountUpdate;
	}
	
	function onShowDiv() 
	{
		showDiv.hidden = false;
		//showDivTimer.stop();
	}
	
	private var lastState:Int = -1;
	function onUsersCountUpdate() 
	{
		var state:Int = getUsersToTimeState();
		var count:Int = 0;
		
		if (state == 0)
			count += Math.floor(1 + Math.random() * 3);
		else if (state == 1)
			count += Math.floor(3 + Math.random() * 2);
		else if (state == 2)
			count += 1;
		
		for (i in 0...count)
		{
			viewModel.addUser(getRandomName(), true);
		}
			
		usersCount += count;
		usersListHeader.innerText = userlistBlockHeaderPattern.split("{0}").join(Std.string(usersCount + 1));
		
		if (lastState != state)
		{
			lastState = state;
			getUsersUpdateTimer();
		}
		
		updateUsersList();
	}
	
	function getRandomName():String
	{
		var name:String = "Вы";
		
		while (name == "Вы")
		{
			name = viewModel.userNamesList[Math.floor(Math.random() * viewModel.userNamesList.length)];
		}
		
		return name;
	}
	
	function buildUi() 
	{
		waitingScreen = new WaitingScreen();
		
		showDiv = Browser.document.getElementById("showDiv");
		
		usersListContainer = Browser.document.getElementById("usersListContainer");
		usersList = Browser.document.getElementById("users");
		usersListHeader = Browser.document.getElementById("usersHeader");
		
		chatContainer = Browser.document.getElementById("chatContainer");
		chatMessages = Browser.document.getElementById("chat");
		chatTextInput = cast(Browser.document.getElementById("chatInput"), InputElement);	
		sendButton = Browser.document.getElementById("sendButton");
	}
	
	function onInputKeyPress(event:Dynamic) 
	{
		event.preventDefault();
		
		if (event.keyCode == 13)
		{
			sendMessage();
		}
	}
	
	private function sendMessage():Void
	{
		if (chatTextInput.value.length == 0)
			return;
			
		viewModel.addMessage("Вы", chatTextInput.value);
		chatTextInput.value = "";
		chatTextInput.select();
	}
	
	private function updateMessagesLists(e:ChatEvent):Void 
	{
		var text:String = "";
		
		for (messageData in viewModel.messages)
		{
			text += '<div class="chatMessege"><span class="chatName">' + messageData.name + ':</span>' + messageData.message + '</div>';
		}
		
		chatMessages.innerHTML = text;
		
		var scrollHeight:Int = Math.floor(Math.max(chatMessages.scrollHeight, chatMessages.clientHeight));
		chatMessages.scrollTop = scrollHeight - chatMessages.clientHeight;
	}
	
	private function updateUsersList(e:UserListEvent = null):Void 
	{
		var text:String = "";
		
		for (userName in viewModel.usersList)
		{
			text += '<div class="member"><img src="img/gray-member.png">' + userName + '</div>';
		}
		
		usersList.innerHTML = text;
		
		//var scrollHeight:Int = Math.floor(Math.max(usersList.scrollHeight, usersList.clientHeight));
		//usersList.scrollTop = scrollHeight - usersList.clientHeight;
	}
	
}