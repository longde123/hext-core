package hext.ds;

import haxe.Serializer;
import haxe.Unserializer;
import hext.IllegalArgumentException;
import hext.ISerializable;
import hext.ds.UnsortedSet;
import hext.utils.Comparator;

using hext.utils.Reflector;

/**
 * TODO
 *
 * Use cases:
 *   - Having a DS that doesn't allow duplicates and is fast to search in.
 */
class SortedSet<T> extends UnsortedSet<T> implements ISerializable
{
    /**
     * Stores either the sort() method should be called or not.
     *
     * @var Bool
     */
    private var doSort:Bool;


    /**
     * Constructor to initialize a new SortedSet.
     *
     * @param hext.utils.Comparator<T> comparator the Comparator used to check for item equality
     */
    public function new(comparator:Comparator<T>):Void
    {
        super(comparator);
        this.doSort = true;
    }

    /**
     * @{inherit}
     */
    override public function add(item:T):Bool
    {
        var success:Bool = super.add(item);
        if (this.doSort && success) {
            this.sort();
        }

        return success;
    }

    /**
     * @{inherit}
     */
    // overriden to prevent sorting after each add()
    override public function addAll(iterable:Iterable<T>):Int
    {
        this.doSort   = false;
        var added:Int = super.addAll(iterable);
        if (added != 0) {
            this.sort();
        }
        this.doSort = true;

        return added;
    }

    /**
     * @{inherit}
     */
    // overriden for better performance
    override public function contains(item:T):Bool
    {
        if (!this.isEmpty()) {
            // Binary search implementation from hext-search
            var first:Int = 0;
            var last:Int  = this.bag.length - 1;
            while (last >= first) {
                var middle:Int = Std.int((first + last) / 2);
                var ret:Int    = this.comparator(this.bag[middle], item);
                if (ret < 0) {
                    first = middle + 1;
                } else if (ret > 0) {
                    last = middle - 1;
                } else {
                    return true;
                }
            }
        }

        return false;
    }

    /**
     * @{inherit}
     */
    @:keep
    override public function hxSerialize(serializer:Serializer):Void
    {
        super.hxSerialize(serializer);
    }

    /**
     * @{inherit}
     */
    @:keep
    override public function hxUnserialize(unserializer:Unserializer):Void
    {
        super.hxUnserialize(unserializer);
        this.doSort = true;
    }

    /**
     * @{inherit}
     */
    override public function remove(item:T):Bool
    {
        var success:Bool = super.remove(item);
        if (this.doSort && success) {
            this.sort();
        }

        return success;
    }

    /**
     * @{inherit}
     */
    // overriden to prevent sorting after each remove()
    override public function removeAll(iterable:Iterable<T>):Int
    {
        this.doSort = false;
        var removed:Int = super.removeAll(iterable);
        if (removed != 0) {
            this.sort();
        }
        this.doSort = true;

        return removed;
    }

    /**
     * Sorts the items within the Set.
     */
    private function sort():Void
    {
        if (!this.isEmpty()) {
            this.bag.sort(this.comparator);
        }
    }

    /**
     * @{inherit}
     */
    override public function subSet(start:T, end:T):SortedSet<T>
    {
        if (this.comparator(start, end) == 1) {
            throw new IllegalArgumentException("End item cannot be less than start.");
        }

        var params:Array<Dynamic> = new Array<Dynamic>();
        params.push(Reflect.field(this, "comparator"));
        var sub:SortedSet<T> = Type.createInstance(Type.getClass(this), params);
        if (!this.isEmpty() && this.comparator(start, end) == -1) {
            var current:T = this.bag[0];
            var index:Int = 0;
            // TODO: binary search like implementation
            while (this.comparator(current, start) == -1) {
                current = this.bag[++index];
            }
            while (this.comparator(current, end) == -1) {
                sub.add(current.clone(true));
                current = this.bag[++index];
            }
        }

        return sub;
    }
}
