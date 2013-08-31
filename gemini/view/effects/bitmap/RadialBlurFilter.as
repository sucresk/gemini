package  gemini.view.effects.bitmap 
{
	import flash.display.DisplayObject;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import ghostcat.events.OperationEvent;
	import pbjAS.ops.OpAbs;
	import pbjAS.ops.OpACos;
	import pbjAS.ops.OpAdd;
	import pbjAS.ops.OpDiv;
	import pbjAS.ops.OpMatrixMatrixMult;
	import pbjAS.ops.OpMatrixVectorMult;
	import pbjAS.ops.OpMov;
	import pbjAS.ops.OpMul;
	import pbjAS.ops.OpSampleLinear;
	import pbjAS.ops.OpSampleNearest;
	import pbjAS.ops.OpSub;
	import pbjAS.ops.OpVectorMatrixMult;
	import pbjAS.params.Parameter;
	import pbjAS.params.Texture;
	import pbjAS.PBJ;
	import pbjAS.PBJAssembler;
	import pbjAS.PBJChannel;
	import pbjAS.PBJParam;
	import pbjAS.PBJType;
	import pbjAS.regs.RFloat;
	
	/**
	 * ...
	 * @author gemini
	 */
	public class RadialBlurFilter
	{
		private static var _instance:RadialBlurFilter;
		public static function get instance():RadialBlurFilter
		{
			if (_instance == null)
				_instance = new RadialBlurFilter();
			return _instance;
		}
		
		private var _version:int = 1;
		private var _name:String = "thresholdFillter";
		private var _shader:Shader;
		private var _filter:ShaderFilter;
		private var _target:DisplayObject;
		private var _layer:int = 0;
		private var _center:Point;
		
		public function RadialBlurFilter() 
		{
			
		}
		
		private function create():ShaderFilter
		{
			//if (_filter == null)
			{
				var pbj:PBJ = new PBJ();
				pbj.version = _version;
				pbj.name = _name;
				pbj.parameters = [
									new PBJParam("_OutCoord", new Parameter(PBJType.TFloat2, false, new RFloat(0, [PBJChannel.R, PBJChannel.G]))),
									new PBJParam("src", new Texture(4, 0)),
									new PBJParam("des", new Parameter(PBJType.TFloat4, true, new RFloat(1))),
									new PBJParam("threshold", new Parameter(PBJType.TFloat2, false, new RFloat(2,[PBJChannel.R,PBJChannel.G]))),
									new PBJParam("mtx",new Parameter(PBJType.TFloat2x2,false,new RFloat(3))),
									new PBJParam("two",new Parameter(PBJType.TFloat,false,new RFloat(4)))
								 ]
				pbj.code = [
							new OpMov(new RFloat(6, [PBJChannel.R, PBJChannel.G]), new RFloat(0, [PBJChannel.R, PBJChannel.G])),
							new OpSub(new RFloat(6, [PBJChannel.R, PBJChannel.G]), new RFloat(2,[PBJChannel.R, PBJChannel.G])),
							new OpVectorMatrixMult(new RFloat(6, [PBJChannel.R, PBJChannel.G]), new RFloat(3, [PBJChannel.M2x2])),
							new OpAdd(new RFloat(6,[PBJChannel.R,PBJChannel.G]),new RFloat(2,[PBJChannel.R,PBJChannel.G])),
							new OpSampleNearest(new RFloat(7), new RFloat(6, [PBJChannel.R, PBJChannel.G]), 0),
							new OpMul(new RFloat(7,[PBJChannel.A]), new RFloat(3,[PBJChannel.R])),
							new OpSampleNearest(new RFloat(1), new RFloat(0, [PBJChannel.R, PBJChannel.G]), 0),
							new OpAdd(new RFloat(1), new RFloat(7)),
							//new OpDiv(new RFloat(1, [PBJChannel.R, PBJChannel.G, PBJChannel.B]), new RFloat(4, [PBJChannel.R])),
							
							//new OpSub(new RFloat(6, [PBJChannel.R, PBJChannel.G]), new RFloat(2,[PBJChannel.R, PBJChannel.G])),
							//new OpVectorMatrixMult(new RFloat(6, [PBJChannel.R, PBJChannel.G]), new RFloat(3, [PBJChannel.M2x2])),
							//new OpAdd(new RFloat(6,[PBJChannel.R,PBJChannel.G]),new RFloat(2,[PBJChannel.R,PBJChannel.G])),
							//new OpSampleNearest(new RFloat(7), new RFloat(6, [PBJChannel.R, PBJChannel.G]), 0),
							//new OpAdd(new RFloat(1), new RFloat(7)),
							//new OpDiv(new RFloat(1, [PBJChannel.R, PBJChannel.G, PBJChannel.B]), new RFloat(4, [PBJChannel.R])),

							// 效果不太好的
							//new OpMov(new RFloat(6, [PBJChannel.R, PBJChannel.G]), new RFloat(0, [PBJChannel.R, PBJChannel.G])),
							//new OpVectorMatrixMult(new RFloat(6, [PBJChannel.R, PBJChannel.G]), new RFloat(3, [PBJChannel.M2x2])),
							//new OpAdd(new RFloat(6,[PBJChannel.R,PBJChannel.G]),new RFloat(2,[PBJChannel.R,PBJChannel.G])),
							//new OpSampleLinear(new RFloat(7), new RFloat(6, [PBJChannel.R, PBJChannel.G]), 0),
							//new OpSampleLinear(new RFloat(1), new RFloat(0, [PBJChannel.R, PBJChannel.G]), 0),
							//new OpAdd(new RFloat(1), new RFloat(7)),
							//new OpDiv(new RFloat(1, [PBJChannel.R, PBJChannel.G, PBJChannel.B]), new RFloat(4, [PBJChannel.R])),
							
							//new OpVectorMatrixMult(new RFloat(6, [PBJChannel.R, PBJChannel.G]), new RFloat(3, [PBJChannel.M2x2])),
							//new OpAdd(new RFloat(6,[PBJChannel.R,PBJChannel.G]),new RFloat(2,[PBJChannel.R,PBJChannel.G])),
							//new OpSampleLinear(new RFloat(7), new RFloat(6, [PBJChannel.R, PBJChannel.G]), 0),
							//new OpAdd(new RFloat(1), new RFloat(7)),
							//new OpDiv(new RFloat(1, [PBJChannel.R, PBJChannel.G, PBJChannel.B]), new RFloat(4, [PBJChannel.R])),
							
						   ]
						   
				var oneStep:Array = [	new OpSub(new RFloat(6, [PBJChannel.R, PBJChannel.G]), new RFloat(2,[PBJChannel.R, PBJChannel.G])),
										new OpVectorMatrixMult(new RFloat(6, [PBJChannel.R, PBJChannel.G]), new RFloat(3, [PBJChannel.M2x2])),
										new OpAdd(new RFloat(6,[PBJChannel.R,PBJChannel.G]),new RFloat(2,[PBJChannel.R,PBJChannel.G])),
										new OpSampleNearest(new RFloat(7), new RFloat(6, [PBJChannel.R, PBJChannel.G]), 0),
										new OpMul(new RFloat(7,[PBJChannel.A]), new RFloat(3,[PBJChannel.R])),
										new OpAdd(new RFloat(1), new RFloat(7)),
										//new OpDiv(new RFloat(1, [PBJChannel.R, PBJChannel.G, PBJChannel.B]), new RFloat(4, [PBJChannel.R]))
										]
				for (var i:int = 0; i < _layer-2; i++)
				{
					pbj.code = pbj.code.concat(oneStep);
				}
				pbj.code.push(new OpDiv(new RFloat(1, [PBJChannel.R, PBJChannel.G, PBJChannel.B]), new RFloat(4, [PBJChannel.R]))
							)
				var byte:ByteArray = PBJAssembler.assemble(pbj);
				_shader = new Shader(byte);
				_filter = new ShaderFilter(_shader);
			}
			_shader.data.mtx.value = [1.005, 0,
									  0, 1.005 ]
			_shader.data.threshold.value = [_center.x, _center.y];
			_shader.data.two.value = [_layer];
			
			return _filter;
		}
		
		public static function apply(target:DisplayObject, center:Point, layer:int):void
		{
			instance._target = target;
			instance._center = center;
			instance._layer = layer + 2;
			target.filters = [instance.create()];
		}
	}

}