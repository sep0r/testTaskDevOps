#!/bin/bash
for(( ; ; ))
do
        if [[ $(pidof test) -ne "" ]]
        then {
                pid=$(pidof test)
                sttime=$(ps -p $pid -o etimes=)

                for(( ; ; ))
                do
                        if [[ $(pidof test) -eq $pid ]]
                        then {
                                if [[ $(ps -p $pid -o etimes=) -ge $sttime ]]
                                then {
                                        curl -Is http://172.30.219.64:9427/metrics | head -n 1 | grep -q 'HTTP/1.1 200' || echo "`date` API is not available" >> /var/log/monitoring.log
                                }
                                else {
                                        echo "`date` Daemon was restart"  >> /var/log/monitoring.log
                                }
                                fi
                        }
                        else
                        {
                                if [[ $(pidof test) -ne "" ]]
                                then {
                                        pid=$(pidof test)
                                        sttime=$(ps -p $pid -o etimes=)
                                        echo "`date` Daemon was restart" >> /var/log/monitoring.log
                                        curl -Is http://172.30.219.64:9427/metrics | head -n 1 | grep -q 'HTTP/1.1 200' || echo "`date` API is not available" >> /var/log/monitoring.log
                                }
                                fi
                        }
                        fi
                  sleep 60
                done
        }
	fi
sleep 1
done
