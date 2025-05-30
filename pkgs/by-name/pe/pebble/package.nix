{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "pebble";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "letsencrypt";
    repo = "pebble";
    rev = "v${version}";
    hash = "sha256-YPU/bl7h6rOWg+5ut0Thn2UupeKpJ7u4KXc2svIeZEM=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru.tests = {
    smoke-test-http = nixosTests.acme.http01-builtin;
    smoke-test-dns = nixosTests.acme.dns01;
  };

  meta = {
    homepage = "https://github.com/letsencrypt/pebble";
    description = "Small RFC 8555 ACME test server";
    longDescription = "Miniature version of Boulder, Pebble is a small RFC 8555 ACME test server not suited for a production CA";
    license = [ lib.licenses.mpl20 ];
    mainProgram = "pebble";
    teams = [ lib.teams.acme ];
  };
}
