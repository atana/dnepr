set version [lindex [mrd 0x0D000000] 1]
puts "version $version"

#puts "включение внутреннего генератора"
#mwr 0x40000004 0x1

set f_status 0
set i 0
while {$f_status != 0x00000003} {
	set f_status "0x[lindex [mrd 0xE0001000] 1]"
	incr i
	if {$i > 1000} {
		puts "Тактовые сигналы не в норме"
		exit
	}
}
puts "Тактовые сигналы в норме"

set cur_tact "0x[lindex [mrd 0x2000000c] 1]"
puts "Текущий такт: $cur_tact"

# puts "Упреждение 1 дискрет"
# mwr 0x30000014 0x1
# puts "Задержка в линии 1 дискрет"
# mwr 0x30000018 0x1

for {set i 0} {$i < 1000} {incr i} {
	set cur_tact "0x[lindex [mrd 0x2000000c] 1]"

	set incr_tact [expr {$cur_tact + 2}]
	set tact_srl [expr {($incr_tact << 16) & 0xffff0000}]

	set TR_start [expr {$tact_srl + 0x0}]
	set TR_stop  [expr {$tact_srl + 0x4}]
	set RC_start [expr {$tact_srl + 0x5}]
	set RC_stop  [expr {$tact_srl + 0x6}]

	# puts $TR_start
	# puts $TR_stop
	# puts $RC_start
	# puts $RC_stop

	mwr 0x3000001C $TR_start
	mwr 0x30000020 $TR_stop
	mwr 0x3000000C 0x1
	mwr 0x30000024 $RC_start
	mwr 0x30000028 $RC_stop
	mwr 0x30000010 0x1

	set decr 0
	while {$decr == 0} {
		set next_tact "0x[lindex [mrd 0x2000000c] 1]"
		set decr [expr {$cur_tact - $next_tact}]
	}

}
