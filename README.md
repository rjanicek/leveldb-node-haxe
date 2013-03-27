leveldb-node-haxe
-----------------

Haxe bindings for LevelDB Node.js modules. LevelUP, and Multilevel.

Tested with Haxe 3.0, LevelUP 0.6.2, Multilevel 2.0.3.

GitHub -> https://github.com/rjanicek/leveldb-node-haxe
	
licence -> https://github.com/rjanicek/leveldb-node-haxe/blob/master/MIT.LICENSE
	
multilevel by Julian Gruber - MIT -> https://github.com/juliangruber/multilevel
	
node-levelup by Rod Vagg - MIT -> https://github.com/rvagg/node-levelup
	
leveldb by Sanjay Ghemawat and Jeff Dean - New BSD -> https://code.google.com/p/leveldb/	

###In App database usage
Install node modules
```bash
npm install levelup
```
```haxe
import js.Node.*;
import js.node.LevelUP.LevelUPInstance.*;
import js.node.LevelUP;

class Main {
	static function main() {
		var db = levelup(__dirname + "/db", function(error : LevelUPError, db : LevelUP) {
			if (error != null) throw error;
			
			db.put("key", "value", function(error : LevelUPError) {
				if (error != null) throw error;
				
				db.get("key", function(error : LevelUPError, value : String) {
					if (error != null) throw error;
					
					trace('$value should equal "value"');
				});				
			});
		});	
	}
}
	
```

##Client / Server usage
###Database server
Install node modules
```bash
npm install levelup
npm install multilevel
```
```haxe
import js.node.LevelUP.LevelUPInstance.*;
import js.node.Multilevel.MultilevelInstance.*;
import js.Node;
import js.Node.*;

class MainDatabaseServer{
	public static function main() {
		var db = levelup(__dirname + "/db");
		net.createServer(function (c:Dynamic) {
			c.pipe(multilevel.server(db)).pipe(c);
		}).listen(3000);
	}
}
```

###Database client
Install node modules
```bash
npm install multilevel
```
```haxe
import js.Node.*;
import js.node.LevelUP;
import js.node.Multilevel.MultilevelInstance.*;

class MainDatabaseClient{
	public static function main() {
		var db = multilevel.client();
		con = net.connect(3000, "127.0.0.1");
		db.pipe(con).pipe(db);

		db.put("key", "value", function(error : LevelUPError) {
			if (error != null) throw error;
			
			db.get("key", function(error : LevelUPError, value : String) {
				if (error != null) throw error;
				
				trace('$value should equal "value"');
				con.destroy();
			});				
		});
	}
}
```

Important considerations
------------------------

LevelDB does not yet work on Windows. You can however use Multilevel on Windows to connect to a LevelDB instance running on a supported platform. This can be a VM running on Windows.

See -> https://github.com/rvagg/node-levelup#tested--supported-platforms

