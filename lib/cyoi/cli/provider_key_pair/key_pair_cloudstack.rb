class Cyoi::Cli::KeyPair; end
class Cyoi::Cli::KeyPair::KeyPairCliCloudstack
  attr_reader :provider_client
  attr_reader :attributes
  attr_reader :hl

  def initialize(provider_client, attributes, highline)
    @provider_client = provider_client
    @hl = highline
    @attributes = attributes.is_a?(Hash) ? ReadWriteSettings.new(attributes) : attributes
    raise "@attributes must be ReadWriteSettings (or Hash)" unless @attributes.is_a?(ReadWriteSettings)
    raise "@attributes.name must be set" unless @attributes["name"]
  end

  def perform_and_return_attributes
    unless valid?
      destroy_existing_key_pair
      provision_key_pair
    end
    export_attributes
  end

  # helper to export the complete nested attributes.
  def export_attributes
    attributes.to_nested_hash
  end

  def valid?
    attributes["name"] && attributes["fingerprint"] && attributes["private_key"] &&
      provider_client.list_ssh_key_pairs.select {|pair| pair['name'] == "key_pair_name" }
      # provider_client.valid_key_pair_fingerprint?(key_pair_name, attributes.fingerprint)
  end

  def display_confirmation
    puts "\n"
    puts "Confirming: Using key pair #{key_pair_name}"
  end

  def key_pair_name
    attributes.name
  end

  def destroy_existing_key_pair
    if provider_client.list_ssh_key_pairs
      provider_client.delete_ssh_key_pair(key_pair_name)
    end
  end

  # provisions key pair from AWS and returns fog object KeyPair
  def provision_key_pair
    # .select {|pair| pair['name'] == "key_pair_name" }
    if key_pair = provider_client.create_ssh_key_pair(key_pair_name)
      attributes["fingerprint"] = key_pair["fingerprint"]
      attributes["private_key"] = key_pair["privatekey"]
    end
  end
end

Cyoi::Cli::KeyPair.register_key_pair_cli("cloudstack", Cyoi::Cli::KeyPair::KeyPairCliCloudstack)
