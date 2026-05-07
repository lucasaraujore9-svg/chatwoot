<script setup>
/* eslint-disable */
import { ref } from 'vue';

const variables = ref([
  { id: 1, key: 'empresa_nome', value: 'Acme Corp', varType: 'string', isSecret: false },
  { id: 2, key: 'api_token', value: '***', varType: 'string', isSecret: true },
  { id: 3, key: 'limite_diario', value: '100', varType: 'number', isSecret: false },
]);

const showModal = ref(false);
</script>

<template>
  <!-- eslint-disable -->
  <div class="p-6">
    <div class="flex items-center justify-between mb-6">
      <h1 class="text-xl font-semibold text-slate-800">Variáveis da Conta</h1>
      <button @click="showModal = true"
              class="px-4 py-2 rounded-lg text-sm font-medium text-white"
              style="background: var(--accent)">
        + Nova Variável
      </button>
    </div>

    <div class="bg-white rounded-lg border border-slate-200">
      <table class="w-full text-sm">
        <thead class="bg-slate-50 border-b border-slate-200">
          <tr>
            <th class="text-left px-4 py-2 text-xs font-medium text-slate-500">Chave</th>
            <th class="text-left px-4 py-2 text-xs font-medium text-slate-500">Valor</th>
            <th class="text-left px-4 py-2 text-xs font-medium text-slate-500">Tipo</th>
            <th class="px-4 py-2" />
          </tr>
        </thead>
        <tbody class="divide-y divide-slate-100">
          <tr v-for="v in variables" :key="v.id" class="hover:bg-slate-50">
            <td class="px-4 py-2 font-mono text-slate-700">{{ '{{' }} {{ v.key }} {{ '}}' }}</td>
            <td class="px-4 py-2 text-slate-600">
              <span v-if="v.isSecret" class="text-slate-400 italic">&#9679; Secreto</span>
              <span v-else>{{ v.value }}</span>
            </td>
            <td class="px-4 py-2">
              <span class="px-2 py-0.5 rounded text-xs bg-blue-50 text-blue-700">{{ v.varType }}</span>
            </td>
            <td class="px-4 py-2 text-right">
              <button class="text-xs text-slate-400 hover:text-red-500">Excluir</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <div v-if="showModal" class="fixed inset-0 bg-black/40 flex items-center justify-center z-50">
      <div class="bg-white rounded-xl p-6 w-96 shadow-xl">
        <h3 class="text-base font-semibold text-slate-800 mb-4">Nova Variável</h3>
        <div class="space-y-3">
          <input type="text" placeholder="chave_em_snake_case"
                 class="w-full px-3 py-2 border rounded-lg text-sm" />
          <input type="text" placeholder="Valor"
                 class="w-full px-3 py-2 border rounded-lg text-sm" />
        </div>
        <div class="flex gap-3 mt-4">
          <button @click="showModal = false"
                  class="px-4 py-2 text-sm text-white rounded-lg"
                  style="background: var(--accent)">
            Salvar
          </button>
          <button @click="showModal = false"
                  class="px-4 py-2 text-sm border rounded-lg text-slate-600">
            Cancelar
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
