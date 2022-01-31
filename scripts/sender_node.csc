atget id my_id
set recA 0
set recB 0
loop
if($recA==0)
	randb dest 289 386
	data RREQ $my_id 0 $dest
	send $RREQ
	cprint "invio RREQ per il nodo: " $dest
	set recA 1
end
wait
read RREP
rdata $RREP rid type dest
if($type==1)
	cprint "RREP ricevuto da: " $dest
	data MSG $my_id 2 500
	send $MSG $rid
	edge 0 $rid
	set recB 1
end
if(($type==3)&&(recB==1))
	set recB 0
	set recA 0
	data resetRecA $my_id 3 0
	send resetRecA
	cprint "inoltro il reset"
end
delay 3000
