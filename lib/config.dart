

const _kMyIdLogoutUrl = 'kMyIdLogoutUrl';
const _kMyIdUrl = 'kMyIdUrl';
const _kSuccessUrlPrefix = 'kSuccessUrlPrefix';
const _kEnvironment = '_kEnvironment';

enum MyIdEnvironment {
  prod,
  stage,
}

Map<String, String>? kConfig;

void setEnvironment(MyIdEnvironment env) {
  switch (env) {
    case MyIdEnvironment.prod:
      kConfig = kProdConfig;
      break;
    case MyIdEnvironment.stage:
      kConfig = kStageConfig;
      break;
  }
}

String? get kMyIdLogoutUrl {
  return kConfig?[_kMyIdLogoutUrl];
}

String? get kMyIdUrl {
  return kConfig?[_kMyIdUrl];
}

String? get kSuccessUrlPrefix {
  return kConfig?[_kSuccessUrlPrefix];
}

String? get kEnvironment {
  return kConfig?[_kEnvironment];
}

Map<String, String> kProdConfig = <String, String>{
  _kMyIdLogoutUrl: 'https://login.myid.disney.com/logout',
  _kMyIdUrl:
  'https://idp.myid.disney.com/as/authorization.oauth2?client_id=SCFWRPROD&response_type=id_token+token&redirect_uri=http://localhost:8001/welcome?&nonce=APPLICATION_GENERATED_ONE_TIME_NONCE&scope=openid+profile+email+relationship.employeeNumber+relationship.employeeId+relationship.employeeType+relationship.salariedCode',
  _kSuccessUrlPrefix: 'http://localhost:8001/welcome',
  _kEnvironment: MyIdEnvironment.prod.name,
};

Map<String, String> kStageConfig = <String, String>{
  _kMyIdLogoutUrl: 'https://login.myid-stg.disney.com/logout',
  _kMyIdUrl:
  'https://idp.myid.disney.com/as/authorization.oauth2?client_id=SCFWRPROD&response_type=code&redirect_uri=http://vetsystemprod.wdw.disney.com/MyIDSolo/AuthProcess.aspx?&scope=openid+profile+email+id.uuid+relationship.employeeNumber+relationship.employeeStatus+relationship.employeeId',
  _kSuccessUrlPrefix: 'http://vetsystemprod.wdw.disney.com/MyIDSolo/Default.aspx?fnCode=SCFWRPROD',
  _kEnvironment: MyIdEnvironment.stage.name,
};