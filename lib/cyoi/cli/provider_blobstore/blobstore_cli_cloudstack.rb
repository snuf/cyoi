require "cyoi/cli/provider_blobstore/blobstore_cli_base"
class Cyoi::Cli::Blobstore::BlobstoreCliCloudstack < Cyoi::Cli::Blobstore::BlobstoreCliBase
end

Cyoi::Cli::Blobstore.register_cli("cloudstack", Cyoi::Cli::Blobstore::BlobstoreCliCloudstack)
