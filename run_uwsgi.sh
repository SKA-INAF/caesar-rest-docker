#!/bin/bash

##########################
##    PARSE ARGS
##########################
RUNUSER="caesar"
PORT=3031
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
		--file=*)
    	UWSGI_FILE=`echo $item | /bin/sed 's/[-a-zA-Z0-9]*=//'`
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

	*)
    # Unknown option
    echo "ERROR: Unknown option ($item)...exit!"
    exit 1
    ;;
	esac
done

AAI_OPT=""
if [ "$AAI" = "1" ] ; then
  AAI_OPT="--aai"
fi

PYARGS="$AAI_OPT --secretfile=$SECRETFILE --sfindernn_weights=$NNWEIGHTS --db --dbhost=$DBHOST --dbname=$DBNAME --dbport=$DBPORT --result_backend_host=$RESULT_BACKEND_HOST --result_backend_port=$RESULT_BACKEND_PORT --result_backend_proto=$RESULT_BACKEND_PROTO --result_backend_dbname=$RESULT_BACKEND_DBNAME --broker_host=$BROKER_HOST --broker_port=$BROKER_PORT --broker_proto=$BROKER_PROTO --broker_user=$BROKER_USER --broker_pass=$BROKER_PASS"

###############################
##    RUN UWSGI
###############################
# - Define run command & args
EXE="/usr/local/bin/uwsgi"
ARGS="--uid=$RUNUSER --gid=$RUNUSER --binary-path /usr/local/bin/uwsgi --wsgi-file=$FILE --callable=app --pyargv=""'"$PYARGS"'"" --workers=$NWORKERS --enable-threads --threads=$NTHREADS --socket=":$PORT" --socket-timeout=$SOCKET_TIMEOUT --master --chmod-socket=$CHMOD_SOCKET --buffer-size=$BUFFER_SIZE --vacuum --die-on-term"

# - Run uwsgi
echo "INFO: Running uwsgi with command: $EXE $ARGS ..."
eval "$EXE $ARGS"

