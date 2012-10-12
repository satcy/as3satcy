package net.satcy.qrcode.event
{
	import flash.events.Event;

	public class QRdecoderEvent extends Event{
		public static const QR_DECODE_CHECK:String="QR_DECODE_CHECK";

        public static const QR_DECODE_CODE_CHECK:String="QR_DECODE_CODE_CHECK";

        public static const QR_DECODE_COMPLETE:String="QR_DECODE_COMPLETE";

        public var checkArray:Array;

        public var data:String;
        
		public function QRdecoderEvent(type:String, _data:String, _checkArray:Array)
		{
			super(type, false, false);
			this.data = _data;
            this.checkArray = _checkArray;
		}
		
		public override function clone():Event
        {
            return new QRdecoderEvent(type, data, checkArray);
        }
		
	}
}