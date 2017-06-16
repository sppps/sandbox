FROM ubuntu:16.04
MAINTAINER mcc admin@monerocc.com
RUN add-apt-repository ppa:longsleep/golang-backports && apt-get update && apt-get install -y golang-go && go get github.com/alvinjoelsantos/urs/...
CMD python verify.py
