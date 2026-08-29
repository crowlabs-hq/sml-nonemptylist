(*
    Copyright (c) 2026 CrowLabs (@crowlabs-hq)
    Author: Khalid B.

    This is free software: you can redistribute and/or modify it under the
    GNU General Public License v3 (or later). See https://www.gnu.org/licenses.
*)

signature NonEmptyList = sig
    (* The non-empty list type *)
    type 'a nonemptylist

    (*
        `a <| l` prepends the element `a` to the non-empty list `l`.
        This infix operator is an alias for `add_front`.
    *)
    val <| : 'a * 'a nonemptylist -> 'a nonemptylist

    (* Construct a singleton non-empty list containing the given element *)
    val new : 'a -> 'a nonemptylist

    (* Add an element to the end of the list *)
    val add_back : 'a -> 'a nonemptylist -> 'a nonemptylist

    (* Add an element to the beginning of the list *)
    val add_front : 'a -> 'a nonemptylist -> 'a nonemptylist

    (* Get the first element of the list *)
    val head : 'a nonemptylist -> 'a

    (* Get the last element of the list *)
    val last : 'a nonemptylist -> 'a

    (* Get all the elements of the list except the last one *)
    val init : 'a nonemptylist -> 'a list

    (* Get the tail of the list, that is, all elements except the first one *)
    val tail : 'a nonemptylist -> 'a list

    (* Get the length of the list *)
    val length : 'a nonemptylist -> int

    (* print_list f l
    Prints the list 'l' with a function 'f' that converts type 'a to string
    *)
    val print_list : ('a -> string) -> 'a nonemptylist -> unit
end
