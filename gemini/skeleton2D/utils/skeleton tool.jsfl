/**
 * 从movieclip导出动画数据
 * @author gemini
 * 
 */
 


for each(var item in document.library.items){
    if(item.itemType=="movie clip"&&item.linkageExportForAS){
        fl.trace("<animation name= \""+ item.linkageClassName+"\">");
        document.selectAll();
        if(document.selection.length>0)
            document.deleteSelection();
        document.addItem({x:0,y:0},item);
        document.enterEditMode('inPlace');
		document.selectAll();
		var allAnim = [];
		var startIndex=[];
		var endIndex=[];
		
		for(var j=0;j<document.getTimeline().frameCount;j++)
		{
			if(allAnim.length == 0 || allAnim[allAnim.length-1] != document.getTimeline().layers[0].frames[j].name)
			{
				allAnim.push(document.getTimeline().layers[0].frames[j].name);
				startIndex.push(j);
				if(j > 0)
				{
					endIndex.push(j-1);
				}
			}
		}
		endIndex.push(j-1);
		for(var i=0;i < document.getTimeline().layerCount;i++)
		{
			document.getTimeline().layers[i].locked = true;
		}
		
		for(var animIndex =0; animIndex < allAnim.length; animIndex++)
		{
			fl.trace("\t<motion name=\"" + allAnim[animIndex] + "\" totalFrame=\"" + (endIndex[animIndex] - startIndex[animIndex] + 1) + "\">");
			for(var i=0;i <document.getTimeline().layerCount;i++)
			{
				document.getTimeline().layers[i].locked = false;
				document.getTimeline().setSelectedFrames(0,0);
				document.selectAll();
				
				if(document.selection.length > 0)
				{
					var selectItemName = document.selection[0].name;
					fl.trace("\t\t<" + selectItemName + ">");
					
					for(var frame = startIndex[animIndex]; frame <= endIndex[animIndex]; frame++)
					{
						if(document.getTimeline().layers[i].frames[frame].startFrame==frame)
						{
							document.getTimeline().setSelectedFrames(frame,frame);
							document.selectAll();
							//<keyframe index="0" x="-9" y="-48" rotation="0" scaleX="1.00" scaleY="1.00" alpha="1.00"/>
							fl.trace("\t\t\t" + "<keyframe " + "index=\"" + (frame-startIndex[animIndex]) +"\""+
															   " x=\"" + Math.floor(document.selection[0].x) + "\""+
															   " y=\"" + Math.floor(document.selection[0].y) + "\""+
															   " rotation=\"" + Math.floor(document.selection[0].rotation) + "\""+
															   //" scaleX=\"" + Math.floor(document.selection[0].scaleX) + "\""+
															   //" scaleY=\"" + Math.floor(document.selection[0].scaleY) + "\""+
															   //" alpha=\"" + Math.floor(document.selection[0].alpha) + "\""+
												"\/>");
							
						}
					}
					fl.trace("\t\t<\/" + selectItemName + ">");
				}
				document.getTimeline().layers[i].locked = true;
			}
			fl.trace("\t<\/motion>");
		}
		fl.trace("<\/animation>");
		document.selectAll();
        document.exitEditMode();
		document.selectAll();
		document.deleteSelection();
    }
}
