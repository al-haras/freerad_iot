FROM ubuntu
RUN apt-get -y update && apt-get -y install \
    freeradius
COPY ./clients.conf /etc/freeradius/3.0
COPY ./authorize /etc/freeradius/3.0/mods-config/files/authorize
RUN chown freerad:freerad /etc/freeradius/3.0/mods-config/files/authorize
EXPOSE 1812 1813
CMD freeradius -X
