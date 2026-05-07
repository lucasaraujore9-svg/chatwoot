<script setup>
/* eslint-disable */
import { ref, computed, onMounted, watch } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useStore } from 'vuex';
import {
  VueFlow,
  useVueFlow,
  Position,
  MarkerType,
} from '@vue-flow/core';
import '@vue-flow/core/dist/style.css';

const props = defineProps({
  flowId: { type: [String, Number], required: true },
});

const route = useRoute();
const router = useRouter();
const store = useStore();
const flowId = computed(() => props.flowId || route.params.flowId);

const { onConnect, addEdges, setNodes, setEdges, getNodes, getEdges, toObject } = useVueFlow();

const saving = ref(false);
const selectedNode = ref(null);
const flow = computed(() => store.getters['atende/flows/getFlow'](flowId.value));

const NODE_TYPES = [
  { type: 'message', label: 'Mensagem', color: '#3B82F6' },
  { type: 'question', label: 'Pergunta', color: '#8B5CF6' },
  { type: 'condition', label: 'Condição', color: '#F59E0B' },
  { type: 'menu', label: 'Menu', color: '#06B6D4' },
  { type: 'switch', label: 'Switch', color: '#EC4899' },
  { type: 'add_label', label: 'Adicionar Label', color: '#10B981' },
  { type: 'transfer_to_human', label: 'Transferir Humano', color: '#F97316' },
  { type: 'transfer_to_team', label: 'Transferir Time', color: '#84CC16' },
  { type: 'set_variable', label: 'Definir Variável', color: '#6366F1' },
  { type: 'update_contact_attr', label: 'Atualizar Contato', color: '#0EA5E9' },
  { type: 'update_conversation_attr', label: 'Atualizar Conversa', color: '#14B8A6' },
  { type: 'webhook', label: 'Webhook', color: '#A855F7' },
  { type: 'end', label: 'Fim', color: '#EF4444' },
];

const NODE_COLORS = Object.fromEntries(NODE_TYPES.map(n => [n.type, n.color]));
NODE_COLORS.start = '#10B981';

const nodes = ref([]);
const edges = ref([]);

onMounted(async () => {
  await store.dispatch('atende/flows/getFlow', flowId.value);
  loadFromFlow();
});

watch(() => flow.value, loadFromFlow);

function loadFromFlow() {
  const f = flow.value;
  if (!f) return;
  const graph = f.graph || {};
  nodes.value = (graph.nodes || []).map(n => ({
    id: n.id,
    type: 'default',
    label: nodeLabel(n),
    position: { x: n.x || 0, y: n.y || 0 },
    data: { ...n },
    style: {
      border: `2px solid ${NODE_COLORS[n.type] || '#94A3B8'}`,
      borderRadius: '8px',
      padding: '8px 14px',
      background: '#fff',
      fontSize: '12px',
      fontWeight: '500',
      cursor: 'pointer',
    },
    sourcePosition: Position.Right,
    targetPosition: Position.Left,
  }));
  edges.value = (graph.edges || []).map(e => ({
    id: e.id || `e-${e.source}-${e.target}`,
    source: e.source,
    target: e.target,
    sourceHandle: e.source_handle,
    label: e.label,
    markerEnd: { type: MarkerType.ArrowClosed },
    style: { stroke: '#94A3B8' },
  }));
}

function nodeLabel(n) {
  const base = NODE_TYPES.find(t => t.type === n.type)?.label || n.type;
  return n.config?.text ? `${base}: ${n.config.text.slice(0, 20)}…` : base;
}

onConnect(params => {
  addEdges([{
    ...params,
    markerEnd: { type: MarkerType.ArrowClosed },
    style: { stroke: '#94A3B8' },
  }]);
});

function onNodeClick({ node }) {
  selectedNode.value = node.data;
}

function addNode(type) {
  const id = `node-${Date.now()}`;
  const newNode = {
    id,
    type: 'default',
    label: NODE_TYPES.find(n => n.type === type)?.label || type,
    position: { x: 200 + Math.random() * 200, y: 150 + Math.random() * 150 },
    data: { id, type, config: {} },
    style: {
      border: `2px solid ${NODE_COLORS[type] || '#94A3B8'}`,
      borderRadius: '8px',
      padding: '8px 14px',
      background: '#fff',
      fontSize: '12px',
      fontWeight: '500',
    },
    sourcePosition: Position.Right,
    targetPosition: Position.Left,
  };
  nodes.value = [...nodes.value, newNode];
}

async function save() {
  saving.value = true;
  try {
    const { nodes: ns, edges: es } = toObject();
    const graph = {
      nodes: ns.map(n => ({
        ...n.data,
        x: Math.round(n.position.x),
        y: Math.round(n.position.y),
      })),
      edges: es.map(e => ({
        id: e.id,
        source: e.source,
        target: e.target,
        source_handle: e.sourceHandle,
        label: e.label,
      })),
    };
    await store.dispatch('atende/flows/updateFlow', {
      id: flowId.value,
      graph,
    });
  } finally {
    saving.value = false;
  }
}

function updateNodeConfig(key, value) {
  if (!selectedNode.value) return;
  selectedNode.value.config = { ...selectedNode.value.config, [key]: value };
  nodes.value = nodes.value.map(n =>
    n.id === selectedNode.value.id
      ? { ...n, data: selectedNode.value, label: nodeLabel(selectedNode.value) }
      : n
  );
}
</script>

<template>
  <!-- eslint-disable -->
  <div class="flex h-screen overflow-hidden">
    <!-- Node palette -->
    <aside class="w-52 border-r border-slate-200 bg-white flex flex-col overflow-y-auto flex-shrink-0">
      <div class="p-3 border-b border-slate-100">
        <p class="text-xs font-semibold text-slate-500 uppercase tracking-wide">Nós</p>
      </div>
      <div class="p-2 flex flex-col gap-1">
        <div
          v-for="nt in NODE_TYPES"
          :key="nt.type"
          class="px-3 py-2 rounded border border-slate-200 text-xs text-slate-700 cursor-pointer hover:border-blue-400 hover:bg-blue-50 select-none"
          :style="{ borderLeftColor: nt.color, borderLeftWidth: '3px' }"
          @click="addNode(nt.type)"
        >
          {{ nt.label }}
        </div>
      </div>
    </aside>

    <!-- Vue Flow canvas -->
    <div class="flex-1 relative">
      <VueFlow
        v-model:nodes="nodes"
        v-model:edges="edges"
        fit-view-on-init
        class="bg-slate-50"
        @node-click="onNodeClick"
      >
        <template #node-default="{ data, label }">
          <div
            class="px-3 py-2 rounded-lg bg-white shadow-sm text-xs font-medium"
            :style="{ borderColor: NODE_COLORS[data.type] || '#94A3B8', border: '2px solid' }"
          >
            {{ label }}
          </div>
        </template>
      </VueFlow>

      <!-- Save button overlay -->
      <div class="absolute top-3 right-3 flex gap-2 z-10">
        <button
          class="px-4 py-1.5 text-xs font-medium bg-white border border-slate-200 rounded-lg shadow-sm hover:bg-slate-50 text-slate-600"
          @click="$router.back()"
        >
          Voltar
        </button>
        <button
          class="px-4 py-1.5 text-xs font-medium bg-blue-600 text-white rounded-lg shadow-sm hover:bg-blue-700 disabled:opacity-50"
          :disabled="saving"
          @click="save"
        >
          {{ saving ? 'Salvando…' : 'Salvar' }}
        </button>
      </div>
    </div>

    <!-- Properties panel -->
    <aside class="w-64 border-l border-slate-200 bg-white flex flex-col flex-shrink-0 overflow-y-auto">
      <div class="p-3 border-b border-slate-100">
        <p class="text-xs font-semibold text-slate-500 uppercase tracking-wide">Propriedades</p>
      </div>
      <div class="p-3">
        <template v-if="selectedNode">
          <div class="space-y-3">
            <div>
              <p class="text-xs text-slate-400">Tipo</p>
              <p class="text-sm font-medium text-slate-800 capitalize">
                {{ selectedNode.type?.replace(/_/g, ' ') }}
              </p>
            </div>
            <div v-if="['message', 'question', 'menu'].includes(selectedNode.type)">
              <label class="text-xs text-slate-500 block mb-1">Texto</label>
              <textarea
                class="w-full border border-slate-200 rounded text-xs p-2 resize-none focus:outline-none focus:border-blue-400"
                rows="4"
                :value="selectedNode.config?.text || ''"
                @input="updateNodeConfig('text', $event.target.value)"
              />
            </div>
            <div v-if="selectedNode.type === 'set_variable'">
              <label class="text-xs text-slate-500 block mb-1">Nome da variável</label>
              <input
                class="w-full border border-slate-200 rounded text-xs p-2 focus:outline-none focus:border-blue-400"
                :value="selectedNode.config?.variable_name || ''"
                @input="updateNodeConfig('variable_name', $event.target.value)"
              />
              <label class="text-xs text-slate-500 block mb-1 mt-2">Valor</label>
              <input
                class="w-full border border-slate-200 rounded text-xs p-2 focus:outline-none focus:border-blue-400"
                :value="selectedNode.config?.value || ''"
                @input="updateNodeConfig('value', $event.target.value)"
              />
            </div>
            <div v-if="selectedNode.type === 'add_label'">
              <label class="text-xs text-slate-500 block mb-1">Label</label>
              <input
                class="w-full border border-slate-200 rounded text-xs p-2 focus:outline-none focus:border-blue-400"
                :value="selectedNode.config?.label || ''"
                @input="updateNodeConfig('label', $event.target.value)"
              />
            </div>
            <div v-if="selectedNode.type === 'webhook'">
              <label class="text-xs text-slate-500 block mb-1">URL</label>
              <input
                class="w-full border border-slate-200 rounded text-xs p-2 focus:outline-none focus:border-blue-400"
                :value="selectedNode.config?.url || ''"
                @input="updateNodeConfig('url', $event.target.value)"
              />
              <label class="text-xs text-slate-500 block mb-1 mt-2">Método</label>
              <select
                class="w-full border border-slate-200 rounded text-xs p-2 focus:outline-none focus:border-blue-400"
                :value="selectedNode.config?.method || 'POST'"
                @change="updateNodeConfig('method', $event.target.value)"
              >
                <option>POST</option>
                <option>GET</option>
                <option>PUT</option>
                <option>PATCH</option>
              </select>
            </div>
            <div>
              <p class="text-xs text-slate-400 font-mono">ID: {{ selectedNode.id }}</p>
            </div>
          </div>
        </template>
        <p v-else class="text-xs text-slate-400">Clique em um nó para editar suas propriedades.</p>
      </div>
    </aside>
  </div>
</template>
