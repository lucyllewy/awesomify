FROM alpine:3.9 as watchdog

RUN apk --no-cache add curl
RUN curl -sSL -o /usr/bin/fwatchdog https://github.com/openfaas/faas/releases/download/0.13.0/fwatchdog \
    && chmod +x /usr/bin/fwatchdog


FROM alpine:3.9 as mimic-build

RUN apk --no-cache add curl icu-dev pcre2-dev autoconf automake libtool m4 make gcc g++
RUN curl -sSL -o /tmp/mimic.tar.gz https://github.com/MycroftAI/mimic/archive/1.2.0.2.tar.gz
RUN mkdir /tmp/mimic \
    && cd /tmp/mimic \
    && tar xf /tmp/mimic.tar.gz --strip-components=1 \
    && ./autogen.sh \
    && ./configure --prefix=/usr --disable-static \
    && make \
    && make install


FROM alpine:3.9

WORKDIR /home/app

# Add non root user
RUN addgroup -S app && adduser app -S -G app
RUN apk --no-cache add bash sox opus-tools icu-libs pcre2

COPY --from=watchdog /usr/bin/fwatchdog /usr/bin/
COPY --from=mimic-build /usr/bin/mimic /usr/bin/

USER app
COPY . /home/app

# Populate example here - i.e. "cat", "sha512sum" or "node index.js"
ENV fprocess="/home/app/create-awesomeness.sh"
# Set to true to see request in function logs
ENV write_debug="false"
ENV content_type="audio/ogg"

EXPOSE 8080

HEALTHCHECK --interval=3s CMD [ -e /tmp/.lock ] || exit 1
CMD [ "fwatchdog" ]
