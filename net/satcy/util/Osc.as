package net.satcy.util
{
	import flash.events.EventDispatcher;
	
	import org.fwiidom.osc.OSCConnection;
	import org.fwiidom.osc.OSCConnectionEvent;
	import org.fwiidom.osc.OSCPacket;
	
	public class Osc
	{
		private static const DISP:EventDispatcher = new EventDispatcher();
		
		private static var osc:OSCConnection;
		private static var connected:Boolean = false;
		private static var firstData:OSCPacket;
		public static function init(port:Number = 9000, _firstData:OSCPacket = null):void{
			firstData = _firstData;
			osc = new OSCConnection("127.0.0.1", port);
			osc.addEventListener(OSCConnectionEvent.ON_CONNECT, onConnectHandler);
			osc.addEventListener(OSCConnectionEvent.ON_PACKET_IN, onPacketInHandler);
			osc.addEventListener(OSCConnectionEvent.ON_CONNECT_ERROR, onErrorHandler);
			try{osc.connect();}catch(e:*){}
		}
		
		private static function onConnectHandler(e:OSCConnectionEvent):void{
			trace("osc connected:",e);
			connected = true;
			if ( firstData ) {
				osc.sendOSCPacket(firstData);
				firstData = null;
			}
		}
		
		private static function onPacketInHandler(e:OSCConnectionEvent):void{
			var pac:OSCPacket = e.data as OSCPacket;
			trace(pac.name, pac.data);
			DISP.dispatchEvent(new OSCConnectionEvent(OSCConnectionEvent.ON_PACKET_IN, pac));
		}
		
		private static function onErrorHandler(e:OSCConnectionEvent):void{
			trace("osc error:",e);
		}
		
		public static function addEvent(handler:Function):void{
			removeEvent(handler);
			DISP.addEventListener(OSCConnectionEvent.ON_PACKET_IN, handler);
		}
		
		public static function removeEvent(handler:Function):void{
			DISP.removeEventListener(OSCConnectionEvent.ON_PACKET_IN, handler);
		}
		
		public static function send(ip:String, port:Number, name:String, data:Array):void{
			if ( !connected ) return;
			var pac:OSCPacket = new OSCPacket(name, data, ip, port);
			osc.sendOSCPacket(pac);
		}

	}
}