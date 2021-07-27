
  sleep 2
  mkdir -p organizations/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=/organizations/ordererOrganizations/example.com
echo $FABRIC_CA_CLIENT_HOME

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@ca-orderer:10054 --caname ca-orderer --tls.certfiles /organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/ca-orderer-10054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/ca-orderer-10054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/ca-orderer-10054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/ca-orderer-10054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >/organizations/ordererOrganizations/example.com/msp/config.yaml

  echo "Register orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles /organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null


  echo "Register the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles /organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/ordererOrganizations/example.com/orderers

  mkdir -p organizations/ordererOrganizations/example.com/orderers/orderer.example.com

  echo "Generate the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@ca-orderer:10054 --caname ca-orderer -M /organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp --csr.hosts orderer.example.com --csr.hosts localhost --csr.hosts ca-orderer --csr.hosts orderer --tls.certfiles /organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp /organizations/ordererOrganizations/example.com/msp/config.yaml /organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml

  echo "Generate the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@ca-orderer:10054 --caname ca-orderer -M /organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --csr.hosts ca-orderer --csr.hosts orderer --tls.certfiles /organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp /organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* /organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
  cp /organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/* /organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
  cp /organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/* /organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

  mkdir -p /organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts
  cp /organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* /organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p /organizations/ordererOrganizations/example.com/msp/tlscacerts
  cp /organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* /organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p organizations/ordererOrganizations/example.com/users
  mkdir -p organizations/ordererOrganizations/example.com/users/Admin@example.com



  echo "Generate the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@ca-orderer:10054 --caname ca-orderer -M /organizations/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles /organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp /organizations/ordererOrganizations/example.com/msp/config.yaml /organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml
