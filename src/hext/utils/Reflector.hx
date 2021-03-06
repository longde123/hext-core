package hext.utils;

import haxe.ds.IntMap;
import haxe.ds.ObjectMap;
import haxe.ds.StringMap;
import haxe.ds.Vector;
import haxe.ds.WeakMap;
import hext.ICloneable;

using hext.ArrayTools;

/**
 * Reflection methods/algorithms wrapper class that provides various
 * methods dedicated to getting information about an object instance.
 */
@:final
class Reflector
{
    /**
     * Returns a (deep-)copy of the provided data (structure).
     *
     * TODO: fails for IMaps on Java target
     *
     * Note: If the provided argument is an object and implements
     *       the hext.ICloneable interface, the clone method of the instance
     *       is called (which ensures a deep-copy).
     *
     * @param Null<T> v    the data to clone
     * @param Bool    deep either to do a deep clone or not
     *
     * @return Null<T> the cloned data (structure)
     */
    public static function clone<T>(v:Null<T>, deep:Bool = true):Null<T>
    {
        var copy:T;
        if (v == null) {
            copy = null;
        } else {
            var childFn:T->T = if (deep) {
                Reflector.clone.bind(_, true);
            } else {
                function(v:T):T {
                    return v;
                }
            }

            if (Reflect.isObject(v) && !Std.is(v, String)) { // reference type
                if (Std.is(v, ICloneable)) {
                    copy = untyped v.clone();
                } else if (Std.is(v, Array)) {
                    copy = Type.createInstance(Type.getClass(v), []);
                    untyped {
                        var it:Iterator<Dynamic> = v.iterator();
                        for (item in it) {
                            copy.add(childFn(item));
                        }
                    }
                } else if (Std.is(v, IntMap) || Std.is(v, ObjectMap) || Std.is(v, StringMap) || Std.is(v, WeakMap)) {
                    copy = Type.createInstance(Type.getClass(v), []);
                    untyped {
                        var keys:Iterator<String> = v.keys();
                        for (key in keys) {
                            copy.set(key, childFn(v.get(key)));
                        }
                    }
                } else if (Std.is(v, List)) {
                    copy = Type.createInstance(Type.getClass(v), []);
                    untyped {
                        var it:Iterator<Dynamic> = v.iterator();
                        for (item in it) {
                            copy.push(childFn(item));
                        }
                    }
                } else if (Type.getClass(v) == null) { // anonymous struct
                    copy = Reflect.copy(v); // TODO: check if is deep-copy
                } else { // class
                    copy = Type.createEmptyInstance(Type.getClass(v));
                    for (field in Reflect.fields(v)) {
                        Reflect.setField(copy, field, childFn(Reflect.field(v, field)));
                    }
                }
            } else { // value type
                copy = v;
            }
        }

        return copy;
    }

    /**
     * Compares the two objects.
     *
     * @see hext.utils.Comparator
     *
     * @param T x the object based on which the return value is calculated
     * @param T y the object to compare against
     *
     * @return Int
     */
    public static function compare<T>(x:T, y:T):Int
    {
        if (x != y) {
            var diff:Int = Reflect.compare(x, y);
            if (diff != 0) {
                return (diff < 0) ? -1 : 1;
            }
        }

        return 0;
    }
}
