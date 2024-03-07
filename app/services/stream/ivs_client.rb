require 'aws-sdk-ivs'

module Stream
  class IvsClient
    def initialize
      @client = Aws::IVS::Client.new(region: 'us-east-1',
                                     access_key_id: Rails.application.credentials.aws[:access_key_id],
                                     secret_access_key: Rails.application.credentials.aws[:secret_access_key])
    end

    def create_channel(resource)
      raise ArgumentError, 'Resource must be a User object' unless resource.is_a?(User)

      response = @client.create_channel(name: resource.username)
      resource&.stream_key&.destroy

      stream_key = StreamKey.create(
        arn: response.stream_key.arn,
        channel_arn: response.channel.arn,
        value: response.stream_key.value,
        user: resource
      )

      resource.update(
        channel_arn: response.channel.arn,
        playback_url: response.channel.playback_url,
        stream_key:
      )
    end

    def update_channel_name(resource)
      raise ArgumentError, 'Resource must be a User object' unless resource.is_a?(User)

      @client.update_channel(arn: resource.channel_arn, name: resource.username)
    end
  end
end
