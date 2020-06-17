FROM centos:7

RUN set -ex \
    && yum makecache fast \
    && yum -y update \
    && yum -y install \
      initscripts \
      krb5-workstation compat-db compat-libstdc++-33 krb5-libs pam_krb5 authconfig \
      sssd nss-pam-ldapd \
      openssh-server openssh-clients \
      tcsh bash \
      python-setuptools \
      strace \
    && easy_install supervisor \
    && yum clean all \
    && rm -rf /var/cache/yum

RUN /usr/sbin/authconfig --enablekrb5 --update

# setup accounts
COPY sssd/nsswitch.conf /etc/
RUN chmod 644 /etc/nsswitch.conf
COPY sssd/system-auth-ac /etc/pam.d/system-auth-ac
COPY sssd/system-auth-ac /etc/pam.d/password-auth-ac
RUN chmod 644 /etc/pam.d/system-auth-ac /etc/pam.d/password-auth-ac
COPY sssd/access.netgroup.conf /etc/security/access.netgroup.conf
RUN chmod 644 /etc/security/access.netgroup.conf

# setup supervisord
COPY supervisord.conf /etc/
COPY docker-entrypoint.sh /docker-entrypoint.sh

# ssh
RUN mkdir -p /var/run/sshd && chmod 700 /var/run/sshd

ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

ENTRYPOINT [ "/tini", "--", "/docker-entrypoint.sh" ]
