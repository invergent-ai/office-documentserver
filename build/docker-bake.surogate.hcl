# Layered on top of docker-bake.hcl by .github/workflows/surogate-office-docs.yml:
#   docker buildx bake -f docker-bake.hcl -f docker-bake.surogate.hcl cluster-docs
# It only renames and pushes the cluster-docs image and swaps the local build
# caches for registry caches; every Dockerfile and build arg stays Euro-Office's.

variable "IMAGE" {
  default = "ghcr.io/invergent-ai/office-docs"
}

variable "CACHE" {
  default = "ghcr.io/invergent-ai/office-docs-buildcache"
}

variable "SHORT_SHA" {
  default = "dev"
}

target "cluster-docs" {
  tags       = ["${IMAGE}:${SHORT_SHA}", "${IMAGE}:${PRODUCT_VERSION}-surogate"]
  output     = ["type=registry"]
  cache-from = ["type=registry,ref=${CACHE}:cluster-docs"]
  cache-to   = ["type=registry,ref=${CACHE}:cluster-docs,mode=max,ignore-error=true"]
}

# One registry cache per stage, so a change in one submodule rebuilds only that
# stage and what depends on it (a cold core compile alone is ~85 min).
target "core" {
  cache-from = ["type=registry,ref=${CACHE}:core"]
  cache-to   = ["type=registry,ref=${CACHE}:core,mode=max,ignore-error=true"]
}

target "core-wasm" {
  cache-from = ["type=registry,ref=${CACHE}:core-wasm"]
  cache-to   = ["type=registry,ref=${CACHE}:core-wasm,mode=max,ignore-error=true"]
}

target "sdkjs" {
  cache-from = ["type=registry,ref=${CACHE}:sdkjs"]
  cache-to   = ["type=registry,ref=${CACHE}:sdkjs,mode=max,ignore-error=true"]
}

target "web-apps" {
  cache-from = ["type=registry,ref=${CACHE}:web-apps"]
  cache-to   = ["type=registry,ref=${CACHE}:web-apps,mode=max,ignore-error=true"]
}

target "server" {
  cache-from = ["type=registry,ref=${CACHE}:server"]
  cache-to   = ["type=registry,ref=${CACHE}:server,mode=max,ignore-error=true"]
}

target "example" {
  cache-from = ["type=registry,ref=${CACHE}:example"]
  cache-to   = ["type=registry,ref=${CACHE}:example,mode=max,ignore-error=true"]
}

target "bundle" {
  cache-from = ["type=registry,ref=${CACHE}:bundle"]
  cache-to   = ["type=registry,ref=${CACHE}:bundle,mode=max,ignore-error=true"]
}

target "packages" {
  cache-from = ["type=registry,ref=${CACHE}:packages"]
  cache-to   = ["type=registry,ref=${CACHE}:packages,mode=max,ignore-error=true"]
}
