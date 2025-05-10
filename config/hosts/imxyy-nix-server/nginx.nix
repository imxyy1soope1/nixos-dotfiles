_:
{
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    clientMaxBodySize = "0";
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "acme@imxyy.top";
  };
}
