# Lambda Run Sample

## build & deploy

### build

```shell
$ build.sh [AWS_ACCOUNT_ID]
```

### deploy

```shell
$ cp environments/dev.yml.sample environments/dev.yml
$ vim environments/dev.yml
$ yarn run serverless deploy
```

# License

The source code is licensed MIT. The website content is licensed CC BY 4.0,see LICENSE.