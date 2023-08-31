
FROM alpine/terragrunt:1.4.2   


RUN apk add --no-cache go

RUN apk add --no-cache python3 py3-pip && \
    pip3 install --no-cache-dir awscli

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY *.go ./

COPY . ./

RUN CGO_ENABLED=0 GOOS=linux go build -o /automate-runner

EXPOSE 8080

CMD ["/automate-runner"]

