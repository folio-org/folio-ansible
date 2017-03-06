FROM node:6.10

ENV STRIPES_HOME /home/folio

WORKDIR $STRIPES_HOME

COPY package.json ${STRIPES_HOME}/package.json
COPY stripes.config.js ${STRIPES_HOME}/stripes.config.js
COPY npmrc  ${STRIPES_HOME}/.npmrc

RUN groupadd folio && \
    useradd -r -d $STRIPES_HOME -g folio -M folio && \
    chown -R folio $STRIPES_HOME

USER folio

RUN npm install

EXPOSE 3000

CMD ["/usr/local/bin/npm", "start"]

