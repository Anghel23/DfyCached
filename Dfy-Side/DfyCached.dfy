// args[0] = program name
// args[1] = arg1
// args[2] = arg2
// args[...] = ...

method Main(args: seq<string>)
{
    if |args| < 2 {
        print "Invalid number of arguments.";
        return;
    }

    if(args[1] == "set") {
        if |args| != 6 {
            print "Usage: Set <name> <flags> <exptime> <bytes> [noreply] <data block>";
            return;
        }

        print "Good set";
    } else if args[1] == "get" {
        if |args| < 3 {
            print "Usage: get <name> (...)";
            return;
        }

        print "Good get";
    } else if args[1] == "incr"{
        if |args| != 4{
            print "Usage: incr <name> <value>";
            return;
        }

        print "Good incr";
    } else if args[1] == "append"{
        if |args| != 6{
            print "Usage: append <name> <value> <value> <value>";
            return;
        }

        print "Good append";
    } else if args[1] == "prepend"{
        if |args| != 6{
            print "Usage: prepend <name> <value> <value> <value>";
            return;
        }

        print "Good prepend";
    } else {
        print "Invalid command.";
    }
}
