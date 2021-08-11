(**************************************************************************)
(*                                                                        *)
(*                                 OCaml                                  *)
(*                                                                        *)
(*                  Mark Shinwell, Jane Street Europe                     *)
(*                                                                        *)
(*   Copyright 2013--2018 Jane Street Group LLC                           *)
(*                                                                        *)
(*   All rights reserved.  This file is distributed under the terms of    *)
(*   the GNU Lesser General Public License version 2.1, with the          *)
(*   special exception on linking described in the file LICENSE.          *)
(*                                                                        *)
(**************************************************************************)

(** Values written into DWARF sections.
    (For attribute values, see [Dwarf_attribute_values].)
*)

[@@@ocaml.warning "+a-4-30-40-41-42"]

module A = Asm_directives

module Int8 = Numbers.Int8
module Int16 = Numbers.Int16

type t =
  | Flag_true
  | Bool of bool
  | Int8 of Int8.t
  | Int16 of Int16.t
  | Int32 of Int32.t
  | Int64 of Int64.t
  | Uleb128 of Int64.t
  | Sleb128 of Int64.t
  | String of string
  | Indirect_string of string
  | Absolute_code_address of Targetint.t
  | Code_address_from_label of Dwarf_misc.label
  | Code_address_from_symbol of string
  | Code_address_from_label_symbol_diff of
      { upper : Dwarf_misc.label; lower : string;
        offset_upper : Targetint.t;
      }
  | Code_address_from_symbol_diff of { upper : string; lower : string; }
  | Code_address_from_symbol_plus_bytes of string * Targetint.t
  | Offset_into_debug_info of Dwarf_misc.label
  | Offset_into_debug_info_from_symbol of string
  | Offset_into_debug_line of Dwarf_misc.label
  | Offset_into_debug_line_from_symbol of string
  | Offset_into_debug_loc of Dwarf_misc.label
  | Offset_into_debug_abbrev of Dwarf_misc.label
  | Distance_between_labels_32bit of { upper : Dwarf_misc.cmm_label; lower : Dwarf_misc.cmm_label; }

(* DWARF-4 standard section 7.6. *)
let rec uleb128_size i =
  assert (Int64.compare i 0L >= 0);
  if Int64.compare i 128L < 0 then 1L
  else Int64.add 1L (uleb128_size (Int64.shift_right_logical i 7))

let rec sleb128_size i =
  if Int64.compare i (-64L) >= 0 && Int64.compare i 64L < 0 then 1L
  else Int64.add 1L (sleb128_size (Int64.shift_right i 7))

let size t =
  match t with
  | Flag_true -> 0L  (* see comment below *)
  | Bool _ -> 1L
  | Int8 _ -> 1L
  | Int16 _ -> 2L
  | Int32 _ -> 4L
  | Int64 _ -> 8L
  | Uleb128 i -> uleb128_size i
  | Sleb128 i -> sleb128_size i
  | Absolute_code_address _
  | Code_address_from_label _
  | Code_address_from_symbol _ 
  | Code_address_from_label_symbol_diff _
  | Code_address_from_symbol_diff _
  | Code_address_from_symbol_plus_bytes _ ->
    begin match Targetint.size with
    | 32 -> 4L
    | 64 -> 8L
    | bits -> Misc.fatal_errorf "Unsupported Targetint.size %d" bits
    end
  | String str -> Int64.of_int (String.length str + 1)
  | Indirect_string _
  | Offset_into_debug_line _
  | Offset_into_debug_line_from_symbol _
  | Offset_into_debug_info _
  | Offset_into_debug_info_from_symbol _
  | Offset_into_debug_loc _
  | Offset_into_debug_abbrev _ ->
    Dwarf_int.size (Dwarf_int.zero ())
  | Distance_between_labels_32bit _ -> 4L

let emit t =
  let width_for_ref_addr_or_sec_offset () : Target_system.machine_width =
    (* DWARF-4 specification p.142. *)
    match Dwarf_format.get () with
    | Thirty_two -> Thirty_two
    | Sixty_four -> Sixty_four
  in
  match t with
  | Flag_true -> ()  (* DWARF-4 specification p.148 *)
  | Bool b -> A.int8 (if b then Int8.one else Int8.zero)
  | Int8 i -> A.int8 i
  | Int16 i -> A.int16 i
  | Int32 i -> A.int32 i
  | Int64 i -> A.int64 i
  | Uleb128 i -> A.uleb128 i
  | Sleb128 i -> A.sleb128 i
  | String str -> A.string str
  | Indirect_string s ->
    (* "Indirect" strings are collected together into ".debug_str". *)
    let label = A.cache_string s in
    A.offset_into_section_label ~section:(DWARF Debug_str) ~label
      ~width:(width_for_ref_addr_or_sec_offset ())
  | Absolute_code_address addr -> A.targetint addr
  | Code_address_from_label label -> A.label label
  | Code_address_from_symbol symbol -> A.symbol symbol
  | Code_address_from_label_symbol_diff { upper; lower; offset_upper; } ->
    A.between_symbol_and_label_offset ~upper ~lower ~offset_upper
  | Code_address_from_symbol_diff { upper; lower; } ->
    A.between_symbols ~upper ~lower
  | Code_address_from_symbol_plus_bytes (symbol, offset_in_bytes) ->
    A.symbol_plus_offset ~symbol ~offset_in_bytes
  | Offset_into_debug_line label ->
    A.offset_into_section_label ~section:(DWARF Debug_line) ~label
      ~width:(width_for_ref_addr_or_sec_offset ())
  | Offset_into_debug_line_from_symbol symbol ->
    A.offset_into_section_symbol ~section:(DWARF Debug_line) ~symbol
      ~width:(width_for_ref_addr_or_sec_offset ())
  | Offset_into_debug_info label ->
    A.offset_into_section_label ~section:(DWARF Debug_info) ~label
      ~width:(width_for_ref_addr_or_sec_offset ())
  | Offset_into_debug_info_from_symbol symbol ->
    A.offset_into_section_symbol ~section:(DWARF Debug_info) ~symbol
      ~width:(width_for_ref_addr_or_sec_offset ())
  | Offset_into_debug_loc label ->
    A.offset_into_section_label ~section:(DWARF Debug_loc) ~label
      ~width:(width_for_ref_addr_or_sec_offset ())
  | Offset_into_debug_abbrev label ->
    A.offset_into_section_label ~section:(DWARF Debug_abbrev) ~label
      ~width:(width_for_ref_addr_or_sec_offset ())
  | Distance_between_labels_32bit { upper; lower; } ->
    (* CR-someday mshinwell: This should really be checked for overflow, but
       seems hard... *)
    A.between_labels_32bit ~upper ~lower
