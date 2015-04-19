#启动脚本
#sh start.sh 普通启动
#-n 以nohup的方式启动，并保存PID 
#-k 杀死进程
#-s 显示进程信息

pid=skynet.pid

case "$1"  in
	"-n")
	echo "nohup start "
	nohup ./skynet/skynet work/config.server  1>nohup.out 2>&1 &
	echo $! > $pid
	;;

	"-k")
	echo "kill the progress"
	if [ -f $pid ]; then
		if kill -0 `cat $pid` > /dev/null 2>&1; then
			kill `cat $pid`
		else
			echo no $pid to stop
		fi
	else
		echo no $pid to stop
	fi
	rm -f $pid
	;;
	

	"-s")
	echo "show progress infomation"
	if [ -f $pid ]; then
		top -p `cat $pid`
	else
		echo no $pid to show
	fi
	;;

	

	*)
	./skynet/skynet work/config.server
	;;
esac