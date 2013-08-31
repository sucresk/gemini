package  gemini.view.effects.bitmap 
{
	import flash.display.DisplayObject;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.utils.ByteArray;
	import ghostcat.events.OperationEvent;
	import pbjAS.ops.OpAbs;
	import pbjAS.ops.OpACos;
	import pbjAS.ops.OpAdd;
	import pbjAS.ops.OpMatrixMatrixMult;
	import pbjAS.ops.OpMatrixVectorMult;
	import pbjAS.ops.OpMov;
	import pbjAS.ops.OpMul;
	import pbjAS.ops.OpSampleLinear;
	import pbjAS.ops.OpSampleNearest;
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
	public class ThresholdFillter 
	{
		private static var _instance:ThresholdFillter;
		public static function get instance():ThresholdFillter
		{
			if (_instance == null)
				_instance = new ThresholdFillter();
			return _instance;
		}
		
		private var _version:int = 1;
		private var _name:String = "thresholdFillter";
		private var _shader:Shader;
		private var _filter:ShaderFilter;
		
		public function ThresholdFillter() 
		{
			
		}
		
		private function create(threshold:int):ShaderFilter
		{
			if (_filter == null)
			{
				var pbj:PBJ = new PBJ();
				pbj.version = _version;
				pbj.name = _name;
				pbj.parameters = [
									new PBJParam("_OutCoord", new Parameter(PBJType.TFloat2, false, new RFloat(0, [PBJChannel.R, PBJChannel.G]))),
									new PBJParam("src", new Texture(4, 0)),
									new PBJParam("des", new Parameter(PBJType.TFloat4, true, new RFloat(1))),
									new PBJParam("threshold", new Parameter(PBJType.TFloat, false, new RFloat(2,[PBJChannel.R,PBJChannel.G,PBJChannel.B,PBJChannel.A]))),
									new PBJParam("mtx",new Parameter(PBJType.TFloat4x4,false,new RFloat(3)))
								 ]
				pbj.code = [
							new OpSampleLinear(new RFloat(1), new RFloat(0, [PBJChannel.R, PBJChannel.G]), 0),
							new OpMov(new RFloat(6),new RFloat(1)),
							new OpVectorMatrixMult(new RFloat(6,[PBJChannel.R, PBJChannel.B, PBJChannel.G,PBJChannel.A]), new RFloat(3, [PBJChannel.M4x4])),
							new OpAdd(new RFloat(6, [PBJChannel.R]), new RFloat(2)),
							new OpAdd(new RFloat(6, [PBJChannel.G]), new RFloat(2)),
							new OpAdd(new RFloat(6, [PBJChannel.B]), new RFloat(2)),
							new OpMul(new RFloat(1, [PBJChannel.A]), new RFloat(6, [PBJChannel.R]))
						   ]
						   
						   
				var byte:ByteArray = PBJAssembler.assemble(pbj);
				_shader = new Shader(byte);
				_filter = new ShaderFilter(_shader);
			}
			_shader.data.mtx.value = [	  0.3086*256,	0.6094*256,	0.0820*256,	0,
										  0.3086*256,	0.6094*256,	0.0820*256,	0,
										  0.3086*256,	0.6094*256,	0.0820*256,	0,
										  0,        0,      0,      1]
			_shader.data.threshold.value = [-threshold];
			
			return _filter;
		}
		
		public static function apply(target:DisplayObject, threshold:int):void
		{
			target.filters = [instance.create(threshold)];
		}
	}

}