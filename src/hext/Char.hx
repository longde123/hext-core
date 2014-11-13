package hext;

import haxe.Serializer;
import haxe.Unserializer;
import haxe.io.Bytes;
import hext.Error;

using StringTools;

/**
 * Abstract C++/Java like single character representation.
 *
 * They are implemented immutable, meaning, that every operation returns a new Bit rather than
 * manipulating the existing one in-place.
 *
 * Use cases:
 *   - Reading/writing from/to streams. Working with characters might feel more natural than integers.
 */
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
     * Overloaded operator used when adding two Chars together.
     *
     * @param hext.Char c the character to add
     *
     * @return hext.Char
     */
    @:noCompletion
    @:op(A + B) public function add(c:Char):Char
    {
        return (this:Char).toInt() + c.toInt();
    }

    /**
     * Overloaded operator used when checking if the Chars are equal.
     *
     * @param hext.Char c the Character to compare against
     *
     * @return Bool
     */
    @:noCompletion
    @:op(A == B) public function compareEqual(c:Char):Bool
    {
        return (this:Char).toInt() == c.toInt();
    }

    /**
     * Overloaded operator used when comparing two Chars for "greater than".
     *
     * @param hext.Char c the Character to check for "greaterness"
     *
     * @return Bool
     */
    @:noCompletion
    @:op(A > B) public function compareGreater(c:Char):Bool
    {
        return (this:Char).toInt() > c.toInt();
    }

    /**
     * Overloaded operator used when comparing two Chars for "less than".
     *
     * @param hext.Char c the Character to check for "lessness"
     *
     * @return Bool
     */
    @:noCompletion
    @:op(A < B) public function compareLess(c:Char):Bool
    {
        return (this:Char).toInt() < c.toInt();
    }

    /**
     * Implicit casting from Int to Char.
     *
     * @param Int i the Int to cast
     *
     * @return hext.Char
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
     * @return hext.Char
     *
     * @throws hext.error is the string is longer than 1 character
     */
    @:noCompletion @:noUsing
    @:from public static function fromString(str:String):Char
    {
        if (str.length > 1) {
            throw new Error("Unclosed character literal.");
        }

        return new Char(Bytes.ofString(str));
    }

    /**
     * Checks if the passed character is a digit.
     *
     * @param hext.Char c the char to check
     *
     * @return true if the character is a digit
     */
    public static function isDigit(c:Char):Bool
    {
        return (c:Int) >= '0'.code && (c:Int) <= '9'.code;
    }

    /**
     * Checks if the passed character is a letter.
     *
     * @param hext.Char c the char to check
     *
     * @return true if the character is a letter
     */
    public static function isLetter(c:Char):Bool
    {
        return Char.isLowerCase(c) || Char.isUpperCase(c);
    }

    /**
     * Checks if the character is a lower case letter.
     *
     * @param hext.Char c the char to check
     *
     * @return true if the character is between 'a' and 'z'
     */
    public static function isLowerCase(c:Char):Bool
    {
        return (c:Int) >= 'a'.code && (c:Int) <= 'z'.code;
    }

    /**
     * Checks if the passed character is a line-separator.
     *
     * @param hext.Char c the char to check
     *
     * @return true if the character is one
     */
    public static function isLineSeparator(c:Char):Bool
    {
        return (c:Int) == '\n'.code || (c:Int) == '\r'.code;
    }

    /**
     * Checks if the character is an upper case letter.
     *
     * @param hext.Char c the char to check
     *
     * @return true if the character is between 'A' and 'Z'
     */
    public static function isUpperCase(c:Char):Bool
    {
        return (c:Int) >= 'A'.code && (c:Int) <= 'Z'.code;
    }

    /**
     * Checks if the passed character is a special one (not digit, letter or whitespace).
     *
     * @param hext.Char c the char to check
     *
     * @return true if the character is a special one
     */
    public static function isSpecial(c:Char):Bool
    {
        return !Char.isDigit(c) && !Char.isLetter(c) && !Char.isWhiteSpace(c);
    }

    /**
     * Checks if the passed character is a whitespace char.
     *
     * @param hext.Char c the char to check
     *
     * @return true if the character is whitespace
     */
    public static function isWhiteSpace(c:Char):Bool
    {
        return (c:Int) == ' '.code || (c:Int) == '\t'.code || Char.isLineSeparator(c);
    }

    /**
     * Overloaded operator used when substracting one Char from another.
     *
     * @param hext.Char c the Character to substract
     *
     * @return hext.Char
     */
    @:noCompletion
    @:op(A - B) public function subs(c:Char):Char
    {
        return (this:Char).toInt() - c.toInt();
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
     * Converts the upper-case character to its lower-case equivalent.
     *
     * @param hext.Char c the character to convert
     *
     * @return hext.Char the lower-case character
     *
     * @throws hext.IllegalArgumentException if the character is not a letter
     */
    public static function toLowerCase(c:Char):Char
    {
        if (Char.isLetter(c)) {
            var lower:Char = c;
            if (Char.isUpperCase(c)) {
                lower += 32;
            }

            return lower;
        }

        throw new IllegalArgumentException("Character is not a valid letter.");
    }

    /**
     * Implicit casting from Char to String.
     *
     * @return String the unicode character behind the char code
     */
    @:noCompletion
    @:to public function toString():String
    {
        return String.fromCharCode((this:Char));
    }

    /**
     * Converts the lower-case character to its upper-case equivalent.
     *
     * @param hext.Char c the character to convert
     *
     * @return hext.Char the upper-case character
     *
     * @throws hext.IllegalArgumentException if the character is not a letter
     */
    public static function toUpperCase(c:Char):Char
    {
        if (Char.isLetter(c)) {
            var upper:Char = c;
            if (Char.isLowerCase(c)) {
                upper -= 32;
            }

            return upper;
        }

        throw new IllegalArgumentException("Character is not a valid letter.");
    }
}
