package gemini.gemini3D.parsers 
{
	import flash.display3D.Context3D;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	/**
	 * ...这个类在vertextBuffer NormalBuffer有冗余，
	 * 效率不高。每个点在每个三角形的位置都会保存一遍
	 * @author gemini
	 */
	public class ObjParser2 
	{
		private var _vertexDataIsZxy:Boolean = false;
		private var _mirrorUv:Boolean = false;
		private var _randomVertexColors:Boolean = true;
		
		private const LINE_FEED:String = String.fromCharCode(10);
		private const SPACE:String = String.fromCharCode(32);
		private const SLASH:String = "/";
		private const VERTEX:String = "v";
		private const NORMAL:String = "vn";
		private const UV:String = "vt";
		private const INDEX_DATA:String = "f";
		
		private var _scale:Number;
		private var _faceIndex:uint;
		private var _vertices:Vector.<Number>;
		private var _normals:Vector.<Number>;
		private var _uvs:Vector.<Number>;
		private var _cachedRawNormalsBuffer:Vector.<Number>;
		
		protected var _rawIndexBuffer:Vector.<uint>;
		protected var _rawPositionsBuffer:Vector.<Number>;
		protected var _rawUvBuffer:Vector.<Number>;
		protected var _rawNormalsBuffer:Vector.<Number>;
		protected var _rawColorsBuffer:Vector.<Number>;
		
		protected var _indexBuffer:IndexBuffer3D;
		protected var _positionsBuffer:VertexBuffer3D;
		protected var _uvBuffer:VertexBuffer3D;
		protected var _normalsBuffer:VertexBuffer3D;
		protected var _colorsBuffer:VertexBuffer3D;
		
		private var _context3d:Context3D;
		
		
		public function ObjParser2(objData:*, acontext:Context3D, scale:Number = 1,dataIsZxy:Boolean = false, textureFlip:Boolean = false) 
		{
			_vertexDataIsZxy = dataIsZxy;
			_mirrorUv = textureFlip;
			
			_rawColorsBuffer = new Vector.<Number>();
			_rawIndexBuffer = new Vector.<uint>();
			_rawPositionsBuffer = new Vector.<Number>();
			_rawUvBuffer = new Vector.<Number>();
			_rawNormalsBuffer = new Vector.<Number>();
			_scale = scale;
			_context3d = acontext;
			
			var definition:String = readData(objData);
			
			_vertices = new Vector.<Number>();
			_normals = new Vector.<Number>();
			_uvs = new Vector.<Number>();
			
			var lines:Array = definition.split(LINE_FEED);
			var loop:uint = lines.length;
			for (var i:uint = 0; i < loop; ++i)
			{
				parseLine(lines[i]);
			}
		}
		
		private function readData(objData:*):String
		{
			if (objData is ByteArray)
			{
				return ByteArray(objData).readUTFBytes(ByteArray(objData).bytesAvailable);
			}
			
			return "";
		}
		
		private function parseLine(line:String):void
		{
			var words:Array = line.split(SPACE);
			
			if (words.length > 0)
			{
				var data:Array = words.slice(1);
			}
			else
				return;
				
			var firstWord:String = words[0];
			switch(firstWord)
			{
				case VERTEX:
					parseVertex(data);
					break;
				case NORMAL:
					parseNormal(data);
					break;
				case UV:
					parseUV(data);
					break;
				case INDEX_DATA:
					parseIndex(data);
					break;
			}
		}
		
		private function parseVertex(data:Array):void
		{
			if (data[0] == "" || data[0] == " ")
			{
				data = data.slice(1);
			}
			if (_vertexDataIsZxy)
			{
				_vertices.push(Number(data[1]) * _scale);
				_vertices.push(Number(data[2]) * _scale);
				_vertices.push(Number(data[0]) * _scale);
			}
			else
			{
				var loop:uint = data.length;
				if (loop > 3)
					loop = 3;
				for (var i:uint = 0; i < loop; ++i)
				{
					_vertices.push(Number(data[i]) * _scale);
				}
			}
		}
		
		private function parseNormal(data:Array):void
		{
			if (data[0] == "" || data[0] == " ")
			{
				data = data.slice(1);
			}
			var loop:uint = data.length;
			if (loop > 3)
				loop = 3;
			for ( var i:uint = 0; i < loop; ++i)
			{
				var element:String = data[i];
				if (element != null)
				{
					_normals.push(Number(element));
				}
			}
		}
		
		private function parseUV(data:Array):void
		{
			if (data[0] == "" || data[0] == " ")
			{
				data = data.slice(1);
			}
			var loop:uint = data.length;
			if (loop > 2) 
				loop = 2;
			for (var i:uint = 0; i < loop; ++i)
			{
				_uvs.push(Number(data[i]));
			}
		}
		
		private function parseIndex(data:Array):void
		{
			var triplet:String;
			var subdata:Array;
			var vertexIndex:int;
			var uvIndex:int;
			var normalIndex:int;
			var index:uint;
			
			var i:uint;
			var loop:uint = data.length;
			var starthere:uint = 0;
			while (data[starthere] == "" || data[starthere] == " ")
			{
				++starthere;
			}
			loop = starthere + 3;
			for ( i = starthere; i < loop; ++i)
			{
				triplet = data[i];
				subdata = triplet.split(SLASH);
				vertexIndex = int(subdata[0]) - 1;
				uvIndex = int(subdata[1]) - 1;
				normalIndex = int(subdata[2]) - 1;
				if (vertexIndex < 0)
					vertexIndex = 0;
				if (uvIndex < 0)
					uvIndex = 0;
				if (normalIndex < 0)
					normalIndex = 0;
					
				index = 3 * vertexIndex;
				_rawPositionsBuffer.push(_vertices[index],
										 _vertices[index + 1],
										 _vertices[index + 2]);
				if (_randomVertexColors)
				{
					_rawColorsBuffer.push(Math.random(),
										  Math.random(),
										  Math.random(),
										  1);
				}
				else
				{
					_rawColorsBuffer.push(1, 1, 1, 1);
				}
				
				if (_normals.length > 0)
				{
					index = 3 * normalIndex;
					_rawNormalsBuffer.push(_normals[index],
										   _normals[index + 1],
										   _normals[index + 2]);
				}
				
				index = 2 * uvIndex;
				if (_mirrorUv)
				{
					_rawUvBuffer.push(_uvs[index],
									  1 - _uvs[index + 1]);
				}
				else 
				{
					_rawUvBuffer.push(1 - _uvs[index],
									  1 - _uvs[index + 1]);
				}					  
			}
			_rawIndexBuffer.push(_faceIndex, _faceIndex + 1, _faceIndex + 2);
			_faceIndex += 3;
		}
		
		public function get colorsBuffer():VertexBuffer3D
		{
			if (!_colorsBuffer)
				updateColorsBuffer();
			return _colorsBuffer;
		}
		
		public function get positionsBuffer():VertexBuffer3D
		{
			if (!_positionsBuffer)
				updateVertexBuffer();
			return _positionsBuffer;
		}
		
		public function get indexBuffer():IndexBuffer3D
		{
			if (!_indexBuffer)
				updateIndexBuffer();
			return _indexBuffer;
		}
		
		public function get indexBufferCount():int
		{
			return _rawIndexBuffer.length / 3;
		}
		
		public function get uvBuffer():VertexBuffer3D
		{
			if (!_uvBuffer)
				updateUvBuffer();
			return _uvBuffer;
		}
		
		public function get normalsBuffer():VertexBuffer3D
		{
			if (!_normalsBuffer)
				updateNormalsBuffer();
			return _normalsBuffer;
		}
		
		public function updateColorsBuffer():void
		{
			if (_rawColorsBuffer.length == 0)
				throw new Error("no color data");
			var colorsCount:uint = _rawColorsBuffer.length / 4;
			_colorsBuffer = _context3d.createVertexBuffer(colorsCount, 4);
			_colorsBuffer.uploadFromVector(_rawColorsBuffer, 0, colorsCount);
		}
		
		public function updateNormalsBuffer():void
		{
			if (_rawNormalsBuffer.length == 0)
				forceNormals();
			if (_rawNormalsBuffer.length == 0)
				throw new Error("no normal data");
			var count:uint = _rawNormalsBuffer.length / 3;
			_normalsBuffer = _context3d.createVertexBuffer(count, 3);
			_normalsBuffer.uploadFromVector(_rawNormalsBuffer, 0, count);
		}
		
		public function updateVertexBuffer():void
		{
			if (_rawPositionsBuffer.length == 0)
				throw new Error("no vertex data");
			var count:uint = _rawPositionsBuffer.length / 3;
			_positionsBuffer = _context3d.createVertexBuffer(count, 3);
			_positionsBuffer.uploadFromVector(_rawPositionsBuffer, 0, count);
		}
		
		public function updateUvBuffer():void
		{
			if (_rawUvBuffer.length == 0)
				throw new Error("no uv data");
			var count:uint = _rawUvBuffer.length / 2;
			_uvBuffer = _context3d.createVertexBuffer(count, 2);
			_uvBuffer.uploadFromVector(_rawUvBuffer, 0, count);
		}
		
		public function updateIndexBuffer():void
		{
			if (_rawIndexBuffer.length == 0)
				throw new Error("no index data");
			_indexBuffer = _context3d.createIndexBuffer(_rawIndexBuffer.length);
			_indexBuffer.uploadFromVector(_rawIndexBuffer, 0, _rawIndexBuffer.length);
		}
		
		public function restoreNormals():void
		{
			_rawNormalsBuffer = _cachedRawNormalsBuffer.concat();
		}
		/**
		 * 求面的法线
		 * @param	p0
		 * @param	p1
		 * @param	p2
		 * @return 
		 */
		public function get3PointNormal(p0:Vector3D, p1:Vector3D, p2:Vector3D):Vector3D
		{
			var p0p1:Vector3D = p1.subtract(p0);
			var p0p2:Vector3D = p2.subtract(p0);
			var normal:Vector3D = p0p1.crossProduct(p0p2);
			normal.normalize();
			return normal;
		}
		
		public function forceNormals():void
		{
			_cachedRawNormalsBuffer = _rawNormalsBuffer.concat();
			var i:uint;
			var index:uint;
			var loop:uint = _rawPositionsBuffer.length / 3;
			var vertices:Vector.<Vector3D> = new Vector.<Vector3D>();
			var vertex:Vector3D;
			for ( i = 0; i < loop; ++i)
			{
				index = 3 * i;
				vertex = new Vector3D(_rawPositionsBuffer[index],
									  _rawPositionsBuffer[index + 1],
									  _rawPositionsBuffer[index + 2]);
				vertices.push(vertex);
			}
			loop = vertices.length;
			var p0:Vector3D;
			var p1:Vector3D;
			var p2:Vector3D;
			var normal:Vector3D;
			_rawNormalsBuffer = new Vector.<Number>();
			for (i = 0; i < loop; i += 3)
			{
				p0 = vertices[i];
				p1 = vertices[i + 1];
				p2 = vertices[i + 2];
				normal = get3PointNormal(p0, p1, p2);
				_rawNormalsBuffer.push(normal.x, normal.y, normal.z);
				_rawNormalsBuffer.push(normal.x, normal.y, normal.z);
				_rawNormalsBuffer.push(normal.x, normal.y, normal.z);
			}
		}
		
		public function dataDumpTrace():void
		{
			trace(dataDumpString());
		}
		
		private function dataDumpString():String
		{
			var str:String;
			str = "// Stage3d Model Data begins\n\n";
			str += "private var _Index:Vector.<uint> ";
			str += "= new Vector.<uint>([";
			str += _rawIndexBuffer.toString();
			str += "]);\n\n";

			str += "private var _Positions:Vector.<Number> ";
			str += "= new Vector.<Number>([";
			str += _rawPositionsBuffer.toString();
			str += "]);\n\n";
			str += "private var _UVs:Vector.<Number> = ";
			str += "new Vector.<Number>([";
			str += _rawUvBuffer.toString();
			str += "]);\n\n";
			str += "private var _Normals:Vector.<Number> = ";
			str += "new Vector.<Number>([";
			str += _rawNormalsBuffer.toString();
			str += "]);\n\n";
			str += "private var _Colors:Vector.<Number> = ";
			str += "new Vector.<Number>([";
			str += _rawColorsBuffer.toString();
			str += "]);\n\n";

			str += "// Stage3d Model Data ends\n";
			return str;
		}
	}

}