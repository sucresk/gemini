package gemini.gemini3D.parsers 
{
	import flash.display3D.Context3D;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ...
	 */
	public class ObjParser 
	{
		//private const NEWLINE:String = "\r\n";
		private const NEWLINE:String = String.fromCharCode(10);
		private const SEPARATION:String = " ";
		private const VERTEX:String = "v";
		private const TEXTURE:String = "vt";
		private const FACE:String = "f";
		
		private var _vertices:Vector.<Number>;
		private var _uvs:Vector.<Number>;
		private var _index:Vector.<uint>;
		private var _uvIndex:Vector.<uint>;
		private var vertexBuff3D:VertexBuffer3D;
		private var context3D:Context3D;
		private var indexBuff3D:IndexBuffer3D;
		private var uvBuffer3D:VertexBuffer3D;
		
		public function ObjParser(data:*, context3D:Context3D) 
		{
			_vertices = new Vector.<Number>();
			_uvs = new Vector.<Number>();
			_index = new Vector.<uint>();
			_uvIndex = new Vector.<uint>();
			
			var conArr:Array
			if (data is String)
			{
				conArr = String(data).split(NEWLINE);
				handlerStrArr(conArr);
			}
			else if (data is ByteArray)
			{
				var str:String = ByteArray(data).readUTFBytes(ByteArray(data).bytesAvailable);
				conArr = str.split(NEWLINE);
				handlerStrArr(conArr)
			}
			this.context3D = context3D;
		}
		
		private function handlerStrArr(strArr:Array):void
		{
			for (var i:int = 0, len:int = strArr.length; i < len; i++)
			{
				var elements:Array = strArr[i].split(SEPARATION);
				switch(elements[0])
				{
					case VERTEX:
						vertexHandler(elements);
						break;
					case TEXTURE:
						textureHandler(elements);
						break;
					case FACE:
						faceHandler(elements);
						break;
				}
			}
		}
		
		private function vertexHandler(elements:Array):void
		{
			for (var i:int = 1, len:int = elements.length; i < len; i++)
			{
				if (elements[i] != "" && elements[i] != VERTEX)
				{
					_vertices.push(Number(elements[i]));
				}
			}
		}
		
		private function textureHandler(elements:Array):void
		{
			for (var i:int = 1, len:int = elements.length; i < len; i++)
			{
				if (elements[i] != "" && elements[i] != TEXTURE)
				{
					_uvs.push(Number(elements[i]));
				}
			}
		}
		
		private function faceHandler(elements:Array):void
		{
			var preElements:Array
			for (var i:int = 1, len:int = elements.length; i < len; i++)
			{
				if (elements[i] != "" && elements[i] != FACE)
				{
					preElements = elements[i].split("\/");
					_index.push(preElements[0] - 1);
					_uvIndex.push(preElements[1] - 1);
				}
			}
		}
		
		public function get positionBuffer():VertexBuffer3D
		{
			if ( vertexBuff3D != null)
			{
				return vertexBuff3D;
			}
			var vertexCount:int = _vertices.length / 3;
			vertexBuff3D = context3D.createVertexBuffer(vertexCount, 3);
			vertexBuff3D.uploadFromVector(_vertices, 0, vertexCount);
			return vertexBuff3D;
		}
		
		public function get indexBuffer():IndexBuffer3D
		{
			if ( indexBuff3D != null)
			{
				return indexBuff3D;
			}
			indexBuff3D = context3D.createIndexBuffer(_index.length);
			indexBuff3D.uploadFromVector(_index, 0, _index.length);
			return indexBuff3D;
		}
		
		public function get uvBuffer():VertexBuffer3D
		{
			if (uvBuffer3D != null)
			{
				return uvBuffer3D;
			}
			var uvBufferVec:Vector.<Number> = new Vector.<Number>(_vertices.length);
			
			for ( var i:int = 0; i < _uvIndex.length; i++)
			{
				uvBufferVec[_index[i] * 2] = _uvs[_uvIndex[i] * 3];
				uvBufferVec[_index[i] * 2 + 1] = _uvs[_uvIndex[i] * 3 + 1];
			}
			var uvsCount:int = uvBufferVec.length / 2;
			uvBuffer3D = context3D.createVertexBuffer(uvsCount, 2);
			uvBuffer3D.uploadFromVector(uvBufferVec, 0, uvsCount);
			return uvBuffer3D;
		}
		
		public function get vertices():Vector.<Number> 
		{
			return _vertices;
		}
		
		public function get uvs():Vector.<Number> 
		{
			return _uvs;
		}
		
		public function get index():Vector.<uint> 
		{
			return _index;
		}
		
		public function get uvIndex():Vector.<uint> 
		{
			return _uvIndex;
		}
		
	}
}