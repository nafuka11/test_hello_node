#!/bin/bash
# ----------------------------------------------------------------------------
# User settings
# ----------------------------------------------------------------------------
PROJECT_DIR="../hello_node"

# ----------------------------------------------------------------------------
# Script settings
# ----------------------------------------------------------------------------
# dir path
EXPECTED_DIR="./expected"
ACTUAL_DIR="./actual"
# color
RESET="\e[0m"
GREEN="\e[32m"
RED="\e[31m"
EX_COLOR="\e[1m"
CASE_COLOR="\e[4m"

# ----------------------------------------------------------------------------
print_result () {
	if [ $1 -eq 0 ]; then
		printf "${GREEN}OK${RESET}\n"
	else
		printf "${RED}KO${RESET}\n"
	fi
}

print_header () {
	printf "\n[${EX_COLOR}$1${RESET}]\n"
}

print_case () {
	printf "${CASE_COLOR}$1${RESET}\n"
}

test () {
	TEST_NAME=$1
	FILE_PATH=$2
	print_case "`echo "node ${PROJECT_DIR}/$2 $3 $4 $5 $6" | sed 's/ *$//'`"
	node ${PROJECT_DIR}/${FILE_PATH} $3 $4 $5 $6 > ${ACTUAL_DIR}/${TEST_NAME}.txt
	diff ${EXPECTED_DIR}/${TEST_NAME}.txt ${ACTUAL_DIR}/${TEST_NAME}.txt
	print_result $?
	echo ""
}

test_no_crash () {
	TEST_NAME=$1
	FILE_PATH=$2
	print_case "`echo "node ${PROJECT_DIR}/$2 $3 $4 $5 $6" | sed 's/ *$//'`"
	node ${PROJECT_DIR}/${FILE_PATH} $3 $4 $5 $6
	echo ""
}

launch_server () {
	FILE_PATH=$1
	PORT=$2
	node ${PROJECT_DIR}/${FILE_PATH} ${PORT} &
	sleep 1
}

kill_server () {
	PID=$1
	kill ${PID}
	wait ${PID} 2> /dev/null
}

test_server () {
	TEST_NAME=$1
	FILE_PATH=$2
	PORT=$3
	URL="http://localhost:${PORT}$4"
	print_case "`echo "node ${PROJECT_DIR}/${FILE_PATH} ${PORT}, URL=${URL}" | sed 's/ *$//'`"
	launch_server ${FILE_PATH} ${PORT}
	curl -s "${URL}" > ${ACTUAL_DIR}/${TEST_NAME}.txt
	kill_server $!
	diff ${EXPECTED_DIR}/${TEST_NAME}.txt ${ACTUAL_DIR}/${TEST_NAME}.txt
	print_result $?
	echo ""
}

test_server_no_crash () {
	FILE_PATH=$1
	PORT=$2
	URL="http://localhost:${PORT}$3"
	print_case "`echo "node ${PROJECT_DIR}/${FILE_PATH} ${PORT}, URL=${URL}" | sed 's/ *$//'`"
	launch_server ${FILE_PATH} ${PORT}
	curl -s "${URL}"
	kill_server $!
	echo ""
}

rm -f actual/*.txt

# ----------------------------------------------------------------------------
print_header ex00
test ex00 ex00/hello-world.js

# ----------------------------------------------------------------------------
print_header ex01
test ex01 ex01/vars.js

# ----------------------------------------------------------------------------
print_header ex02
test          ex02_0_arg            ex02/sum_args.js
test          ex02_3_args           ex02/sum_args.js 1 2 3
test_no_crash ex02_non_number       ex02/sum_args.js 1 2 3 ft_tokyo
test          ex02_minus            ex02/sum_args.js -1 -2 -3 -4
test          ex02_max_safe_integer ex02/sum_args.js 9007199254740991
test          ex02_min_safe_integer ex02/sum_args.js -9007199254740991

# ----------------------------------------------------------------------------
print_header ex03
cat /etc/passwd | wc -l | tr -d ' ' > ${EXPECTED_DIR}/ex03_passwd.txt
test          ex03_passwd       ex03/io.js /etc/passwd
test_no_crash ex03_no_arg       ex03/io.js
test_no_crash ex03_no_such_file ex03/io.js no_such_file.txt
test_no_crash ex03_dir          ex03/io.js actual/

# ----------------------------------------------------------------------------
print_header ex04
cat /etc/passwd | wc -l | tr -d ' ' > ${EXPECTED_DIR}/ex04_passwd.txt
test          ex04_passwd       ex04/asyncio.js /etc/passwd
test_no_crash ex04_no_arg       ex04/asyncio.js
test_no_crash ex04_no_such_file ex04/asyncio.js no_such_file.txt
test_no_crash ex04_dir          ex04/asyncio.js actual/

# ----------------------------------------------------------------------------
print_header ex05
test_no_crash ex05_ok          ex05/http-client.js http://abehiroshi.la.coocan.jp/
test_no_crash ex05_no_arg      ex05/http-client.js
test_no_crash ex05_invalid_url ex05/http-client.js ft_tokyo
test_no_crash ex05_invalid_url ex05/http-client.js http://no/
test_no_crash ex05_locahost    ex05/http-client.js http://localhost
test_no_crash ex05_https       ex05/http-client.js https://google.com

# ----------------------------------------------------------------------------
print_header ex06
test_no_crash ex06_ok          ex06/http-collect.js http://abehiroshi.la.coocan.jp/
test_no_crash ex06_no_arg      ex06/http-collect.js
test_no_crash ex06_invalid_url ex06/http-collect.js ft_tokyo
test_no_crash ex06_invalid_url ex06/http-collect.js http://no/
test_no_crash ex06_locahost    ex06/http-collect.js http://localhost
test_no_crash ex06_https       ex06/http-collect.js https://google.com

# ----------------------------------------------------------------------------
print_header ex07
test_no_crash ex07_ok          ex07/async-http-collect.js http://abehiroshi.la.coocan.jp/ http://httpbin.org/user-agent http://api.thecatapi.com/v1/images/search
test_no_crash ex07_no_arg      ex07/async-http-collect.js
test_no_crash ex07_many_arg    ex07/async-http-collect.js http://www.google.com/ http://www.google.com/ http://www.google.com/ http://www.google.com/
test_no_crash ex07_invalid_url ex07/async-http-collect.js http://www.google.com/ http://www.google.com/ ft_tokyo
test_no_crash ex07_invalid_url ex07/async-http-collect.js http://www.google.com/ http://www.google.com/ http://no/
test_no_crash ex07_locahost    ex07/async-http-collect.js http://www.google.com/ http://www.google.com/ http://localhost
test_no_crash ex07_https       ex07/async-http-collect.js http://www.google.com/ http://www.google.com/ https://google.com

# ----------------------------------------------------------------------------
print_header ex08
# ok
print_case "test 8080 port"
launch_server ex08/time-server.js 8080
curl localhost:8080
kill_server $!

# invalid port number
print_case "\ntest invalid port number(aaaa)"
node ${PROJECT_DIR}/ex08/time-server.js aaaa

print_case "\ntest invalid port number(11111111111111111)"
node ${PROJECT_DIR}/ex08/time-server.js 11111111111111111

# port already use
print_case "\ntest port already use"
launch_server ex08/time-server.js 8080
node ${PROJECT_DIR}/ex08/time-server.js 8080
kill_server $!

# ----------------------------------------------------------------------------
print_header ex09
test_server ex09_parsetime ex09/http-json-api-server.js 8080 "/api/parsetime?iso=2020-12-15T17:10:15.474Z"
test_server ex09_unixtime ex09/http-json-api-server.js 8080 "/api/unixtime?iso=2020-12-15T17:10:15.474Z"

test_server_no_crash ex09/http-json-api-server.js 8080 "/api/unixtime?iso=2020-12-32T17:10:15.474Z"
test_server_no_crash ex09/http-json-api-server.js 8080 "/api/invalidpath"
test_server_no_crash ex09/http-json-api-server.js 8080

# invalid port number
print_case "test invalid port number(aaaa)"
node ${PROJECT_DIR}/ex09/http-json-api-server.js aaaa

print_case "\ntest invalid port number(11111111111111111)"
node ${PROJECT_DIR}/ex09/http-json-api-server.js 11111111111111111

# port already use
print_case "\ntest port already use"
launch_server ex09/http-json-api-server.js 8080
node ${PROJECT_DIR}/ex09/http-json-api-server.js 8080
kill_server $!
