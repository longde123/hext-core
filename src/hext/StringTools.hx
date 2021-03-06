package hext;

import hext.Char;
import hext.Failure;
import hext.IllegalArgumentException;
import hext.StringIterator;

using hext.ArrayTools;

/**
 * The StringTools utilities class adds several helpful methods
 * to the standard String class.
 */
@:final
class StringTools
{
    /**
     * Checks if the string contains the substring 'sub'.
     *
     * @param String str the string to search in
     * @param String sub the substring to search
     *
     * @return Bool
     */
    public static inline function contains(str:String, sub:String):Bool
    {
        return str.indexOf(sub) != -1;
    }

    /**
     * Checks if the string contains all substrings within the Iterable.
     *
     * Attn: The search doesn't move forward. So the method will return true for
     * the string 'abc' and a search Iterable of ["ab", "bc"].
     *
     * If the Iterable is empty, true is returned.
     *
     * @param String                 str   the string to search in
     * @param Null<Iterable<String>> subs  the substrings to search
     * @param Null<Failure<T>>       fails if set and 'fail' is not null, the method will
     *                               abort at the first substring that is not contained and set
     *                               the reference to its value. If 'fails' is not-null (on or the other)
     *                               the method will check all and include all not-contained items within
     *                               the fails Array.
     *
     * @return Bool
     */
    public static function containsAll(str:String, subs:Null<Iterable<String>>, ?fails:Failure<String>):Bool
    {
        var contains:Bool = true;
        if (subs != null) {
            for (sub in subs) {
                if (!StringTools.contains(str, sub)) {
                    contains = false;
                    if (fails != null) {
                        if (fails.fail == null) {
                            fails.fails.add(sub);
                        } else {
                            fails.fail.val = sub;
                            break;
                        }
                    }
                }
            }
        }

        return contains;
    }

    /**
     * Checks if all string characters are lower-case.
     *
     * Attn: If the string is empty, true is returned.
     *
     * @param String str the string to check
     *
     * @return Bool true if all is lower
     */
    public static function isLowerCase(str:String):Bool
    {
        for (i in 0...str.length) {
            var c:Char = str.charCodeAt(i);
            if (Char.isLetter(c) && Char.isUpperCase(c)) {
                return false;
            }
        }

        return true;
    }

    /**
     * Checks if all string characters are upper-case.
     *
     * Attn: If the string is empty, true is returned.
     *
     * @param String str the string to check
     *
     * @return Bool true if all is upper
     */
    public static function isUpperCase(str:String):Bool
    {
        for (i in 0...str.length) {
            var c:Char = str.charCodeAt(i);
            if (Char.isLetter(c) && Char.isLowerCase(c)) {
                return false;
            }
        }

        return true;
    }

    /**
     * Returns an Iterator that can be used to access every character of the String.
     *
     * @param String str the String to iterate over
     *
     * @return hext.StringIterator
     */
    public static inline function iterator(str:String):StringIterator
    {
        return new StringIterator(str);
    }

    /**
     * Reverses all characters of the String and returns the reversed one.
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
     * @throws hext.IllegalArgumentException if the string is no valid Bool value
     */
    public static function toBool(str:String):Bool
    {
        str = str.toLowerCase();
        if (str == "false" || str == "true") {
            return str == "true";
        }

        throw new IllegalArgumentException("String is not a valid Bool value.");
    }

    /**
     * Returns an Array of all characters of the String.
     *
     * @param String str the String to get the characters for
     *
     * @return Array<hext.Char>
     */
    public static function toCharArray(str:String):Array<Char>
    {
        var chars:Array<Char> = new Array<Char>();
        for (char in StringTools.iterator(str)) {
            chars.add(char);
        }

        return chars;
    }
}
