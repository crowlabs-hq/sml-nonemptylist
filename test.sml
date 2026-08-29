(* polyc -o a.out test.sml *)

use "lib/github.com/crowlabs-hq/sml-nonemptylist/nonemptylist.sig";
use "lib/github.com/crowlabs-hq/sml-nonemptylist/nonemptylist.sml";

fun main () =
    let
        open Nonemptylist
        val my_list = new 10 |> add_back 30 |> add_back 20 |> add_front 5
        val modified_list = 42 <| my_list
    in
        print "[LIST] : "; modified_list |> print_list Int.toString; print "\n";

        print ("Length: " ^ (Int.toString (length modified_list)) ^ "\n");
        print ("Head: " ^ (Int.toString (head modified_list)) ^ "\n");
        print ("Last: " ^ (Int.toString (last modified_list)) ^ "\n");
        print "Init: "; List.app (fn x => print (Int.toString x ^ " ")) (init modified_list); print "\n";
        print "Tail: "; List.app (fn x => print (Int.toString x ^ " ")) (tail modified_list); print "\n"
end