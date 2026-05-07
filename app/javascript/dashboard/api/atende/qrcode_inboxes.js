/* global axios */
import ApiClient from '../ApiClient';

class QrcodeInboxesAPI extends ApiClient {
  constructor() {
    super('atende/qrcode_inboxes', { accountScoped: true });
  }

  create(payload) {
    return axios.post(this.url, payload);
  }

  getQrCode(id) {
    return axios.get(`${this.url}/${id}/qr_code`);
  }

  disconnect(id) {
    return axios.post(`${this.url}/${id}/disconnect`);
  }

  destroy(id) {
    return axios.delete(`${this.url}/${id}`);
  }
}

export default new QrcodeInboxesAPI();
