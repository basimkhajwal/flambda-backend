(**************************************************************************)
(*                                                                        *)
(*                                 OCaml                                  *)
(*                                                                        *)
(*                       Pierre Chambart, OCamlPro                        *)
(*           Mark Shinwell and Leo White, Jane Street Europe              *)
(*                                                                        *)
(*   Copyright 2013--2016 OCamlPro SAS                                    *)
(*   Copyright 2014--2016 Jane Street Group LLC                           *)
(*                                                                        *)
(*   All rights reserved.  This file is distributed under the terms of    *)
(*   the GNU Lesser General Public License version 2.1, with the          *)
(*   special exception on linking described in the file LICENSE.          *)
(*                                                                        *)
(**************************************************************************)

[@@@ocaml.warning "+a-4-9-30-40-41-42"]

type t = string

include Container_types.Make (struct
  include String

  let hash = Hashtbl.hash

  let [@ocamlformat "disable"] print ppf t = Format.pp_print_string ppf t

  let output chan t = print (Format.formatter_of_out_channel chan) t
end)

let create t = t

let to_string t = t

(* CR mshinwell: this is dire *)
let rename t = t ^ "_"
