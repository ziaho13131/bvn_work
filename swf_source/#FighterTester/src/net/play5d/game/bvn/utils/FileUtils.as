/**
 * 2024/6/16 移植文件保存类 优化中
 * 2024/6/16 21:33 优化完成 未测试
 */
package net.play5d.game.bvn.utils
{
   import flash.filesystem.File;
   import flash.filesystem.FileStream;
   import flash.utils.ByteArray;
   
   /**
	* 文件管理工具
	*/
   public class FileUtils
   {
       
      
      public function FileUtils()
      {
         super();
      }
      
	  public static function writeFile(filePath:String, data:*, writeMode:String = null):void {
		  var file:File = null;
		  var fileStream:FileStream = null;
		  var byteArray:ByteArray = null;
		  if(!writeMode) {
			  writeMode = "write";
		  }
		  try {
			  file = new File(filePath);
			  (fileStream = new FileStream()).open(file, writeMode);
			  if(data is String) {
				  fileStream.writeUTFBytes(data);
			  }
			  if(data is ByteArray) {
				  byteArray = data as ByteArray;
				  fileStream.writeBytes(byteArray, 0, byteArray.bytesAvailable);
			  }
			  fileStream.close();
		  }
		  catch(e:Error) {
			  trace("FileUtils.writeFile", e);
		  }
	  }
      
      public static function writeAppFloderFile(fileName:String, data:*, writeMode:String = null):void {
         var fileUrl:String = getAppFolderFileUrl(fileName);
         writeFile(fileUrl,data,writeMode);
      }
      
	  public static function getAppFolderFileUrl(fileName:String):String {
		  var appDir:File = File.applicationDirectory;
		  var appDirPath:String = String(appDir.nativePath);
		  return appDirPath + "/" + fileName;
	  }
      
	  public static function createFolder(path:String):void {
		  var file:File = null;
		  try {
			  file = new File(path);
			  file.createDirectory();
		  } catch(e:Error) {
			  trace("FileUtils.createFolder", e);
		  }
	  }
      
      public static function readTextFile(path:String):String {
         var fileData:String = null;
         var file:File = null;
         var fileStream:FileStream = null;
         try
         {
			 file = new File(path);
            (fileStream = new FileStream()).open(file,"read");
			fileData = String(fileStream.readUTFBytes(fileStream.bytesAvailable));
			fileStream.close();
         }
         catch(e:Error)
         {
            trace("FileUtils.readTextFile",e);
         }
         return fileData;
      }
      
      public static function del(path:String):void {
         var _loc2_:File = new File(path);
         try
         {
            _loc2_.deleteFile();
         }
         catch(e:Error)
         {
            trace("FileUtils.del",e);
         }
      }
	  
   }
}
