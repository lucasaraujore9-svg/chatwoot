/* global axios */
import ApiClient from '../ApiClient';

class AgentsAtendeAPI extends ApiClient {
  constructor() {
    super('atende/agents', { accountScoped: true });
  }

  list() {
    return axios.get(this.url);
  }

  show(id) {
    return axios.get(`${this.url}/${id}`);
  }

  create(data) {
    return axios.post(this.url, { agent: data });
  }

  update(id, data) {
    return axios.patch(`${this.url}/${id}`, { agent: data });
  }

  destroy(id) {
    return axios.delete(`${this.url}/${id}`);
  }

  playground(id, payload) {
    return axios.post(`${this.url}/${id}/playground`, payload);
  }
}

export default new AgentsAtendeAPI();
