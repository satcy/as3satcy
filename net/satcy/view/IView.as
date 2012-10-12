package net.satcy.view{
	import flash.events.IEventDispatcher;
	
	
	public interface IView extends IEventDispatcher{
		
		function show():void;
		function hide(_fn:Function = null):void;
		function onResizing():void;
		function get _thisWidth():Number;
		function get _thisHeight():Number;

	}
}