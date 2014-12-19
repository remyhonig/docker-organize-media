# User Docker specific base image https://github.com/phusion/baseimage-docker
FROM phusion/baseimage:0.9.15
MAINTAINER Remy Honig

# Correct environment variables
ENV HOME /root

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Volume
VOLUME ["/src", "/dst"]

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Install git-annex
RUN apt-get update && apt-get install -y mediainfo jhead

# Install moreutls for the "ts" command which prepends lines with a timestamp
RUN apt-get install -y moreutils

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Run process as a one-shot script
ADD process.sh /etc/my_init.d/01_process.sh
RUN chmod +x /etc/my_init.d/01_process.sh
