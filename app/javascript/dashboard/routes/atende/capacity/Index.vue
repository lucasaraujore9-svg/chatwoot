<script setup>
/* eslint-disable */
import { ref } from 'vue';
const policies = ref([
  { id: 1, name: 'Padrão Geral', limit: 10 },
  { id: 2, name: 'Time Premium', limit: 5 },
]);
const showForm = ref(false);
const form = ref({ name: '', limit: 10 });
</script>
<template>
  <!-- eslint-disable -->
  <div class="p-6">
    <div class="flex items-center justify-between mb-6">
      <h1 class="text-xl font-semibold text-slate-800">Capacidade de Atendentes</h1>
      <button @click="showForm = !showForm" class="px-4 py-2 rounded-lg text-sm font-medium text-white" style="background: var(--accent)">
        + Nova Política
      </button>
    </div>
    <div v-if="showForm" class="bg-white rounded-lg border border-slate-200 p-4 mb-4 space-y-3">
      <input v-model="form.name" type="text" placeholder="Nome da política"
             class="w-full px-3 py-2 border rounded-lg text-sm" />
      <div class="flex items-center gap-3">
        <label class="text-sm text-slate-600">Limite de conversas simultâneas:</label>
        <input v-model="form.limit" type="range" min="1" max="50" class="flex-1" />
        <span class="text-sm font-medium text-slate-800 w-8 text-right">{{ form.limit }}</span>
      </div>
      <button class="px-4 py-2 text-sm text-white rounded-lg" style="background: var(--accent)">Salvar</button>
    </div>
    <div class="space-y-3">
      <div v-for="p in policies" :key="p.id" class="bg-white rounded-lg border border-slate-200 p-4 flex items-center justify-between">
        <div>
          <p class="text-sm font-medium text-slate-800">{{ p.name }}</p>
          <p class="text-xs text-slate-400 mt-0.5">Limite: {{ p.limit }} conversas</p>
        </div>
        <div class="w-32 bg-slate-100 rounded-full h-2">
          <div class="h-2 rounded-full" style="background: var(--accent); width: 40%"></div>
        </div>
      </div>
    </div>
  </div>
</template>
