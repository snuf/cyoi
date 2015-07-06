require "cyoi/providers/constants/cloudstack_constants"
require "cyoi/cli/providers/provider_cli"
class Cyoi::Cli::Providers::ProviderCliCloudstack < Cyoi::Cli::Providers::ProviderCli
  def perform_and_return_attributes
    unless valid_infrastructure?
      puts "\nUsing provider Cloudstack\n"
      setup_credentials
    end
    export_attributes
  end

  def setup_credentials
    puts "\n"
    attributes.set_default("credentials", {})
    credentials = attributes.credentials
    credentials["cloudstack_api_key"] = hl.ask("APi key: ").to_s unless credentials.exists?("cloudstack_api_key")
    credentials["cloudstack_secret_access_key"] = hl.ask("Secret key: ").to_s unless credentials.exists?("cloudstack_secret_access_key")
    credentials["cloudstack_host"] = hl.ask("APi host: ").to_s unless credentials.exists?("cloudstack_host")
    credentials["cloudstack_scheme"] = "http"
    # hl.ask("APi scheme: ").to_s unless credentials.exists?("cloudstack_scheme")
    credentials["cloudstack_path"] = "/client/api"
    # hl.ask("APi path: ").to_s unless credentials.exists?("cloudstack_path")
    credentials["cloudstack_port"] = 8080
    # hl.ask("APi port: ").to_s unless credentials.exists?("cloudstack_port")
    # credentials["cloudstack_zone"] = hl.ask("Zone: ").to_s unless credentials.exists?("cloudstack_zone")
  end

  def valid_infrastructure?
    attributes.exists?("credentials.cloudstack_api_key") &&
    attributes.exists?("credentials.cloudstack_secret_access_key") &&
    attributes.exists?("credentials.cloudstack_api") &&
    attributes.exists?("credentials.cloudstack_host") &&
    attributes.exists?("credentials.cloudstack_scheme") &&
    attributes.exists?("credentials.cloudstack_port") &&
    attributes.exists?("credentials.cloudstack_path")
    # attributes.exists?("credentials.cloudstack_zone")
  end

  def display_confirmation
    puts "\n"
    # type = attributes.exists?("vpc") ? "VPC" : "VR"
    puts "Confirming: Using Cloudstack on #{attributes.credentials.cloudstack_host}"
  end
end

Cyoi::Cli::Provider.register_provider_cli("cloudstack", Cyoi::Cli::Providers::ProviderCliCloudstack)
