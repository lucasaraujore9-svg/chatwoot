Rails.application.configure do
  config.to_prepare do
    AsyncDispatcher.prepend(Module.new do
      def listeners
        super + [Atende::MessageListener.instance]
      end
    end)
  end
end
