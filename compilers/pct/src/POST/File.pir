
.namespace []
.sub "_block1000"  :anon :subid("10_1308206294.1966")
.annotate 'line', 0
    .const 'Sub' $P1003 = "11_1308206294.1966" 
    capture_lex $P1003
.annotate 'line', 1
    $P0 = find_dynamic_lex "$*CTXSAVE"
    if null $P0 goto ctxsave_done
    $I0 = can $P0, "ctxsave"
    unless $I0 goto ctxsave_done
    $P0."ctxsave"()
  ctxsave_done:
.annotate 'line', 10
    .const 'Sub' $P1003 = "11_1308206294.1966" 
    capture_lex $P1003
    $P113 = $P1003()
.annotate 'line', 1
    .return ($P113)
    .const 'Sub' $P1023 = "14_1308206294.1966" 
    .return ($P1023)
.end


.namespace []
.sub "" :load :init :subid("post15") :outer("10_1308206294.1966")
.annotate 'line', 0
    .const 'Sub' $P1001 = "10_1308206294.1966" 
    .local pmc block
    set block, $P1001
    $P1025 = get_root_global ["parrot"], "P6metaclass"
    $P1025."new_class"("POST::File", "POST::Node" :named("parent"))
.end


.namespace ["POST";"File"]
.sub "_block1002"  :subid("11_1308206294.1966") :outer("10_1308206294.1966")
.annotate 'line', 10
    .const 'Sub' $P1004 = "12_1308206294.1966" 
    capture_lex $P1004
    $P0 = find_dynamic_lex "$*CTXSAVE"
    if null $P0 goto ctxsave_done
    $I0 = can $P0, "ctxsave"
    unless $I0 goto ctxsave_done
    $P0."ctxsave"()
  ctxsave_done:
    .const 'Sub' $P1004 = "12_1308206294.1966" 
    newclosure $P1018, $P1004
    .return ($P1018)
    .const 'Sub' $P1020 = "13_1308206294.1966" 
    .return ($P1020)
.end


.namespace ["POST";"File"]
.include "except_types.pasm"
.sub "sub"  :subid("12_1308206294.1966") :method :outer("11_1308206294.1966")
    .param pmc param_1007
    .param pmc param_1008 :optional
    .param int has_param_1008 :opt_flag
.annotate 'line', 10
    new $P1006, ['ExceptionHandler'], .CONTROL_RETURN
    set_label $P1006, control_1005
    push_eh $P1006
    .lex "self", self
    .lex "$name", param_1007
    if has_param_1008, optparam_16
    new $P101, "Undef"
    set param_1008, $P101
  optparam_16:
    .lex "$value", param_1008
.annotate 'line', 11
    $P1010 = root_new ['parrot';'Hash']
    set $P1009, $P1010
    .lex "%subs", $P1009
    find_lex $P1011, "self"
    unless_null $P1011, vivify_17
    $P1011 = root_new ['parrot';'Hash']
  vivify_17:
    set $P102, $P1011["subs"]
    unless_null $P102, vivify_18
    new $P102, "Undef"
  vivify_18:
    store_lex "%subs", $P102
.annotate 'line', 12
    find_lex $P103, "%subs"
    if $P103, unless_1012_end
.annotate 'line', 13
    $P104 = "hash"()
    find_lex $P1013, "self"
    unless_null $P1013, vivify_19
    $P1013 = root_new ['parrot';'Hash']
    store_lex "self", $P1013
  vivify_19:
    set $P1013["subs"], $P104
.annotate 'line', 14
    find_lex $P1014, "self"
    unless_null $P1014, vivify_20
    $P1014 = root_new ['parrot';'Hash']
  vivify_20:
    set $P105, $P1014["subs"]
    unless_null $P105, vivify_21
    new $P105, "Undef"
  vivify_21:
    store_lex "%subs", $P105
  unless_1012_end:
.annotate 'line', 17
    find_lex $P106, "$value"
    unless $P106, if_1015_end
.annotate 'line', 18
    find_lex $P107, "$value"
    find_lex $P108, "$name"
    find_lex $P1016, "%subs"
    unless_null $P1016, vivify_22
    $P1016 = root_new ['parrot';'Hash']
    store_lex "%subs", $P1016
  vivify_22:
    set $P1016[$P108], $P107
  if_1015_end:
.annotate 'line', 17
    find_lex $P109, "$name"
    find_lex $P1017, "%subs"
    unless_null $P1017, vivify_23
    $P1017 = root_new ['parrot';'Hash']
  vivify_23:
    set $P110, $P1017[$P109]
    unless_null $P110, vivify_24
    new $P110, "Undef"
  vivify_24:
.annotate 'line', 10
    .return ($P110)
  control_1005:
    .local pmc exception 
    .get_results (exception) 
    getattribute $P111, exception, "payload"
    .return ($P111)
.end


.namespace ["POST";"File"]
.sub "_block1019" :load :anon :subid("13_1308206294.1966")
.annotate 'line', 10
    .const 'Sub' $P1021 = "11_1308206294.1966" 
    $P112 = $P1021()
    .return ($P112)
.end


.namespace []
.sub "_block1022" :load :anon :subid("14_1308206294.1966")
.annotate 'line', 1
    .const 'Sub' $P1024 = "10_1308206294.1966" 
    $P114 = $P1024()
    .return ($P114)
.end
