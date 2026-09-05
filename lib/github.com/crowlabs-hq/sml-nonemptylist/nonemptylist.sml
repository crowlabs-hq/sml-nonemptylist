(*
    Copyright (c) 2026 CrowLabs (@crowlabs-hq)
    Author: Khalid B.

    This is free software: you can redistribute and/or modify it under the
    GNU General Public License v3 (or later). See https://www.gnu.org/licenses.
*)

infix |>
fun x |> f = f x

infixr 5 <|

structure Nonemptylist :> NonEmptyList = struct
    type 'a nonemptylist = 'a * 'a list

    fun new (elem: 'a) : 'a nonemptylist = (elem, [])

    fun add_front (elem: 'a) ((first, rest) : 'a nonemptylist) : 'a nonemptylist =
        (elem, first :: rest)

    fun add_back (elem: 'a) ((first, rest) : 'a nonemptylist ) : 'a nonemptylist =
        (first, rest @ [elem])

    fun head ((first, _): 'a nonemptylist) : 'a = first

    fun tail ((_, rest): 'a nonemptylist) : 'a list = rest

    fun last ((first, rest): 'a nonemptylist) : 'a =
        case rest of
            [] => first
        | [x] => x
        | _ :: tail => last (first, tail)

    fun init ((first, rest): 'a nonemptylist) : 'a list =
        case rest of
            [] => []
        | [_] => [first]
        | head :: tail => first :: (init (head, tail))

    fun length (l: 'a nonemptylist) : int =
        let
            val (_, tail) = l
            fun count l acc =
                case l of
                    [] => acc
                | _ :: rest => count rest (acc + 1)
        in
            1 + count tail 0
        end

    fun print_list (toString: 'a -> string) (l: 'a nonemptylist) : unit =
        let val (first, rest) = l
        in
            print ((toString first) ^ " ");
            List.app (fn x => print ((toString x) ^ " ")) rest;
            print "\n"
        end

    val op <| = fn (a, l) => add_front a l

    fun reverse ((first, rest) : 'a nonemptylist) : 'a nonemptylist =
        let
            fun rev_acc [] acc = acc
                | rev_acc (f :: r) (accF, accR) = rev_acc r (f, accF :: accR)
        in
            rev_acc rest (first, [])
        end

    fun from_list (l: 'a list) : 'a nonemptylist option =
        case l of
            [] => NONE
          | head :: tail => SOME (head, tail)
end