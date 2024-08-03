# Service Provider Setup Guide

## Requirements

Using Digital Ocean's droplets as reference, these are the minimum suggested specifications:

- daemon (2 vCPUs, 4G RAM)
  - This host will run `laconicd`. You can set up a private testnet for testing purposes.
- orchestrator (2 vCPUs, 4G RAM)
  - You will manage the entire Service Provider infrastructure from this host.
- control (8vCPUs, 32G RAM)
  - This host will run a cluster to deploy all the applications requested from the Laconic chain.


## Initial Ubuntu base setup: `control` and `daemon` hosts

1. Set unique hostnames.

```
hostnamectl set-hostname changeme
```

In the following example, we've named each machine like so:
```
lcn-daemon               23.111.69.218
lcn-cad-cluster-control  23.111.78.182
```

See below for the full list of DNS records to be configured.

2. Update base packages.

```
apt update && apt upgrade -y
```

3. Install additional packages.

```
apt install -y doas zsh tmux git jq acl curl wget netcat-traditional fping rsync htop iotop iftop tar less firewalld sshguard wireguard iproute2 iperf3 zfsutils-linux net-tools ca-certificates gnupg sshpass
```

Select "Yes" when prompted for iperf3.

4. Verify status of firewalld and enable sshguard.

```
systemctl enable --now firewalld
systemctl enable --now sshguard
```

5. Disable and remove snapd.

```
systemctl disable snapd.service
systemctl disable snapd.socket
systemctl disable snapd.seeded
systemctl disable snapd.snap-repair.timer

apt purge -y snapd

rm -rf ~/snap /snap /var/snap /var/lib/snapd
```

6. Create a `so` user.

We will use the password `so-service-provider` in this example.
```
adduser so
```

7. Give the `so` user sudoer permissions.
```
sudo adduser so sudo
```

8. Run `ssh-keygen` in the `orchestrator` host and copy the pubkey from `~/.ssh/id_d25519.pub`.

9. Create a `/home/so/.ssh/authorized_keys` file in both `lcn-daemon` and `lcn-cad-cluster-control`, and paste the pubkey from the previous step in it.


## Buy a domain and configure nameservers to DO

* In this example, we are using laconic.com with [nameservers pointing to Digital Ocean](https://docs.digitalocean.com/products/networking/dns/getting-started/dns-registrars/). You'll need to do the same. Integration with other providers is possible and encouraged, but requires know-how and research.
* Generate a Digital Ocean Access Token, we will need one later.

## Configure DNS

Point your nameservers to Digital Ocean and create the following A and CNAME records from the Digital Ocean Dashboard.
 
Like this:

|  Type  |            Hostname                  |            Value                     |
|--------|--------------------------------------|--------------------------------------|
| A      | lcn-daemon.laconic.com               | 23.111.69.218                        |
| A      | lcn-cad-cluster-control.laconic.com  | 23.111.78.179                        |
| NS     | laconic.com                          | ns1.digitalocean.com.                |
| NS     | laconic.com                          | ns2.digitalocean.com.                |
| NS     | laconic.com                          | ns3.digitalocean.com.                |
| CNAME  | www.laconic.com                      | laconic.com.                         |
| CNAME  | laconicd.laconic.com                 | lcn-daemon.laconic.com.              |
| CNAME  | lcn-backend.laconic.com              | lcn-daemon.laconic.com.              |
| CNAME  | lcn-console.laconic.com              | lcn-daemon.laconic.com.              |
| CNAME  | lcn-cad.laconic.com                  | lcn-cad-cluster-control.laconic.com. |
| CNAME  | *.lcn-cad.laconic.com                | lcn-cad-cluster-control.laconic.com. |
| CNAME  | pwa.laconic.com                      | lcn-cad-cluster-control.laconic.com. |
| CNAME  | *.pwa.laconic.com                    | lcn-cad-cluster-control.laconic.com. |


## Setup a k8s cluster with Ansible: `orchestrator` host only

1. Install stack orchestrator.

```
mkdir ~/bin
curl -L -o ~/bin/laconic-so https://git.vdb.to/cerc-io/stack-orchestrator/releases/download/latest/laconic-so
chmod +x ~/bin/laconic-so
```

2. Add `export PATH="$HOME/bin:$PATH"` to `~/.bashrc` , log out, and log back in.

3. Verify stack orchestrator is in the PATH.
```
laconic-so version
```

4. Install ansible via virtual env.

```
sudo apt install python3-pip python3.12-venv
python3.12 -m venv ~/.local/venv/ansible
source ~/.local/venv/ansible/bin/activate
pip install ansible
ansible --version
```

5. Install docker and test with `docker run hello-world` afterwards.

```
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update -y && apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

6. Clone the service provider template repo and enter the directory

```
git clone https://git.vdb.to/cerc-io/service-provider-template.git
cd service-provider-template/
```

7. Create a PGP key. You will need to use the passphrase from this step later on. We used `so-service-provider` in this example.

```
gpg --full-generate-key
```

8. List the secret keys.
```
gpg --list-secret-keys --keyid-format=long
```

This will output something like this:
```
[keyboxd]
---------
sec   rsa4096/0AFB10B643944C22 2024-05-03 [SC] [expires: 2025-05-03]
      17B3248D6784EC6CB43365A60AFB10B643944C22
uid                 [ultimate] user <hello@laconic.com>
```

Note the `0AFB10B643944C22` sequence of characters.

9. Replace the keys listed in `.vault/vault-keys` with the sequence you obtained in the previous step (`0AFB10B643944C22` in this example).

10. Start the GPG agent.

```
gpg-agent
```

11. Run `export VAULT_KEY=password`, where `password is the passphrase used when generating the PGP key.

12. Run `bash .vault/vault-rekey.sh` and enter the GPG passphrase again when prompted.

13. Review [this pull request](https://git.vdb.to/cerc-io/service-provider-template/pulls/4) and make the required modifications to match your setup.
  * `lcn`/`msp`: This can be replaced a three-letter identifier for your organization.
  * `cad`: This can be replaced with a three-letter identifier for the location the host is running in.
  * `laconic.com`: Replace this with your equivalent DNS domain.

14. Install required Ansible roles.

```
ansible-galaxy install -f -p roles -r roles/requirements.yml
```

15. Install k8s helper tools.

```
sudo ./roles/k8s/files/scripts/get-kube-tools.sh
```

16.  Update `group_vars/all/vault.yml` as follows, replacing the email address:

```
---
support_email: hello@laconic.com
```

17. Base64 encode your Digital Ocean token:

```
echo dop_v1<rest of your DO token> | base64 -w 0
```

18.  Update `files/manifests/secret-digitalocean-dns.yaml` using the output from the previous step:

```
apiVersion: v1
kind: Namespace
metadata:
  name: cert-manager
---
apiVersion: v1
data:
  access-token: <base_64_encoded_digital_ocean_token>
kind: Secret
metadata:
  name: digitalocean-dns
  namespace: cert-manager
```

19.  Remove the `./group_vars/lcn_cad/k8s-vault.yml` file. 
  
```
rm ./group_vars/lcn_cad/k8s-vault.yml
```


20. Generate token for the cluster.

* Change `lcn_cad` in the command below to the name used for your service provider deployment:
```
./roles/k8s/files/scripts/token-vault.sh ./group_vars/lcn_cad/k8s-vault.yml
```

21. Configure firewalld and nginx for hosts.

```
ansible-playbook -i hosts site.yml --tags=firewalld,nginx --user so -kK
```
When prompted, enter the password for the `so` user that was created both the daemon and control machines (`so-service-provider` in this example).

22. Install Stack Orchestrator for hosts.

```
ansible-playbook -i hosts site.yml --tags=so --limit=so --user so -kK
```
Enter the `so` user password again (`so-service-provider` in this example).

23. Deploy k8s to hosts

This step creates the cluster and puts `kubeconfig.yml` on your local machine here: `~/.kube/config-default.yaml`. You will need it later.

```
ansible-playbook -i hosts site.yml --tags=k8s --limit=lcn_cad --user so -kK
```
Enter the `so` user password again (`so-service-provider` in this example).

**Note:** For debugging, to undeploy, add `--extra-vars 'k8s_action=destroy'` to the above command.

24.  Verify cluster creation

Run these commands to view the various resources that were created by the ansible playbook. Your output form each commmand should look similar.

```
kubie ctx default
# this allows you to run kubectl commands
```

```
kubectl get nodes -o wide

NAME                      STATUS   ROLES                       AGE   VERSION        INTERNAL-IP     EXTERNAL-IP     OS-IMAGE           KERNEL-VERSION     CONTAINER-RUNTIME
lnt-cad-cluster-control   Ready    control-plane,etcd,master   27m   v1.29.6+k3s2   147.182.144.6   147.182.144.6   Ubuntu 24.04 LTS   6.8.0-36-generic   containerd://1.7.17-k3s1
```
```
kubectl get secrets --all-namespaces

NAMESPACE       NAME                                        TYPE                DATA   AGE
cert-manager    cert-manager-webhook-ca                     Opaque              3      3m14s
cert-manager    digitalocean-dns                            Opaque              1      3m30s
cert-manager    letsencrypt-prod-prviate-key                Opaque              1      3m3s
cert-manager    letsencrypt-prod-wild-prviate-key           Opaque              1      3m3s
default         pwa.laconic.com-lsnz4                       Opaque              1      3m3s
ingress-nginx   ingress-nginx-admission                     Opaque              3      3m13s
kube-system     k3s-serving                                 kubernetes.io/tls   2      28m
kube-system     tnt-cad-cluster-control.node-password.k3s   Opaque              1      28m
```

```
kubectl get clusterissuer

NAME                    READY   AGE
letsencrypt-prod        True    4m8s
letsencrypt-prod-wild   True    4m8s
```

```
kubectl get certificates

NAME                       READY   SECRET                     AGE
pwa.laconic.com            True    pwa.laconic.com            4m31s
```

```
kubectl get ds --all-namespaces

NAMESPACE     NAME                                      DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
kube-system   svclb-ingress-nginx-controller-a766a501   1         1         1       1            1           <none>          5m32s
```

### Ansible Vault Notes

With `ansible-vault`, files are encrypted this way:

```
ansible-vault encrypt path/to/file.yaml
```

and the result overwrites the original file with the encrypted version.

To decrypt that file, run: 

```
echo 'content-of-the-file' | ansible-vault decrypt
```

and the decrypted file will be output to stdout.

You can add additional PGP key IDs to the `.vault/vault-keys` file and re-key the vault to give other users access.

### Nginx and SSL

If your initial ansible configuration was modified correctly; nginx and SSL will work. The k8s cluster was created with these features automated.

## Deploy docker image (container) registry

This will be the first test that everything is configured correctly.

1. Generate the spec file for the `container-registry` stack.
```
laconic-so --stack container-registry deploy init --output container-registry.spec
```

2. Modify the `container-registry.spec` as shown below.
* Set the `host-name` field according to your configuration.

```
stack: container-registry
deploy-to: k8s
kube-config: /root/.kube/config-default.yaml
network:
  ports:
    registry:
     - '5000'
  http-proxy:
    - host-name: container-registry.pwa.laconic.com
      routes:
        - path: '/'
          proxy-to: registry:5000
volumes:
  registry-data:
configmaps:
  config: ./configmaps/config
```

3. Create the deployment directory for the `container-registry` stack.
```
laconic-so --stack container-registry deploy create --deployment-dir container-registry --spec-file container-registry.spec
```

The above commands created a new directory; `container-registry`. It should contain the following:

```
$ ls
compose/  config.env configmaps/ deployment.yml kubeconfig.yml pods/  spec.yml  stack.yml
```

### Configure access to the container registry

1. Generate a username and password for the container registry.
* Username: `so-reg-user`
* Password: `pXDwO5zLU7M88x3aA`

2. Base64 encode the container registry credentials.
```
echo -n "so-reg-user:pXDwO5zLU7M88x3aA" | base64 -w0
c28tcmVnLXVzZXI6cFhEd081ekxVN004OHgzYUE=
```

3. Encrypt the conteainer registry credentials to create an `htpasswd` file:

```
htpasswd -bB -c container-registry/configmaps/config/htpasswd so-reg-user pXDwO5zLU7M88x3aA
```

The resulting file should look like this:
```
so-reg-user:$2y$05$Eds.WkuUgn6XFUL8/NKSt.JTX.gCuXRGQFyJaRit9HhrUTsVrhH.W
```

4. Using the credentials from the previous steps, create a `container-registry/my_password.json` file.

```
{
  "auths": {
    "container-registry.pwa.laconic.com": {
      "username": "so-reg-user",
      "password": "$2y$05$Eds.WkuUgn6XFUL8/NKSt.JTX.gCuXRGQFyJaRit9HhrUTsVrhH.W",
      "auth": "c28tcmVnLXVzZXI6cFhEd081ekxVN004OHgzYUE="
    }
  }
}
```

5. Configure the file `container-registry/config.env` as follows:

```
REGISTRY_AUTH=htpasswd
REGISTRY_AUTH_HTPASSWD_REALM="LCN Service Provider Image Registry"
REGISTRY_AUTH_HTPASSWD_PATH="/config/htpasswd"
REGISTRY_HTTP_SECRET='$2y$05$Eds.WkuUgn6XFUL8/NKSt.JTX.gCuXRGQFyJaRit9HhrUTsVrhH.W'
```

6. Add the container registry credentials as a secret available to the cluster:

```
kubectl create secret generic laconic-registry --from-file=.dockerconfigjson=container-registry/my_password.json --type=kubernetes.io/dockerconfigjson
```

7. Deploy the container registry.

```
laconic-so deployment --dir container-registry start
```

6. Check the logs.

```
laconic-so deployment --dir container-registry logs
```

7. Check status and await succesful deployment:

```
laconic-so deployment --dir container-registry status
```

8. Confirm deployment by logging in:

```
docker login container-registry.pwa.laconic.com --username so-reg-user --password pXDwO5zLU7M88x3aA
```

All this htpasswd configuration will enable the deployer (below) to build and push images to this docker registry (which is hosted on your k8s cluster).

### Set ingress annotations

1. Replace `laconic-26cc70be8a3db3f4` with the `cluster-id` found in `container-registry/deployment.yml` then run the following commands:
```
kubectl annotate ingress laconic-26cc70be8a3db3f4-ingress nginx.ingress.kubernetes.io/proxy-body-size=0
kubectl annotate ingress laconic-26cc70be8a3db3f4-ingress nginx.ingress.kubernetes.io/proxy-read-timeout=600
kubectl annotate ingress laconic-26cc70be8a3db3f4-ingress nginx.ingress.kubernetes.io/proxy-send-timeout=600
```

Note: this will be handled automatically by stack orchestrator in [this issue](https://git.vdb.to/cerc-io/stack-orchestrator/issues/849).

## Connect to laconicd

For the testnet, this next step will require using the onboarding app. Running a single node fixturenet will allow service providers to test their system e2e prior to the testnet.

### Deploy a single laconicd fixturenet and console

Follow the instructions in [this document](https://git.vdb.to/cerc-io/fixturenet-laconicd-stack/src/branch/main/stack-orchestrator/stacks/fixturenet-laconicd/README.md) from the `daemon` host.

See the [Perform operations](https://git.vdb.to/cerc-io/fixturenet-laconicd-stack/src/branch/main/stack-orchestrator/stacks/fixturenet-laconicd/README.md#perform-operations) section for instructions on how to collect the following:
* Bond ID
* Private key


### Set a name authority

Follow [these steps](https://github.com/hyphacoop/loro-testnet/blob/main/docs/instructions.md#register-an-authority) to create an authority.
* This authority needs to be added to the `package.json` of any application deployed under this namespace
* This authority will be set as the variable `DEPLOYMENT_RECORD_NAMESPACE="my-org-name"` in the next section.

## Deploy backend

This service listens for `ApplicationDeploymentRequest`'s in the Laconic Registry and automatically deploys an application to the k8s cluster.

1. Initialize a spec file for the deployer backend.

```
laconic-so --stack webapp-deployer-backend setup-repositories
laconic-so --stack webapp-deployer-backend build-containers
laconic-so --stack webapp-deployer-backend deploy init --output webapp-deployer.spec
```

2. Modify the contents of `webapp-deployer.spec`:

```
stack: webapp-deployer-backend
deploy-to: k8s
kube-config: /home/so/.kube/config-default.yaml
image-registry: container-registry.pwa.laconic.com/laconic-registry
network:
  ports:
    server:
     - '9555'
  http-proxy:
    - host-name: webapp-deployer-api.pwa.laconic.com
      routes:
        - path: '/'
          proxy-to: server:9555
volumes:
  srv: 
configmaps:
  config: ./data/config
annotations:
  container.apparmor.security.beta.kubernetes.io/{name}: unconfined
labels:
  container.kubeaudit.io/{name}.allow-disabled-apparmor: "podman"
security:
  privileged: true

resources:
  containers:
    reservations:
      cpus: 4
      memory: 8G
    limits:
      cpus: 6
      memory: 16G
  volumes:
    reservations:
      storage: 200G
```

3. Create the deployment directory from the spec file.
```
laconic-so --stack webapp-deployer-backend deploy create --deployment-dir webapp-deployer --spec-file webapp-deployer.spec
```
4. Modify the contents of `webapp-deployer/config.env`:

```
DEPLOYMENT_DNS_SUFFIX="pwa.laconic.com"

# this should match the name authority reserved above
DEPLOYMENT_RECORD_NAMESPACE="my-org-name"

# url of the deployed docker image registry
IMAGE_REGISTRY="container-registry.pwa.laconic.com"

# credentials from the htpasswd section above
IMAGE_REGISTRY_USER="so-reg-user"
IMAGE_REGISTRY_CREDS="pXDwO5zLU7M88x3aA"

# configs
CLEAN_DEPLOYMENTS=false
CLEAN_LOGS=false
CLEAN_CONTAINERS=false
SYSTEM_PRUNE=false
WEBAPP_IMAGE_PRUNE=true
CHECK_INTERVAL=5
FQDN_POLICY="allow"
```

5. Copy `~/.kube/config-default.yaml` from the k8s cluster creation step to `webapp-deployer/data/config/kube.yml`
6. Create `webapp-deployer/data/config/laconic.yml`, it should look like this:
```
services:
  registry:
    rpcEndpoint: 'https://lcn-daemon.laconic.com:26657'
    gqlEndpoint: 'https://lcn-daemon.laconic.com:9473/api'
    userKey: e64ae9d07b21c62081b3d6d48e78bf44275ffe0575f788ea7b36f71ea559724b
    bondId: ad9c977f4a641c2cf26ce37dcc9d9eb95325e9f317aee6c9f33388cdd8f2abb8
    chainId: lorotestnet-1
    gas: 9950000
    fees: 500000alnt
```
Modify the endpoints, user key, and bond ID according to your configuration.

7. Push the image to the container registry.
```
laconic-so deployment --dir webapp-deployer start
```

8. Start the deployer.
```
laconic-so deployment --dir webapp-deployer start
```

Publishing records to the Laconic Registry will trigger deployments in your backend now.

## Deploy frontend

1. Clone and build the deployer UI

```
git clone https://git.vdb.to/cerc-io/webapp-deployment-status-ui.git ~/cerc/webapp-deployment-status-ui
laconic-so build-webapp --source-repo ~/cerc/webapp-deployment-status-ui
```

2. Create a deployment

```
laconic-so deploy-webapp create --kube-config /root/.kube/config-default.yaml --image-registry container-registry.pwa.laconic.com --deployment-dir webapp-ui --image cerc/webapp-deployment-status-ui:local --url https://webapp-deployer-ui.pwa.laconic.com --env-file ~/cerc/webapp-deployment-status-ui/.env
```

3. Push the image to the container registry.
```
laconic-so deployment --dir webapp-ui push-images
```
4. Start the deployer UI
```
laconic-so deployment --dir webapp-ui start
```

1. Wait a moment then go to https://webapp-deployer-ui.pwa.laconic.com for the status and logs of each deployment.

## Deploy a test webapp

1. Fork this repo: https://git.vdb.to/cerc-io/test-progressive-web-app

2. Review this file: `.gitea/workflows/publish.yaml`. Change to `.github` if that's where your fork is.

3. Update both `scripts/publish-app-record.sh` and `scripts/request-app-deployment.sh` with relevant endpoints (or set envs).

4. Update `package.json` fields: `"name": "@my-org-name/app-name` and `"repository": "url_to_your_fork_must_be_public"`

5. Add the envs referenced in `.gitea/workflows/publish.yaml`, i.e., for `privKey` and `bondId` as Secrets in Gitea/GitHub Actions.

Now, anytime a release is created, a new set of records will be published to the Laconic Registry, and eventually picked up by the `deployer`, which will target the k8s cluster that was setup.

**Note:** to override the default webapp build process, put a file named `build-webapp.sh` in the root of the repo.

## Result

We now have:

- https://lcn-console.laconic.com displays registry records (webapp deployments)
- https://container-registry.pwa.laconic.com hosts docker images used by webapp deployments
- https://webapp-deployer-api.pwa.laconic.com listens for ApplicationDeploymentRequest and runs `laconic-so deploy-webapp-from-registry` behind the scenes
- https://webapp-deployer-ui.pwa.laconic.com displays status and logs for webapps deployed via the Laconic Registry
- https://app-name-45wjhbhef.pwa.laconic.com is the webapp deployed above

