/* global axios */
import ApiClient from '../ApiClient';

class FlowsAPI extends ApiClient {
  constructor() {
    super('atende/flows', { accountScoped: true });
  }

  getFlows(page = 1) {
    return axios.get(`${this.url}?page=${page}`);
  }

  getFlow(id) {
    return axios.get(`${this.url}/${id}`);
  }

  createFlow(data) {
    return axios.post(this.url, { flow: data });
  }

  updateFlow(id, data) {
    return axios.patch(`${this.url}/${id}`, { flow: data });
  }

  deleteFlow(id) {
    return axios.delete(`${this.url}/${id}`);
  }

  publishFlow(id) {
    return axios.post(`${this.url}/${id}/publish`);
  }

  unpublishFlow(id) {
    return axios.post(`${this.url}/${id}/unpublish`);
  }
}

export default new FlowsAPI();
