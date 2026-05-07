import * as MutationTypes from './mutationTypes';
import FlowsAPI from '../../../../api/atende/flows';

const state = {
  records: {},
  sortOrder: [],
  uiFlags: {
    isFetching: false,
    isFetchingItem: false,
    isCreating: false,
    isUpdating: false,
    isDeleting: false,
  },
};

const getters = {
  allFlows: $state => $state.sortOrder.map(id => $state.records[id]),
  getFlow: $state => id => $state.records[id],
  uiFlags: $state => $state.uiFlags,
};

const mutations = {
  [MutationTypes.SET_FLOWS]($state, flows) {
    flows.forEach(flow => {
      $state.records[flow.id] = flow;
    });
    $state.sortOrder = flows.map(f => f.id);
  },
  [MutationTypes.SET_FLOW]($state, flow) {
    $state.records[flow.id] = flow;
    if (!$state.sortOrder.includes(flow.id)) {
      $state.sortOrder.push(flow.id);
    }
  },
  [MutationTypes.REMOVE_FLOW]($state, id) {
    delete $state.records[id];
    $state.sortOrder = $state.sortOrder.filter(fId => fId !== id);
  },
  [MutationTypes.SET_UI_FLAG]($state, { flag, value }) {
    $state.uiFlags[flag] = value;
  },
};

const actions = {
  async fetchFlows({ commit }, page = 1) {
    commit(MutationTypes.SET_UI_FLAG, { flag: 'isFetching', value: true });
    try {
      const { data } = await FlowsAPI.getFlows(page);
      commit(MutationTypes.SET_FLOWS, data.flows);
      return data;
    } finally {
      commit(MutationTypes.SET_UI_FLAG, { flag: 'isFetching', value: false });
    }
  },

  async createFlow({ commit }, flowData) {
    commit(MutationTypes.SET_UI_FLAG, { flag: 'isCreating', value: true });
    try {
      const { data } = await FlowsAPI.createFlow(flowData);
      commit(MutationTypes.SET_FLOW, data);
      return data;
    } finally {
      commit(MutationTypes.SET_UI_FLAG, { flag: 'isCreating', value: false });
    }
  },

  async updateFlow({ commit }, { id, ...flowData }) {
    commit(MutationTypes.SET_UI_FLAG, { flag: 'isUpdating', value: true });
    try {
      const { data } = await FlowsAPI.updateFlow(id, flowData);
      commit(MutationTypes.SET_FLOW, data);
      return data;
    } finally {
      commit(MutationTypes.SET_UI_FLAG, { flag: 'isUpdating', value: false });
    }
  },

  async deleteFlow({ commit }, id) {
    commit(MutationTypes.SET_UI_FLAG, { flag: 'isDeleting', value: true });
    try {
      await FlowsAPI.deleteFlow(id);
      commit(MutationTypes.REMOVE_FLOW, id);
    } finally {
      commit(MutationTypes.SET_UI_FLAG, { flag: 'isDeleting', value: false });
    }
  },

  async publishFlow({ commit }, id) {
    const { data } = await FlowsAPI.publishFlow(id);
    commit(MutationTypes.SET_FLOW, data);
    return data;
  },

  async unpublishFlow({ commit }, id) {
    const { data } = await FlowsAPI.unpublishFlow(id);
    commit(MutationTypes.SET_FLOW, data);
    return data;
  },
};

export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions,
};
