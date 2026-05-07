<script setup>
/* eslint-disable */
import { ref } from 'vue';
const policies = ref([
  { id: 1, name: 'SLA Padrão', firstResponse: 60, resolution: 480, businessHours: true },
  { id: 2, name: 'SLA Premium', firstResponse: 15, resolution: 120, businessHours: false },
  { id: 3, name: 'SLA Crítico', firstResponse: 5, resolution: 60, businessHours: false },
]);
const formatMin = m => m >= 60 ? `${Math.floor(m/60)}h${m%60 > 0 ? m%60+'min' : ''}` : `${m}min`;
</script>
<template>
  <!-- eslint-disable -->
  <div class="p-6">
    <div class="flex items-center justify-between mb-6">
      <h1 class="text-xl font-semibold text-slate-800">Políticas de SLA</h1>
      <button class="px-4 py-2 rounded-lg text-sm font-medium text-white" style="background: var(--accent)">+ Nova Política</button>
    </div>
    <div class="space-y-3">
      <div v-for="p in policies" :key="p.id" class="bg-white rounded-lg border border-slate-200 p-4">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-sm font-semibold text-slate-800">{{ p.name }}</p>
            <div class="flex gap-4 mt-1 text-xs text-slate-500">
              <span>1ª resp: <strong>{{ formatMin(p.firstResponse) }}</strong></span>
              <span>Resolução: <strong>{{ formatMin(p.resolution) }}</strong></span>
              <span v-if="p.businessHours" class="px-1.5 py-0.5 rounded bg-blue-50 text-blue-600">horário comercial</span>
            </div>
          </div>
          <div class="flex gap-2">
            <span class="px-2 py-1 rounded text-xs bg-green-100 text-green-700">Ativo</span>
            <button class="text-xs px-3 py-1 border rounded text-slate-600">Editar</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
