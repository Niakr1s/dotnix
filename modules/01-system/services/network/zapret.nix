{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    zapret
  ];

  systemd.services.zapret.wantedBy = [ ]; # Disable auto start

  services.zapret = {
    enable = false;
    configureFirewall = true;
    qnum = 200; # default: 200

    params = [
      "--dpi-desync=hostfakesplit"
      # "--dpi-desync-ttl=11" # works with rutracker
      "--dpi-desync-fooling=ts"
    ];

    # blacklist = [
    # ];
    #
    # whitelist = [
    #   "rutracker.org"
    #   "youtube.com"
    # ];
  };
}

### rutracker.org
# curl_test_http ipv4 rutracker.org : tpws --split-pos=method+2 --oob
# curl_test_http ipv4 rutracker.org : tpws --methodeol
# curl_test_http ipv4 rutracker.org : nfqws --methodeol
# curl_test_http ipv4 rutracker.org : nfqws --dpi-desync=fakedsplit --dpi-desync-ttl=8 --dpi-desync-split-pos=method+2 --dpi-desync-fakedsplit-mod=altorder=1
# curl_test_http ipv4 rutracker.org : nfqws --dpi-desync=fakedsplit --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=0 --dpi-desync-split-pos=method+2
# curl_test_http ipv4 rutracker.org : nfqws --dpi-desync=fakedsplit --dpi-desync-fooling=ts --dpi-desync-split-pos=method+2
# curl_test_http ipv4 rutracker.org : nfqws --dpi-desync=fakedsplit --dpi-desync-fooling=md5sig --dpi-desync-split-pos=method+2 --dpi-desync-fakedsplit-mod=altorder=1
# curl_test_http ipv4 rutracker.org : nfqws --dpi-desync=hostfakesplit --dpi-desync-ttl=7
# curl_test_http ipv4 rutracker.org : nfqws --dpi-desync=hostfakesplit --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=0
# curl_test_http ipv4 rutracker.org : nfqws --dpi-desync=hostfakesplit --dpi-desync-fooling=ts
# curl_test_http ipv4 rutracker.org : nfqws --dpi-desync=hostfakesplit --dpi-desync-fooling=md5sig
# curl_test_http ipv4 rutracker.org : nfqws --dpi-desync=fakeddisorder --dpi-desync-ttl=11 --dpi-desync-split-pos=method+2 --dpi-desync-fakedsplit-mod=altorder=1
# curl_test_http ipv4 rutracker.org : nfqws --dpi-desync=fakeddisorder --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=0 --dpi-desync-split-pos=midsld
# curl_test_http ipv4 rutracker.org : nfqws --dpi-desync=fakeddisorder --dpi-desync-fooling=ts --dpi-desync-split-pos=method+2
# curl_test_http ipv4 rutracker.org : nfqws --dpi-desync=fakeddisorder --dpi-desync-fooling=md5sig --dpi-desync-split-pos=method+2 --dpi-desync-fakedsplit-mod=altorder=1
# curl_test_http ipv4 rutracker.org : nfqws --dpi-desync=fake,multidisorder --dpi-desync-ttl=11 --orig-ttl=1 --orig-mod-start=s1 --orig-mod-cutoff=d1 --dpi-desync-split-pos=method+2
# curl_test_http ipv4 rutracker.org : nfqws --dpi-desync=fake,multidisorder --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=0 --dpi-desync-split-pos=method+2 --dpi-desync-fake-http=0x00000000
# curl_test_http ipv4 rutracker.org : nfqws --dpi-desync=fake,multidisorder --dpi-desync-fooling=ts --dpi-desync-split-pos=method+2
# curl_test_http ipv4 rutracker.org : nfqws --dpi-desync=fake,multidisorder --dpi-desync-fooling=md5sig --dup=1 --dup-cutoff=n2 --dup-fooling=md5sig --dpi-desync-split-pos=method+2
# curl_test_http ipv4 rutracker.org : nfqws --dpi-desync=hostfakesplit --dpi-desync-ttl=1 --dpi-desync-autottl=-3 --dpi-desync-hostfakesplit-mod=altorder=1 --dpi-desync-hostfakesplit-midhost=midsld
# curl_test_http ipv4 rutracker.org : nfqws --dpi-desync=fake,fakeddisorder --dpi-desync-ttl=1 --dpi-desync-autottl=-2 --orig-ttl=1 --orig-mod-start=s1 --orig-mod-cutoff=d1 --dpi-desync-split-pos=method+2 --dpi-desync-fakedsplit-mod=altorder=1
# curl_test_http ipv4 rutracker.org : nfqws --dpi-desync=syndata,multidisorder --dpi-desync-split-pos=method+2
# curl_test_https_tls12 ipv4 rutracker.org : tpws not working
# curl_test_https_tls12 ipv4 rutracker.org : nfqws --dpi-desync=fake,multisplit --dpi-desync-ttl=8 --orig-ttl=1 --orig-mod-start=s1 --orig-mod-cutoff=d1 --dpi-desync-split-pos=midsld
# curl_test_https_tls12 ipv4 rutracker.org : nfqws --dpi-desync=fake,multisplit --dpi-desync-fooling=ts --dpi-desync-split-pos=1
# curl_test_https_tls12 ipv4 rutracker.org : nfqws --dpi-desync=fake,multisplit --dpi-desync-fooling=md5sig --dup=1 --dup-cutoff=n2 --dup-fooling=md5sig --dpi-desync-split-pos=1
# curl_test_https_tls12 ipv4 rutracker.org : nfqws --dpi-desync=fake,fakedsplit --dpi-desync-ttl=7 --orig-ttl=1 --orig-mod-start=s1 --orig-mod-cutoff=d1 --dpi-desync-split-pos=1
# curl_test_https_tls12 ipv4 rutracker.org : nfqws --dpi-desync=fake,fakedsplit --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=0 --dpi-desync-split-pos=1
# curl_test_https_tls12 ipv4 rutracker.org : nfqws --dpi-desync=fake,fakedsplit --dpi-desync-fooling=ts --dpi-desync-split-pos=1
# curl_test_https_tls12 ipv4 rutracker.org : nfqws --dpi-desync=fake,fakedsplit --dpi-desync-fooling=md5sig --dup=1 --dup-cutoff=n2 --dup-fooling=md5sig --dpi-desync-split-pos=1
#!!!!! curl_test_https_tls12 ipv4 rutracker.org : nfqws --dpi-desync=hostfakesplit --dpi-desync-ttl=11
# curl_test_https_tls12 ipv4 rutracker.org : nfqws --dpi-desync=hostfakesplit --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=0
# curl_test_https_tls12 ipv4 rutracker.org : nfqws --dpi-desync=hostfakesplit --dpi-desync-fooling=ts
# curl_test_https_tls12 ipv4 rutracker.org : nfqws --dpi-desync=hostfakesplit --dpi-desync-fooling=md5sig
# curl_test_https_tls12 ipv4 rutracker.org : nfqws --dpi-desync=fake,multidisorder --dpi-desync-ttl=10 --orig-ttl=1 --orig-mod-start=s1 --orig-mod-cutoff=d1 --dpi-desync-split-pos=1,midsld
# curl_test_https_tls12 ipv4 rutracker.org : nfqws --dpi-desync=fake,multidisorder --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=0 --dpi-desync-split-pos=midsld
# curl_test_https_tls12 ipv4 rutracker.org : nfqws --dpi-desync=fake,multidisorder --dpi-desync-fooling=ts --dpi-desync-split-pos=1
# curl_test_https_tls12 ipv4 rutracker.org : nfqws --dpi-desync=fake,multidisorder --dpi-desync-fooling=md5sig --dup=1 --dup-cutoff=n2 --dup-fooling=md5sig --dpi-desync-split-pos=1
# curl_test_https_tls12 ipv4 rutracker.org : nfqws --dpi-desync=fake,fakeddisorder --dpi-desync-ttl=11 --orig-ttl=1 --orig-mod-start=s1 --orig-mod-cutoff=d1 --dpi-desync-split-pos=1
# curl_test_https_tls12 ipv4 rutracker.org : nfqws --dpi-desync=fake,fakeddisorder --dpi-desync-fooling=ts --dpi-desync-split-pos=1
# curl_test_https_tls12 ipv4 rutracker.org : nfqws --dpi-desync=fake,fakeddisorder --dpi-desync-fooling=md5sig --dup=1 --dup-cutoff=n2 --dup-fooling=md5sig --dpi-desync-split-pos=1
# curl_test_https_tls12 ipv4 rutracker.org : nfqws --dpi-desync=fake,multisplit --dpi-desync-ttl=1 --dpi-desync-autottl=-4 --dpi-desync-split-pos=1,midsld --dpi-desync-fake-tls=0x1603 --dpi-desync-fake-tls=!+2 --dpi-desync-fake-tls-mod=rnd,dupsid,rndsni --dpi-desync-fake-tcp-mod=seq
# curl_test_https_tls12 ipv4 rutracker.org : nfqws --dpi-desync=fake,fakedsplit --dpi-desync-ttl=1 --dpi-desync-autottl=-3 --orig-ttl=1 --orig-mod-start=s1 --orig-mod-cutoff=d1 --dpi-desync-split-pos=1
# curl_test_https_tls12 ipv4 rutracker.org : nfqws --dpi-desync=hostfakesplit --dpi-desync-ttl=1 --dpi-desync-autottl=-3 --orig-ttl=1 --orig-mod-start=s1 --orig-mod-cutoff=d1
# curl_test_http3 ipv4 rutracker.org : nfqws --dpi-desync=fake --dpi-desync-repeats=10
# curl_test_http3 ipv4 rutracker.org : nfqws --dpi-desync=fake --dpi-desync-fake-quic=/nix/store/b726db89l7ry0i5bi6v1lnrv59dc3a21-zapret-72.12/usr/share/zapret/files/fake/quic_initial_www_google_com.bin
