package net.satcy.away3d.traverse
{
	import away3d.arcane;
	import away3d.core.traverse.EntityCollector;
	import away3d.materials.MaterialBase;
	import away3d.core.base.IRenderable;
	import away3d.core.data.RenderableListItem;
	import away3d.core.render.BackgroundImageRenderer;
	import away3d.textures.VideoTexture;
	import away3d.materials.ColorMaterial;
	use namespace arcane;
	public class MaskEntityCollector extends EntityCollector
	{
		protected var _maskRenderableHead : RenderableListItem;
		protected var _numMasked : uint;
		
		public function MaskEntityCollector()
		{
			super();
		}
		
		public function get maskRenderableHead() : RenderableListItem
		{
			return _maskRenderableHead;
		}

		public function set maskRenderableHead(value : RenderableListItem) : void
		{
			_maskRenderableHead = value;
		}
		
		override public function clear():void{
			super.clear();
			_maskRenderableHead = null;
		}
		/**
		 * Adds an IRenderable object to the potentially visible objects.
		 * @param renderable The IRenderable object to add.
		 */
		override public function applyRenderable(renderable:IRenderable) : void
		{
			var material : MaterialBase;

			if (renderable.mouseEnabled) ++_numMouseEnableds;
			_numTriangles += renderable.numTriangles;

			material = renderable.material;
			if (material) {
				var item : RenderableListItem = _renderableListItemPool.getItem();
				item.renderable = renderable;
				item.materialId = material._uniqueId;
				item.renderOrderId = material._renderOrderId;
				item.zIndex = renderable.zIndex;
				
				if ( material.extra && material.extra.hasOwnProperty("mask") && material.extra.mask ) {
				 	item.next = _maskRenderableHead;
					_maskRenderableHead = item;
					++_numMasked;
				} else if (material.requiresBlending) {
					item.next = _blendedRenderableHead;
					_blendedRenderableHead = item;
					++_numBlended;
				} else {
					item.next = _opaqueRenderableHead;
					_opaqueRenderableHead = item;
					++_numOpaques;
				}
			}
		}
		
	}
}