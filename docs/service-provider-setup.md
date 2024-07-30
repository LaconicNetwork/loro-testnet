## Select and boot servers

Using Digital Ocean's droplets as reference, these are the minimum suggested specifications:

- orchestrator (4G RAM, 25G Disk)
- daemon (4G RAM, 25G Disk)
- control (8vCPUs, 32G RAM, 300G Disk)

## Access control

This is personal preference. At minimum, create new users and disable root access. The daemon and control will need an `so` user, see below.

## Initial Ubuntu base setup

**On daemon and control:**

1. Set unique hostnames 

```
hostnamectl set-hostname changeme
```

In the following example, we've named each machine like so:
```
lcn-daemon               23.111.69.218
lcn-cad-cluster-control  23.111.78.182
```

See below for the full list of DNS records to be configured.

2. Next, update base packages:

```
apt update && apt upgrade -y
```

3. Install additional packages:

```
apt install -y doas zsh tmux git jq acl curl wget netcat-traditional fping rsync htop iotop iftop tar less firewalld sshguard wireguard iproute2 iperf3 zfsutils-linux net-tools ca-certificates gnupg sshpass
```

Select "Yes" when prompted for iperf3.

4. Verify status of firewalld and enable sshguard:

```
systemctl enable --now firewalld
systemctl enable --now sshguard
```

5. Disable and remove snapd

```
systemctl disable snapd.service
systemctl disable snapd.socket
systemctl disable snapd.seeded
systemctl disable snapd.snap-repair.timer

apt purge -y snapd

rm -rf ~/snap /snap /var/snap /var/lib/snapd
```

6. Create a new user `so`:

```
adduser so
# make the password so-service-provider
```
```
# then give this user sudoer permissions
sudo adduser so sudo
```

## Daemon-only (skip this step for the control node)

1. On `orchestrator` run `ssh-keygen` then `cat ~/.ssh/id_ed25519.pub` and put the output in to `/home/so/.ssh/authorized_keys` on `lcn-daemon` and `lcn-cad-cluster-control`

2. Install nginx and certbot:

```
apt install -y nginx certbot python3-certbot-nginx
```

3. Install Docker:

```
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update -y && apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

4. Logout from the root user and log back in as the `so` user. Then run:

```
sudo groupadd docker
sudo usermod -aG docker so
```

5. Confirm docker works with `docker run hello-world`.

## Buy a domain and configure nameservers to DO

In this example, we are using laconic.com with [nameservers pointing to Digital Ocean](https://docs.digitalocean.com/products/networking/dns/getting-started/dns-registrars/). You'll need to do the same. Integration with other providers is possible and encouraged, but requires know-how and research. Later, we'll need a Digital Ocean Access Token added to the ansible-vault.

## Configure DNS

As mentioned, point your nameservers to Digital Ocean and create the following A and CNAME records from the Digital Ocean Dashboard.
 
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


## Use ansible to setup a k8s cluster

The steps in this section and for the rest of the tutorial are to be completed on the `orchestrator` machine (with the exception of deploying laconicd on the daemon).

1. Install ansible via virtual env

```
sudo apt install python3-pip python3.12-venv
python3.12 -m venv ~/.local/venv/ansible
source ~/.local/venv/ansible/bin/activate
pip install ansible
ansible --version
```

2. Install docker using the same instructions as above.

3. Install stack orchestrator

```
mkdir ~/bin
curl -L -o ~/bin/laconic-so https://git.vdb.to/cerc-io/stack-orchestrator/releases/download/latest/laconic-so
chmod +x ~/bin/laconic-so
# add `export PATH="$HOME/bin:$PATH"` to `~/.bashrc`
laconic-so version
```

4. Clone the service provider template repo and enter the directory

```
git clone https://git.vdb.to/cerc-io/service-provider-template.git
cd service-provider-template/
```

5. Sort out credentials and ansible vault

- get a digital ocean token, base64 encode it, and put that in the `files/manifests/secret-digitalocean-dns.yaml` file
   
- create a PGP key:

```
gpg --full-generate-key
```

then 

```
gpg --list-secret-keys --keyid-format=long
```

which provides an output like:

```
[keyboxd]
---------
sec   rsa4096/0AFB10B643944C22 2024-05-03 [SC] [expires: 2025-05-03]
      17B3248D6784EC6CB43365A60AFB10B643944C22
uid                 [ultimate] user <hello@laconic.com>
```

and replace the other keys with `0AFB10B643944C22` in the `.vault/vault-keys` file. Start the agent: `gpg-agent`.

then run: `export VAULT_KEY=password` where `password` is the password used for creating the GPG key.

Next, run `bash .vault/vault-rekey.sh` and enter that same password when prompted.

- review [this pull request](https://git.vdb.to/cerc-io/service-provider-template/pulls/4) and make the required modifications to match your setup.

6. Install required roles

```
ansible-galaxy install -f -p roles -r roles/requirements.yml
```

7. Install k8s helper tools

```
sudo ./roles/k8s/files/scripts/get-kube-tools.sh
```

8. Become familiar with encrypting and decrypting secrets using `ansible-vault`. You'll need have 3 files that are encrypted.
 
a) `group_vars/all/vault.yml` will look like:

```
---
support_email: hello@laconic.com
```

b) `files/manifests/secret-digitalocean-dns.yaml` will look like:

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

c) `./group_vars/lcn_cad/k8s-vault.yml` which will be created in the next step and looks like:

```
---
k8s_cluster_token: f63c34881f3d7fbd30229db4c82e902b

# note: delete this file; it will be re-created when running `./roles/k8s/files/token-vault.sh ./group_vars/lcn_cad/k8s-vault.yml`
```

With `ansible-vault`, files are encrypted like so:

```
ansible-vault encrypt path/to/file.yaml
```

and the result overwrites the original file with the encrypted version.

To then decrypt that file run: 

```
echo 'content-of-the-file' | ansible-vault decrypt
```

and the decrypted file will be output to stdout.

You can add additional PGP key IDs to the `.vault/vault-keys` file and re-key the vault to give other users access.

9. Generate token for the cluster

As mentioned, `rm ./group_vars/lcn_cad/k8s-vault.yml` then

```
./roles/k8s/files/scripts/token-vault.sh ./group_vars/lcn_cad/k8s-vault.yml
```

Note: `lcn_cad` should be changed to a different name used for your service provider deployment.

10. Configure firewalld and nginx for hosts

```
ansible-playbook -i hosts site.yml --tags=firewalld,nginx --user so -kK
```
When prompted, enter the password for the `so` user that was created both the daemon and control machines.

11. Install Stack Orchestrator for hosts

```
ansible-playbook -i hosts site.yml --tags=so --limit=so --user so -kK
```
Enter the `so` user password again.

12. Deploy k8s to hosts

This step creates the cluster and puts the `kubeconfig.yml` at on your local machine here: `~/.kube/config-default.yaml`. You'll need it for later.

```
ansible-playbook -i hosts site.yml --tags=k8s --limit=lcn_cad --user so -kK
```
Enter the `so` user password again.

**Note:** For debugging, to undeploy, add `--extra-vars 'k8s_action=destroy'` to the above command.

13. Verify cluster creation

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

## Nginx and SSL

If your initial ansible configuration was modified correctly; nginx and SSL will work. The k8s cluster was created with these features automated.

## Deploy docker image (container) registry

This will be the first test that everything is configured correctly.

```
laconic-so --stack container-registry deploy init --output container-registry.spec
```
Modify the `container-registry.spec` to look like:
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

then run:
```
laconic-so --stack container-registry deploy create --deployment-dir container-registry --spec-file container-registry.spec
```

The above commands created a new directory; `container-registry`. It looks like:

```
$ ls
compose/  config.env configmaps/ deployment.yml kubeconfig.yml pods/  spec.yml  stack.yml
```

### Htpasswd

1. Create the `htpasswd` file:

```
htpasswd -b -c container-registry/configmaps/config/htpasswd so-reg-user pXDwO5zLU7M88x3aA
```

the resulting file should look like:

```
so-reg-user:$2y$05$Eds.WkuUgn6XFUL8/NKSt.JTX.gCuXRGQFyJaRit9HhrUTsVrhH.W
```

2. Configure the file `container-registry/config.env` like this:

```
REGISTRY_AUTH=htpasswd
REGISTRY_AUTH_HTPASSWD_REALM="LCN Service Provider Image Registry"
REGISTRY_AUTH_HTPASSWD_PATH="/config/htpasswd"
REGISTRY_HTTP_SECRET='$2y$05$Eds.WkuUgn6XFUL8/NKSt.JTX.gCuXRGQFyJaRit9HhrUTsVrhH.W'
```

3. Using these credentials, create a `container-registry/my_password.json` that looks like:

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
where the `auth:` field is the output of:

```
echo -n "so-reg-user:pXDwO5zLU7M88x3aA" | base64 -w0
```

4. Add the container registry credentials as a secret available to the cluster:

```
kubectl create secret generic laconic-registry --from-file=.dockerconfigjson=container-registry/my_password.json --type=kubernetes.io/dockerconfigjson
```

5. deploy it:

```
laconic-so deployment --dir container-registry start
```

6. Check the logs:

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

1. replace `laconic-26cc70be8a3db3f4` with the `cluster-id` found in `container-registry/deployment.yml` then run the following commands:
```
kubectl annotate ingress laconic-26cc70be8a3db3f4-ingress nginx.ingress.kubernetes.io/proxy-body-size=0
kubectl annotate ingress laconic-26cc70be8a3db3f4-ingress nginx.ingress.kubernetes.io/proxy-read-timeout=600
kubectl annotate ingress laconic-26cc70be8a3db3f4-ingress nginx.ingress.kubernetes.io/proxy-send-timeout=600
```

Note: this will be handled automatically by stack orchestrator in [this issue](https://git.vdb.to/cerc-io/stack-orchestrator/issues/849).

## Connect to laconicd

For the testnet, this next step will require using the onboarding app. Running a single node fixturenet will allow service providers to test their system e2e prior to the testnet.

### Deploy a single laconicd fixturenet and console

Follow the instructions in [this document](https://git.vdb.to/cerc-io/fixturenet-laconicd-stack/src/branch/main/stack-orchestrator/stacks/fixturenet-laconicd/README.md)

After publishing sample records, you'll have a `bondId`. Also retreive your `userKey` (private key) which will be required later.

#### Set name authority

```
laconic registry authority reserve my-org-name
laconic registry authority bond set my-org-name <bondId>
```

where `my-org-name` needs to be added to the `package.json` of any application deployed under this namespace and will be set as the env var `DEPLOYMENT_RECORD_NAMESPACE="my-org-name"`, below.

## Deploy back end

This service listens for `ApplicationDeploymentRequest`'s in the Laconic Registry and automatically deploys an application to the k8s cluster.

```
laconic-so --stack webapp-deployer-backend setup-repositories
laconic-so --stack webapp-deployer-backend build-containers
laconic-so --stack webapp-deployer-backend deploy init --output webapp-deployer.spec
```
Modify `webapp-deployer.spec`:

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

then run:
```
laconic-so --stack webapp-deployer-backend deploy create --deployment-dir webapp-deployer --spec-file webapp-deployer.spec
```

Modify the contents of `webapp-deployer/config.env`:

```
DEPLOYMENT_DNS_SUFFIX="pwa.laconic.com"

# this should match the name authority reserved above
DEPLOYMENT_RECORD_NAMESPACE="mito"

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

In `webapp-deployer/data/config/` there needs to be two files:
  1. `kube.yml` --> copied from `/home/so/.kube/config-default.yaml`
  2. `laconic.yml` --> with the details for talking to laconicd

The latter looks like:

```
services:
  registry:
    rpcEndpoint: 'https://lcn-daemon.laconic.com:26657'
    gqlEndpoint: 'https://lcn-daemon.laconic.com:9473/api'
    userKey: e64ae9d07b21c62081b3d6d48e78bf44275ffe0575f788ea7b36f71ea559724b
    bondId: ad9c977f4a641c2cf26ce37dcc9d9eb95325e9f317aee6c9f33388cdd8f2abb8
    chainId: laconic_9000-1
    gas: 9950000
    fees: 500000photon
```

Push the image and start up the deployer
```
laconic-so deployment --dir webapp-deployer push-images
laconic-so deployment --dir webapp-deployer start
```

Now, publishing records to the Laconic Registry will trigger deployments. See below for more details.

## Deploy front end

1. Clone and build the UI

```
git clone https://git.vdb.to/cerc-io/webapp-deployment-status-ui.git ~/cerc/webapp-deployment-status-ui
laconic-so build-webapp --source-repo ~/cerc/webapp-deployment-status-ui
```

2. Create a deployment

```
laconic-so deploy-webapp create --kube-config /root/.kube/config-default.yaml --image-registry container-registry.pwa.laconic.com --deployment-dir webapp-ui --image cerc/webapp-deployment-status-ui:local --url https://webapp-deployer-ui.pwa.laconic.com --env-file ~/cerc/webapp-deployment-status-ui/.env
```

3. Push the image and start the service
```
laconic-so deployment --dir webapp-ui push-images
laconic-so deployment --dir webapp-ui start
```

4. Wait a moment then view https://webapp-deployer-ui.pwa.laconic.com for the status and logs of each deployment.

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
