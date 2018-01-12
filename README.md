# hxArbitraryPrecisionInt
Platform independent arbitrary precision Int library for haxe based on Array<Bool>. Unittests included.

ArbitraryPrecisionInt is a DataType which can be used for unsigned integers which can become arbitrary large. 
This class runs on flash, html5, neko and hxcpp and comes with basic arithmetics a set of unit tests. 
It is based on the binary representation of the number (stored as Array<Bool>). 
The only limitation is the machines memory. Very large numbers might become slow.

# Usage 
This exmapels might seem kind of useless for small integer numbers but will work nevertheless for positive integer numbers of arbitray size.

    var x : ArbitraryPrecisionInt = ArbitraryPrecisionInt.fromInt(15);
    var y : ArbitraryPrecisionInt = ArbitraryPrecisionInt.fromInt(3);
    var add : ArbitraryPrecisionInt = x.add(y); // 18
    var sub : ArbitraryPrecisionInt = x.sub(y); // 12 
    var mul : ArbitraryPrecisionInt = x.mul(y); // 45
    var div : ArbitraryPrecisionInt = x.div(y); // 5
    var log2 : Float = x.calcLog2(); // \approx 3.906
