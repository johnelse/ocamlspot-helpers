open Variant

let rec fact = function
  | 0 -> 1
  | n -> n * (fact (n-1))

let _ =
  print_int (fact 5);
  print_newline ();
  print_endline (Variant.check_variant_default `maybe)
