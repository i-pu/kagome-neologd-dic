FROM golang:1.13.4-alpine

RUN apk add --update --no-cache build-base curl git bash file sudo openssh

WORKDIR /
# Install Neologd dic
RUN go get -u github.com/ikawaha/kagome/... \
  && git clone https://github.com/neologd/mecab-ipadic-neologd.git /neologd \
  && unxz /neologd/seed/mecab-user-dict-seed.20191212.csv.xz \
  && cp /neologd/seed/mecab-user-dict-seed.20191212.csv /go/src/github.com/ikawaha/kagome/cmd/_dictool

ENV ipadic_url https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM
# Install IPA dic
RUN curl -SL -o /mecab-ipadic-2.7.0-20070801.tar.gz ${ipadic_url} \
  && tar -zvxf /mecab-ipadic-2.7.0-20070801.tar.gz

WORKDIR /go/src/github.com/ikawaha/kagome/cmd/_dictool
# RUN go run main
# use about ~5GB memory
RUN go run main.go ipa -mecab /mecab-ipadic-2.7.0-20070801 -neologd mecab-user-dict-seed.20191212.csv \
  && cp ipa.dic /ipa.dic
