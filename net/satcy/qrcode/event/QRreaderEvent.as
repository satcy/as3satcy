package net.satcy.qrcode.event{
	import flash.display.BitmapData;
	import flash.events.Event;

	public class QRreaderEvent extends Event
	{
		
        

        public static const QR_IMAGE_READ_COMPLETE:String="QR_IMAGE_READ_COMPLETE";

        public static const QR_IMAGE_READ_CHECK:String="QR_IMAGE_READ_CHECK";

        public var data:Array;

        public var imageData:BitmapData;
		public function QRreaderEvent(type:String, _imageData:BitmapData, _data:Array)
		{
			super(type);
			this.imageData = _imageData;
            this.data = _data;
		}
		
		public override function clone():Event
        {
            return new QRreaderEvent(type, imageData, data);
        }
		
	}
}