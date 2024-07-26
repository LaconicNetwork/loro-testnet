# LORO Testnet Instructions

The following is a cheat sheet for all the CLI commands you may need to submit at one point during the LORO testnet.

## Create a bond

Sample command:
```
laconic-so deployment --dir laconic-console-deployment exec cli "laconic registry bond create --type photon --quantity 100000000000"
```
```
{"bondId":"a742489e5817ef274187611dadb0e4284a49c087608b545ab6bd990905fb61f3"}
```

## Register an authority

### Reserve authority

Reserve the name to start the auction.
```
laconic-so deployment --dir laconic-console-deployment exec cli "laconic registry authority reserve loro"
```
```
{"success": true}
```
Obtain the auction ID.
```
laconic-so deployment --dir laconic-console-deployment exec cli "laconic registry authority whois loro"
```
```
...
    "auction": {
      "id": "73e0b082a198c396009ce748804a9060c674a10045365d262c1584f99d2771c1",
...
```

### Commit a bid

Commit a bid to the auction while its status is listed as `commit` using the auction ID. A reveal file will be generated.
```
laconic-so deployment --dir laconic-console-deployment exec cli "laconic registry auction bid commit 73e0b082a198c396009ce748804a9060c674a10045365d262c1584f99d2771c1 5000000 photon --chain-id laconic_9000-1"
```
```
{"reveal_file":"/app/out/bafyreiewi4osqyvrnljwwcb36fn6sr5iidfpuznqkz52gxc5ztt3jt4zmy.json"}
```

### Reveal a bid

Reveal a bid to the auction while its status is listed as `reveal` using the auction ID and the reveal file generated from the bid commit.
```
laconic-so deployment --dir laconic-console-deployment exec cli "laconic registry auction bid reveal 73e0b082a198c396009ce748804a9060c674a10045365d262c1584f99d2771c1 /app/out/bafyreiewi4osqyvrnljwwcb36fn6sr5iidfpuznqkz52gxc5ztt3jt4zmy.json --chain-id laconic_9000-1"
```
```
{"success": true}
```


### Set authority

Query the auction after the auction ends, it should list a `completed` status and a winner.
```
laconic-so deployment --dir laconic-console-deployment exec cli "laconic registry auction get 73e0b082a198c396009ce748804a9060c674a10045365d262c1584f99d2771c1"
```

Set the authority using a bond ID.
```
laconic-so deployment --dir laconic-console-deployment exec cli "laconic registry authority bond set loro fbea5d17b6a8b71c8e8fb971977b6cd2e1900621d8cbb0e463646f21d69b38ef"
```
```
{"success": true}
```

Verify the authority has been registered.
```
laconic-so deployment --dir laconic-console-deployment exec cli "laconic registry authority whois loro"
```

## Register a name

Set the name using a registered authority and an Application Record ID:
```
laconic-so deployment --dir laconic-console-deployment exec cli "laconic registry name set lrn://loro/applications/webapp bafyreibmqxncmt4fuwgtf5jzx2k6zkw2iwxaags7z6wgksuqbnusmrpk24"
```
* In this example, `loro` is an active authority and `bafyreibmqxncmt4fuwgtf5jzx2k6zkw2iwxaags7z6wgksuqbnusmrpk24` is the ID of an Application Record.


## Register an Application Record

Anybody looking to publish an app must register an Application Record that Application Deployment Requests can reference.
  
* Copy the application record yaml file ([see this sample](/templates/application-record.yml)) to `laconic-console-deployment/data/laconic-registry-data/application-record.yml`.
* Register the Application Record.
```
laconic-so deployment --dir laconic-console-deployment exec cli "laconic registry record publish --filename /laconic-registry-data/application-record.yml --bond-id <bond_id> --gas 250000"
```
```
{
  "id": "bafyreibmqxncmt4fuwgtf5jzx2k6zkw2iwxaags7z6wgksuqbnusmrpk24"
}
```

## Register an Application Deployment Request Record

An Application Deployment Request must be registered to notify Service Providers that an app is waiting to be deployed.

* Copy the application deployment request yaml file ([see this sample](/templates/application-deployment-request.yml)) to `laconic-console-deployment/data/laconic-registry-data/application-deployment-request.yml`.
* Register the Application Deployment Request.
```
laconic-so deployment --dir laconic-console-deployment exec cli "laconic registry record publish --filename /laconic-registry-data/application-deployment-request.yml --bond-id <bond_id> --gas 250000"
```
```
{
  "id": "bafyreia4skpopfqre3j4romwmbtydgb5d53e2g2pvfd4kedjr7kwtrcb7u"
}
```

## Register a DNS Record

A Service Provider must register a DNS Record after a successful application deployment.

* Copy the DNS record yaml file ([see this sample](/templates/dns-record.yml)) to `laconic-console-deployment/data/laconic-registry-data/dns-record.yml`.
* Register the DNS Record.
```
laconic-so deployment --dir laconic-console-deployment exec cli "laconic registry record publish --filename /laconic-registry-data/dns-record.yml --bond-id <bond_id> --gas 250000"
```
```
{
  "id": "bafyreie2yesktfv2jez5fyvtc2thklpg5suh6ygdy6ggijbeckmohohybm"
}
```

Verify the record:
```
laconic-so deployment --dir laconic-console-deployment exec cli "laconicd registry record get --id bafyreie2yesktfv2jez5fyvtc2thklpg5suh6ygdy6ggijbeckmohohybm"
```

## Register an Application Deployment Record

A Service Provider must register an Application Deployment Record after a successful deployment.

* Copy the Application deployment record yaml file ([see this sample](/templates/application-deployment-record.yml)) to `laconic-console-deployment/data/laconic-registry-data/application-deployment-record.yml`.
* Register the Application Deployment Record.
```
laconic-so deployment --dir laconic-console-deployment exec cli "laconic registry record publish --filename /laconic-registry-data/application-deployment-record.yml --bond-id <bond_id> --gas 250000"
```
```
{
  "id": "bafyreieow4oybr5spo6imwtegd24t26obqhlnq5tl2mw3cvpbdq4prst7e"
}
```

Verify the record:
```
laconic-so deployment --dir laconic-console-deployment exec cli "laconicd registry record get --id bafyreieow4oybr5spo6imwtegd24t26obqhlnq5tl2mw3cvpbdq4prst7e"
```

## Register an Application Deployment Removal Request

An Application Deployment Removal Request can be registered to notify Service Providers that an app deployment should be stopped.

* Copy the application deployment removal request yaml file ([see this sample](/templates/application-deployment-removal-request.yml)) to `laconic-console-deployment/data/laconic-registry-data/application-deployment-removal-request.yml`.
* Register the Application Deployment Request.
```
laconic-so deployment --dir laconic-console-deployment exec cli "laconic registry record publish --filename /laconic-registry-data/application-deployment-removal-request.yml --bond-id <bond_id> --gas 250000"
```
```
{
  "id": "bafyreibwgtf5jzx2bnusmrpk24k6zkw2iwxaags7z6mqxncmt4fuwgksuq"
}
```