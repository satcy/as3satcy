package net.satcy.air.osc{
	import flash.errors.EOFError;
	import flash.events.DatagramSocketDataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.DatagramSocket;
	import flash.utils.ByteArray;
	
	import org.fwiidom.osc.OSCConnection;
	import org.fwiidom.osc.OSCConnectionEvent;
	import org.fwiidom.osc.OSCPacket;
	
	/*
	AIR2+ require
	*/
	
	
	
	public class OSCDatagramConnection extends OSCConnection{
//		[Event(name=”onConnect”, type=”org.fwiidom.osc.OSCConnectionEvent”)]
//		[Event(name=”onConnectError”, type=”org.fwiidom.osc.OSCConnectionEvent”)]
//		[Event(name=”onClose”, type=”org.fwiidom.osc.OSCConnectionEvent”)]
//		[Event(name=”onPacketIn”, type=”org.fwiidom.osc.OSCConnectionEvent”)]
//		[Event(name=”onPacketOut”, type=”org.fwiidom.osc.OSCConnectionEvent”)]
		
		private var soc:DatagramSocket;
		private var sender:DatagramSocket;
		
		public function OSCDatagramConnection(inIp:String, inPort:Number){
			super(inIp, inPort);
		}
		
		//-------------------------------------------------------------------------------------Public
		
		override public function connect():void{
			sender = new DatagramSocket();
			soc = new DatagramSocket();
			soc.addEventListener(DatagramSocketDataEvent.DATA, onDataHandler);
			soc.addEventListener(Event.ACTIVATE, onActiveHandler);
			soc.addEventListener(Event.DEACTIVATE, onDeactiveHandler);
			soc.addEventListener(Event.CLOSE, onCloseHandler);
			soc.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			soc.bind(this.mPort, this.mIp);
			soc.receive();
		}
		
		override public function disconnect():void{
			if ( soc && soc.connected ) soc.close();
			if ( sender && sender.connected ) sender.close();
			mConnected = false;
		}
		
		public function destroy():void{
			if ( soc ) {
				soc.removeEventListener(DatagramSocketDataEvent.DATA, onDataHandler);
				soc.removeEventListener(Event.ACTIVATE, onActiveHandler);
				soc.removeEventListener(Event.DEACTIVATE, onDeactiveHandler);
				soc.removeEventListener(Event.CLOSE, onCloseHandler);
				soc.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			}
			disconnect();
			soc = null;
			sender = null;
		}
		
		override public function sendOSCPacket(outPacket:OSCPacket):void{
			if ( !(mConnected) ) return;
			
			var out:ByteArray = new ByteArray();
			this.writeString(outPacket.name, out);
			var pattern:String = ",";
			var o:Object;
			for each ( o in outPacket.data ){
				if ( o is int ) pattern += "i";
				else if ( o is Number ) pattern += "f";
				else if ( o is String ) pattern += "s";
				else if ( o is Boolean ) pattern += (o == true) ? "T" : "F";	
			}
			this.writeString(pattern, out);
			for each ( o in outPacket.data ){
				if ( o is int ) out.writeInt(o as int);
				else if ( o is Number ) out.writeFloat(o as Number);
				else if ( o is String ) this.writeString(o as String, out);
				else if ( o is Boolean ) out.writeBoolean(o as Boolean);
			}
			out.position = 0;
			
			sender.send(out, 0, 0, outPacket.address, outPacket.port);
			dispatchEvent(new OSCConnectionEvent(OSCConnectionEvent.ON_PACKET_OUT,outPacket));
			
		}
		
		//-------------------------------------------------------------------------------------Protected
		
		protected function writeString(str:String, byteArray:ByteArray):void {
			var nulls:int = 4 - (str.length % 4);
			byteArray.writeUTFBytes(str);
			//add zero padding so the length of the string is a multiple of 4
			for (var c:int = 0; c < nulls; c++ ){
				byteArray.writeByte(0);
			}
		}
		
		protected function readString(byteArray:ByteArray):String {
			var out:String = new String();
			var char:String = new String();
			while(byteArray.bytesAvailable > 0){
				char = byteArray.readUTFBytes(4);
				out += char;
				if(char.length < 4) break;
			}
			return out;
		}
		
		protected function readTimetag(byteArray:ByteArray):Number {
			var seconds:uint = byteArray.readUnsignedInt();
			var picoseconds:uint = byteArray.readUnsignedInt();
			
			return seconds;
		}
		
		protected function readBlob(byteArray:ByteArray):ByteArray {
			var length:int = byteArray.readInt();
			var blob:ByteArray = new ByteArray();
			byteArray.readBytes(blob, 0, length);
			var bits:int = (length + 1) * 8;
			while((bits % 32) != 0){
				byteArray.position += 1;
				bits += 8;
			}
			return blob;
		}
		
		protected function read64BInt(byteArray:ByteArray):ByteArray {
			var bigInt:ByteArray = new ByteArray();
			byteArray.readBytes(bigInt, 0, 8);
			return bigInt;
		}
		
		//-------------------------------------------------------------------------------------Private
		
		//-------------------------------------------------------------------------------------Event
		
		private function onDataHandler(e:DatagramSocketDataEvent):void{
			var bytes:ByteArray = e.data;
			//trace(e.srcAddress, e.srcPort);
			//trace(e.dstAddress, e.dstPort);
			if(bytes != null){
				//read the OSCMessage head
				var addressPattern:String = this.readString(bytes);
				//read the parsing pattern for the following OSCMessage bytes
				var pattern:String = this.readString(bytes);
				var openArray:Array = [];
				var l:int = pattern.length;
				try{
					for(var c:int = 0; c < l; c++){
						switch(pattern.charAt(c)){
							case "s": openArray.push(readString(bytes)); break;
							case "f": openArray.push(bytes.readFloat()); break;
							case "i": openArray.push(bytes.readInt()); break;
							case "t": openArray.push(readTimetag(bytes)); break;
							case "d": openArray.push(bytes.readDouble()); break;
							case "S": openArray.push(readString(bytes)); break;
							case "T": openArray.push(true); break;
							case "F": openArray.push(false); break;
							case "b": openArray.push(readBlob(bytes)); break;
							case "h": openArray.push(read64BInt(bytes)); break;
							case "c": openArray.push(bytes.readMultiByte(4, "US-ASCII")); break;
							case "r": openArray.push(bytes.readUnsignedInt()); break;
							case "N": openArray.push(null); break;
							case "I": openArray.push(Infinity); break;
							default: break;
						}
					}
				} catch (e:EOFError) {
					trace("OSCDatagramConnection::onDataHandler::parse corrupt");
					openArray = null;
				}
				//trace(addressPattern, openArray);
				var osc_packet:OSCPacket = new OSCPacket(addressPattern, openArray, e.srcAddress, e.srcPort);
				dispatchEvent(new OSCConnectionEvent(OSCConnectionEvent.ON_PACKET_IN,osc_packet));	
			}
		}
		
		private function onActiveHandler(e:Event):void{
			this.mConnected = true;
			e.target.removeEventListener(Event.ACTIVATE, onActiveHandler);
			dispatchEvent(new OSCConnectionEvent(OSCConnectionEvent.ON_CONNECT,null));
		}
		
		private function onDeactiveHandler(e:Event):void{
			trace("onDataHandler::onDeactiveHandler");
		}
		private function onCloseHandler(e:Event):void{
			trace("onDataHandler::onCloseHandler");
			onClose(null);
		}
		
		private function onErrorHandler(e:IOErrorEvent):void{
			trace("onDataHandler::onErrorHandler");
			onConnectError();
		}
	}
}