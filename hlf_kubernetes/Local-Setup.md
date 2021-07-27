# Setting up the entire hyperledger fabric cluster on local Docker Desktop K8 environment 

The cluster consists of 
* __3 Orgs__ : Org1, Org2, Org3 
* __5 Orderers__: Due to resource constraints on local we can go with 1 orderer node
* __Chaincode__ : This is deployed as an external chaincode 
* __Api application__ : This is used to interface with chaincode and ledger
* __UI application__ :  A sample UI application to interact with chaincode and ledger. This is powered by Api application 
* __Hyperledger Fabric Explorer__: This is to visualize the entire network
* __Monitoring Layer__: Grafana and Prometheus to monitor the network and setup alerts
* __K8 Ingress__ : This helps expose the UI, API , Explorer and Monitoring applications on Local or Server setup

Order of running the setup 
1. Setup NFS (1.nfs)
    *  On local evnvironment we need to use the mypv.yaml, Please update the hostPath.path to your local workstation path run the below command
    Note for windows users using wsl2 : If host directory is present at C:/tempdir then in persistent volume section of mypv.yaml give hostpath as /run/desktop/mnt/host/c/tempdir

        _kubectl apply -f mypv.yaml_
    
1. Bring Fabric CA Servers (2.ca)
    *  Please run the below command and verify the ca folders are created in shared pv
    
        _kubectl apply -f ._
    
1. Link Certificates (3.certificates)
    *  Please run the below command and verify the kubernetes job completed successfully
    
        _kubectl apply -f ._
    
1. Bring Orderers Up (5.orderer)
    *  On local we can bring up few of the orderers. Below is the command to bring first orderer
        
        _kubectl apply -f orderer.yaml,orderer-svc.yaml_
    
1. Enable external chaincode build & deploy, configure core.yaml (6.cofigmap)
    *  Please run the below command and verify configmap has been added kubernetes
    
        _kubectl apply -f ._

1. Bring Peers Up (7.peers)
    *  Please run the below command and verify that peer & peer cli pods are up 
    
        _kubectl apply -f org1/._

        _kubectl apply -f org2/._

        _kubectl apply -f org3/._

1. Setup Genesis, Create channel artifacts, Create Application Channel & Join Channel (4.artifacts)
    *  Please run the below command and verify that genesis block & channel artifacts are created in shared pv  location
        
        _kubectl apply -f ._

1. Package Chaincode & Install  (8.chaincode)
    *  Please follow the steps listed in [notes](./8.chaincode/notes.txt) file

1. Deploy, approve, Commit and Init chaincode (9.cc-deploy)
    *  Please follow the steps listed in [notes](./9.cc-deploy/notes.txt) file

1. Deploy api (10.api)
    *  Please run the below command and verify that api server application is up 
        
        _kubectl apply -f ._
    * Please update the /etc/hosts file on your local to have seperate domain names for api, ui and explorer apps. For example 

        _127.0.0.1	localhost __explorer.localhost__ __api.localhost__ __ui.localhost___

1. Deploy UI (11.ui)
    *  Please update the environment.ts and environment.prod.ts to point to the api host that we set in the /etc/hosts file for api in above step
    * Build the docker image for ui on your local with command below 
        docker build -t local/frontend:latest
    * Update the fronten.yaml with the tag name and imagePullPolicy as never 
    * Run below command to deploy the ui application

        _kubectl apply -f frontend.yaml_

1. Deploy Explorer (12.explorer)
    * Please execute the ccp.sh file 
    * Run below command to deploy the ui application

        _kubectl apply -f ._

1. Enable Ingress local (14.ingress)
    * Please update the host values in ingress-local.yaml with hosts setup in /etc/hosts file
    * Please install ythe ingress-nginx on your local with below command (for Docker Desktop)

        _kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.47.0/deploy/static/provider/cloud/deploy.yaml_

        reference [link](https://kubernetes.github.io/ingress-nginx/deploy/#docker-desktop)

    * Run below command to setup the ingress 

        _kubectl apply -f ingress-local.yaml_

1. Enable Monitoring (13.monitoring)
    * Run below command to deploy the monitoring application

        _kubectl apply -f ._

1. Verify using below urls on local 
    * __UI APPLICATION__: http://ui.localhost/ 
    * __API APPLICATION__: http://api.localhost/
    * __EXPLORER APPLICATION__ : http://explorer.localhost/


 __NOTE__ these hosts will change with respect to /etc/hosts and ports mentioned in deployment yamls)        


