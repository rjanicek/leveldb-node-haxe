package js.node;

import js.Node;

class MultilevelInstance {

	public static var multilevel : Multilevel;

	static function __init__() untyped {
		if (__js__("typeof require !== 'undefined'"))
			multilevel = __js__("require('multilevel')");
		else
			throw "could not find require module";
	}
	
}

/**
 * Expose a levelDB over the network, to be used by multiple processes, with levelUp's API.
 * @see https://github.com/juliangruber/multilevel
 */
typedef Multilevel = {
	/**
	 * Returns a server-stream that exposes db, an instance of levelUp.
	 * @see https://github.com/juliangruber/multilevel#multilevelserverdb
	 */
	function server( db : LevelUP ) : Dynamic;
	/**
	 * Returns a db that is to be piped into a server-stream.
	 * @see https://github.com/juliangruber/multilevel#var-db--multilevelclient
	 */
	function client() : LevelUP;
}
