_:
{
  services.caddy = {
    enable = true;
    email = "acme@imxyy.top";
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "acme@imxyy.top";
  };
}
