package specs;

import js.expect.Expect.E.*;
import js.mocha.Mocha.M.*;
import js.Node.*;
import js.node.LevelUP;
import js.node.LevelUP.LevelUPInstance.*;
using co.janicek.core.NullCore;
using js.expect.Expect;
using Std;

/**
 * ...
 * @author Richard Janicek
 */
class LevelUpSpecCore{

	private static inline var TEST_KEY = "test~key";
	private static inline var TEST_VALUE = "value";
	
	public static function location( db : LevelUP, databaseLocation : String ) : Void {
		describe("location", function() {
			it('should contain the location of the database', function() {
				db.location.should().equal(databaseLocation);
			});
		});
	}
	
	public static function put( db : LevelUP ) : Void {
		describe("put()", function() {
			it('should put a key & value into the database', function(done) {
				db.put(TEST_KEY, TEST_VALUE, function(error : LevelUPError) {
					error.should().not.be.ok();
					done();
				});
			});
		});
	}
	
	public static function get( db : LevelUP ) : Void {
		describe("get()", function() {
			it('should get a key & value from the database', function(done) {
				db.get(TEST_KEY, function(error : LevelUPError, value : String) {
					error.should().not.be.ok();
					value.should().equal(TEST_VALUE);
					done();
				});
			});
			it('should return error for invalid key', function(done) {
				db.get("supercalifragilisticexpialidocious", function(error : LevelUPError, value) {
					error.name.should().equal(LevelUPErrorNames.NotFoundError);
					done();
				});
			});
		});
	}
	
	public static function del( db : LevelUP ) : Void {
		describe("del()", function() {
			it('should remove key & value from the database', function(done) {
				db.del(TEST_KEY, function(error : LevelUPError) {
					error.should().not.be.ok();
					db.get(TEST_KEY, function(error : LevelUPError, value) {
						error.name.should().equal(LevelUPErrorNames.NotFoundError);
						done();
					});					
				});
			});
		});
	}
	
	public static function batch( db : LevelUP ) : Void {
		describe("batch()", function() {
			after(function(done) {
				db.del(TEST_KEY, function(error : LevelUPError) {
					if (error.isNotNull()) {
						throw error;
					}
					done();
				});
			});
			it('should send batch operations to the database', function(done) {
				var ops : Array<BatchOperation> = [
					{ type : BatchOperationTypes.put, key : TEST_KEY, value : TEST_VALUE },
					{ type : BatchOperationTypes.put, key : TEST_KEY + "2", value : TEST_VALUE },
					{ type : BatchOperationTypes.del, key : TEST_KEY + "2" }
				];
				db.batch(ops, function(error : LevelUPError) {
					error.should().not.be.ok();
					db.get(TEST_KEY, function(error : LevelUPError, value : String) {
						error.should().not.be.ok();
						value.should().equal(TEST_VALUE);
						db.get(TEST_KEY + "2", function(error : LevelUPError, value : String) {
							error.name.should().equal(LevelUPErrorNames.NotFoundError);
							done();
						});
					});
				});
			});
		});
	}
	
	public static function approximateSize( db : LevelUP ) : Void {
		describe("approximateSize()", function() {
			it('should get number of bytes in range', function(done) {
				db.approximateSize(TEST_KEY, TEST_KEY, function(error : LevelUPError, numberOfBytes : Int) {
					error.should().not.be.ok();
					numberOfBytes.should().be.a("number");
					done();
				});
			});
		});
	}
	
	public static function createReadStream( db : LevelUP ) : Void {
		describe("createReadStream()", function() {
			it('should create a read stream', function(done) {
				db.createReadStream()
					.on(LevelUPStreamEvents.end, function() { 
						done();
					});
			});
		});
	}
	
	
	
}