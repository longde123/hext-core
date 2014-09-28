package lib;

import lib.Char;
import lib.IllegalArgumentException;
import lib.StringIterator;

/**
 * The StringTools utilities class adds several helpful methods
 * to the standard String class.
 */
class StringTools
{
    /**
     * Returns an Iterator that can be used to access every character of the String.
     *
     * @param String str the String to iterate over
     *
     * @return lib.StringIterator
     */
    public static inline function iterator(str:String):StringIterator
    {
        return new StringIterator(str);
    }

    /**
     * Reverses all characters of the String and returns the reversed one.
     *
     * This method does not change the input String.
     *
     * @param String str the String to reverse
     *
     * @return String the reversed String
     */
    public static function reverse(str:String):String
    {
        var reverse:StringBuf = new StringBuf();
        for (i in 0...str.length + 1) {
            reverse.add(str.charAt(str.length - i));
        }

        return reverse.toString();
    }

    /**
     * Converts the string to its Bool value.
     *
     * @param str the string to get the Bool value of
     *
     * @return Bool
     *
     * @throws lib.IllegalArgumentException if the string is no valid Bool value
     */
    public static function toBool(str:String):Bool
    {
        if (str != "false" && str != "true") {
            throw new IllegalArgumentException("String is not a valid Boolean value");
        }

        return str == "true";
    }

    /**
     * Returns an Array of all characters of the String.
     *
     * @param String str the String to get the characters from
     *
     * @return Array<lib.Char>
     */
    public static function toCharArray(str:String):Array<Char>
    {
        var chars:Array<Char> = new Array<Char>();
        for (char in StringTools.iterator(str)) {
            chars.push(char);
        }

        return chars;
    }
}
