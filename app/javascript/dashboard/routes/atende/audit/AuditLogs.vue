<script setup>
/* eslint-disable */
import { ref } from 'vue';
const logs = ref([
  { id: 1, action: 'create', resource: 'Inbox', user: 'admin@acme.com', ip: '192.168.1.1', at: '2026-05-01 14:32' },
  { id: 2, action: 'update', resource: 'Agent', user: 'lucas@acme.com', ip: '192.168.1.2', at: '2026-05-01 13:15' },
  { id: 3, action: 'destroy', resource: 'Label', user: 'admin@acme.com', ip: '192.168.1.1', at: '2026-04-30 17:08' },
  { id: 4, action: 'create', resource: 'Webhook', user: 'dev@acme.com', ip: '10.0.0.5', at: '2026-04-30 11:42' },
]);
const actionClass = a => ({ create: 'bg-green-100 text-green-700', update: 'bg-blue-100 text-blue-700', destroy: 'bg-red-100 text-red-700' }[a] ?? 'bg-gray-100 text-gray-600');
</script>
<template>
  <!-- eslint-disable -->
  <div class="p-6">
    <div class="flex items-center justify-between mb-6">
      <h1 class="text-xl font-semibold text-slate-800">Audit Logs</h1>
      <button class="px-4 py-2 text-sm border rounded-lg text-slate-600 opacity-50 cursor-not-allowed">Exportar CSV</button>
    </div>
    <div class="bg-white rounded-lg border border-slate-200">
      <table class="w-full text-sm">
        <thead class="bg-slate-50 border-b">
          <tr>
            <th class="text-left px-4 py-2 text-xs font-medium text-slate-500">Ação</th>
            <th class="text-left px-4 py-2 text-xs font-medium text-slate-500">Recurso</th>
            <th class="text-left px-4 py-2 text-xs font-medium text-slate-500">Usuário</th>
            <th class="text-left px-4 py-2 text-xs font-medium text-slate-500">IP</th>
            <th class="text-left px-4 py-2 text-xs font-medium text-slate-500">Quando</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-slate-100">
          <tr v-for="log in logs" :key="log.id" class="hover:bg-slate-50">
            <td class="px-4 py-2">
              <span :class="['px-2 py-0.5 rounded text-xs font-medium', actionClass(log.action)]">{{ log.action }}</span>
            </td>
            <td class="px-4 py-2 text-slate-700">{{ log.resource }}</td>
            <td class="px-4 py-2 text-slate-600">{{ log.user }}</td>
            <td class="px-4 py-2 font-mono text-xs text-slate-400">{{ log.ip }}</td>
            <td class="px-4 py-2 text-xs text-slate-400">{{ log.at }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>
