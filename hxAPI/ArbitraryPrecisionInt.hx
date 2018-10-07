package hxAPI;

/**
 * ArbitraryPrecisionInt is a DataType which can be used for unsigned integers which can become arbitrary large.
 * This class runs on flash, html5, neko and hxcpp and comes with basic arithmetics a set of unit tests.
 * It is based on the binary representation of the number (stored as Array<Bool>).
 * The only limitation is the machines memory. Very large numbers might become slow.
 * @author Laguna_999
 * 
 */
class ArbitraryPrecisionInt
{
	/**
		The binary representation of the number in big-endian format.
		Normally a user does not need to touch this.
		values[values.length-1] is always the 1 digit, values[values.length-1] is the 2 digit, ... values[0] is the largest digit
	**/
	public var values: Array<Bool> = [];
	
	/**
		Creates a new ArbitraryPrecisionInt which is initialized with 0.
	**/
	public function new() 
	{
		values = [];
	}
	
	/**
		static function to convert a normal Int to an ArbitraryPrecisionInt
		@param n 		the number to convert to an ArbitraryPrecisionInt. must be >= 0.
		@return a new ArbitraryPrecisionInt
	**/
	public static function fromInt (n : Int) : ArbitraryPrecisionInt
	{
		var li : ArbitraryPrecisionInt = new ArbitraryPrecisionInt();
		if (n < 0) throw("cannot handle negative numbers!");
		if (n == 0)
		{
			li.values.push(false);
			return li;
		}
		while (true)
		{
			if (n == 0)
			{
				break;
			}
			var rem : Int = n % 2;
			li.values.push((rem==1)? true : false);
			n = n >> 1;
		}
		li.values.reverse();
		return li;
	}
	
	/**
		converts this ArbitraryPrecisionInt to a string, containing the binary information.
		@return a string which contains the binary representation of the number
	**/
	public function toBinaryString (): String
	{		
		var str : StringBuf = new StringBuf();
		for (v in values)
		{
			str.add((v == true) ? "1" : "0");
		}
		
		return str.toString();
	}
	
	/**
		converts this ArbitraryPrecisionInt to a string containing the decimal information
		@return a string which contains the decimal representation of the number
	**/
		

	public function toString() : String
	{
		var str : StringBuf = new StringBuf();
		
		if (this.compare(tenAsAPI) == -1)
		{
			str.add(Std.string(this.toInt()));
		}
		else
		{	
			str.add(this.divide(tenAsAPI).toString());
			str.add(this.mod(tenAsAPI).toString());
		}
		return str.toString();
	}
	
	/**
		Convert this ArbitraryPrecisionInt to a normal Int. 
		!no numbers larger or equal to 2^32 will be converted to prevent integer overflows!
		A warning will be issued, if the number is too big to be converted.
		@return an int which contains the number stored in values Max will be 2^32 -1
		
	**/
	public function toInt() : Int
	{
		values.splice(0, values.indexOf(true) - 1); // getting rid of leading zeros
		if (values.length > 32)
		{
			trace ("warning in arrayToInt: int buffer overflow possible!");
		}
		var retval : Int = 0;
		for (i in 0...values.length)
		{
			if (i >= 32) continue;
			var idx  = values.length - 1 -i;
			
			if (values[idx]) retval += (1 << (i));
		}
		return retval;
	}
	
	/**
		Add Two ArbitraryPrecisionInts with this function.
		Will leave this unchanged.
		@param rhs		The other ArbitraryPrecisionInt to add
		@return  mathematical representation of this + rhs
	**/
	public function add (rhs:ArbitraryPrecisionInt) : ArbitraryPrecisionInt
	{
		var l1 : Int = this.values.length;
		var l2 : Int = rhs.values.length;
		var l : Int = ((l1 > l2) ? l1 : l2) + 1;
		var arr : Array<Bool> = new Array<Bool>();
		
		var remainder : Bool = false;
		for (i in 0 ... l -1)
		{
			var idx1 = l1 - 1 - i;
			var idx2 = l2 - 1 - i;
			var v1 : Int = values[idx1] ? 1 : 0;
			var v2 : Int = rhs.values[idx2] ? 1: 0;
			var carry : Int = remainder ? 1: 0;
			
			var sum = v1 + v2 + carry;
			
			if (sum == 0)
			{
				remainder = false;
				arr[i] = false;
			}
			else if (sum == 1)
			{
				remainder = false;
				arr[i] = true;
			}
			else if (sum == 2)
			{
				remainder = true;
				arr[i] = false;
			}
			else
			{
				remainder = true;
				arr[i] = true;
			}
		}
		arr[l-1] = remainder;
		
		
		var li : ArbitraryPrecisionInt = new ArbitraryPrecisionInt();
		if (!arr[arr.length - 1]) arr.pop(); // getting rid of leading zeros
		arr.reverse();
		li.values = arr;
		return li;
	}
	
	/**
		Subtract Two ArbitraryPrecisionInts with this function.
		Will leave this unchanged.
		@param rhs		The ArbitraryPrecisionInt to subtract
		@return  mathematical representation of this - rhs
	**/
	public function sub (rhs:ArbitraryPrecisionInt) : ArbitraryPrecisionInt
	{
		if (this.compare(rhs) == -1) 
		{
			trace("warning: ArbitraryPrecisionInt: Subtraction would yield negative Int");
			return ArbitraryPrecisionInt.fromInt(0);
		}
		if (this.compare(rhs) == 0)
		{
			return ArbitraryPrecisionInt.fromInt(0);
		}
		
		var l1 : Int = values.length;
		var l2 : Int = rhs.values.length;
		var l : Int = (l1 > l2 ? l1 : l2) + 1;
		var arr : Array<Bool> = new Array<Bool>();
		
		var remainder : Bool = false;
		for (i in 0 ... l -1)
		{
			var idx1 = l1 - 1 - i;
			var idx2 = l2 - 1 - i;
			var v1 : Int = values[idx1] ? 1 : 0;
			var v2 : Int = rhs.values[idx2] ? 1: 0;
			var carry : Int = remainder ? 1: 0;
			
			var sum = v1 - v2 - carry;
			
			if (sum == 0)
			{
				remainder = false;
				arr[i] = false;
			}
			else if (sum == 1)
			{
				remainder = false;
				arr[i] = true;
			}
			else if (sum == -1)
			{
				remainder = true;
				arr[i] = true;
			}
			else
			{
				remainder = true;
				arr[i] = false;
			}
		}
		arr[l-1] = remainder;
		
		
		var li : ArbitraryPrecisionInt = new ArbitraryPrecisionInt();
		if (!arr[arr.length - 1]) arr.pop();
		arr.reverse();
		li.values = arr;
		return li;
	}
	
	/**
	 * multiply two ArbitraryPrecisionInts. 
	 * Will leave this unchanged.
	 * @param rhs	The ArbitraryPrecisionInt to multiply with
	 * @return 	the mathematical representation of this * rhs
	**/
	public function multiply (rhs : ArbitraryPrecisionInt) : ArbitraryPrecisionInt
	{
		
		var result : ArbitraryPrecisionInt = new ArbitraryPrecisionInt();
		
		var tmp : ArbitraryPrecisionInt = new ArbitraryPrecisionInt();
		tmp.values = this.values;
		
		for (i in 0 ... rhs.values.length)
		{
			var idx : Int = rhs.values.length - 1 - i;
			if (rhs.values[idx])
			{
				result = result.add(tmp);
			}
			tmp = tmp.lshift();
		}
		return result;
	}
	
	/**
	 * divide this ArbitraryPrecisionInts by rhs. 
	 * Will leave this unchanged.
	 * @param rhs	The ArbitraryPrecisionInt to divide by.
	 * @return 	the mathematical representation of this / rhs
	**/
	public function divide (rhs : ArbitraryPrecisionInt) : ArbitraryPrecisionInt
	{
		if ( rhs.compare(ArbitraryPrecisionInt.fromInt(0)) == 0)
		{
			trace("division by zero attempted!");
			return ArbitraryPrecisionInt.fromInt(0);
		}
		
		
		var c : Int = compare (rhs);
		if (c == -1) return ArbitraryPrecisionInt.fromInt(0);
		else if (c == 0) return ArbitraryPrecisionInt.fromInt(1);
		
		var Q : ArbitraryPrecisionInt = ArbitraryPrecisionInt.fromInt(0);
		var R : ArbitraryPrecisionInt = ArbitraryPrecisionInt.fromInt(0);
		for (i in 0 ... values.length) 
		{
			var idx : Int = values.length -1 - i;
			R = R.lshift();
			R.values[R.values.length-1] = values[i];
			var c2 : Int = R.compare(rhs);
			if (c2 >= 0)
			{
				R = R.sub(rhs);
				Q.values[idx] = true;
			}
			else
			{
				Q.values[idx] = false;
			}
		}
		Q.values[values.length] = (R.compare(rhs) >= 0);

		
		Q.values.reverse();
		Q.values.splice(0, Q.values.indexOf(true) - 1);	// getting rid of leading zeros
		return Q;
	}
	
	/**
	 * modulo operator of two ArbitraryPrecisionInts. 
	 * Will leave this unchanged.
	 * @param rhs	The ArbitraryPrecisionInt to use modulo with.
	 * @return 	the mathematical representation of this % rhs
	**/
	public function mod (rhs : ArbitraryPrecisionInt) : ArbitraryPrecisionInt
	{
		var c : Int = compare (rhs);
		if (c == 0) return ArbitraryPrecisionInt.fromInt(0);
		
		var Q : ArbitraryPrecisionInt = ArbitraryPrecisionInt.fromInt(0);
		var R : ArbitraryPrecisionInt = ArbitraryPrecisionInt.fromInt(0);
		for (i in 0 ... values.length) 
		{
			var idx : Int = values.length -1 - i;
			R = R.lshift();
			R.values[R.values.length-1] = values[i];
			var c2 : Int = R.compare(rhs);
			if (c2 >= 0)
			{
				R = R.sub(rhs);
				Q.values[idx] = true;
			}
			else
			{
				Q.values[idx] = false;
			}
		}
		R.values.splice(0, R.values.indexOf(true) - 1); // getting rid of leading zeros
		return R;
	}
	
	
	
	
	
	/**
		LeftShift This Number by 1. This is equal to a multiplication by two.
		Will leave this unchanged.
		@return the leftshifted Number. 
	**/
	public function lshift() : ArbitraryPrecisionInt
	{
		var arr : Array<Bool> = [];
		arr = values.copy();
		arr.push(false);
		
		
		var ret : ArbitraryPrecisionInt = new ArbitraryPrecisionInt();
		ret.values = arr;
		return ret;
	}
	
	/**
		Rightshift this Number by 1. This is equal to a division by two.
		Will leave this unchanged.
		@return the rightshifted Number. 
	**/
	public function rshift() : ArbitraryPrecisionInt
	{
		var arr : Array<Bool> = [];
		arr = values.copy();
		if (!arr[arr.length - 1]) arr.pop();
		
		var ret : ArbitraryPrecisionInt = new ArbitraryPrecisionInt();
		ret.values = arr;
		return ret;
	}
	
	/**
	 * compare two ArbitraryPrecisionInts. 
	 * @param rhs	The ArbitraryPrecisionInt to compare with
	 * @return 	-1  (this < rhs)
	 * 			0	(this == rhs)
	 * 			+1 	(this > rhs)
	**/
	public function compare (rhs : ArbitraryPrecisionInt) : Int 
	{
		var ls : Int = (this.values.length < rhs.values.length ? this.values.length : rhs.values.length);
		var ll : Int = (this.values.length > rhs.values.length ? this.values.length : rhs.values.length);
		var diff : Int = (ll - ls);
		var arrs : Array<Bool>;
		var arrl : Array<Bool>;
		var which : Bool = false;
		if (this.values.length == rhs.values.length)
		{
			arrs = this.values;
			arrl = rhs.values;
		}
		else
		{
			arrs = (this.values.length < rhs.values.length) ? this.values : rhs.values;
			arrl = (this.values.length < rhs.values.length) ? rhs.values : this.values;
			which = (this.values.length > rhs.values.length);
		}
		
		var retval : Int = 0;
		for (i in 0 ... ll)
		{
			var vs : Bool = ((i < diff) ? false : arrs[i - diff]);
			var vl : Bool = arrl[i];
			
			if (vs == vl) continue;
			else if (vs == true)
			{
				retval = 1;
				break;
			}
			else
			{
				retval = -1;
				break;
			}
		}
		
		if (which)
			retval *= -1;
		
		
		return retval;
	}
	
	/**
	 * 
	 * @return log10
	**/
	public function calcLog10() : Float
	{
		return return calcLog2() / 3.32192809488736234787;
	}
	
	/**
	 * calculated the base2 logarithm of this. 
	 * Will leave this unchanged
	 * based on https://en.wikipedia.org/wiki/Binary_logarithm#Iterative_approximation without the iterative stuff.
	 * @return approximation of lg(this)
	 */
	public function calcLog2() : Float
	{
		if (this.compare(ArbitraryPrecisionInt.fromInt(0)) <= 0) 
			return 1.0 / 0.0;
		
		// n is the pre-decimal value, which can easily be calculated 
		// as an lower bound by finding the first binary digit which is true.
		var n : Int = values.length - 1 - values.indexOf(true);
		if (n == 0) return 0;	
		// safe to do here, because ArbitraryPrecisionInts 
		// can not be smaller than 1 (which would be n ==0)
		// and the next larger number 2 would be n == 1.
		
		// dirty hack, but a ok as my calcLog2 is still monotonous.
		var precision : Int = 100000000;
		
		// multiply by precision to ensure we get enough decimal places in front of the point 
		// for float -> AribtraryPrecisionInt conversion
		var pre : Float  = Math.pow(2, -n) * precision;
		// do the conversion and multiply by the (possibly large ArbitraryPrecisionInt value)
		var num : ArbitraryPrecisionInt = ArbitraryPrecisionInt.fromInt(Std.int(pre)).multiply(this);
		// do the conversion back (might loose some digits here
		
		var post : Float = num.toInt() / precision;
		
		var res : Float = n + Math.log(post) / Math.log(2);
		
		return res; 
	}
	
	public function powInt(n : Int) : ArbitraryPrecisionInt
	{
		if (n == 0)
			return ArbitraryPrecisionInt.fromInt(1);
		else if (n == 1)
		{
			var ret : ArbitraryPrecisionInt = new ArbitraryPrecisionInt();
			ret.values = this.values.copy();
			return ret;
		}
		else if (n > 1)
		{
			var ret : ArbitraryPrecisionInt = new ArbitraryPrecisionInt();
			ret.values = this.values.copy();
			for (i in 0 ... n-1)
			{
				ret = ret.multiply(this);
			}
			return ret;
		}
		else
		{
			var ret : ArbitraryPrecisionInt = new ArbitraryPrecisionInt();
			ret.values = this.values.copy();
			for (i in 0 ... n)
			{
				ret = ret.divide(ret);
			}
			return ret;
		}
		
	}
	
	public static var oneAsAPI :ArbitraryPrecisionInt = ArbitraryPrecisionInt.fromInt(1);	
	public static var tenAsAPI :ArbitraryPrecisionInt = ArbitraryPrecisionInt.fromInt(10);	
}