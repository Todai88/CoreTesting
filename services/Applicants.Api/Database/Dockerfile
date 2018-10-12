####
##
## For production use, it's typically not advisable to put your database in a container, however, 
## there are exceptions to every rule. 
## So if you're thinking about production you'll need to carefully test and evaluate any containerized database.
##
####

FROM microsoft/mssql-server-linux:2017-latest
ENV SA_PASSWORD=Pass@word
ENV ACCEPT_EULA=Y
COPY entrypoint.sh entrypoint.sh
COPY SqlCmdStartup.sh SqlCmdStartup.sh
COPY SqlCmdScript.sql SqlCmdScript.sql
RUN chmod +x ./SqlCmdStartup.sh
CMD /bin/bash ./entrypoint.sh