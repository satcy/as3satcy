package net.satcy.away3d.textures
{
	import away3d.materials.utils.IVideoPlayer;
	import away3d.materials.utils.SimpleVideoPlayer;
	import away3d.textures.BitmapTexture;
	import away3d.tools.utils.TextureUtils;
	
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.ShaderFilter;
	import flash.geom.Rectangle;

	public class NoAlphaVideoTexture extends BitmapTexture
	{
		[Embed(source="../pb/NoAlpha.pbj", mimeType="application/octet-stream")]
		private var NoAlphaClass:Class;
		private var _broadcaster : Sprite;
		private var _autoPlay : Boolean;
		private var _autoUpdate : Boolean;
		private var _materialWidth : uint;
		private var _materialHeight : uint;
		private var _player : IVideoPlayer;
		private var _clippingRect : Rectangle;
		private var myFilter:ShaderFilter ;
		public function NoAlphaVideoTexture(source : String, materialWidth : uint = 256, materialHeight : uint = 256, loop : Boolean = true, autoPlay : Boolean = false, player : IVideoPlayer = null)
		{
			var shader:Shader = new Shader(new NoAlphaClass());
			myFilter = new ShaderFilter(shader);
			_broadcaster = new Sprite();

			// validates the size of the video
			_materialWidth = materialWidth;
			_materialHeight = materialHeight;

			// this clipping ensures the bimapdata size is valid.
			_clippingRect = new Rectangle(0, 0, _materialWidth, _materialHeight);

			// assigns the provided player or creates a simple player if null.
			_player = player || new SimpleVideoPlayer();
			_player.loop = loop;
			_player.source = source;
			_player.width = _materialWidth;
			_player.height = _materialHeight*2;

			// sets autplay
			_autoPlay = autoPlay;
			
			//_player.container.filters = [myFilter];

			// Sets up the bitmap material
			super(new BitmapData(_materialWidth, _materialHeight, true, 0));

			// if autoplay start video
			if (autoPlay)
				_player.play();

			// auto update is true by default
			autoUpdate = true;
		}

		/**
		 * Draws the video and updates the bitmap texture
		 * If autoUpdate is false and this function is not called the bitmap texture will not update!
		 */
		public function update() : void
		{

			if (_player.playing && !_player.paused) {
				//_player.container.filters = [myFilter];
				bitmapData.lock();
				bitmapData.fillRect(_clippingRect, 0xFFFF00);
				bitmapData.draw(_player.container, null, null, null, _clippingRect, true);
				bitmapData.unlock();
				invalidateContent();
			}

		}

		override public function dispose() : void
		{
			super.dispose();
			autoUpdate = false;
			bitmapData.dispose();
			_player.dispose();
			_player = null;
			_broadcaster = null;
			_clippingRect = null;
		}

		private function autoUpdateHandler(event : Event) : void
		{
			update();
		}

		/**
		 * Indicates whether the video will start playing on initialisation.
		 * If false, only the first frame is displayed.
		 */
		public function set autoPlay(b : Boolean) : void
		{
			_autoPlay = b;
		}

		public function get autoPlay() : Boolean
		{
			return _autoPlay;
		}

		public function get materialWidth():uint
		{
			return _materialWidth;
		}

		public function set materialWidth(value:uint):void
		{
			_materialWidth = validateMaterialSize( value );
			_player.width = _materialWidth;
			_clippingRect.width = _materialWidth;
		}

		public function get materialHeight() : uint
		{
			return _materialHeight;
		}

		public function set materialHeight(value : uint) : void
		{
			_materialHeight = validateMaterialSize( value );
			_player.width = _materialHeight;
			_clippingRect.width = _materialHeight;
		}

		private function validateMaterialSize( size:uint ):int
		{
			if (!TextureUtils.isDimensionValid(size)) {
				var oldSize : uint = size;
				size = TextureUtils.getBestPowerOf2(size);
				trace("Warning: "+ oldSize + " is not a valid material size. Updating to the closest supported resolution: " + size);
			}

			return size;
		}

		/**
		 * Indicates whether the material will redraw onEnterFrame
		 */
		public function get autoUpdate():Boolean
		{
			return _autoUpdate;
		}

		public function set autoUpdate(value:Boolean):void
		{
			if (value == _autoUpdate) return;

			_autoUpdate = value;

			if(value)
				_broadcaster.addEventListener(Event.ENTER_FRAME, autoUpdateHandler, false, 0, true);
			else
				_broadcaster.removeEventListener(Event.ENTER_FRAME, autoUpdateHandler);
		}

		public function get player():IVideoPlayer
		{
			return _player;
		}
	}
}
