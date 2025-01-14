(**************************************************************************)
(*                                                                        *)
(*                                 OCaml                                  *)
(*                                                                        *)
(*             Xavier Leroy, projet Cristal, INRIA Rocquencourt           *)
(*                                                                        *)
(*   Copyright 1996 Institut National de Recherche en Informatique et     *)
(*     en Automatique.                                                    *)
(*                                                                        *)
(*   All rights reserved.  This file is distributed under the terms of    *)
(*   the GNU Lesser General Public License version 2.1, with the          *)
(*   special exception on linking described in the file LICENSE.          *)
(*                                                                        *)
(**************************************************************************)
external raise : exn -> 'a = "%raise"

external raise_notrace : exn -> 'a = "%raise_notrace"

external ( |> ) : 'a -> ('a -> 'b) -> 'b = "%revapply"

external ( @@ ) : ('a -> 'b) -> 'a -> 'b = "%apply"

external __LOC__ : string = "%loc_LOC"

external __FILE__ : string = "%loc_FILE"

external __LINE__ : int = "%loc_LINE"

external __MODULE__ : string = "%loc_MODULE"

external __POS__ : string * int * int * int = "%loc_POS"

external __LOC_OF__ : 'a -> string * 'a = "%loc_LOC"

external __LINE_OF__ : 'a -> int * 'a = "%loc_LINE"

external __POS_OF__ : 'a -> (string * int * int * int) * 'a = "%loc_POS"

external ( = ) : 'a -> 'a -> bool = "%equal"

external ( <> ) : 'a -> 'a -> bool = "%notequal"

external ( < ) : 'a -> 'a -> bool = "%lessthan"

external ( > ) : 'a -> 'a -> bool = "%greaterthan"

external ( <= ) : 'a -> 'a -> bool = "%lessequal"

external ( >= ) : 'a -> 'a -> bool = "%greaterequal"

external compare : 'a -> 'a -> int = "%compare"

external ( == ) : 'a -> 'a -> bool = "%eq"

external ( != ) : 'a -> 'a -> bool = "%noteq"

external not : bool -> bool = "%boolnot"

external ( & ) : bool -> bool -> bool = "%sequand"

external ( && ) : bool -> bool -> bool = "%sequand"

external ( or ) : bool -> bool -> bool = "%sequor"

external ( || ) : bool -> bool -> bool = "%sequor"

external ( ~- ) : int -> int = "%negint"

external ( ~+ ) : int -> int = "%identity"

external succ : int -> int = "%succint"

external pred : int -> int = "%predint"

external ( + ) : int -> int -> int = "%addint"

external ( - ) : int -> int -> int = "%subint"

external ( * ) : int -> int -> int = "%mulint"

external ( / ) : int -> int -> int = "%divint"

external ( mod ) : int -> int -> int = "%modint"

external ( land ) : int -> int -> int = "%andint"

external ( lor ) : int -> int -> int = "%orint"

external ( lxor ) : int -> int -> int = "%xorint"

external ( lsl ) : int -> int -> int = "%lslint"

external ( lsr ) : int -> int -> int = "%lsrint"

external ( asr ) : int -> int -> int = "%asrint"

external ( ~-. ) : float -> float = "%negfloat"

external ( ~+. ) : float -> float = "%identity"

external ( +. ) : float -> float -> float = "%addfloat"

external ( -. ) : float -> float -> float = "%subfloat"

external ( *. ) : float -> float -> float = "%mulfloat"

external ( /. ) : float -> float -> float = "%divfloat"

external ( ** ) : float -> float -> float = "caml_power_float" "pow"

external exp : float -> float = "caml_exp_float" "exp" [@@unboxed] [@@noalloc]

external expm1 : float -> float = "caml_expm1_float" "caml_expm1"

external acos : float -> float = "caml_acos_float" "acos"

external asin : float -> float = "caml_asin_float" "asin"

external atan : float -> float = "caml_atan_float" "atan"

external atan2 : float -> float -> float = "caml_atan2_float" "atan2"

external cos : float -> float = "caml_cos_float" "cos" [@@unboxed] [@@noalloc]

external cosh : float -> float = "caml_cosh_float" "cosh"

external log : float -> float = "caml_log_float" "log" [@@unboxed] [@@noalloc]

external log10 : float -> float = "caml_log10_float" "log10"

external log1p : float -> float = "caml_log1p_float" "caml_log1p"

external sin : float -> float = "caml_sin_float" "sin" [@@unboxed] [@@noalloc]

external sinh : float -> float = "caml_sinh_float" "sinh"

external sqrt : float -> float = "caml_sqrt_float" "sqrt"

external tan : float -> float = "caml_tan_float" "tan" [@@unboxed] [@@noalloc]

external tanh : float -> float = "caml_tanh_float" "tanh"

external ceil : float -> float = "caml_ceil_float" "ceil"

external floor : float -> float = "caml_floor_float" "floor"

external abs_float : float -> float = "%absfloat"

external mod_float : float -> float -> float = "caml_fmod_float" "fmod"

external frexp : float -> float * int = "caml_frexp_float"

external modf : float -> float * float = "caml_modf_float"

external float : int -> float = "%floatofint"

external float_of_int : int -> float = "%floatofint"

external truncate : float -> int = "%intoffloat"

external int_of_float : float -> int = "%intoffloat"

external string_length : string -> int = "%string_length"

external bytes_length : bytes -> int = "%bytes_length"

external bytes_create : int -> bytes = "caml_create_bytes"

external bytes_unsafe_to_string : bytes -> string = "%bytes_to_string"

external int_of_char : char -> int = "%identity"

external unsafe_char_of_int : int -> char = "%identity"

external ignore : 'a -> unit = "%ignore"

external fst : 'a * 'b -> 'a = "%field0"

external snd : 'a * 'b -> 'b = "%field1"

type 'a ref = { mutable contents : 'a }

external ref : 'a -> 'a ref = "%makemutable"

external ( ! ) : 'a ref -> 'a = "%field0"

external ( := ) : 'a ref -> 'a -> unit = "%setfield0"

external incr : int ref -> unit = "%incr"

external decr : int ref -> unit = "%decr"

external format_int : string -> int -> string = "caml_format_int"

external format_float : string -> float -> string = "caml_format_float"

external int_of_string : string -> int = "caml_int_of_string"

external string_get : string -> int -> char = "%string_safe_get"

external float_of_string : string -> float = "caml_float_of_string"

external sys_exit : int -> 'a = "caml_sys_exit"

let failwith s = raise (Failure s)

let invalid_arg s = raise (Invalid_argument s)

module type OrderedType = sig
  type t

  val compare : t -> t -> int
end

[@@@ocaml.warning "-26"]

module Make (Ord : OrderedType) = struct
  type key = Ord.t

  type 'a t =
    | Empty
    | Node of
        { l : 'a t;
          v : key;
          d : 'a;
          r : 'a t;
          h : int
        }

  let[@inline never] bal _ _ _ _ = assert false

  let[@inline never] min_binding_opt _ = assert false

  let[@inline never] join _ _ _ _ = assert false

  let rec min_binding = function
    | Empty -> raise Not_found
    | Node { l = Empty; v; d } -> v, d
    | Node { l } -> min_binding l

  let rec remove_min_binding = function
    | Empty -> invalid_arg "Map.remove_min_elt"
    | Node { l = Empty; r } -> r
    | Node { l = l2; v; d; r } -> bal (remove_min_binding l2) v d r

  let[@inline always] concat t1a t2b =
    match t1a, t2b with
    | Empty, t -> t
    | t, Empty -> t
    | _, _ ->
      let x, d = min_binding t2b in
      let t2c = remove_min_binding t2b in
      assert false

  let concat_or_join t1 v d t2 =
    match d with Some d -> assert false | None -> concat t1 t2
end
