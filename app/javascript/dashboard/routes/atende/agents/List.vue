<script setup>
/* eslint-disable */
import { ref } from 'vue';

const agents = ref([
  { id: 1, name: 'Assistente Geral', provider: 'openai', model: 'gpt-4o', isActive: true },
  { id: 2, name: 'Qualificador de Leads', provider: 'anthropic', model: 'claude-sonnet-4-6', isActive: true },
  { id: 3, name: 'Suporte Técnico', provider: 'google', model: 'gemini-2.0-flash', isActive: false },
]);

const providerColor = p => ({
  openai: 'bg-green-100 text-green-700',
  anthropic: 'bg-orange-100 text-orange-700',
  google: 'bg-blue-100 text-blue-700',
  ollama: 'bg-purple-100 text-purple-700',
}[p] ?? 'bg-gray-100 text-gray-600');
</script>

<template>
  <!-- eslint-disable -->
  <div class="p-6">
    <div class="flex items-center justify-between mb-6">
      <h1 class="text-xl font-semibold text-slate-800">Agentes IA</h1>
      <button class="px-4 py-2 rounded-lg text-sm font-medium text-white"
              style="background: var(--accent)">
        + Novo Agente
      </button>
    </div>

    <div class="grid gap-4">
      <div v-for="agent in agents" :key="agent.id"
           class="bg-white rounded-lg border border-slate-200 p-4 flex items-center justify-between">
        <div class="flex items-center gap-3">
          <div class="w-10 h-10 rounded-full flex items-center justify-center text-white text-sm font-bold"
               style="background: var(--accent)">
            {{ agent.name[0] }}
          </div>
          <div>
            <p class="text-sm font-semibold text-slate-800">{{ agent.name }}</p>
            <div class="flex items-center gap-2 mt-0.5">
              <span :class="['px-2 py-0.5 rounded text-xs font-medium', providerColor(agent.provider)]">
                {{ agent.provider }}
              </span>
              <span class="text-xs text-slate-400">{{ agent.model }}</span>
            </div>
          </div>
        </div>
        <div class="flex items-center gap-2">
          <span :class="['text-xs px-2 py-0.5 rounded', agent.isActive ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-500']">
            {{ agent.isActive ? 'Ativo' : 'Inativo' }}
          </span>
          <button class="text-xs text-slate-500 hover:text-slate-800 px-3 py-1 border rounded">Editar</button>
        </div>
      </div>
    </div>

    <div v-if="!agents.length" class="text-center py-16 text-slate-400">
      <p>Nenhum agente criado.</p>
    </div>
  </div>
</template>
