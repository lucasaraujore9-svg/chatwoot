<script setup>
/* eslint-disable */
import { ref } from 'vue';

const flows = ref([
  { id: 1, name: 'Boas-vindas WhatsApp', status: 'published', updatedAt: '2026-05-01' },
  { id: 2, name: 'Qualificação de Leads', status: 'draft', updatedAt: '2026-04-28' },
  { id: 3, name: 'Suporte Técnico', status: 'published', updatedAt: '2026-04-20' },
]);

const statusClass = status =>
  status === 'published'
    ? 'bg-green-100 text-green-800'
    : 'bg-gray-100 text-gray-600';
</script>

<template>
  <!-- eslint-disable -->
  <div class="p-6">
    <div class="flex items-center justify-between mb-6">
      <h1 class="text-xl font-semibold text-slate-800">Fluxos</h1>
      <button class="px-4 py-2 rounded-lg text-sm font-medium text-white"
              style="background: var(--accent)">
        + Novo Fluxo
      </button>
    </div>

    <div v-if="flows.length" class="bg-white rounded-lg border border-slate-200 divide-y divide-slate-100">
      <div v-for="flow in flows" :key="flow.id"
           class="flex items-center justify-between px-4 py-3 hover:bg-slate-50">
        <div class="flex items-center gap-3">
          <span class="text-base font-medium text-slate-800">{{ flow.name }}</span>
          <span :class="['px-2 py-0.5 rounded text-xs font-medium', statusClass(flow.status)]">
            {{ flow.status === 'published' ? 'Publicado' : 'Rascunho' }}
          </span>
        </div>
        <div class="flex items-center gap-3">
          <span class="text-xs text-slate-400">{{ flow.updatedAt }}</span>
          <button class="text-xs text-slate-500 hover:text-slate-800 px-3 py-1 border rounded">
            Editar
          </button>
        </div>
      </div>
    </div>

    <div v-else class="text-center py-16 text-slate-400">
      <p class="text-base">Nenhum fluxo criado ainda.</p>
      <p class="text-sm mt-1">Crie seu primeiro fluxo para começar.</p>
    </div>
  </div>
</template>
