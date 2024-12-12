module {:extern "MM"} MM {
  newtype {:nativeType "byte"} byte = x : int | 0 <= x < 256
  class {:extern "C"} C {
    static method {:extern "init"} init()
    static method {:extern "put"} put(buffer: array<byte>)
    static method {:extern "get"} get() returns (r : array<byte>)
  }
}

method Main(args: seq<string>) {
  MM.C.init();
  var input_raw := MM.C.get();
  MM.C.put(input_raw);
}