/* global axios */
import ApiClient from '../ApiClient';

class SessionsAPI extends ApiClient {
  constructor() {
    super('atende/sessions', { accountScoped: true });
  }

  list(params = {}) {
    return axios.get(this.url, { params });
  }

  show(id) {
    return axios.get(`${this.url}/${id}`);
  }
}

export default new SessionsAPI();
