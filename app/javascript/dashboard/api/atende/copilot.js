/* global axios */
import ApiClient from '../ApiClient';

class CopilotAPI extends ApiClient {
  constructor() {
    super('atende/copilot_threads', { accountScoped: true });
  }

  getOrCreateThread(conversationId) {
    return axios.post(this.url, {
      thread: { conversation_id: conversationId },
    });
  }

  getMessages(threadId) {
    return axios.get(`${this.url}/${threadId}/copilot_messages`);
  }

  sendMessage(threadId, content) {
    return axios.post(`${this.url}/${threadId}/copilot_messages`, {
      message: { content },
    });
  }
}

export default new CopilotAPI();
