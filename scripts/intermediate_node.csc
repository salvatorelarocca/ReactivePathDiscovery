atget id my_id
set recA 0
set dest1 -1
loop
wait
read msg
rdata $msg rid type dest
if(($type==0)&&($recA==0))
	set recA 1
	#cprint "recA"
	if($dest==$my_id)
		mark 1
		data RREP $my_id 1 $dest
		#cprint $RREP
		send $RREP rid
		#cprint "invio a -->" $rid
		edge 1 $rid
		set dest1 dest
	else
		set prev $rid
		#cprint "precedente" $prev
		data RREQ $my_id 0 $dest
		#cprint $RREQ
		send $RREQ
		#mark 1
	end
end
if($type==1)
	data RREP $my_id 1 $dest
	set suc $rid
	#cprint "successore di " $my_id "e'" $suc
	send $RREP prev
	#cprint "invio a -->" $prev
	edge 1 $prev
end
if($type==2)
	if($dest1==$my_id)
		cprint "messaggio ricevuto!!!" $msg
		mark 0
		set recA 0
		data resetRecA $my_id 3 0
		send resetRecA
		set dest1 -1
	else
		data m $my_id 2 $dest
		cprint $msg " " $suc
		send $m $suc
		edge 0 $suc
	end
end
if(($type==3)&&($recA==1))
	set recA 0
	data resetRecA $my_id 3 0
	send resetRecA
	#mark 0
end
delay 1000
