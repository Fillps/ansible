FROM ubuntu:jammy AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git ansible build-essential && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

RUN apt-get install -y sudo

FROM base AS prime
ARG TAGS
RUN addgroup --gid 1000 filipe
RUN adduser --gecos filipe --uid 1000 --gid 1000 --disabled-password filipe
RUN echo "filipe ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER filipe
WORKDIR /home/filipe

FROM prime
COPY --chown=filipe:filipe . .
USER filipe
ENV USER=filipe
CMD ["sh", "-c", "USER=filipe ansible-playbook $TAGS local.yml --ask-vault-pass && bash"]

