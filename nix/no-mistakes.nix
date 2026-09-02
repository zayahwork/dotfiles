# no-mistakes: a local git proxy that gates a push behind an agent-run
# validation pipeline before it reaches the real remote.
#
# Not in nixpkgs and it ships no flake, so we build it here. Pinned to a
# release tag: this is somebody else's fast moving repo and a surprise in it
# should never break a switch. Bump the version and both hashes together.
{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "no-mistakes";
  version = "1.60.2";

  src = fetchFromGitHub {
    owner = "kunchenguid";
    repo = "no-mistakes";
    rev = "v${version}";
    hash = "sha256-+aJKgoykK443BLiQQgvMgL0rbsipUrs2LHERz9KdTMY=";
  };

  vendorHash = "sha256-NZOYxNYvt4192uqKBdKRxdgrKFvWx3585psdCnRdPSM=";

  # The test suite reaches for git remotes and a configured agent, neither of
  # which exists in the build sandbox.
  doCheck = false;

  meta = {
    description = "Git proxy that gates a push behind an agent validation pipeline";
    homepage = "https://github.com/kunchenguid/no-mistakes";
    license = lib.licenses.mit;
    mainProgram = "no-mistakes";
  };
}
