<script setup>
/* eslint-disable */
import { ref, onMounted, computed } from 'vue';
import { useStore } from 'vuex';

const store = useStore();
const loading = ref(false);
const statusFilter = ref('');
const kindFilter = ref('');

const sessions = computed(() => store.getters['atende/sessions/allSessions']);
const meta = computed(() => store.getters['atende/sessions/meta']);

const statusClass = s => ({
  active: 'bg-blue-100 text-blue-700',
  completed: 'bg-green-100 text-green-700',
  failed: 'bg-red-100 text-red-700',
  expired: 'bg-slate-100 text-slate-500',
}[s] || 'bg-slate-100 text-slate-500');

async function fetchSessions(page = 1) {
  loading.value = true;
  try {
    await store.dispatch('atende/sessions/fetchSessions', {
      page,
      status: statusFilter.value,
      kind: kindFilter.value,
    });
  } finally {
    loading.value = false;
  }
}

function formatDate(ts) {
  if (!ts) return '—';
  return new Date(ts).toLocaleString('pt-BR', { dateStyle: 'short', timeStyle: 'short' });
}

onMounted(() => fetchSessions());
</script>

<template>
  <!-- eslint-disable -->
  <div class="p-6">
    <div class="flex items-center justify-between mb-6">
      <h1 class="text-xl font-semibold text-slate-800">Sessões</h1>
      <div class="flex gap-2">
        <select v-model="statusFilter" @change="fetchSessions()" class="text-sm border border-slate-200 rounded px-2 py-1">
          <option value="">Todos os status</option>
          <option value="active">Ativo</option>
          <option value="completed">Concluído</option>
          <option value="failed">Falhou</option>
          <option value="expired">Expirado</option>
        </select>
        <select v-model="kindFilter" @change="fetchSessions()" class="text-sm border border-slate-200 rounded px-2 py-1">
          <option value="">Todos os tipos</option>
          <option value="flow">Fluxo</option>
          <option value="agent">Agente</option>
        </select>
      </div>
    </div>

    <div v-if="loading" class="text-center py-10 text-slate-400 text-sm">Carregando...</div>

    <div v-else class="bg-white rounded-lg border border-slate-200 divide-y divide-slate-100">
      <div v-if="sessions.length === 0" class="px-4 py-8 text-center text-slate-400 text-sm">
        Nenhuma sessão encontrada.
      </div>
      <div v-for="session in sessions" :key="session.id"
           class="px-4 py-3 flex items-center justify-between hover:bg-slate-50">
        <div class="flex items-center gap-3">
          <span :class="['px-2 py-0.5 rounded text-xs font-medium',
                         session.kind === 'flow' ? 'bg-purple-100 text-purple-700' : 'bg-orange-100 text-orange-700']">
            {{ session.kind }}
          </span>
          <div>
            <p class="text-sm font-medium text-slate-800">#{{ session.conversation_id }}</p>
            <p class="text-xs text-slate-400">nó atual: {{ session.current_node_id || '—' }}</p>
          </div>
        </div>
        <div class="flex items-center gap-3">
          <span :class="['px-2 py-0.5 rounded text-xs font-medium', statusClass(session.status)]">
            {{ session.status }}
          </span>
          <span class="text-xs text-slate-400">{{ formatDate(session.created_at) }}</span>
        </div>
      </div>
    </div>

    <div v-if="meta && meta.count > 0" class="mt-4 flex items-center justify-between text-xs text-slate-500">
      <span>{{ meta.count }} sessões encontradas</span>
    </div>
  </div>
</template>
