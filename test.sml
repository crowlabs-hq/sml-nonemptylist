(* polyc -o a.out test.sml *)

use "lib/github.com/crowlabs-hq/sml-nonemptylist/nonemptylist.sig";
use "lib/github.com/crowlabs-hq/sml-nonemptylist/nonemptylist.sml";

structure N = Nonemptylist
val op <| = N.<|

fun list_to_string (toString: 'a -> string) (l: 'a list) : string =
    let val str =
        case l of
            [] => "[]"
        | _ => "[" ^ String.concatWith " " (List.map toString l) ^ "]"
    in str end

fun nel_to_string (toString: 'a -> string) (l: 'a N.nonemptylist) : string =
    String.concatWith " " (toString (N.head l) :: List.map toString (N.tail l))

fun from_list_and_stringify (l: int list) : string =
    case N.from_list l of
        NONE => "NONE"
      | SOME nemptyl => "Some (" ^ Int.toString (N.head nemptyl) ^ ", [" ^
            String.concatWith ", " (List.map Int.toString (N.tail nemptyl)) ^ "])"

fun to_list_and_stringify (toString: 'a -> string) (l: 'a N.nonemptylist) : string =
    l |> N.to_list |> list_to_string toString

fun run_tests () : string =
    let
        val initial_nelist = N.new 10 |> N.add_back 30 |> N.add_back 20 |> N.add_front 5
        val int_nelist = 42 <| initial_nelist
        val helloworld_nelist = N.new "hello" |> N.add_back "world"
        (*TODO: replace this multiple add_back's approach with a new 'append' function that add mansy items *)
        val int_nelist_6_elems = List.foldl (fn (x, acc) => N.add_back x acc) (N.new 1) [2, 3, 4, 5, 6]
    in
        "[LIST] : " ^ nel_to_string Int.toString int_nelist ^ "\n" ^
        "[REV]  : " ^ nel_to_string Int.toString (N.reverse int_nelist) ^ "\n" ^
        "\n" ^

        "Length: " ^ Int.toString (N.length int_nelist) ^ "\n" ^
        "Head: " ^ Int.toString (N.head int_nelist) ^ "\n" ^
        "Last: " ^ Int.toString (N.last int_nelist) ^ "\n" ^
        "Init: " ^ list_to_string Int.toString (N.init int_nelist) ^ "\n" ^
        "Tail: " ^ list_to_string Int.toString (N.tail int_nelist) ^ "\n" ^

        (* from_list *)
        "from_list [1]: " ^ from_list_and_stringify [1] ^ "\n" ^
        "from_list [1,2,3]: " ^ from_list_and_stringify [1, 2, 3] ^ "\n" ^
        "from_list []: " ^ from_list_and_stringify [] ^ "\n" ^

        (* to_list *)
        "to_list (1, []): " ^ to_list_and_stringify Int.toString (N.new 1) ^ "\n" ^
        "to_list (1, [2]): " ^ to_list_and_stringify Int.toString (N.new 1 |> N.add_back 2) ^ "\n" ^
        "to_list (1, [2, 3, 4, 5, 6]): " ^ to_list_and_stringify Int.toString int_nelist_6_elems ^ "\n" ^
        "to_list (\"hello\", [\"world\"]): " ^ (to_list_and_stringify (fn s => s) helloworld_nelist) ^ "\n"
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