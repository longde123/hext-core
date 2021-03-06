package hext.vm;

import hext.Closure;
import hext.IllegalStateException;
import hext.threading.ISynchronizer;
import hext.threading.Synchronizer;
import hext.vm.Thread;

/**
 * The Looper class extends Threads and execute the callback
 * function multiple times - until the Looper gets destroyed.
 *
 * Use cases:
 *   - Doing action 'X' every 'Y' seconds.
 *   - Process all callbacks passed to a hext.vm.IDeque.
 */
class Looper extends Thread
{
    /**
     * Stores the Synchronizer used to perform atomic operations.
     *
     * @var hext.threading.ISynchronizer
     */
    @:final private var synchronizer:ISynchronizer;

    #if !cs
        /**
         * Stores the Looper's state.
         *
         * @var hext.vm.Looper.State
         */
        private var state:State;
    #end


    /**
     * Constructor to initialize a new Looper instance.
     *
     * @param hext.vm.Thread.VMThread handle the underlaying Thread to wrap
     */
    private function new(handle:VMThread):Void
    {
        super(handle);

        this.synchronizer = new Synchronizer();
        #if !cs
            this.state = State.INITIALIZED;
        #end
    }

    /**
     * @{inherit}
     */
    public static function current():Looper
    {
        return new Looper(Thread.current().handle);
    }

    /**
     * @{inherit}
     */
    public static function create(fn:Closure):Looper
    {
        var looper:Looper = new Looper(Thread.create(function():Void {
            var self:Looper = Looper.readMessage(true);
            while (!self.isDestroyed()) {
                fn();
            }
            self.handle = null;
        }).handle);
        looper.sendMessage(looper);

        return looper;
    }

    /**
     * Destroys the Looper.
     *
     * The Looper is not destroyed immediately, but when the next loop
     * iteration would be entered.
     *
     * @throws hext.IllegalStateException if the Looper has already been destroyed
     */
    public function destroy():Void
    {
        this.synchronizer.sync(function():Void {
            #if cs
                this.handle.Abort();
            #else
                if (this.state == State.DESTROYED) {
                    throw new IllegalStateException("Cannot destroy an already destroyed Looper.");
                }
                this.state = State.DESTROYED;
            #end
        });
    }

    /**
     * Checks if the Looper is alive/looping.
     *
     * @return Bool
     */
    public inline function isAlive():Bool
    {
        return !this.isDestroyed();
    }

    /**
     * Checks if the Looper has been destroyed.
     *
     * @return Bool
     */
    public function isDestroyed():Bool
    {
        var ret:Bool;
        this.synchronizer.sync(function():Void {
            #if cs
                ret = !this.handle.IsAlive;
            #else
                ret = (this.state == State.DESTROYED);
            #end
        });

        return ret;
    }

    /**
     * @{inherit}
     */
    public static inline function readMessage(block:Bool):Null<Dynamic>
    {
        return Thread.readMessage(block);
    }
}


#if !cs
    /**
     * Enum for the States a Looper can be in.
     */
    private enum State
    {
        DESTROYED;
        INITIALIZED;
        LOOPING;
    }
#end
