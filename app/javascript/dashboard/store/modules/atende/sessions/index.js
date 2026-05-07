import SessionsAPI from '../../../../api/atende/sessions';

const state = {
  records: [],
  meta: { count: 0, current_page: 1 },
  uiFlags: { isFetching: false },
};

const getters = {
  allSessions: s => s.records,
  meta: s => s.meta,
  uiFlags: s => s.uiFlags,
};

const mutations = {
  SET_SESSIONS(st, { sessions, meta }) {
    st.records = sessions;
    st.meta = meta;
  },
  SET_FETCHING(st, value) {
    st.uiFlags.isFetching = value;
  },
};

const actions = {
  async fetchSessions({ commit }, params = {}) {
    commit('SET_FETCHING', true);
    try {
      const { data } = await SessionsAPI.list(params);
      commit('SET_SESSIONS', { sessions: data.sessions, meta: data.meta });
    } finally {
      commit('SET_FETCHING', false);
    }
  },
};

export default { namespaced: true, state, getters, mutations, actions };
