#! /bin/bash
echo
read -p "Date(order:YYYYMMDD): " date
dd=${date: -2}
echo $date

while :
do
echo
echo "* * * * * * * * * * * * * * * * * *"
echo "1.Apache Access log"
printf "2.Apache Error log\n"
printf "3.Current Users\n"
printf "4.System logs\n"
printf "5.Audit logs\n"
printf "6.CPU(Process) Avg. Usage\n"
printf "7.Memory(RAM) Avg. usage\n"
printf "8.Disk Space\n"
printf "9.Current Network Connection\n"
printf "10.Change date\n"
printf "R.Run any command\n"
printf "E.Exit\n"
echo "* * * * * * * * * * * * * * * * * *"
echo
read -p "Choose an Option: " option

case $option in
1)	while :
	do
	echo
	echo "* * * * * * * * * * * * * * * * * * * * * * * * * * * *"
        printf "1.Top 10 requester IP'S\n"
        printf "2.URL along with status code for particular IP'S\n"
        printf "3.Status Code '4**' or '5**'\n"
        printf "4.Main MEnu\n"
	echo "* * * * * * * * * * * * * * * * * * * * * * * * * * * *"
        echo
	Dir=/var/log/httpd
	File=/var/log/httpd/access_log-$date.gz
        if [ -f "$File" ]; then	
		echo "$File is Present."
        	read -p "Choose an option: " option1
	else 
		printf "Sorry! $File Not Found!\n......... Unable to do any Operation........\n"
		find $Dir -name access_log* |grep -v rotated
		#for entry in "$Dir"/*
                #do
                #        echo "$entry"   
                #done
		echo
		break
	fi

	
	case $option1 in
	1)     	if [ ! -f "topip-$( date '+%Y-%m-%d' ).txt" ]; then
			zcat /var/log/httpd/access_log-$date.gz | cut -d ' ' -f 2|sort|uniq -c|sort -nr |head|grep -v "-" > ~/topip-$( date '+%Y-%m-%d' ).txt
       			echo "Information stored in $HOME/topip-$( date '+%Y-%m-%d' ).txt file...."
       		#	read -p "Want to view the file:(Y/N) " choice
  		#	if [ $choice == "Y" ] || [ $choice == 'y' ]; then
                		cat $HOME/topip-$( date '+%Y-%m-%d' ).txt
        	#	fi
		else
			more $HOME/topip-$( date '+%Y-%m-%d' ).txt
		fi
		while :
		do
		echo
		read -p "Want to Check for IP Info(Y/n): " ipoption
		echo
		if [ $ipoption == 'y' ] || [ $ipoption == 'Y' ]; then
			python -s /home/ankit/ip.py
			
		else
			break
		fi
		done;;
	
	2)      read -p "Enter the ip: " ip
		a=`zcat /var/log/httpd/access_log-$date.gz |grep $ip|awk '{print $2,$8,$10}'|awk '$3 ~ /^ *2/'|wc -l`
		if [ $a == 0 ]; then
			a="0"
		fi  
		b=`zcat /var/log/httpd/access_log-$date.gz |grep $ip|awk '{print $2,$8,$10}'|awk '$3 ~ /^ *[3-5]/'|wc -l`
		if [ $b == 0 ]; then
                        b="0"
		fi
		#echo "General Summary"
		echo "$ip 200     	$a" > ~/urls-$( date '+%Y-%m-%d' ).txt
		echo "$ip 3XX/4XX/5XX 	$b" >> ~/urls-$( date '+%Y-%m-%d' ).txt
		echo "**********************************************************************************">> ~/urls-$( date '+%Y-%m-%d' ).txt
        	zcat /var/log/httpd/access_log-$date.gz |grep $ip|awk '{print $2,$8,$10}'|sort -k 3 |nl >> ~/urls-$( date '+%Y-%m-%d' ).txt
              	less $HOME/urls-$( date '+%Y-%m-%d' ).txt
        	#fi
		;;
	3)      zcat /var/log/httpd/access_log-$date.gz |awk '{print $2,$10}'|grep  [4-5][0-9][0-9] | sort -nr | uniq -c|sort -nr|less ;;
	4)      break
	esac	
	done;;

2)	while :
	do
	echo	
	echo "* * * * * * * * * * * * *"
	printf "1.General Check\n"
	printf "2.Error check\n"
	printf "3.Warning Check\n"
	printf "4.Tools Error\n"
	printf "5.Notice Error\n"
	printf "6.Main MEnu\n"
	echo "* * * * * * * * * * * * *"
	echo
	Dir=/var/log/httpd
	File=$Dir/error_log-$date.gz
        if [ -f "$File" ]; then
		echo "$File is Present."
                read -p "Choose an option: " option2
        else
                printf "Sorry! $File Not Found!\n......... Unable to do any Operation........\n"
		find $Dir -name error_log* |grep -v rotated
		#for entry in "$Dir"/*
		#do
  		#	echo "$entry"	
		#done
                echo
                break
        fi
		

	case $option2 in
	1)	zcat /var/log/httpd/error_log-$date.gz | grep -vi -e "warn*" -e "notice" -e "which"
		if [ $? != 0 ]; then
			echo "No Critical Issue"
		fi;;
	2)	zcat /var/log/httpd/error_log-$date.gz | grep  'error'
		if [ $? == 0 ]; then
			read -p "Are You Seeing Same Message Multiple time(Y/N): " yn
               	 	if [ $yn == "y" ] || [ $yn == "Y" ]; then
                		echo "These are Unique Messages:"
                        	zcat /var/log/httpd/error_log-$date.gz | grep   "error"|sort -bfuc
                	fi
		fi;;
	3)	zcat /var/log/httpd/error_log-$date.gz | grep -i  "warn"
		if [ $? == 0 ]; then
			read -p "Are You Seeing Same Message Multiple time(Y/N): " yn
			if [ $yn == "y" ] || [ $yn == "Y" ]; then
				echo "These are Unique Messages:"
				zcat /var/log/httpd/error_log-$date.gz | grep -i  "warn"|sort -bfuc
			fi
		fi;;
	4)	zcat /var/log/httpd/error_log-$date.gz | grep -i "which"|sort |uniq -d;;
	5)	zcat /var/log/httpd/error_log-$date.gz | grep -i "notice"|sort -bfu;;
	6)	break		
	esac
	done;;

3)	while :
	do
	echo
	echo "* * * * * * * * * * * * * * * * * * *"
	printf "1.All Logged in Users\n"
	printf "2.Currently Loggeed in Users\n"
	printf "3.Main MEnu\n"
	echo "* * * * * * * * * * * * * * * * * * *"
	echo
	read -p "Choose an option: " option3 
	
	case $option3 in
	1)	lastlog|grep -v "Never logged in";;
	2)	w;;
	3)	break
	esac
	done;;

4)	File=/var/log/messages-$date.gz\
	Dir=/var/log/messages
        if [ -f "$File" ]; then
                echo "$File is Present."
                zcat /var/log/messages-$date.gz |grep -v -e "ntpd" -e "dhclient" -e "ec2net" -e "audi*"
		if [ $? == 1 ]; then
			echo "No Critical Message Yet...."
		fi

		while :
		do
		read -p "Want to run any particular command(Y/n): " comm
		if [ $comm == "y" ] || [ $comm == 'Y' ]; then
			read -p "Enter your Command: " comm
			echo $comm
			echo
			eval $comm
			#mycmd=($comm)
			#${mycmd[@]}"
		else
			break
		fi
		done

        else
                printf "Sorry! $File Not Found!\n......... Unable to do any Operation........\n"
                for entry in "$Dir"/*
                do
                        echo "$entry"   
                done
                echo
                break
	fi;;

5)	while :
	do
	echo
	echo "* * * * * * * * * * * * * * * * *"
	printf "1.General Test\n"
	printf "2.View Summary Report\n"
#	printf "3.Run a Command\n"
	printf "3.Main MeNu\n"
	echo "* * * * * * * * * * * * * * * * *"
	echo
	File=/var/log/audit/audit.log-$date.gz
	if [ -f "$File" ]; then
		echo "$File is Present."
                read -p "Choose an option: " option5
		echo
        else
               	printf "Sorry! $File Not Found!\n......... Unable to do any Operation........\n"
               	echo
               	break
       	fi

	case $option5 in
	1)	zcat /var/log/audit/audit.log-$date.gz |grep -v -e "res=success" -e "res=1"
		if [ $? == 1 ]; then
			echo "No Critical Issue"
		fi;;
	2)	zcat /var/log/audit/audit.log-$date.gz | aureport 
		while :
		do
		read -p "Want to run any command(Y/n): " com
		if [ $com == 'Y' ] || [ $com == 'y' ]; then
			read -p "Enter your Command: " com
			eval $com
		else
			break
		fi
		done;;
#	3)	read -p "Enter Your Command: " command
#		$command;;
	3)	break
	esac	
	done;;

6)	echo 
	sar -f /var/log/sa/sa$dd |(head -n3 && tail -n1)
	echo
	echo "Cpu Used Avg.% : `sar -f /var/log/sa/sa$dd | tail -1|awk {'print 100-$8'}`";;

7)	echo 
	sar -r -f /var/log/sa/sa$dd|(head -3 && tail -1)
	echo
	echo "Memory Used Avg.% : `sar -r -f /var/log/sa/sa$dd | tail -1|awk {'print $4'}`";;

8)	echo
	df -h |(head -n1)
	df -h |tail -2
	echo
	echo Disk Usge is `df -h|awk 'FNR == 4 { print $4 }'`/`df -h|awk 'FNR == 4 { print $2 }'`;;

9)	echo
	netstat -a|head -2|tail -1
	netstat -ap|grep ESTABLISHED;;

10)	echo
	read -p "Date(order:YYYYMMDD): " date
	dd=${date: -2}
	echo "New Date is:" $date;;

R)	while :
	do
	read -p "Enter the command(q for quit): " c
	if [ $c == "q" ] ; then
		break
	else
		eval $c
	fi
	done;;

E)	break

esac	
done
