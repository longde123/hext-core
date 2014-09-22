package lib;

import haxe.io.Bytes;
import lib.Error;

using StringTools;

/**
 * Abstract C++/Java like single character representation.
 */
@:forward(get, set)
abstract Char(Bytes) from Bytes to Bytes
{
    /**
     * Constructor to initialize a new Char.
     *
     * @param Bytes bytes the Bytes to use as an underlaying structure
     */
    private inline function new(bytes:Bytes):Void
    {
        this = bytes;
    }

    /**
     * Overloaded operator used when adding and assigning two Chars together.
     *
     * @param lib.Char c the character to add
     *
     * @return lib.Char
     */
    @:noCompletion
    @:op(A += B) public function addAssignChar(c:Char):Char
    {
        this.set(0, (this:Char).toInt() + c.toInt());
        return this;
    }

    /**
     * Overloaded operator used when adding two Chars together.
     *
     * @param lib.Char c the character to add
     *
     * @return lib.Char
     */
    @:noCompletion
    @:op(A + B) public inline function addChar(c:Char):Char
    {
        return (this:Char).toInt() + c.toInt();
    }

    /**
     * Overloaded operator used when checking if the Chars are equal.
     *
     * @param lib.Char c the Character to compare against
     *
     * @return Bool
     */
    @:noCompletion
    @:op(A == B) public inline function compareEqualChar(c:Char):Bool
    {
        return (this:Char).toInt() == c.toInt();
    }

    /**
     * Overloaded operator used when comparing two Chars for "greater than".
     *
     * @param lib.Char c the Character to check for "greaterness"
     *
     * @return Bool
     */
    @:noCompletion
    @:op(A > B) public inline function compareGreaterChar(c:Char):Bool
    {
        return (this:Char).toInt() > c.toInt();
    }

    /**
     * Overloaded operator used when comparing two Chars for "less than".
     *
     * @param lib.Char c the Character to check for "lessness"
     *
     * @return Bool
     */
    @:noCompletion
    @:op(A < B) public inline function compareLessChar(c:Char):Bool
    {
        return (this:Char).toInt() < c.toInt();
    }

    /**
     * Overloaded operator used when dividing a Character by another Character.
     *
     * @param lib.Char c the Character to divide by
     *
     * @return lib.Char
     */
    @:noCompletion
    @:op(A / B) public inline function divideByChar(c:Char):Char
    {
        return Std.int((this:Char).toInt() / c.toInt());
    }

    /**
     * Overloaded operator used when multiplying a Character by another Character.
     *
     * @param lib.Char c the Character to multiply by
     *
     * @return lib.Char
     */
    @:noCompletion
    @:op(A * B) public inline function multiplyByChar(c:Char):Char
    {
        return Std.int((this:Char).toInt() * c.toInt());
    }

    /**
     * Post decrements the current Character.
     *
     * @return lib.Char
     */
    @:noCompletion
    @:op(A--) public function postDecrement():Char
    {
        var cur:Int = (this:Char).toInt();
        this.set(0, cur - 1);

        return cur;
    }

    /**
     * Post increments the current Character.
     *
     * @return lib.Char
     */
    @:noCompletion
    @:op(A++) public function postIncrement():Char
    {
        var cur:Int = (this:Char).toInt();
        this.set(0, cur + 1);

        return cur;
    }

    /**
     * Pre decrements the current Character.
     *
     * @return lib.Char
     */
    @:noCompletion
    @:op(--A) public function preDecrement():Char
    {
        this.set(0, (this:Char).toInt() - 1);
        return this;
    }

    /**
     * Pre increment the current Character.
     *
     * @return lib.Char
     */
    @:noCompletion
    @:op(++A) public function preIncrement():Char
    {
        this.set(0, (this:Char).toInt() + 1);
        return this;
    }

    /**
     * Overloaded operator used when substracting and assigning two Chars together.
     *
     * @param lib.Char c the character to add
     *
     * @return lib.Char
     */
    @:noCompletion
    @:op(A -= B) public function subsAssignChar(c:Char):Char
    {
        this.set(0, (this:Char).toInt() - c.toInt());
        return this;
    }

    /**
     * Overloaded operator used when substracting one Char from another.
     *
     * @param lib.Char c the Character to substract
     *
     * @return lib.Char
     */
    @:noCompletion
    @:op(A - B) public inline function subsChar(c:Char):Char
    {
        return (this:Char).toInt() - c.toInt();
    }

    /**
     * Implicit casting from Bytes to Char.
     *
     * @param Bytes b the bytes to cast
     *
     * @return lib.Char
     */
    @:noCompletion @:noUsing
    @:from public static inline function fromBytes(b:Bytes):Char
    {
        return new Char(b);
    }

    /**
     * Implicit casting from Int to Char.
     *
     * @param Int i the Int to cast
     *
     * @return lib.Char
     */
    @:noCompletion @:noUsing
    @:from public static function fromInt(i:Int):Char
    {
        var bytes:Bytes = Bytes.alloc(1);
        bytes.set(0, i);

        return new Char(bytes);
    }

    /**
     * Implicit casting from String to Char.
     *
     * @param String str the String character to cast
     *
     * @return lib.Char
     *
     * @throws lib.error is the string is longer than 1 character
     */
    @:noCompletion @:noUsing
    @:from public static function fromString(str:String):Char
    {
        if (str.length > 1) {
            throw new Error("Unclosed character literal");
        }

        return new Char(Bytes.ofString(str));
    }

    /**
     * Implicit casting from Char to Bytes.
     *
     * @return Bytes the bytes to store the character code
     */
    @:noCompletion
    @:to public inline function toBytes():Bytes
    {
        return this;
    }

    /**
     * Implicit casting from Char to Int.
     *
     * @return Int the character code
     */
    @:noCompletion
    @:to public inline function toInt():Int
    {
        return this.get(0);
    }

    /**
     * Implicit casting from Char to String.
     *
     * @return String the unicode character behind the char code
     */
    @:noCompletion
    @:to public inline function toString():String
    {
        return String.fromCharCode((this:Char));
    }
}