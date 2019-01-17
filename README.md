# Awesomify #

Make someone or something awesome!

## Usage ##

### Deploy ###

This is an [OpenFaaS](https://www.openfaas.com/) function so you need an OpenFaaS system to deploy onto. These instructions assume you have the `faas-cli` available (See [Installing OpenFaaS CLI](https://docs.openfaas.com/cli/install/) for details).

```bash
faas-cli deploy --image=diddledan/awesomify --name=awesomify
```

### Curl ###

```bash
curl -o awesome.ogg http://example.com/function/awesomify?Testing+Functions
```

Or

```bash
curl -X POST -d 'Testing Functions' -o awesome.ogg http://example.com/function/awesomify
```

Alternatively visit the URL http://example.com/function/awesomify?Testing+Functions in your browser (preferably Chrome or Firefox because they definitely support the audio codec, but Edge might work if you first install the [Web Media Extensions pack](https://www.microsoft.com/en-us/p/web-media-extensions/9n5tdp8vcmhs) from the store).

In all the above examples you need to replace `http://example.com/` with the URL to your functions server.

Open the file `awesome.ogg` in a media player that supports Ogg+Opus codecs, of which there are many; I like [VLC Media Player](https://www.videolan.org/) for it's cross-platform and supports every codec stance.