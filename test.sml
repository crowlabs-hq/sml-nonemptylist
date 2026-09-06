(* polyc -o a.out test.sml *)

use "lib/github.com/crowlabs-hq/sml-nonemptylist/nonemptylist.sig";
use "lib/github.com/crowlabs-hq/sml-nonemptylist/nonemptylist.sml";

structure N = Nonemptylist
val op <| = N.<|

fun list_to_string (toString: 'a -> string) (l: 'a list) : string =
    String.concatWith " " (List.map toString l)

fun nel_to_string (toString: 'a -> string) (l: 'a N.nonemptylist) : string =
    String.concatWith " " (toString (N.head l) :: List.map toString (N.tail l))

fun from_list_to_string (l: int list) : string =
    case N.from_list l of
        NONE => "NONE"
      | SOME nemptyl => "Some (" ^ Int.toString (N.head nemptyl) ^ ", [" ^
            String.concatWith ", " (List.map Int.toString (N.tail nemptyl)) ^ "])"

fun run_tests () : string =
    let
        val my_list = N.new 10 |> N.add_back 30 |> N.add_back 20 |> N.add_front 5
        val modified_list = 42 <| my_list
    in
        "[LIST] : " ^ nel_to_string Int.toString modified_list ^ "\n" ^
        "[REV]  : " ^ nel_to_string Int.toString (N.reverse modified_list) ^ "\n" ^
        "\n" ^
        "Length: " ^ Int.toString (N.length modified_list) ^ "\n" ^
        "Head: " ^ Int.toString (N.head modified_list) ^ "\n" ^
        "Last: " ^ Int.toString (N.last modified_list) ^ "\n" ^
        "Init: " ^ list_to_string Int.toString (N.init modified_list) ^ "\n" ^
        "Tail: " ^ list_to_string Int.toString (N.tail modified_list) ^ "\n" ^
        "from_list [1]: " ^ from_list_to_string [1] ^ "\n" ^
        "from_list [1,2,3]: " ^ from_list_to_string [1, 2, 3] ^ "\n" ^
        "from_list []: " ^ from_list_to_string []
    end

fun read_file (path: string) : string =
    let
        val in_stream = TextIO.openIn path
        val content = TextIO.inputAll in_stream
    in
        TextIO.closeIn in_stream;
        content
    end

fun main () =
    let
        val actual = run_tests ()
        val expected = read_file "test.ref"
    in
        if actual = expected
        then (print "Success ! Got the expected output.\n"; OS.Process.exit OS.Process.success)
        else
            let
                val tmp_file = "/tmp/nonemptylist_test_actual.txt"
                val out_stream = TextIO.openOut tmp_file
            in
                TextIO.output (out_stream, actual);
                TextIO.closeOut out_stream;
                print "Mismatch! Diff (test.ref vs actual):\n";
                OS.Process.system ("diff test.ref " ^ tmp_file);
                OS.FileSys.remove tmp_file;
                OS.Process.exit OS.Process.failure
            end
    end