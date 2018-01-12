package hxAPI;

/**
 * ArbitraryPrecisionInt is a DataType which can be used for unsigned integers which can become arbitrary large.
 * This class runs on flash, html5, neko and hxcpp and comes with basic arithmetics a set of unit tests.
 * It is based on the binary representation of the number (stored as Array<Bool>).
 * The only limitation is the machines memory. Very large numbers might become slow.
 * @author Laguna_999
 * 
 */
class Tests
{

	public static function RunTests() : Void
	{
		trace("running tests");

		trace("toBinaryString");
		for (i in 1...16)
		{
			{
				var val : Int = Std.int(Math.pow(2, i));
				var str : String = "1";
				for (j in 0 ...i)
					str += "0";
				
				if (ArbitraryPrecisionInt.fromInt(val).toBinaryString() != str) throw ("ERROR in ArbitraryPrecsionInt:toBinaryString");
			}
			{
				var val : Int = Std.int(Math.pow(2, i)) -1;
				var str : String = "1";
				for (j in 0 ...i-1)
					str += "1";
					
				if (ArbitraryPrecisionInt.fromInt(val).toBinaryString() != str) throw ("ERROR in ArbitraryPrecsionInt:toBinaryString");
			}
		}

		trace("toInt");
		for (i in 0...256)
		{
			if (ArbitraryPrecisionInt.fromInt(i).toInt() != i) throw ("ERROR in ArbitraryPrecsionInt:toInt");
		}
		
		trace("add");
		for (i in 0...256)
		for (j in 0...128)
		{
			var l1 : ArbitraryPrecisionInt = ArbitraryPrecisionInt.fromInt(i);
			var l2 : ArbitraryPrecisionInt = ArbitraryPrecisionInt.fromInt(j);
			var l3 : ArbitraryPrecisionInt = l1.add(l2);
			if (l3.toInt() != i + j) throw("ERROR in ArbitraryPrecsionInt:add");
		}
		
		trace("sub");
		for (i in 0...256)
		for (j in 0...i+1)
		{
			var l1 : ArbitraryPrecisionInt = ArbitraryPrecisionInt.fromInt(i);
			var l2 : ArbitraryPrecisionInt = ArbitraryPrecisionInt.fromInt(j);
			var l3 : ArbitraryPrecisionInt = l1.sub(l2);
			if (l3.toInt() != i - j) throw("ERROR in ArbitraryPrecsionInt:sub");
		}
		
		trace("compare");
		for (i in 0...256)
		for (j in 0...256)
		{
			var l1 : ArbitraryPrecisionInt = ArbitraryPrecisionInt.fromInt(i);
			var l2 : ArbitraryPrecisionInt = ArbitraryPrecisionInt.fromInt(j);
			var res : Int = ((i < j) ? -1 : ((i == j)? 0 : 1));
			if (l1.compare(l2) != res) throw("ERROR in ArbitraryPrecsionInt:compare");
		}
		
		trace("lshift");
		for (i in 0...10)
		{
			var l : ArbitraryPrecisionInt = ArbitraryPrecisionInt.fromInt(1);
			
			for (j in 0 ... i)
			{
				l = l.lshift();
			}
			if (l.toInt() != (1 << i)) throw ("ERROR in ArbitraryPrecisionInt:lshift");
		}
		
		trace("multiply");
		for (i in 0...256)
		for (j in 0...16)
		{
			var l1 : ArbitraryPrecisionInt  = ArbitraryPrecisionInt.fromInt(i);
			var l2 : ArbitraryPrecisionInt  = ArbitraryPrecisionInt.fromInt(j);
			var l3 : ArbitraryPrecisionInt = l1.multiply(l2);
			if (l3.toInt() != i*j) throw ("ERROR in ArbitraryPrecisionInt:multiply");
		}
				
		trace("division");
		for (i in 0...256)
		for (j in 1...16)
		{
			var l1 : ArbitraryPrecisionInt = ArbitraryPrecisionInt.fromInt(i);
			var l2 : ArbitraryPrecisionInt = ArbitraryPrecisionInt.fromInt(j);
			var l3 : ArbitraryPrecisionInt = l1.divide(l2);
			if (l3.toInt() != Std.int(i/j)) throw("ERROR in ArbitraryPrecisionInt:divide");
		}
		
		trace("mod");
		for (i in 1...100)
		{
			var l1 : ArbitraryPrecisionInt = ArbitraryPrecisionInt.fromInt(i);
			var l2 : ArbitraryPrecisionInt = ArbitraryPrecisionInt.fromInt(10);
			var l3 : ArbitraryPrecisionInt = l1.mod(l2);
			if (l3.toInt() != i%10) throw("ERROR in ArbitraryPrecisionInt:mod");
			//trace("");
		}
		
		
		trace("toString");
		for (i in 1...1024)
		{
			if (ArbitraryPrecisionInt.fromInt(i).toString() != Std.string(i)) throw ("ERROR in ArbitraryPositionInt:toString");
		}
		
		
		trace("pow");
		
		for (i in 0...10)
		{
			var l1 : ArbitraryPrecisionInt = ArbitraryPrecisionInt.fromInt(2);
			var l2 :ArbitraryPrecisionInt = l1.powInt(i);
			var res : Int = Std.int(Math.pow(2, i));
			//trace(res +  " " + l2.toInt());
			if (l2.compare(ArbitraryPrecisionInt.fromInt(res)) != 0) throw ("ERROR in ArbitraryPrecisionInt: pow");
		}
		
		
		trace("calcLog2");
		for (i in 1...128)
		{
			var result : Float = ArbitraryPrecisionInt.fromInt(i).calcLog2();
			var correct :Float = Math.log(i) / Math.log(2);
			var resudial : Float = Math.abs(result - correct);
			
			if (resudial > 0.001) throw("ERROR in ArbitraryPrecisionInt.calcLog2");
		}
		
		trace("All ArbitraryPrecisionInt Tests passed!");
	}
	
}