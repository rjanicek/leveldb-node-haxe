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
class LevelUpSpec{

	//private static inline var TEST_KEY = "test~key";
	//private static inline var TEST_VALUE = "value";
	
	private static inline var DATABASE_LOCATION = "/db";
	
	public function new() {

		describe("LevelUP", function() {
			it("should create a database instance", function(done) {
				var location = __dirname + DATABASE_LOCATION;
				var db = levelup(location, function(error : LevelUPError, db : LevelUP) {
					error.should().not.be.ok();
					isOpen(db);
					isClosed(db);
					LevelUpSpecCore.location(db, location); 
					LevelUpSpecCore.put(db);
					LevelUpSpecCore.get(db);
					LevelUpSpecCore.del(db);
					LevelUpSpecCore.batch(db);
					LevelUpSpecCore.approximateSize(db);
					LevelUpSpecCore.createReadStream(db);
					done();
				});
			});
		});
		
	}
	
	public function isOpen( db : LevelUP ) : Void {
		describe("isOpen()", function() {
			it('should test database open state', function() {
				db.isOpen().should().be.ok();
			});
		});
	}

	public function isClosed( db : LevelUP ) : Void {
		describe("isClosed()", function() {
			it('should test database closed state', function() {
				db.isClosed().should().not.be.ok();
			});
		});
	}

}