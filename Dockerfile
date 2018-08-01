FROM debian:stretch-slim

ENV OSSEC_EMAIL_NOTIFICATION "no"
ENV OSSEC_EMAIL_TO ""
ENV OSSEC_EMAIL_FROM ""
ENV OSSEC_SMTP_SERVER ""
ENV OSSEC_SYSLOG_PROTOCOL "udp"
ENV OSSEC_ALLOWED_IPS "10.0.0.0/8"
ENV OSSEC_LOG_ALERT_LEVEL "1"
ENV OSSEC_EMAIL_ALERT_LEVEL "7"

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      apt-transport-https \
      ca-certificates \
      procps \
      wget \
      gnupg2 && \
    (wget -q -O- https://www.atomicorp.com/RPM-GPG-KEY.atomicorp.txt | apt-key add -) && \
    echo 'deb https://updates.atomicorp.com/channels/atomic/debian stretch main' > /etc/apt/sources.list.d/atomic.list && \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ossec-hids-server && \
    DEBIAN_FRONTEND=noninteractive apt-get autoremove --purge -y \
      apt-transport-https \
      ca-certificates \
      wget \
      gnupg2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists

WORKDIR /var/ossec
RUN export DATA_DIRS="etc rules logs stats queue" && \
    touch etc/client.keys && \
    mkdir data && \
    chown ossec:ossec etc/client.keys data && \
    for datadir in $DATA_DIRS; do \
        mv $datadir ${datadir}-template && \
        ln -s data/${datadir} $datadir; \
    done

VOLUME "/var/ossec/data"
EXPOSE 514/udp 514/tcp

# Currently we rely on OSSEC to drop the privileges.

# Load the rules from the default config since it has the correct loading order already figured out.
# Including all rules seems to be broken even when including rules_config.xml first (using <rule_dir> doesn't work either).
ENTRYPOINT set -eu; \
           export DATA_DIRS="etc rules logs stats queue"; \
           export CONFIG_RULES="$(fgrep '_rules.xml' etc-template/ossec.conf)"; \
           for datadir in $DATA_DIRS; do \
               [ -d data/${datadir} ] || cp -a ${datadir}-template data/${datadir}; \
           done; \
           echo \
               "<ossec_config>"\
                 "<global>"\
                   "<email_notification>${OSSEC_EMAIL_NOTIFICATION}</email_notification>"\
                   "<email_to>${OSSEC_EMAIL_TO}</email_to>"\
                   "<email_from>${OSSEC_EMAIL_FROM}</email_from>"\
                   "<logall>yes</logall>"\
                   "<smtp_server>${OSSEC_SMTP_SERVER}</smtp_server>"\
                 "</global>"\
                 "<remote>"\
                   "<connection>syslog</connection>"\
                   "<allowed-ips>${OSSEC_ALLOWED_IPS}</allowed-ips>"\
                   "<protocol>${OSSEC_SYSLOG_PROTOCOL}</protocol>"\
                 "</remote>"\
                 "<alerts>"\
                   "<log_alert_level>${OSSEC_LOG_ALERT_LEVEL}</log_alert_level>"\
                   "<email_alert_level>${OSSEC_EMAIL_ALERT_LEVEL}</email_alert_level>"\
                 "</alerts>"\
                 "<rules>"\
                   "<include>rules_config.xml</include>"\
                   "$CONFIG_RULES"\
                 "</rules>"\
                 "<rootcheck>"\
                   "<disabled>yes</disabled>"\
                 "</rootcheck>"\
                 "<active-response>"\
                   "<disabled>yes</disabled>"\
                 "</active-response>"\
               "</ossec_config>" > /var/ossec/etc/ossec.conf; \
          trap "/var/ossec/bin/ossec-control stop" INT TERM; \
          /var/ossec/bin/ossec-control start; \
          tail -f /var/ossec/logs/ossec.log & wait

