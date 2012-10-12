package net.satcy.away3d.renderer
{
	import away3d.arcane;
	import away3d.cameras.Camera3D;
	import away3d.core.base.IRenderable;
	import away3d.core.data.RenderableListItem;
	import away3d.core.managers.Stage3DProxy;
	import away3d.core.render.BackgroundImageRenderer;
	import away3d.core.render.DepthRenderer;
	import away3d.core.render.RendererBase;
	import away3d.core.traverse.EntityCollector;
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.lights.PointLight;
	import away3d.materials.MaterialBase;
	import away3d.textures.Texture2DBase;
	
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DClearMask;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.textures.TextureBase;
	import flash.geom.Rectangle;
	
	import net.satcy.away3d.traverse.MaskEntityCollector;
	use namespace arcane;
	public class MaskRenderer extends RendererBase
	{
		private var _activeMaterial : MaterialBase;
		private var _distanceRenderer : DepthRenderer;
		private var _depthRenderer : DepthRenderer;
		private var _foregroundImageRenderer:BackgroundImageRenderer;
		private var _foreground : Texture2DBase;
		public function MaskRenderer()
		{
			super();
			_depthRenderer = new DepthRenderer();
			_distanceRenderer = new DepthRenderer(false, true);
			
		}
		
		public function get foreground() : Texture2DBase
		{
			return _foreground;
		}

		public function set foreground(value : Texture2DBase) : void
		{
			if (_foregroundImageRenderer && !value) {
				_foregroundImageRenderer.dispose();
				_foregroundImageRenderer = null;
			}

			if (!_foregroundImageRenderer && value)
				_foregroundImageRenderer = new BackgroundImageRenderer(_stage3DProxy);

			_foreground = value;

			if (_foregroundImageRenderer) _foregroundImageRenderer.texture = value;
		}
		
		arcane override function set stage3DProxy(value : Stage3DProxy) : void
		{
			super.stage3DProxy = value;
			_distanceRenderer.stage3DProxy = _depthRenderer.stage3DProxy = value;
			if (_foregroundImageRenderer) _foregroundImageRenderer.stage3DProxy = value;
		}

		protected override function executeRender(entityCollector : EntityCollector, target : TextureBase = null, scissorRect : Rectangle = null, surfaceSelector : int = 0, additionalClearMask : int = 7) : void
		{
			
			updateLights(entityCollector);
			
			//super.executeRender(entityCollector, target, scissorRect, surfaceSelector, additionalClearMask);
			
			_renderTarget = target;
			_renderTargetSurface = surfaceSelector;
			
			if (renderableSorter)
				renderableSorter.sort(entityCollector);

			if (_renderToTexture)
				executeRenderToTexturePass(entityCollector);

			_stage3DProxy.setRenderTarget(target, true, surfaceSelector);

			if (additionalClearMask != 0)
				_context.clear(_backgroundR, _backgroundG, _backgroundB, _backgroundAlpha, 1, 0, additionalClearMask);
			_context.setDepthTest(false, Context3DCompareMode.ALWAYS);
			_stage3DProxy.scissorRect = scissorRect;
			if (backgroundImageRenderer) backgroundImageRenderer.render();

			draw(entityCollector, target);
			
			if (_foregroundImageRenderer) {
				//stage3DProxy._context3D.setBlendFactors(Context3DBlendFactor.ZERO,  Context3DBlendFactor.SOURCE_ALPHA);
				//stage3DProxy._context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA,  Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
				stage3DProxy._context3D.setBlendFactors(Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR,  Context3DBlendFactor.ONE);
				_foregroundImageRenderer.render();
			}
			
			if (_swapBackBuffer && !target) _context.present();
			_stage3DProxy.scissorRect = null;
			
			
			
		}

		private function updateLights(entityCollector : EntityCollector) : void
		{
			var dirLights : Vector.<DirectionalLight> = entityCollector.directionalLights;
			var pointLights : Vector.<PointLight> = entityCollector.pointLights;
			var len : uint, i : uint;
			var light : LightBase;

			len = dirLights.length;
			for (i = 0; i < len; ++i) {
				light = dirLights[i];
				if (light.castsShadows)
					light.shadowMapper.renderDepthMap(_stage3DProxy, entityCollector, _depthRenderer);
			}

			len = pointLights.length;
			for (i = 0; i < len; ++i) {
				light = pointLights[i];
				if (light.castsShadows)
					light.shadowMapper.renderDepthMap(_stage3DProxy, entityCollector, _distanceRenderer);
			}
		}
		
		arcane override function createEntityCollector():EntityCollector{
			return new MaskEntityCollector();
		}
		override protected function draw(entityCollector : EntityCollector, target : TextureBase) : void
		{
			// TODO: not used
			//target = target;
			
			_context.setStencilReferenceValue(1);
			// 立体Ｂ描画でステンシルマスクを生成
			_context.setCulling(Context3DTriangleFace.NONE); // カリング。表面/裏面、両方書く
			//_context.setColorMask(false, false, false, false); // 色バッファ。書込禁止（前処理と設定が同じなので必要なし）
			_context.setDepthTest(false, Context3DCompareMode.LESS); // デプスバッファ設定。第一引数＝書込禁止、第二引数＝"less"で参照。
			// ステンシルバッファへの書込。表面はINCREMENT，裏面はDECREMENT。
			_context.setStencilActions( "frontAndBack", "always", "set", "set", "set" );
			//_context.setStencilActions(Context3DTriangleFace.FRONT, Context3DCompareMode.ALWAYS, Context3DStencilAction.INCREMENT_SATURATE);
			//_context.setStencilActions(Context3DTriangleFace.BACK, Context3DCompareMode.ALWAYS, Context3DStencilAction.DECREMENT_SATURATE);
			//if (backgroundImageRenderer) backgroundImageRenderer.render(this._textureRatioX, this._textureRatioY);
			drawRenderables(MaskEntityCollector(entityCollector).maskRenderableHead, entityCollector);
			//_context.setColorMask(true, true, true, true);
			//_context.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK, Context3DCompareMode.NOT_EQUAL); 
			//drawRenderables(entityCollector.opaqueRenderableHead, entityCollector);
			//drawRenderables(entityCollector.blendedRenderableHead, entityCollector);
			
			// 生成したステンシルマスクを参照して立体Ａを描画
			_context.clear(0,0,0,1,1,0,Context3DClearMask.DEPTH); // デプスバッファのクリア
			_context.setCulling(Context3DTriangleFace.BACK); // カリング。表面を書く
			_context.setColorMask(true, true, true, true); // 色バッファ。書込
			_context.setDepthTest(true, Context3DCompareMode.LESS); // デプスバッファ。第一引数＝書込、第二引数＝"less"で参照。
			_context.setStencilReferenceValue(0); // ステンシルバッファの評価値＝０
			//_context.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK, Context3DCompareMode.NOT_EQUAL); // バッファ≠評価値なら描画．立体Ｂの内側
			_context.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK, Context3DCompareMode.EQUAL); // バッファ＝評価値なら描画．立体Ｂの外側
			//drawRenderables(entityCollector.opaqueRenderableHead, entityCollector);
			//drawRenderables(entityCollector.blendedRenderableHead, entityCollector);		
			
			_context.setDepthTest(true, Context3DCompareMode.LESS);
			
			_context.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			drawRenderables(entityCollector.opaqueRenderableHead, entityCollector);
			
			_context.setDepthTest(false, Context3DCompareMode.LESS);

			if (entityCollector.skyBox) {
				if (_activeMaterial) _activeMaterial.deactivate(_stage3DProxy);
				_activeMaterial = null;
				drawSkyBox(entityCollector);
			}
			
			drawRenderables(entityCollector.blendedRenderableHead, entityCollector);
			
			if (_activeMaterial) _activeMaterial.deactivate(_stage3DProxy);
			
			_activeMaterial = null;
			
			_context.setStencilActions();
		}
		
		/**
		 * Draw the skybox if present.
		 * @param entityCollector The EntityCollector containing all potentially visible information.
		 */
		private function drawSkyBox(entityCollector : EntityCollector) : void
		{
			var skyBox : IRenderable = entityCollector.skyBox;
			var material : MaterialBase = skyBox.material;
			var camera : Camera3D = entityCollector.camera;

			material.activatePass(0, _stage3DProxy, camera, _textureRatioX, _textureRatioY);
			material.renderPass(0, skyBox, _stage3DProxy, entityCollector);
			material.deactivatePass(0, _stage3DProxy);
		}

		/**
		 * Draw a list of renderables.
		 * @param renderables The renderables to draw.
		 * @param entityCollector The EntityCollector containing all potentially visible information.
		 */
		private function drawRenderables(item : RenderableListItem, entityCollector : EntityCollector) : void
		{
			var numPasses : uint;
			var j : uint;
			var camera : Camera3D = entityCollector.camera;
			var item2 : RenderableListItem;

			while (item) {
				_activeMaterial = item.renderable.material;
				_activeMaterial.updateMaterial(_context);

				numPasses = _activeMaterial.numPasses;
				j = 0;

				do {
					item2 = item;

					_activeMaterial.activatePass(j, _stage3DProxy, camera, _textureRatioX, _textureRatioY);
					do {
						_activeMaterial.renderPass(j, item2.renderable, _stage3DProxy, entityCollector);
						item2 = item2.next;
					} while (item2 && item2.renderable.material == _activeMaterial);
					_activeMaterial.deactivatePass(j, _stage3DProxy);

				} while (++j < numPasses);

				item = item2;
			}
		}


		arcane override function dispose() : void
		{
			super.dispose();
			_depthRenderer.dispose();
			_distanceRenderer.dispose();
			_depthRenderer = null;
			_distanceRenderer = null;
			if (_foregroundImageRenderer) {
				_foregroundImageRenderer.dispose();
				_foregroundImageRenderer = null;
			}
		}
	}
}