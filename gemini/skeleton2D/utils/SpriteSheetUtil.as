package gemini.skeleton2D.utils 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 */
	public class SpriteSheetUtil 
	{
		private var mTextureRegions:Dictionary;
        private var mTextureFrames:Dictionary;
		
		private var _bmpD:BitmapData;
		
		public function SpriteSheetUtil(bmpD:BitmapData, atlasXml:XML) 
		{
			mTextureRegions = new Dictionary();
            mTextureFrames  = new Dictionary();
			
			_bmpD = bmpD;
			parseAtlasXml(atlasXml);
		}
		
		protected function parseAtlasXml(atlasXml:XML):void
        {
            var scale:Number = 1;
            
            for each (var subTexture:XML in atlasXml.SubTexture)
            {
                var name:String        = subTexture.attribute("name");
                var x:Number           = parseFloat(subTexture.attribute("x")) / scale;
                var y:Number           = parseFloat(subTexture.attribute("y")) / scale;
                var width:Number       = parseFloat(subTexture.attribute("width")) / scale;
                var height:Number      = parseFloat(subTexture.attribute("height")) / scale;
                var frameX:Number      = parseFloat(subTexture.attribute("frameX")) / scale;
                var frameY:Number      = parseFloat(subTexture.attribute("frameY")) / scale;
                var frameWidth:Number  = parseFloat(subTexture.attribute("frameWidth")) / scale;
                var frameHeight:Number = parseFloat(subTexture.attribute("frameHeight")) / scale;
                
                var region:Rectangle = new Rectangle(x, y, width, height);
                //var frame:Rectangle  = frameWidth > 0 && frameHeight > 0 ?  new Rectangle(frameX, frameY, frameWidth, frameHeight) : null;
                var frame:Rectangle  = new Rectangle(frameX, frameY, 1, 1);
                
                addRegion(name, region, frame);
            }
        }
		
		public function getBmpD(name:String):BitmapData
		{
			var region:Rectangle = mTextureRegions[name];
            
            if (region == null) return null;
			
			var bmpd:BitmapData = new BitmapData(region.width, region.height);
			bmpd.copyPixels(_bmpD, region, new Point());
			return bmpd;
		}
		
		 /** Returns all texture names that start with a certain string, sorted alphabetically. */
        public function getNames(prefix:String="", result:Vector.<String>=null):Vector.<String>
        {
            if (result == null) result = new <String>[];
            
            for (var name:String in mTextureRegions)
                if (name.indexOf(prefix) == 0)
                    result.push(name);
            
            result.sort(Array.CASEINSENSITIVE);
            return result;
        }
        
        /** Returns the region rectangle associated with a specific name. */
        public function getRegion(name:String):Rectangle
        {
            return mTextureRegions[name];
        }
        
        /** Returns the frame rectangle of a specific region, or <code>null</code> if that region 
         *  has no frame. */
        public function getFrame(name:String):Rectangle
        {
            return mTextureFrames[name];
        }
        
        /** Adds a named region for a subtexture (described by rectangle with coordinates in 
         *  pixels) with an optional frame. */
        public function addRegion(name:String, region:Rectangle, frame:Rectangle=null):void
        {
            mTextureRegions[name] = region;
            mTextureFrames[name]  = frame;
        }
        
        /** Removes a region with a certain name. */
        public function removeRegion(name:String):void
        {
            delete mTextureRegions[name];
            delete mTextureFrames[name];
        }
	}

}