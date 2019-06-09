FROM alpine:3.9 as mimic-build

RUN apk --no-cache add curl \
    && curl -sSL -o /tmp/mimic.tar.gz https://github.com/MycroftAI/mimic/archive/1.2.0.2.tar.gz

RUN apk --no-cache add icu-dev pcre2-dev autoconf automake libtool m4 make gcc g++ \
    && mkdir /tmp/mimic \
    && cd /tmp/mimic \
    && tar xf /tmp/mimic.tar.gz --strip-components=1 \
    && ./autogen.sh \
    && ./configure --prefix=/usr --disable-static \
    && make \
    && make install


FROM alpine:3.9

WORKDIR /home/app

RUN apk --no-cache add curl \
    && echo "Pulling watchdog binary from Github." \
    && curl -o /usr/bin/fwatchdog -sSL https://github.com/openfaas/faas/releases/download/0.9.14/fwatchdog \
    && chmod +x /usr/bin/fwatchdog \
    && cp /usr/bin/fwatchdog /home/app \
    && apk del curl --no-cache

RUN apk --no-cache add bash sox opus-tools icu-libs pcre2

COPY --from=mimic-build /usr/bin/mimic /usr/bin/

# Add non root user
RUN addgroup -S app \
    && adduser app -S -G app

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
