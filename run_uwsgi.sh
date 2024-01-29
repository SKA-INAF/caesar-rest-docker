#!/bin/bash

##########################
##    PARSE ARGS
##########################
RUNUSER="caesar"
PORT=3031
DATADIR="/opt/caesar-rest/data"
JOBDIR="/opt/caesar-rest/jobs"
FILE="/opt/caesar-rest/bin/run_app.py"
NWORKERS=2
NTHREADS=2
SOCKET_TIMEOUT=60
CHMOD_SOCKET=660
BUFFER_SIZE=32768
SECRETFILE="/etc/systemd/system/client_secrets.json"
NNWEIGHTS="/opt/caesar-rest/share/mrcnn_weights.h5"
DBHOST="127.0.0.1"
DBNAME="caesardb"
DBPORT=27017
RESULT_BACKEND_HOST="127.0.0.1"
RESULT_BACKEND_PORT=27017
RESULT_BACKEND_PROTO="mongodb"
RESULT_BACKEND_DBNAME="caesardb"
BROKER_HOST="127.0.0.1"
BROKER_PORT=5672
BROKER_PROTO="amqp"
BROKER_USER="guest"
BROKER_PASS="guest"
AAI=0
SSL=0
JOB_MONITORING_PERIOD=5
UWSGI_HTTP=0
MOUNT_RCLONE_VOLUME=0
MOUNT_VOLUME_PATH="/mnt/storage"
RCLONE_REMOTE_STORAGE="neanias-nextcloud"
RCLONE_REMOTE_STORAGE_PATH="."
RCLONE_MOUNT_WAIT_TIME=10

JOB_SCHEDULER=""
KUBE_INCLUSTER=1
KUBE_CONFIG=""
KUBE_CAFILE=""
KUBE_KEYFILE=""
KUBE_CERTFILE=""

SLURM_KEYFILE=""
SLURM_USER=""
SLURM_HOST=""
SLURM_PORT=""
SLURM_BATCH_WORKDIR=""
SLURM_QUEUE=""
SLURM_JOBDIR=""
SLURM_DATADIR=""
SLURM_MAX_CORES_PER_JOB="4"

FORWARD_LOGS=0
LOG_LEVEL="INFO"
LOG_TO_FILE=0
LOG_DIR="/opt/caesar-rest/logs"
LOG_FILE="app_logs.json"
LOG_FILE_MAX_SIZE="5"

CHANGE_DNS=0


echo "ARGS: $@"

for item in "$@"
do
	case $item in
		--runuser=*)
    	RUNUSER=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--port=*)
    	PORT=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--datadir=*)
    	DATADIR=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--jobdir=*)
    	JOBDIR=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--file=*)
    	FILE=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--nworkers=*)
    	NWORKERS=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--nthreads=*)
    	NTHREADS=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--socket-timeout=*)
    	SOCKET_TIMEOUT=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--chmod-socket=*)
    	CHMOD_SOCKET=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--bufsize=*)
    	BUFFER_SIZE=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--aai=*)
    	AAI=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--ssl=*)
    	SSL=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--uwsgi-http=*)
    	UWSGI_HTTP=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--job-monitoring-period=*)
    	JOB_MONITORING_PERIOD=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--secretfile=*)
    	SECRETFILE=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--nnweights=*)
    	NNWEIGHTS=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--dbhost=*)
    	DBHOST=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--dbport=*)
    	DBPORT=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--dbname=*)
    	DBNAME=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--result-backend-host=*)
    	RESULT_BACKEND_HOST=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--result-backend-port=*)
    	RESULT_BACKEND_PORT=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--result-backend-proto=*)
    	RESULT_BACKEND_PROTO=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--result-backend-dbname=*)
    	RESULT_BACKEND_DBNAME=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--broker-host=*)
    	BROKER_HOST=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--broker-port=*)
    	BROKER_PORT=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--broker-proto=*)
    	BROKER_PROTO=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--broker-user=*)
    	BROKER_USER=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--broker-pass=*)
    	BROKER_PASS=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--mount-rclone-volume=*)
    	MOUNT_RCLONE_VOLUME=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--mount-volume-path=*)
    	MOUNT_VOLUME_PATH=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--rclone-remote-storage=*)
    	RCLONE_REMOTE_STORAGE=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--rclone-remote-storage-path=*)
    	RCLONE_REMOTE_STORAGE_PATH=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--rclone-mount-wait=*)
    	RCLONE_MOUNT_WAIT_TIME=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--job-scheduler=*)
    	JOB_SCHEDULER=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--kube-incluster=*)
    	KUBE_INCLUSTER=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--kube-config=*)
    	KUBE_CONFIG=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--kube-cafile=*)
    	KUBE_CAFILE=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--kube-keyfile=*)
    	KUBE_KEYFILE=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--kube-certfile=*)
    	KUBE_CERTFILE=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;

		--slurm-keyfile=*)
    	SLURM_KEYFILE=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--slurm-user=*)
    	SLURM_USER=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--slurm-host=*)
    	SLURM_HOST=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--slurm-port=*)
    	SLURM_PORT=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--slurm-batch-workdir=*)
    	SLURM_BATCH_WORKDIR=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--slurm-queue=*)
    	SLURM_QUEUE=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--slurm-jobdir=*)
    	SLURM_JOBDIR=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--slurm-datadir=*)
    	SLURM_DATADIR=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--slurm-max-cores-per-job=*)
    	SLURM_MAX_CORES_PER_JOB=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;

		--forward-logs=*)
    	FORWARD_LOGS=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--loglevel=*)
    	LOG_LEVEL=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--logtofile=*)
    	LOG_TO_FILE=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--logdir=*)
    	LOG_DIR=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--logfile=*)
    	LOG_FILE=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--logfile-maxsize=*)
    	LOG_FILE_MAX_SIZE=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;
		--changedns=*)
    	CHANGE_DNS=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
    ;;


	*)
    # Unknown option
    echo "ERROR: Unknown option ($item)...exit!"
    exit 1
    ;;
	esac
done

###############################
##    CHANGE DNS TO GOOGLE
###############################
if [ "$CHANGE_DNS" = "1" ] ; then
	echo "Setting DNS to Google ..."
	##sed -i '/nameserver/c nameserver 8.8.8.8' /etc/resolv.conf
	##echo "$(sed '/nameserver/c nameserver 8.8.8.8' /etc/resolv.conf)" > /etc/resolv.conf
	echo "$(sed '/^nameserver/i nameserver 8.8.8.8' /etc/resolv.conf)" > /etc/resolv.conf

fi


###############################
##    START FILEBEAT
###############################
if [ "$FORWARD_LOGS" = "1" ] ; then
	#echo "Enabling file beat service ..."
	#systemctl enable filebeat.service

	echo "Starting file beat service ..."
	systemctl start filebeat.service
	#journalctl filebeat.service -b
fi

###############################
##    MOUNT VOLUMES
###############################
if [ "$MOUNT_RCLONE_VOLUME" = "1" ] ; then

	# - Create mount directory if not existing
	echo "INFO: Creating mount directory $MOUNT_VOLUME_PATH ..."
	mkdir -p $MOUNT_VOLUME_PATH	

	# - Get device ID of standard dir, for example $HOME
	#   To be compared with mount point to check if mount is ready
	DEVICE_ID=`stat "$HOME" -c %d`
	echo "INFO: Standard device id @ $HOME: $DEVICE_ID"

	# - Mount rclone volume in background
	uid=`id -u $RUNUSER`

	echo "INFO: Mounting rclone volume at path $MOUNT_VOLUME_PATH for uid/gid=$uid ..."
	MOUNT_CMD="/usr/bin/rclone mount --daemon --uid=$uid --gid=$uid --umask 000 --allow-other --file-perms 0777 --dir-cache-time 0m5s --vfs-cache-mode full $RCLONE_REMOTE_STORAGE:$RCLONE_REMOTE_STORAGE_PATH $MOUNT_VOLUME_PATH -vvv"
	#MOUNT_CMD="/usr/bin/rclone mount --daemon --umask 000 --dir-cache-time 0m5s --vfs-cache-mode full $RCLONE_REMOTE_STORAGE:$RCLONE_REMOTE_STORAGE_PATH $MOUNT_VOLUME_PATH -vvv"
	#MOUNT_CMD="/usr/bin/rclone mount --daemon --uid=$uid --gid=$uid --umask 000 --allow-other --dir-cache-time 0m5s --vfs-cache-mode full $RCLONE_REMOTE_STORAGE:$RCLONE_REMOTE_STORAGE_PATH $MOUNT_VOLUME_PATH -vvv"
	eval $MOUNT_CMD

	# - Wait until filesystem is ready
	echo "INFO: Sleeping $RCLONE_MOUNT_WAIT_TIME seconds and then check if mount is ready..."
	sleep $RCLONE_MOUNT_WAIT_TIME
	#until findmnt --mountpoint "$MOUNT_VOLUME_PATH" --mtab >/dev/null; do :; done
	#findmnt --poll --timeout 2000

	# - Get device ID of mount point
	MOUNT_DEVICE_ID=`stat "$MOUNT_VOLUME_PATH" -c %d`
	echo "INFO: MOUNT_DEVICE_ID=$MOUNT_DEVICE_ID"
	if [ "$MOUNT_DEVICE_ID" = "$DEVICE_ID" ] ; then
 		echo "ERROR: Failed to mount rclone storage at $MOUNT_VOLUME_PATH within $RCLONE_MOUNT_WAIT_TIME seconds, exit!"
		exit 1
	fi

	# - Print mount dir content
	echo "INFO: Mounted rclone storage at $MOUNT_VOLUME_PATH with success (MOUNT_DEVICE_ID: $MOUNT_DEVICE_ID)..."
	ls -ltr $MOUNT_VOLUME_PATH

	# - Create job & data directories
	echo "INFO: Creating job & data directories ..."
	mkdir -p 	$MOUNT_VOLUME_PATH/jobs
	mkdir -p 	$MOUNT_VOLUME_PATH/data

fi


###############################
##    SET KUBE CONFIG
###############################
if [ "$JOB_SCHEDULER" = "kubernetes" ] && [ "$KUBE_INCLUSTER" = "0" ] ; then
	
	echo "INFO: Creating kube config dir in /home/$RUNUSER ..."
	KUBE_CONFIG_TOP_DIR="/home/$RUNUSER/.kube"
	mkdir -p "$KUBE_CONFIG_TOP_DIR"

	uid=`id -u $RUNUSER`

	# - Copy Kube config file (if not empty)
	if [ "$KUBE_CONFIG" != "" ] ; then
		if [ -e "$KUBE_CONFIG" ] ; then
			echo "INFO: Copying kube config file $KUBE_CONFIG to $KUBE_CONFIG_TOP_DIR ..."
			cp $KUBE_CONFIG $KUBE_CONFIG_TOP_DIR/config
			
			echo "INFO: Renaming KUBE_CONFIG to $KUBE_CONFIG_TOP_DIR/config and set uid/gid to $id ..."
			KUBE_CONFIG="$KUBE_CONFIG_TOP_DIR/config"
			chown $uid:$uid $KUBE_CONFIG
		fi
	fi

	# - Copy Kube ca file to local RUNUSER dir
	if [ "$KUBE_CAFILE" != "" ] ; then
		if [ -e "$KUBE_CAFILE" ] ; then
			echo "INFO: Copying kube ca file $KUBE_CAFILE to $KUBE_CONFIG_TOP_DIR ..."
			cp $KUBE_CAFILE $KUBE_CONFIG_TOP_DIR/ca.pem
			
			echo "INFO: Renaming KUBE_CAFILE to $KUBE_CONFIG_TOP_DIR/ca.pem and set uid/gid to $id ..."
			KUBE_CAFILE="$KUBE_CONFIG_TOP_DIR/ca.pem"
			chown $uid:$uid $KUBE_CAFILE
		fi
	fi

	# - Copy Kube key file to local RUNUSER dir
	if [ "$KUBE_KEYFILE" != "" ] ; then
		if [ -e "$KUBE_KEYFILE" ] ; then
			echo "INFO: Copying kube key file $KUBE_KEYFILE to $KUBE_CONFIG_TOP_DIR ..."
			cp $KUBE_KEYFILE $KUBE_CONFIG_TOP_DIR/client.key
			
			echo "INFO: Renaming KUBE_KEYFILE to $KUBE_CONFIG_TOP_DIR/client.key and set uid/gid to $id ..."
			KUBE_KEYFILE="$KUBE_CONFIG_TOP_DIR/client.key"
			chown $uid:$uid $KUBE_KEYFILE
		fi
	fi

	# - Copy Kube cert file to local RUNUSER dir
	if [ "$KUBE_CERTFILE" != "" ] ; then
		if [ -e "$KUBE_CERTFILE" ] ; then
			echo "INFO: Copying kube cert file $KUBE_CERTFILE to $KUBE_CONFIG_TOP_DIR ..."
			cp $KUBE_CERTFILE $KUBE_CONFIG_TOP_DIR/client.pem
			
			echo "INFO: Renaming KUBE_CERTFILE to $KUBE_CONFIG_TOP_DIR/client.cert and set uid/gid to $id ..."
			KUBE_CERTFILE="$KUBE_CONFIG_TOP_DIR/client.pem"
			chown $uid:$uid $KUBE_CERTFILE
		fi
	fi

	# - Change dir permissions
	echo "INFO: Setting 755 permissions to Kube config dir ..."
	chmod -R 755 $KUBE_CONFIG_TOP_DIR

fi


###############################
##    SET UWSGI CONFIG
###############################
AAI_OPT=""
if [ "$AAI" = "1" ] ; then
  AAI_OPT="--aai"
fi

SSL_OPT=""
if [ "$SSL" = "1" ] ; then
  SSL_OPT="--ssl"
fi

JOB_SCHEDULER_OPT=""
if [ "$JOB_SCHEDULER" != "" ] ; then
  JOB_SCHEDULER_OPT="--job_scheduler=$JOB_SCHEDULER"
fi

KUBE_OPTS=""
if [ "$KUBE_INCLUSTER" = "1" ] ; then
  KUBE_OPTS="--kube_incluster "
fi
KUBE_OPTS="$KUBE_OPTS --kube_config=$KUBE_CONFIG --kube_cafile=$KUBE_CAFILE --kube_keyfile=$KUBE_KEYFILE --kube_certfile=$KUBE_CERTFILE"
	
SLURM_OPTS="--slurm_keyfile=$SLURM_KEYFILE --slurm_user=$SLURM_USER --slurm_host=$SLURM_HOST --slurm_port=$SLURM_PORT --slurm_batch_workdir=$SLURM_BATCH_WORKDIR --slurm_queue=$SLURM_QUEUE --slurm_jobdir=$SLURM_JOBDIR --slurm_datadir=$SLURM_DATADIR --slurm_max_cores_per_job=$SLURM_MAX_CORES_PER_JOB "

RCLONE_OPTS=""
if [ "$MOUNT_RCLONE_VOLUME" = "1" ] ; then
	RCLONE_OPTS="--mount_rclone_volume --mount_volume_path=$MOUNT_VOLUME_PATH	--rclone_storage_name=$RCLONE_REMOTE_STORAGE --rclone_storage_path=$RCLONE_REMOTE_STORAGE_PATH "
fi

LOGGING_OPTS="--loglevel=$LOG_LEVEL --logdir=$LOG_DIR --logfile=$LOG_FILE --logfile_maxsize=$LOG_FILE_MAX_SIZE "
if [ "$LOG_TO_FILE" = "1" ] ; then
	LOGGING_OPTS="$LOGGING_OPTS --logtofile "
fi

PYARGS="--datadir=$DATADIR --jobdir=$JOBDIR --job_monitoring_period=$JOB_MONITORING_PERIOD --secretfile=$SECRETFILE --mrcnn_weights=$NNWEIGHTS --db --dbhost=$DBHOST --dbname=$DBNAME --dbport=$DBPORT --result_backend_host=$RESULT_BACKEND_HOST --result_backend_port=$RESULT_BACKEND_PORT --result_backend_proto=$RESULT_BACKEND_PROTO --result_backend_dbname=$RESULT_BACKEND_DBNAME --broker_host=$BROKER_HOST --broker_port=$BROKER_PORT --broker_proto=$BROKER_PROTO --broker_user=$BROKER_USER --broker_pass=$BROKER_PASS $AAI_OPT $SSL_OPT $JOB_SCHEDULER_OPT $KUBE_OPTS $SLURM_OPTS $RCLONE_OPTS $LOGGING_OPTS "

###############################
##    RUN UWSGI
###############################
# - Define run command & args
EXE="/usr/local/bin/uwsgi"
#ARGS="--uid=$RUNUSER --gid=$RUNUSER --binary-path /usr/local/bin/uwsgi --wsgi-file=$FILE --callable=app --pyargv=""'"$PYARGS"'"" --workers=$NWORKERS --enable-threads --threads=$NTHREADS --socket=":$PORT" --socket-timeout=$SOCKET_TIMEOUT --master --chmod-socket=$CHMOD_SOCKET --buffer-size=$BUFFER_SIZE --vacuum --die-on-term"

if [ "$UWSGI_HTTP" = "1" ] ; then
	if [ "$SSL" = "1" ] ; then
		echo "INFO: Running uwsgi with https-socket option ..."
  	ARGS="--uid=$RUNUSER --gid=$RUNUSER --binary-path /usr/local/bin/uwsgi --wsgi-file=$FILE --callable=app --pyargv=""'"$PYARGS"'"" --workers=$NWORKERS --enable-threads --threads=$NTHREADS --https-socket="0.0.0.0:$PORT" --http-timeout=$SOCKET_TIMEOUT --http-enable-proxy-protocol --http-auto-chunked --socket-timeout=$SOCKET_TIMEOUT --master --chmod-socket=$CHMOD_SOCKET --chown-socket=$RUNUSER --buffer-size=$BUFFER_SIZE --vacuum --die-on-term"
	else
    echo "INFO: Running uwsgi with http-socket option ..."
		ARGS="--uid=$RUNUSER --gid=$RUNUSER --binary-path /usr/local/bin/uwsgi --wsgi-file=$FILE --callable=app --pyargv=""'"$PYARGS"'"" --workers=$NWORKERS --enable-threads --threads=$NTHREADS --http-socket="0.0.0.0:$PORT" --http-timeout=$SOCKET_TIMEOUT --http-enable-proxy-protocol --http-auto-chunked --socket-timeout=$SOCKET_TIMEOUT --master --chmod-socket=$CHMOD_SOCKET --chown-socket=$RUNUSER --buffer-size=$BUFFER_SIZE --vacuum --die-on-term"
	fi
else
	#ARGS="--uid=$RUNUSER --gid=$RUNUSER --binary-path /usr/local/bin/uwsgi --wsgi-file=$FILE --callable=app --pyargv=""'"$PYARGS"'"" --workers=$NWORKERS --enable-threads --threads=$NTHREADS --socket="0.0.0.0:$PORT" --socket-timeout=$SOCKET_TIMEOUT --master --chmod-socket=$CHMOD_SOCKET --buffer-size=$BUFFER_SIZE --vacuum --die-on-term"
	echo "INFO: Running uwsgi with socket option ..."
	ARGS="--uid=$RUNUSER --gid=$RUNUSER --binary-path /usr/local/bin/uwsgi --wsgi-file=$FILE --callable=app --pyargv=""'"$PYARGS"'"" --workers=$NWORKERS --enable-threads --threads=$NTHREADS --socket=":$PORT" --socket-timeout=$SOCKET_TIMEOUT --master --chmod-socket=$CHMOD_SOCKET --chown-socket=$RUNUSER --buffer-size=$BUFFER_SIZE --vacuum --die-on-term"
fi

# - Run uwsgi
echo "INFO: Running uwsgi with command: $EXE $ARGS ..."
eval "$EXE $ARGS"

