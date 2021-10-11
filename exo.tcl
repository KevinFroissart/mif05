set ns [new Simulator]

$ns color 1 green
$ns color 2 red
$ns color 3 blue

set file1 [open out.tr w]
$ns trace-all $file1
set file2 [open out.nam w]
$ns namtrace-all $file2

proc finish {} {
global ns file1 file2
$ns flush-trace
close $file1
close $file2
exec nam out.nam &
exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 1.5Mb 20ms DropTail

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
set null [new Agent/Null]
$ns attach-agent $n3 $null
set sink [new Agent/TCPSink]
$ns attach-agent $n3 $sink
$ns connect $udp $null
$ns connect $tcp $sink
$udp set fid_ 1
$tcp set fid_ 2

set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp
$cbr0 set packetSize_ 1000
$cbr0 set rate_ 1Mb

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp

$ns at 1 "$cbr0 start"
$ns at 5 "$cbr0 stop"
$ns at 2 "$ftp0 start"
$ns at 4 "$ftp0 stop"

$ns at 5.0 "finish"
$ns run
