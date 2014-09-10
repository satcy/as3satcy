package net.satcy.air.osc
{
	import flash.events.EventDispatcher;
	//import flash.filesystem.*;
	import flash.net.*;
	import flash.text.TextField;
	
	import net.satcy.air.osc.OSCDatagramConnection;
	import net.satcy.util.LayOutUtil;
	import net.satcy.view.DebugView;
	
	import org.fwiidom.osc.OSCConnection;
	import org.fwiidom.osc.OSCConnectionEvent;
	import org.fwiidom.osc.OSCPacket;
	
	public class OscWrapper
	{
		private static var _root:OscWrapper;
		private static const DISP:EventDispatcher = new EventDispatcher();
		
		public static function close():void{
			if ( _root ) _root.close();
		}
		
		public static function sendMessage(address:String, vals:Array):void{
			if ( _root ) _root.sendMessage(address, vals);
		}
		
		private var _osc:OSCConnection;
		private var _to_ip:String = "127.0.0.1";
		private var _to_port:int = 9999;
		private var _in_port:int = 8000;
		
		private var tf:TextField;
		public function close():void{
			if ( _osc ) {
				_osc.removeEventListener(OSCConnectionEvent.ON_PACKET_IN, onPacketHandler);
				_osc.disconnect();
				if ( _osc.hasOwnProperty("destroy") ) _osc["destroy"]();
				_osc = null;
			}
		}
		public function OscWrapper(osc:OSCConnection, to_ip:String, to_port:int, in_port:int){
			_root = this;
			_osc = osc;
			_to_ip = to_ip;
			_to_port = to_port;
			_in_port = in_port;
			configureOsc(); 
		}
		
		private function configureOsc():void{
			_osc.addEventListener(OSCConnectionEvent.ON_CONNECT, _onConnect);
			_osc.addEventListener(OSCConnectionEvent.ON_CONNECT_ERROR, _onError);
			_osc.addEventListener(OSCConnectionEvent.ON_PACKET_IN, onPacketHandler);
			_osc.connect();
			
			function _onError(e:OSCConnectionEvent):void{
				_osc.removeEventListener(OSCConnectionEvent.ON_CONNECT, _onConnect);
				_osc.removeEventListener(OSCConnectionEvent.ON_CONNECT_ERROR, _onError);
				DebugView.writeAdd(0, "error");
			}
			function _onConnect(e:OSCConnectionEvent):void{
				_osc.removeEventListener(OSCConnectionEvent.ON_CONNECT, _onConnect);
				_osc.removeEventListener(OSCConnectionEvent.ON_CONNECT_ERROR, _onError);
				if ( tf ) LayOutUtil.stage.removeChild(tf);
				tf = null;
				OscWrapper.sendMessage("/dummy", [0]);
				DebugView.writeAdd(0, "connected");
			}
			
			
		}
		
		public function sendMessage(address:String, vals:Array):void{
			if ( !_osc ) return;
			var p:OSCPacket = new OSCPacket(address, vals, _to_ip, _to_port);
			_osc.sendOSCPacket(p);
		}
		
		public static function addEvent(fn:Function):void{
			DISP.removeEventListener(OSCConnectionEvent.ON_PACKET_IN, fn);
			DISP.addEventListener(OSCConnectionEvent.ON_PACKET_IN, fn);
		}
		
		public static function removeEvent(fn:Function):void{
			DISP.removeEventListener(OSCConnectionEvent.ON_PACKET_IN, fn);
		}
		
		private static function onPacketHandler(e:OSCConnectionEvent):void{
			var p:OSCPacket = e.data as OSCPacket;
			//trace("osc in:", p.name, p.data);
			DebugView.writeAdd(0, p.data[0]);
			var evt:OSCConnectionEvent = new OSCConnectionEvent(e.type, e.data);
			DISP.dispatchEvent(evt);
		}

	}
}