# Changelog

### [2.0.1](https://www.github.com/rajesh-nitc/gcp-foundation/compare/v2.0.0...v2.0.1) (2022-01-10)


### Bug Fixes

* clear distinction between hub and spoke fw rules ([5e49f1f](https://www.github.com/rajesh-nitc/gcp-foundation/commit/5e49f1f52bf311de0bf427a81e8b5017a004214c))

## [2.0.0](https://www.github.com/rajesh-nitc/gcp-foundation/compare/v1.10.0...v2.0.0) (2022-01-09)


### Miscellaneous Chores

* release 2.0.0 ([3259c76](https://www.github.com/rajesh-nitc/gcp-foundation/commit/3259c76dce2b29fe51782f8fb8cb13482cf23737))

## [1.10.0](https://www.github.com/rajesh-nitc/gcp-foundation/compare/v1.9.0...v1.10.0) (2022-01-08)


### Features

* enabled network intelligence apis on hub and spoke shared vpcs ([c324434](https://www.github.com/rajesh-nitc/gcp-foundation/commit/c324434896b165d286d9b8f570874189010e92f4))

## [1.9.0](https://www.github.com/rajesh-nitc/gcp-foundation/compare/v1.8.1...v1.9.0) (2022-01-07)


### Features

* microsoft managed ad ([a7524ec](https://www.github.com/rajesh-nitc/gcp-foundation/commit/a7524ecada122c10587698146a492971e69ccb97))

### [1.8.1](https://www.github.com/rajesh-nitc/gcp-foundation/compare/v1.8.0...v1.8.1) (2022-01-07)


### Bug Fixes

* api service identity for vmmigration.googleapis.com ([47f8406](https://www.github.com/rajesh-nitc/gcp-foundation/commit/47f8406d1c9e56e5c13f82e7630d4cd929e28d05))

## [1.8.0](https://www.github.com/rajesh-nitc/gcp-foundation/compare/v1.7.0...v1.8.0) (2022-01-04)


### Features

* Added m4ce sharedvpc access ([e1d41e1](https://www.github.com/rajesh-nitc/gcp-foundation/commit/e1d41e1d557ee2fd9b7868abc6544398121f44a6))

## [1.7.0](https://www.github.com/rajesh-nitc/gcp-foundation/compare/v1.6.0...v1.7.0) (2022-01-04)


### Features

* Added m4ce connector ([d2b9de1](https://www.github.com/rajesh-nitc/gcp-foundation/commit/d2b9de122b29f10d62347772559d7dd384d0a7f4))

## [1.6.0](https://www.github.com/rajesh-nitc/gcp-foundation/compare/v1.5.2...v1.6.0) (2022-01-03)


### Features

* Added m4ce host project ([d923c83](https://www.github.com/rajesh-nitc/gcp-foundation/commit/d923c83613f51a510bb4e7087abdd619a1a18f32))

### [1.5.2](https://www.github.com/rajesh-nitc/gcp-foundation/compare/v1.5.1...v1.5.2) (2021-11-10)


### Bug Fixes

* changed variable gke_fw_rules_enabled to enable_gke_fw_rules ([e00745a](https://www.github.com/rajesh-nitc/gcp-foundation/commit/e00745aeb09f5dff24b6e5c947205639f747665f))

### [1.5.1](https://www.github.com/rajesh-nitc/gcp-foundation/compare/v1.5.0...v1.5.1) (2021-11-10)


### Bug Fixes

* call to gke fw module from base shared vpc module now has a general name ([70b5d13](https://www.github.com/rajesh-nitc/gcp-foundation/commit/70b5d13b6149c3f7456730c5412012570a9b0aef))

## [1.5.0](https://www.github.com/rajesh-nitc/gcp-foundation/compare/v1.4.2...v1.5.0) (2021-11-06)


### Features

* create spoke dns zones on demand to save cost ([0db462f](https://www.github.com/rajesh-nitc/gcp-foundation/commit/0db462f5528100ece08d85366fc777cd59fad473))

### [1.4.2](https://www.github.com/rajesh-nitc/gcp-foundation/compare/v1.4.1...v1.4.2) (2021-11-06)


### Bug Fixes

* we dont need to create csr repos in bootstrap stage ([4900681](https://www.github.com/rajesh-nitc/gcp-foundation/commit/490068121f5eea7ab035107ba439cdcc8029dcbd))

### [1.4.1](https://www.github.com/rajesh-nitc/gcp-foundation/compare/v1.4.0...v1.4.1) (2021-11-04)


### Bug Fixes

* browser and networkviewer role to infra and cicd project sa is not required ([671c3b8](https://www.github.com/rajesh-nitc/gcp-foundation/commit/671c3b83915033856dd424a72ddf1ca018f875d4))

## [1.4.0](https://www.github.com/rajesh-nitc/gcp-foundation/compare/v1.3.1...v1.4.0) (2021-10-19)


### Features

* destroy dns zones when not in use to save cost ([eaf81b5](https://www.github.com/rajesh-nitc/gcp-foundation/commit/eaf81b5f5ca1dbdd8951d4179a631818139566a5))

### [1.3.1](https://www.github.com/rajesh-nitc/gcp-foundation/compare/v1.3.0...v1.3.1) (2021-10-19)


### Bug Fixes

* added admin group per bu ([2d2cc8d](https://www.github.com/rajesh-nitc/gcp-foundation/commit/2d2cc8d53201bc505bbc099f26d3c93aa90c3e5f))

## [1.3.0](https://www.github.com/rajesh-nitc/gcp-foundation/compare/v1.2.0...v1.3.0) (2021-10-09)


### Features

* added features in project factory module ([2e07e2a](https://www.github.com/rajesh-nitc/gcp-foundation/commit/2e07e2a76f1584c3346e23901b7fa316c752e3c1))

## [1.2.0](https://www.github.com/rajesh-nitc/gcp-foundation/compare/v1.1.1...v1.2.0) (2021-09-03)


### Features

* project module now supports serverless vpc access ([f2b6219](https://www.github.com/rajesh-nitc/gcp-foundation/commit/f2b6219d8987ff0e97eb09647e6fb737ef73cabe))

### [1.1.1](https://www.github.com/rajesh-nitc/gcp-foundation/compare/v1.1.0...v1.1.1) (2021-08-16)


### Bug Fixes

* Tested workload identity ([d8a7ca1](https://www.github.com/rajesh-nitc/gcp-foundation/commit/d8a7ca1c6f0866ee07d5049c9efabba459258922))

## [1.1.0](https://www.github.com/rajesh-nitc/gcp-foundation/compare/v1.0.1...v1.1.0) (2021-08-11)


### Features

* save costs for personal organization ([fc054a7](https://www.github.com/rajesh-nitc/gcp-foundation/commit/fc054a7183757d1e51e371e7329c5cf848cc6dd8))

### [1.0.1](https://www.github.com/rajesh-nitc/gcp-foundation/compare/v1.0.0...v1.0.1) (2021-08-10)


### Bug Fixes

* use http probes ([111dc64](https://www.github.com/rajesh-nitc/gcp-foundation/commit/111dc64d8bfe309f2d94768e33c839ab022572f1))

## [1.0.0](https://www.github.com/rajesh-nitc/gcp-foundation/compare/v1.0.0...v1.0.0) (2021-08-09)


### Miscellaneous Chores

* release 1.0.0 ([bf66aa1](https://www.github.com/rajesh-nitc/gcp-foundation/commit/bf66aa164e4b04fa108083e84acf225f1b407a12))
