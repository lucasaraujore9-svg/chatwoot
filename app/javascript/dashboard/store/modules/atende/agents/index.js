import AgentsAPI from '../../../../api/atende/agents';

const state = {
  records: [],
  uiFlags: { isFetching: false, isSaving: false },
};

const getters = {
  allAgents: s => s.records,
  getAgent: s => id => s.records.find(a => a.id === id),
  uiFlags: s => s.uiFlags,
};

const mutations = {
  SET_AGENTS(st, agents) {
    st.records = agents;
  },
  UPSERT_AGENT(st, agent) {
    const idx = st.records.findIndex(a => a.id === agent.id);
    if (idx >= 0) st.records.splice(idx, 1, agent);
    else st.records.push(agent);
  },
  REMOVE_AGENT(st, id) {
    st.records = st.records.filter(a => a.id !== id);
  },
  SET_FETCHING(st, v) {
    st.uiFlags.isFetching = v;
  },
  SET_SAVING(st, v) {
    st.uiFlags.isSaving = v;
  },
};

const actions = {
  async fetchAgents({ commit }) {
    commit('SET_FETCHING', true);
    try {
      const { data } = await AgentsAPI.list();
      commit('SET_AGENTS', data.agents);
    } finally {
      commit('SET_FETCHING', false);
    }
  },
  async createAgent({ commit }, agentData) {
    commit('SET_SAVING', true);
    try {
      const { data } = await AgentsAPI.create(agentData);
      commit('UPSERT_AGENT', data);
      return data;
    } finally {
      commit('SET_SAVING', false);
    }
  },
  async updateAgent({ commit }, { id, ...data }) {
    commit('SET_SAVING', true);
    try {
      const { data: agent } = await AgentsAPI.update(id, data);
      commit('UPSERT_AGENT', agent);
      return agent;
    } finally {
      commit('SET_SAVING', false);
    }
  },
  async deleteAgent({ commit }, id) {
    await AgentsAPI.destroy(id);
    commit('REMOVE_AGENT', id);
  },
};

export default { namespaced: true, state, getters, mutations, actions };
