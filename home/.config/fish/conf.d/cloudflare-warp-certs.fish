# Cloudflare One Client (WARP) with Gateway TLS inspection re-signs HTTPS traffic,
# so CLI tools must trust the Gateway root CA.
#
# Download the certificate from Zero Trust > Settings > Resources > Certificates,
# then save it as ~/.local/share/cloudflare-warp-certs/Cloudflare_CA.pem.
# Without that file this config does nothing.
set -l __cf_dir "$HOME/.local/share/cloudflare-warp-certs"
set -l __cf_ca "$__cf_dir/Cloudflare_CA.pem"
set -l __cf_bundle "$__cf_dir/ca-bundle.pem"

if test -f "$__cf_ca"
    # Combined bundle = system roots + Gateway CA, for tools that replace the trust store.
    if not test -f "$__cf_bundle"; or test "$__cf_ca" -nt "$__cf_bundle"
        cat /etc/ssl/cert.pem "$__cf_ca" >"$__cf_bundle" 2>/dev/null
    end

    # Node adds this to its built-in roots.
    set -gx NODE_EXTRA_CA_CERTS "$__cf_ca"
    # These replace the trust store, so they point at the combined bundle.
    set -gx SSL_CERT_FILE "$__cf_bundle"
    set -gx CURL_CA_BUNDLE "$__cf_bundle"
    set -gx REQUESTS_CA_BUNDLE "$__cf_bundle"
    set -gx GIT_SSL_CAINFO "$__cf_bundle"
    set -gx CARGO_HTTP_CAINFO "$__cf_bundle"
end
