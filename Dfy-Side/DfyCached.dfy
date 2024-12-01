method Main(args: seq<string>)
{
    if |args| < 2 {
        print "Invalid number of arguments.";
        return;
    }

    var message := args[1];
    if message == "test" {
        print "ok";
    } else {
        print "error";
    }
}
