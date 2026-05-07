module Atende
  class CopilotChannel < ApplicationCable::Channel
    def subscribed
      thread = find_thread
      return reject unless thread

      stream_from "atende_copilot_thread_#{thread.id}"
    end

    def unsubscribed
      stop_all_streams
    end

    def speak(data)
      thread = find_thread
      return transmit({ error: 'thread_not_found' }) unless thread
      return transmit({ error: 'message_required' }) if data['message'].blank?

      Atende::CopilotJob.perform_later(
        thread_id: thread.id,
        account_id: thread.account_id,
        user_message: data['message']
      )
    end

    private

    def find_thread
      account = Account.find_by(id: params[:account_id])
      return nil unless account

      account.atende_copilot_threads.find_by(id: params[:thread_id])
    end
  end
end
