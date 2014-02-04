package common.utils
{
import flash.system.Capabilities;

public class VersionUtil
{
	//@see http://www.senocular.com/flash/tutorials/versions/
	//About Flash Player Versions
	//Flash Player versioning follows the major.minor.build.revision format.
	private static const PLANTFORM:String = "plantform";
	private static const MAJOR:String = "major";
	private static const MINOR:String = "minor";
	private static const BUILD:String = "build";
	private static const REVISION:String = "revision";
	
	private static const VERSION:RegExp = /(?P<plantform>\w+) (?P<major>\d+),(?P<minor>\d+),(?P<build>\d+),(?P<revision>\d+)/;
	private static const MATCH:Object = VERSION.exec(Capabilities.version);
	
	public static const major:int = MATCH[MAJOR];
	public static const minor:int = MATCH[MINOR];
	public static const build:int = MATCH[BUILD];
	public static const revision:int = MATCH[REVISION];
	
	public static function getVersion():String {
		return MATCH[MAJOR] + "." + MATCH[MINOR] + "." + MATCH[BUILD] + "." + MATCH[REVISION];
	}
}
}