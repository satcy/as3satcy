package net.satcy.flare.loaders
{
	import __AS3__.vec.Vector;
	
	import com.perfume.utils.PerfumeDecoder;
	
	import deng.fzip.*;
	
	import flare.core.Mesh3D;
	import flare.core.Pivot3D;
	import flare.core.Surface3D;
	import flare.core.Texture3D;
	import flare.materials.Shader3D;
	import flare.materials.filters.*;
	import flare.primitives.DebugWireframe;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.*;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import net.satcy.data.LoadDataSerial;
	import net.satcy.flare.core.UV;
	import net.satcy.flare.core.Vertex;
	import net.satcy.util.DelayFunction;
	
	public class OBJLoader extends Mesh3D
	{
		private var _lastMtlID:String;
		
		private var _mtlLib:Boolean = false;
		private var _mtlLibLoaded:Boolean = false;
		
		private var _materialIDs:Vector.<String> = new Vector.<String>();
		
		private var _path_prefix:String = "";
		
		private var _materialLoaded:Vector.<LoadedMaterial>;
		private var _materialSpecularData:Vector.<SpecularFilter>;
		
		private var _objects:Vector.<ObjectGroup>;
		
		private var _currentObject:ObjectGroup;
		private var _currentGroup:Group;
		private var _currentMaterialGroup:MaterialGroup;
		
		private var _activeMaterialID:String = "";
		
		private var _vertexIndex:uint;
		private var _vertices:Vector.<Vertex>;
		private var _vertexNormals:Vector.<Vertex>;
		private var _uvs:Vector.<UV>;
		
		
		private var _startedParsing:Boolean = false;
		
		private var _ld:LoadDataSerial;
		private var _img_cnt:int = 0;
		
		private var _temp_wire:DebugWireframe;
		
		private var _ignoreMtl:Boolean = false;
		
		private var _apply_materials_delay_sec:Number = 0;
		
		public var offset:Vector3D = new Vector3D();
		
		public function OBJLoader(auto_dispose_remove_from_scene:Boolean = false, ignoreMtl:Boolean = false, apply_materials_delay_sec:Number = 0)
		{
			if ( auto_dispose_remove_from_scene ) 
				this.addEventListener(Pivot3D.ADDED_TO_SCENE_EVENT, onAdd);
			
			_ignoreMtl = ignoreMtl;
			_apply_materials_delay_sec = apply_materials_delay_sec;
		}
		
		private function onAdd(e:Event):void{
			this.removeEventListener(Pivot3D.ADDED_TO_SCENE_EVENT, onAdd);
			this.addEventListener(Pivot3D.REMOVED_FROM_SCENE_EVENT, onRemove);
		}
		
		private function onRemove(e:Event):void{
			this.removeEventListener(Pivot3D.REMOVED_FROM_SCENE_EVENT, onRemove);
			this.dispose();
		}
		
		override public function dispose():void{
			super.dispose();
			_currentObject = null;
			if ( _ld ) _ld.destroy();
			_ld = null;
			_vertices = null;
			_vertexNormals = null;
			_uvs = null;
			_materialSpecularData = null;
			_materialLoaded = null;
			_objects = null;
		}
		
		public function load(path:String, func:Function = null, error:Function = null):void{
			var ld:URLLoader = new URLLoader();
			ld.addEventListener(Event.COMPLETE, _onComp);
			ld.addEventListener(IOErrorEvent.IO_ERROR, _onError);
			var req:URLRequest = new URLRequest(path);
			ld.load(req);
			_path_prefix = req.url.substring(0, req.url.lastIndexOf("/")+1);
			
			function _onComp(e:Event):void{
				ld.removeEventListener(Event.COMPLETE, _onComp);
				ld.removeEventListener(IOErrorEvent.IO_ERROR, _onError);
				
				parse(ld.data as String);
				
				if ( func != null ) func();
			}
			
			function _onError(e:Event):void{
				ld.removeEventListener(Event.COMPLETE, _onComp);
				ld.removeEventListener(IOErrorEvent.IO_ERROR, _onError);
				
				if ( error != null ) error(e);
			}
		}
		
		public function loadCompressData(path:String, func:Function = null, error:Function = null):void{
			var ld:URLLoader = new URLLoader();
			ld.addEventListener(Event.COMPLETE, _onComp);
			ld.addEventListener(IOErrorEvent.IO_ERROR, _onError);
			ld.dataFormat = URLLoaderDataFormat.BINARY;
			var req:URLRequest = new URLRequest(path);
			ld.load(req);
			_path_prefix = req.url.substring(0, req.url.lastIndexOf("/")+1);
			
			
			function _onComp(e:Event):void{
				ld.removeEventListener(Event.COMPLETE, _onComp);
				ld.removeEventListener(IOErrorEvent.IO_ERROR, _onError);
				var ba:ByteArray = ByteArray(ld.data);
				ba.uncompress();
				var s:String = ba.readUTFBytes(ba.length);
				PerfumeDecoder.getInstance().decode(s);
				parse(PerfumeDecoder.getInstance().decode(s));
				
				if ( func != null ) func();
			}
			
			function _onError(e:Event):void{
				ld.removeEventListener(Event.COMPLETE, _onComp);
				ld.removeEventListener(IOErrorEvent.IO_ERROR, _onError);
				
				if ( error != null ) error(e);
			}
		}
		
		protected function parse(str:String):void{
			str = str.replace(/\\[\r\n]+\s*/gm, ' ');
			
			var line:String;
			var creturn:String = String.fromCharCode(10);
			
			if (str.indexOf(creturn) == -1)
				creturn = String.fromCharCode(13);
				
			if (!_startedParsing) {
				_startedParsing = true;
				_vertices = new Vector.<Vertex>();
				_vertexNormals = new Vector.<Vertex>();
				_materialIDs = new Vector.<String>();
				_materialLoaded = new Vector.<LoadedMaterial>();
				//_meshes = new Vector.<Mesh>();
				_uvs = new Vector.<UV>();
				_objects = new Vector.<ObjectGroup>();
			}
				
			var lines:Array = str.split("\n");
			var l:int = lines.length;
			
			for ( var i:int = 0; i<l; i++ ) {
				line = lines[i];
				line = line.replace("  ", " ");
				parseLine(line.split(" "));
			}
			
			
			translate();
		}	
		
		private function translate():void
		{
			var i:int = 0;
			var l:int = _objects.length;
			var j:int = 0;
			
			
			var material:Shader3D = new Shader3D("", [new ColorFilter(0x0099FF*0, 1)]);
			//material.build();
			
			for ( i = 0; i<l; i++ ) {
				var group:ObjectGroup = _objects[i];
				var groups:Vector.<Group> = group.groups;
				var materialGroups:Vector.<MaterialGroup>;
				var numGroups:uint = groups.length;
				
				var numMaterialGroups:uint;
				
				//log("group name",group.name);
				
				for ( j=0; j<groups.length; j++ ) {
					var materialID:String = (groups[j] as Group).materialID;
					//log(materialID);
					materialGroups = groups[j].materialGroups;
					numMaterialGroups = materialGroups.length;
					
					for ( var k:int = 0; k<numMaterialGroups; k++ ) {
						var surface:Surface3DWithMaterialID = new Surface3DWithMaterialID();
						surface.name = group.name;
						surface.addVertexData( Surface3D.POSITION, 3 );
						surface.addVertexData( Surface3D.NORMAL, 3 );
						surface.addVertexData( Surface3D.UV0, 2 );
						surface.materialID = materialID;
						surface.material = material;
						this.surfaces.push(surface);
						translateMaterialGroup((materialGroups[k] as MaterialGroup), surface);
					}
				}
			}
			if ( this._ignoreMtl ) {
				dispatchEvent(new Event(Event.COMPLETE, true, true));
			}
			if ( _mtlLib ) {
				_temp_wire = new DebugWireframe(this, 0xFFFFFF, 1);
				this.addChild(_temp_wire);
			}
		}
		
		private function translateMaterialGroup(materialGroup:MaterialGroup, surface:Surface3D):void{
			var faces:Vector.<FaceData> = materialGroup.faces;
			var face:FaceData;
			var numFaces:uint = faces.length;
			var numVerts:uint;
			
			var vertices:Vector.<Number> = new Vector.<Number>();
			var uvs:Vector.<Number> = new Vector.<Number>();
			var normals:Vector.<Number> = new Vector.<Number>();
			var indices:Vector.<uint> = new Vector.<uint>();
			
			_vertexIndex = 0;
			
			var j:uint;
			for (var i:uint = 0; i < numFaces; ++i) {
				face = faces[i];
				numVerts = face.vertexIndices.length;
				
				var v1:Vertex;
				var n1:Vertex;
				var uv1:UV;
				for ( j = 0; j<numVerts; j++ ) {
					v1 = this._vertices[face.vertexIndices[j] - 1];
					
					if ( face.normalIndices.length == numVerts ) {
						n1 = this._vertexNormals[face.normalIndices[j] - 1];
					} else {
						n1 = new Vertex(0, 1, 0);
					}
					if ( face.uvIndices.length == numVerts ) {
						uv1 = this._uvs[face.uvIndices[j] - 1];
					} else {
						uv1 = new UV(0,0);
					}
					
					surface.vertexVector.push(v1.x, v1.y, v1.z, n1.x, n1.y, n1.z, uv1.u, uv1.v);
				}
				if ( numVerts == 3 ) surface.indexVector.push(i*3 + 0, i*3 + 2, i*3 + 1);
				else if ( numVerts == 4 ) surface.indexVector.push(i*4 + 0, i*4 + 2, i*4 + 3,  i*4 + 1);
			}
			
			
		}
		
		private function parseLine(trunk:Array):void{
			//log(trunk[0]);
			switch (trunk[0]) {
				case "mtllib":
					if ( _ignoreMtl ) {
						_mtlLib = false;
						_mtlLibLoaded = true;
					} else {
						_mtlLib = true;
						_mtlLibLoaded = false;
						loadMtl(trunk[1]);
					}
					break;
				case "g":
					createGroup(trunk);
					break;
				case "o":
					createObject(trunk);
					break;
				case "usemtl":
					if (_mtlLib) {
						if (!trunk[1])
							trunk[1] = "def000";
						_materialIDs.push(trunk[1]);
						_activeMaterialID = trunk[1];
						if (_currentGroup)
							_currentGroup.materialID = _activeMaterialID;
					}
					break;
				case "v":
					parseVertex(trunk);
					break;
				case "vt":
					parseUV(trunk);
					break;
				case "vn":
					parseVertexNormal(trunk);
					break;
				case "f":
					parseFace(trunk);
					break;
			}
		}
		
		
		
		
		
		private function loadMtl(path:String):void{
			var ld:URLLoader = new URLLoader();
			ld.addEventListener(Event.COMPLETE, _onComp);
			ld.load(new URLRequest(_path_prefix + path));
			
			function _onComp(e:Event):void{
				ld.removeEventListener(Event.COMPLETE, _onComp);
				parseMtl(ld.data as String);
			}
		}
		
		
		private function createGroup(trunk:Array):void{
			if (!_currentObject)
				createObject(null);
			_currentGroup = new Group();
			
			_currentGroup.materialID = _activeMaterialID;
			
			if (trunk)
				_currentGroup.name = trunk[1];
			_currentObject.groups.push(_currentGroup);
			
			createMaterialGroup(null);
			
		}
		
		private function createObject(trunk:Array):void{
			
			_currentGroup = null;
			_currentMaterialGroup = null;
			_objects.push(_currentObject = new ObjectGroup());
			
			if (trunk)
				_currentObject.name = trunk[1];
		}
		
		private function createMaterialGroup(trunk:Array):void
		{
			_currentMaterialGroup = new MaterialGroup();
			if (trunk)
				_currentMaterialGroup.url = trunk[1];
			_currentGroup.materialGroups.push(_currentMaterialGroup);
		}
		
		private function parseVertex(trunk:Array):void{
			//for the very rare cases of other delimiters/charcodes seen in some obj files
			if (trunk.length > 4) {
				var nTrunk:Array = [];
				var val:Number;
				for (var i:uint = 1; i < trunk.length; ++i) {
					val = parseFloat(trunk[i]);
					if (!isNaN(val))
						nTrunk.push(val);
				}
				_vertices.push(new Vertex(nTrunk[0] + offset.x, nTrunk[1] + offset.y, -nTrunk[2] + offset.z));
			} else
				_vertices.push(new Vertex(parseFloat(trunk[1]) + offset.x, parseFloat(trunk[2]) + offset.y, -parseFloat(trunk[3]) + offset.z));
		
		}
		
		private function parseUV(trunk:Array):void{
			if (trunk.length > 3) {
				var nTrunk:Array = [];
				var val:Number;
				for (var i:uint = 1; i < trunk.length; ++i) {
					val = parseFloat(trunk[i]);
					if (!isNaN(val))
						nTrunk.push(val);
				}
				_uvs.push(new UV(nTrunk[0], 1 - nTrunk[1]));
				
			} else
				_uvs.push(new UV(parseFloat(trunk[1]), 1 - parseFloat(trunk[2])));
		
		}
		
		private function parseVertexNormal(trunk:Array):void{
			if (trunk.length > 4) {
				var nTrunk:Array = [];
				var val:Number;
				for (var i:uint = 1; i < trunk.length; ++i) {
					val = parseFloat(trunk[i]);
					if (!isNaN(val))
						nTrunk.push(val);
				}
				_vertexNormals.push(new Vertex(nTrunk[0], nTrunk[1], -nTrunk[2]));
				
			} else
				_vertexNormals.push(new Vertex(parseFloat(trunk[1]), parseFloat(trunk[2]), -parseFloat(trunk[3])));
		
		}
		
		private function parseFace(trunk:Array):void{
			var len:uint = trunk.length;
			var face:FaceData = new FaceData();
			
			if (!_currentGroup)
				createGroup(null);
			
			var indices:Array;
			for (var i:uint = 1; i < len; ++i) {
				if (trunk[i] == "")
					continue;
				indices = trunk[i].split("/");
				face.vertexIndices.push(parseIndex(parseInt(indices[0]), _vertices.length));
				if (indices[1] && String(indices[1]).length > 0)
					face.uvIndices.push(parseIndex(parseInt(indices[1]), _uvs.length));
				if (indices[2] && String(indices[2]).length > 0)
					face.normalIndices.push(parseIndex(parseInt(indices[2]), _vertexNormals.length));
				face.indexIds.push(trunk[i]);
			}
			
			_currentMaterialGroup.faces.push(face);
		}
		
		private function parseIndex(index:int, length:uint):int
		{
			if (index < 0)
				return index + length + 1;
			else
				return index;
		}
		
		private function parseMtl(data:String):void{
			var materialDefinitions:Array = data.split('newmtl');
			var lines:Array;
			var trunk:Array;
			var j:uint;
			
			var basicSpecularMethod:SpecularFilter;
			var useSpecular:Boolean;
			var useColor:Boolean;
			var diffuseColor:uint;
			var ambientColor:uint;
			var specularColor:uint;
			var specular:Number;
			var alpha:Number;
			var mapkd:String;
			
			for (var i:uint = 0; i < materialDefinitions.length; ++i) {
				
				lines = (materialDefinitions[i].split('\r') as Array).join("").split('\n');
				
				if (lines.length == 1)
					lines = materialDefinitions[i].split(String.fromCharCode(13));
				//log(lines);
				diffuseColor = ambientColor = specularColor = 0xFFFFFF;
				specular = 0;
				useSpecular = false;
				useColor = false;
				alpha = 1;
				mapkd = "";
				var lm:LoadedMaterial;
				
				for (j = 0; j < lines.length; ++j) {
					lines[j] = lines[j].replace(/\s+$/, "");
					
					if (lines[j].substring(0, 1) != "#" && (j == 0 || lines[j] != "")) {
						trunk = lines[j].split(" ");
						
						if (String(trunk[0]).charCodeAt(0) == 9 || String(trunk[0]).charCodeAt(0) == 32)
							trunk[0] = trunk[0].substring(1, trunk[0].length);
						
						if (j == 0) {
							_lastMtlID = trunk.join("");
							_lastMtlID = (_lastMtlID == "")? "def000" : _lastMtlID;
							
							lm = new LoadedMaterial();
							lm.materialID = _lastMtlID;
							_materialLoaded.push(lm);
						} else {
							
							switch (trunk[0]) {
								
								case "Ka":
									if (trunk[1] && !isNaN(Number(trunk[1])) && trunk[2] && !isNaN(Number(trunk[2])) && trunk[3] && !isNaN(Number(trunk[3])))
										ambientColor = trunk[1]*255 << 16 | trunk[2]*255 << 8 | trunk[3]*255;
									break;
								
								case "Ks":
									if (trunk[1] && !isNaN(Number(trunk[1])) && trunk[2] && !isNaN(Number(trunk[2])) && trunk[3] && !isNaN(Number(trunk[3]))) {
										specularColor = trunk[1]*255 << 16 | trunk[2]*255 << 8 | trunk[3]*255;
										useSpecular = true;
									}
									break;
								
								case "Ns":
									if (trunk[1] && !isNaN(Number(trunk[1])))
										specular = Number(trunk[1])*0.001;
									if (specular == 0)
										useSpecular = false;
									break;
								
								case "Kd":
									if (trunk[1] && !isNaN(Number(trunk[1])) && trunk[2] && !isNaN(Number(trunk[2])) && trunk[3] && !isNaN(Number(trunk[3]))) {
										diffuseColor = trunk[1]*255 << 16 | trunk[2]*255 << 8 | trunk[3]*255;
										useColor = true;
									}
									break;
								
								case "tr":
								case "d":
									if (trunk[1] && !isNaN(Number(trunk[1])))
										alpha = Number(trunk[1]);
									break;
								
								case "map_Kd":
									mapkd = parseMapKdString(trunk);
									mapkd = mapkd.replace(/\\/g, "/");
									break;
								case "map_Ka":
									mapkd = parseMapKdString(trunk);
									mapkd = mapkd.replace(/\\/g, "/");
									break;
							}
						}
					}
				}
				if ( lm && !isNaN(ambientColor) ) {
					lm.color = new ColorFilter(ambientColor);
				}
				if (mapkd != "") {
					//var lm:LoadedMaterial = new LoadedMaterial();
					//lm.materialID = _lastMtlID;
					if (useSpecular) {
						
						
						lm.specular = new SpecularFilter(specular);
						
					}
					
					addDependency(_lastMtlID, _path_prefix + mapkd);
					
				} else if (useColor && !isNaN(diffuseColor)) {
					
					
					//var lm:LoadedMaterial = new LoadedMaterial();
					//lm.materialID = _lastMtlID;
					
					lm.color = new ColorFilter(diffuseColor);
					
					
					//applyMaterial(lm);
					
				}
			}
			
			
			_mtlLibLoaded = true;
			
			if ( _img_cnt == 0 ) {
				applyMaterials();
			}
		}
		
		private function addDependency(id:String, path:String):void{
			if ( !_materialLoaded ) return;
			if ( !_ld ) {
				_ld = new LoadDataSerial(false, false);
			}
			_img_cnt++;
			_ld.addLoader(path, function(ld:Loader):void{
				if ( !_materialLoaded ) return;
				var tex:Texture3D = new Texture3D();
				tex.bitmapData = (ld.content as Bitmap).bitmapData;
				var tex_filter:TextureMapFilter = new TextureMapFilter(tex);
				
				for ( var i:int = 0; i<_materialLoaded.length; i++ ) {
					if ( _materialLoaded[i].materialID == id ) {
						_materialLoaded[i].texture = tex_filter;
						break;
					}
				}
				
				_img_cnt--;
				if ( _img_cnt == 0 ) {
					applyMaterials();
				}
			});
			//new LoadDataSerial().addLoader(
		}
		
		private function applyMaterial(lm:LoadedMaterial):void{
			if ( _materialLoaded == null ) return;
			for ( var i:int = 0; i<surfaces.length; i++ ) {
				if ( surfaces[i] is Surface3DWithMaterialID ) {
					if ( (surfaces[i] as Surface3DWithMaterialID).materialID == lm.materialID ) {
						
						if ( !lm.material ) {
							if ( lm.texture ) {
								lm.texture.texture.mipMode = 0;
								lm.material = new Shader3D(lm.materialID, [lm.texture]);
							} else if ( lm.color && lm.specular ) lm.material = new Shader3D(lm.materialID, [lm.color, lm.specular]);
							else if ( lm.color ) lm.material = new Shader3D(lm.materialID, [lm.color]);
						}
						if ( lm.material ) {
							lm.material.blendMode = 4;
							lm.material.transparent = true;
							lm.material.twoSided = true;
							(surfaces[i] as Surface3DWithMaterialID).material = lm.material;
						}
					}
				}
			}
		}
		
		private function disposeTempWireframe():void{
			if ( _temp_wire && _temp_wire.parent ) {
				_temp_wire.parent = null;
				_temp_wire.dispose();
				_temp_wire = null;
			}
		}
		
		private function applyMaterials():void{
			if ( this._apply_materials_delay_sec > 0 ) {
				var delay:Number = _apply_materials_delay_sec;
				for (var i:uint = 0; i < _materialLoaded.length; ++i) {
					new DelayFunction(delay*1000, this, applyMaterial, _materialLoaded[i]);
					delay += _apply_materials_delay_sec;
				}
				new DelayFunction(delay*1000, this, function():void{
					disposeTempWireframe();
					dispatchEvent(new Event(Event.COMPLETE, true, true));
				});
			} else {
				
				disposeTempWireframe();
				if (_materialLoaded.length == 0) {
					
					return;
				}
				
				for (var j:uint = 0; j < _materialLoaded.length; ++j)
					applyMaterial(_materialLoaded[j]);
				
				
				dispatchEvent(new Event(Event.COMPLETE, true, true));
			}
		}
		
		private function parseMapKdString(trunk:Array):String
		{
			var url:String = "";
			var i:int;
			var breakflag:Boolean;
			
			for (i = 1; i < trunk.length; ) {
				switch (trunk[i]) {
					case "-blendu":
					case "-blendv":
					case "-cc":
					case "-clamp":
					case "-texres":
						i += 2; //Skip ahead 1 attribute
						break;
					case "-mm":
						i += 3; //Skip ahead 2 attributes
						break;
					case "-o":
					case "-s":
					case "-t":
						i += 4; //Skip ahead 3 attributes
						continue;
					default:
						breakflag = true;
						break;
				}
				
				if (breakflag)
					break;
			}
			
			//Reconstruct URL/filename
			for (i; i < trunk.length; i++) {
				url += trunk[i];
				url += " ";
			}
			
			//Remove the extraneous space and/or newline from the right side
			url = url.replace(/\s+$/, "");
			
			return url;
		}
	}
}

	import flare.materials.Shader3D;
	import flare.core.Texture3D;
	import flare.materials.filters.SpecularFilter;
	import flare.materials.filters.TextureMapFilter;
	import flare.materials.filters.ColorFilter;
	import __AS3__.vec.Vector;
	import flare.core.Surface3D;
	
class ObjectGroup
{
	public var name:String;
	public var groups:Vector.<Group> = new Vector.<Group>();
	
	public function ObjectGroup()
	{
	}
}

class Group
{
	public var name:String;
	public var materialID:String;
	public var materialGroups:Vector.<MaterialGroup> = new Vector.<MaterialGroup>();
	
	public function Group()
	{
	}
}


class MaterialGroup
{
	public var url:String;
	public var faces:Vector.<FaceData> = new Vector.<FaceData>();
	
	public function MaterialGroup()
	{
	}
}

class SpecularData
{
	public var materialID:String;
	public var basicSpecularMethod:Shader3D;
	public var ambientColor:uint = 0xFFFFFF;
	public var alpha:Number = 1;
	
	public function SpecularData()
	{
	}
}
	
class LoadedMaterial
{
	
	public var materialID:String;
	public var material:Shader3D;
	public var texture:TextureMapFilter;
	public var color:ColorFilter;
	public var specular:SpecularFilter;
	public var alpha:Number = 1;
	
	public function LoadedMaterial()
	{
	}
}

class FaceData
{
	public var vertexIndices:Vector.<uint> = new Vector.<uint>();
	public var uvIndices:Vector.<uint> = new Vector.<uint>();
	public var normalIndices:Vector.<uint> = new Vector.<uint>();
	public var indexIds:Vector.<String> = new Vector.<String>(); // used for real index lookups
	
	public function FaceData()
	{
	}

}