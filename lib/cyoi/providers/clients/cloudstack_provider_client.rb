module Cyoi; module Providers; module Clients; end; end; end

require "cyoi/providers/clients/fog_provider_client"

class Cyoi::Providers::Clients::CloudstackProviderClient < Cyoi::Providers::Clients::FogProviderClient

  # Construct a Fog::Compute object
  # Uses +attributes+ which normally originates from +settings.provider+
  def setup_fog_connection
    configuration = Fog.symbolize_credentials(attributes.credentials)
    configuration[:provider] = "cloudstack"
    @fog_compute = Fog::Compute.new(configuration)
  end

  def networks
    fog_compute.list_networks['listnetworksresponse']['network']
  end

  def vpcs
    fog_compute.list_vpcs['listvpcsresponse']['vpc']
  end

  def subnets
    fog_compute.subnets
  end

  def publicips
  	fog_compute.list_public_ip_addresses['listpublicipaddressesresponse']['publicipaddress']
  end

  def associatepublicip(vpcid)
  	fog_compute.associate_ip_address("vpcid" => vpcid)
  end
end
