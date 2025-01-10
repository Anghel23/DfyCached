module {:extern "MM"} MM {
  newtype {:nativeType "byte"} byte = x : int | 0 <= x < 256
  class {:extern "C"} C {
    static method {:extern "init"} init()
    static method {:extern "put"} put(buffer: array<byte>)
    static method {:extern "get"} get() returns (r : array<byte>)
  }
}

method BytesToString(bytes: seq<MM.byte>) returns (result: string)
    ensures |result| == |bytes|
    ensures forall i :: 0 <= i < |bytes| ==> result[i] == bytes[i] as char
{
    var s := "";
    var i := 0;
    while i < |bytes|
        invariant 0 <= i <= |bytes|
        invariant |s| == i
        invariant forall j :: 0 <= j < i ==> s[j] == bytes[j] as char
    {
        s := s + [bytes[i] as char];
        i := i + 1;
    }
    result := s;
}

method StringToBytes(s: string) returns (result: array<MM.byte>)
    requires forall i :: 0 <= i < |s| ==> 0 <= s[i] as int < 256
    ensures result.Length == |s|
    ensures forall i :: 0 <= i < |s| ==> result[i] == s[i] as MM.byte
{
    result := new MM.byte[|s|];
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant forall j :: 0 <= j < i ==> result[j] == s[j] as MM.byte
    {
        result[i] := s[i] as MM.byte;
        i := i + 1;
    }
}

method InputToArgs(s: string) returns (args: seq<string>)
{
    var parts := [];
    var current := "";
    var i := 0;
    while i < |s|
        invariant 0 <= i <= |s|
        invariant |parts| >= 0
    {
        if s[i] == ' ' {
            if |current| > 0 {
                parts := parts + [current];
                current := "";
            }
        } else {
            current := current + [s[i]];
        }
        i := i + 1;
    }
    if |current| > 0 {
        parts := parts + [current];
    }
    args := parts;
}

method Main(args: seq<string>)
{
  MM.C.init();
  var input_raw : array<MM.byte> := MM.C.get();
  var input := BytesToString(input_raw[..]);
  var split_input := [];
  split_input := InputToArgs(input);

  if |split_input| == 5 && split_input[0] == "set"{
    var key_name := split_input[1];
    var flags := split_input[2];
    var exptime := split_input[3];
    var bytes := split_input[4];
    var output := "";
    var output_raw := StringToBytes(output);

    MM.C.put(output_raw);

    input_raw := MM.C.get();
    input := BytesToString(input_raw[..]);
    split_input := InputToArgs(input);

    if |split_input| == 1{
      var key_name := split_input[0];
      output := "END";
      output_raw := StringToBytes(output);
      MM.C.put(output_raw);
    }
  }
}