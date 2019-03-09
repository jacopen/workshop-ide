FROM ubuntu:18.04
RUN apt update && apt install -y curl
WORKDIR /src
RUN curl -L https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-5.4.0-linux-amd64 -o bosh&&\
    curl -L https://github.com/pivotal-cf/om/releases/download/0.54.0/om-linux -o om &&\
    curl -L https://github.com/pivotal-cf/pivnet-cli/releases/download/v0.0.55/pivnet-linux-amd64-0.0.55 -o pivnet &&\
    curl -LO https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/2.2.0/credhub-linux-2.2.0.tgz &&\
    tar xvf credhub-linux-2.2.0.tgz
COPY . .

FROM codercom/code-server:latest
RUN apt-get update && apt-get install -y curl wget vim less git
COPY --from=0 /src/om /src/bosh /src/pivnet /src/credhub /usr/local/bin/
RUN chmod +x /usr/local/bin/bosh &&\
    chmod +x /usr/local/bin/om &&\
    chmod +x /usr/local/bin/pivnet &&\
    chmod +x /usr/local/bin/credhub &&\
    mkdir -p ~/.code-server/User &&\
    mkdir -p ~/.code-server/Backups &&\
    echo '{ "terminal.integrated.fontFamily": "Consolas, Courier" }' > ~/.code-server/User/settings.json

#CMD code-server $PWD
