package js.node;
import js.Node;

class LevelUPInstance{

	/**
	 * levelup() is the main entry point for creating a new LevelUP instance and opening the underlying store with LevelDB.
	 * @see https://github.com/rvagg/node-levelup#leveluplocation-options-callback
	 */
	public static var levelup : String->?LevelUPOptions->?(LevelUPError->LevelUP->Void)->LevelUP;
	
	static function __init__() untyped {
		if (__js__("typeof require !== 'undefined'"))
			levelup = __js__("require('levelup')");
		else
			throw "could not find require module";
	}
	
}

/**
 * @see https://github.com/rvagg/node-levelup
 */
typedef LevelUP = { > NodeEventEmitter,
	
	function pipe( stream : Dynamic ) : LevelUP;
	
	/**
	 * The location of the database.
	 */
	var location : String;
	
	/**
	 * open() opens the underlying LevelDB store. In general you should never need to call this method directly as it's automatically called by levelup().
	 * @see https://github.com/rvagg/node-levelup#dbopencallback
	 */
	function open( returnErrorAndDatabase : LevelUPError->LevelUP->Void ) : Void;
	
	/**
	 * close() closes the underlying LevelDB store. The callback will receive any error encountered during closing as the first argument.
	 * @see https://github.com/rvagg/node-levelup#dbclosecallback
	 */
	function close( returnErrorAndDatabase : LevelUPError->Void ) : Void;
	
	/**
	 * put() is the primary method for inserting data into the store. Both the key and value can be arbitrary data objects.
	 * @see https://github.com/rvagg/node-levelup#dbputkey-value-options-callback
	 */
	function put( key : Dynamic, value : Dynamic, ?options : { ?encoding : String, ?keyEncoding : String, ?valueEncoding : String, ?sync : Bool }, ?returnError : LevelUPError->Void ) : Void;
	
	/**
	 * get() is the primary method for fetching data from the store. The key can be an arbitrary data object but if it doesn't exist in the store then the callback will receive an error as its first argument.
	 * @see https://github.com/rvagg/node-levelup#dbgetkey-options-callback
	 */
	function get( key : Dynamic, ?options : { ?encoding : String, ?keyEncoding : String, ?valueEncoding : String }, ?returnErrorAndValue : LevelUPError->Dynamic->Void ) : Void;
	
	/**
	 * del() is the primary method for removing data from the store.
	 * @see https://github.com/rvagg/node-levelup#dbdelkey-options-callback
	 */
	function del( key : Dynamic, ?options : { ?encoding : String, ?sync : Bool }, returnError : LevelUPError->Void ) : Void;
	
	/**
	 * batch() can be used for very fast bulk-write operations (both put and delete). The array argument should contain a list of operations to be executed sequentially, although as a whole they are performed as an atomic operation inside LevelDB. Each operation is contained in an object having the following properties: type, key, value, where the type is either 'put' or 'del'. In the case of 'del' the 'value' property is ignored. Any entries with a 'key' of null or undefined will cause an error to be returned on the callback and any 'type': 'put' entry with a 'value' of null or undefined will return an error.
	 * @see https://github.com/rvagg/node-levelup#dbbatcharray-options-callback
	 */
	function batch( array : Array<BatchOperation>, ?options : { ?encoding : String, ?keyEncoding : String, ?valueEncoding : String, ?sync : Bool }, ?returnError : LevelUPError->Void ) : Void;
	
	/**
	 * approximateSize() can used to get the approximate number of bytes of file system space used by the range [start..end). The result may not include recently written data.
	 * @see https://github.com/rvagg/node-levelup#dbapproximatesizestart-end-callback
	 */
	function approximateSize( start : Dynamic, end : Dynamic, returnErrorAndNumberOfBytes : LevelUPError->Int->Void ) : Void;
	
	/**
	 * isOpen() will return true only when the state is "open".
	 * @see https://github.com/rvagg/node-levelup#dbisopen
	 */
	function isOpen( ?returnErrorAndIsOpen : LevelUPError->Bool->Void ) : Bool;
	
	/**
	 * isClosed() will return true only when the state is "closing" or "closed", it can be useful for determining if read and write operations are permissible.
	 * @see https://github.com/rvagg/node-levelup#dbisclosed
	 */
	function isClosed( ?returnErrorAndIsClosed : LevelUPError->Bool->Void ) : Bool;
	
	/**
	 * You can obtain a ReadStream of the full database by calling the createReadStream() method. The resulting stream is a complete Node.js-style Readable Stream where 'data' events emit objects with 'key' and 'value' pairs.
	 * @see https://github.com/rvagg/node-levelup#dbcreatereadstreamoptions
	 */
	function createReadStream( ?options : LevelUPStreamOptions ) : NodeReadStream;
	
	/**
	 * A KeyStream is a ReadStream where the 'data' events are simply the keys from the database so it can be used like a traditional stream rather than an object stream.
	 * @see https://github.com/rvagg/node-levelup#dbcreatekeystreamoptions
	 */
	function createKeyStream( ?options : LevelUPStreamOptions ) : NodeReadStream;
	
	/**
	 * A ValueStream is a ReadStream where the 'data' events are simply the values from the database so it can be used like a traditional stream rather than an object stream.
	 * @see https://github.com/rvagg/node-levelup#dbcreatevaluestreamoptions
	 */
	function createValueStream( ?options : LevelUPStreamOptions ) : NodeReadStream;
	
	/**
	 * A WriteStream can be obtained by calling the createWriteStream() method. The resulting stream is a complete Node.js-style Writable Stream which accepts objects with 'key' and 'value' pairs on its write() method. The WriteStream will buffer writes and submit them as a batch() operation where the writes occur on the same event loop tick, otherwise they are treated as simple put() operations.
	 * @see https://github.com/rvagg/node-levelup#dbcreatewritestreamoptions
	 */
	function createWriteStream( ?options : { } ) : NodeWriteStream;
	
	/**
	 * Copy an entire database.
	 * @see https://github.com/rvagg/node-levelup#pipes-and-node-stream-compatibility
	 */
	function copy( srcdb : LevelUP, dstdb : LevelUP, returnDone : Void->Void ) : Void;
}

// ----------------------------------------------------------------------------
// Errors

typedef LevelUPError = {
	name : String,
	message : String
}

class LevelUPErrorNames {
	public static inline var NotFoundError = "NotFoundError";
}

// ----------------------------------------------------------------------------
// Options


/**
 * Additionally, each of the main interface methods accept an optional options object that can be used to override encoding (or keyEncoding & valueEncoding).
 * @see https://github.com/rvagg/node-levelup#options
 */
typedef LevelUPOptions = {
	/**
	 * (boolean, default: true): If true, will initialise an empty database at the specified location if one doesn't already exist. If false and a database doesn't exist you will receive an error in your open() callback and your database won't open.
	 */
	?createIfMissing : Bool,
	/**
	 * (boolean, default: false): If true, you will receive an error in your open() callback if the database exists at the specified location.
	 */
	?errorIfExists : Bool,
	/**
	 * (boolean, default: true): If true, all compressible data will be run through the Snappy compression algorithm before being stored. Snappy is very fast and shouldn't gain much speed by disabling so leave this on unless you have good reason to turn it off.
	 */
	?compression :Bool,
	/**
	 * (number, default: 8 * 1024 * 1024): The size (in bytes) of the in-memory LRU cache with frequently used uncompressed block contents.
	 */
	?cacheSize : Int,
	/**
	 * is the default encoding for both keys and values so you can simply pass in strings and expect strings from your get() operations. You can also pass Buffer objects as keys and/or values and conversion will be performed.
	 * Supported encodings are: hex, utf8, ascii, binary, base64, ucs2, utf16le.
	 */
	?encoding : String,
	/**
	 * (string, default: 'utf8'): use instead of encoding to specify the exact encoding of both the keys and the values in this database.
	 */
	?keyEncoding : String,
	/**
	 * (string, default: 'utf8'): use instead of encoding to specify the exact encoding of both the keys and the values in this database.
	 */
	?valueEncoding : String,
}

/**
 * 'encoding' (string, default: 'utf8'): The encoding of the keys and values passed through Node.js' Buffer implementation (see Buffer#toString())
 * 'utf8' is the default encoding for both keys and values so you can simply pass in strings and expect strings from your get() operations. You can also pass Buffer objects as keys and/or values and conversion will be performed.
 * Supported encodings are: hex, utf8, ascii, binary, base64, ucs2, utf16le.
 */
class LevelUPEncodings {
	public static inline var utf8 = "utf8";
	public static inline var hex = "hex";
	public static inline var ascii = "ascii";
	public static inline var binary = "binary";
	public static inline var base64 = "base64";
	public static inline var ucs2 = "ucs2";
	public static inline var utf16le = "utf16le";
	/**
	 * You specify 'json' encoding for both keys and/or values, you can then supply JavaScript objects to LevelUP and receive them from all fetch operations, including ReadStreams. LevelUP will automatically stringify your objects and store them as utf8 and parse the strings back into objects before passing them back to you.
	 */
	public static inline var json = "json";
}

// ----------------------------------------------------------------------------
// Batch

class BatchOperationTypes {
	public static inline var del = "del";
	public static inline var put = "put";
}

typedef BatchOperation = {
	type : String,
	key : Dynamic, 
	?value : Dynamic
}

// ----------------------------------------------------------------------------
//	Streaming

typedef LevelUPStreamOptions = {
	/**
	 * The key you wish to start the read at. By default it will start at the beginning of the store. Note that the start doesn't have to be an actual key that exists, LevelDB will simply find the next key, greater than the key you provide.
	 */
	?start : Dynamic,
	/**
	 * The key you wish to end the read on. By default it will continue until the end of the store. Again, the end doesn't have to be an actual key as an (inclusive) <=-type operation is performed to detect the end. You can also use the destroy() method instead of supplying an 'end' parameter to achieve the same effect.
	 */
	?end : Dynamic,
	/**
	 * (boolean, default: false): a boolean, set to true if you want the stream to go in reverse order. Beware that due to the way LevelDB works, a reverse seek will be slower than a forward seek.
	 */
	?reverse : Bool,
	/**
	 * (boolean, default: true): whether the 'data' event should contain keys. If set to true and 'values' set to false then 'data' events will simply be keys, rather than objects with a 'key' property. Used internally by the createKeyStream() method.
	 */
	?keys : Bool,
	/**
	 * (boolean, default: true): whether the 'data' event should contain values. If set to true and 'keys' set to false then 'data' events will simply be values, rather than objects with a 'value' property. Used internally by the createValueStream() method.
	 */
	?values : Bool,
	/**
	 * (number, default: -1): limit the number of results collected by this stream. This number represents a maximum number of results and may not be reached if you get to the end of the store or your 'end' value first. A value of -1 means there is no limit.
	 */
	?limit : Int,
	/**
	 * (boolean, default: false): wheather LevelDB's LRU-cache should be filled with data read.
	 */
	?fillCache : Bool
}

class LevelUPStreamEvents {
	public static inline var data = "data";
	public static inline var error = "error";
	public static inline var close = "close";
	public static inline var end = "end";
}

// ----------------------------------------------------------------------------
// Events

/**
 * LevelUP emits events when the callbacks to the corresponding methods are called.
 * @see https://github.com/rvagg/node-levelup#events
 */
class LevelUPEvents {
	public static inline var put = "put";
	public static inline var del = "del";
	public static inline var batch = "batch";
	public static inline var ready = "ready";
	public static inline var closed = "closed";
	public static inline var opening = "opening";
	public static inline var closing = "closing";
	public static inline var error = "error";
}


