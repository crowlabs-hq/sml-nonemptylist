(* polyc -o a.out test.sml *)

use "lib/github.com/crowlabs-hq/sml-nonemptylist/nonemptylist.sig";
use "lib/github.com/crowlabs-hq/sml-nonemptylist/nonemptylist.sml";

structure N = Nonemptylist
val op <| = N.<|

fun main () =
    let
        val my_list = N.new 10 |> N.add_back 30 |> N.add_back 20 |> N.add_front 5
        val modified_list = 42 <| my_list
    in
        print "[LIST] : "; modified_list |> N.print_list Int.toString; print "\n";

        print ("Length: " ^ (Int.toString (N.length modified_list)) ^ "\n");
        print ("Head: " ^ (Int.toString (N.head modified_list)) ^ "\n");
        print ("Last: " ^ (Int.toString (N.last modified_list)) ^ "\n");
        print "Init: "; List.app (fn x => print (Int.toString x ^ " ")) (N.init modified_list); print "\n";
        print "Tail: "; List.app (fn x => print (Int.toString x ^ " ")) (N.tail modified_list); print "\n"
end
