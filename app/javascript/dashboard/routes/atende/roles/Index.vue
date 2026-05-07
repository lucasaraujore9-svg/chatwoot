<script setup>
/* eslint-disable */
import { ref } from 'vue';
const roles = ref([
  { id: 'admin', name: 'Administrador', isDefault: true, permissions: ['all'] },
  { id: 'agent', name: 'Agente', isDefault: true, permissions: ['conversations.view', 'conversations.reply'] },
  { id: 'supervisor', name: 'Supervisor', isDefault: false, permissions: ['conversations.view', 'reports.view'] },
]);
const resources = ['conversations', 'contacts', 'reports', 'inboxes', 'agents', 'labels', 'custom_roles', 'audit_logs'];
const actions = ['view', 'create', 'update', 'destroy'];
const selectedRole = ref(null);
</script>
<template>
  <!-- eslint-disable -->
  <div class="p-6 flex gap-6">
    <div class="w-56 flex-shrink-0">
      <div class="flex items-center justify-between mb-3">
        <h2 class="text-sm font-semibold text-slate-700">Roles</h2>
        <button class="text-xs px-2 py-1 rounded text-white" style="background: var(--accent)">+ Nova</button>
      </div>
      <div class="space-y-1">
        <button v-for="role in roles" :key="role.id"
                @click="selectedRole = role"
                :class="['w-full text-left px-3 py-2 rounded-lg text-sm', selectedRole?.id === role.id ? 'text-white font-medium' : 'text-slate-700 hover:bg-slate-100']"
                :style="selectedRole?.id === role.id ? 'background: var(--accent)' : ''">
          {{ role.name }}
          <span v-if="role.isDefault" class="ml-1 text-xs opacity-60">(padrão)</span>
        </button>
      </div>
    </div>
    <div class="flex-1 bg-white rounded-lg border border-slate-200 p-4">
      <div v-if="selectedRole">
        <h3 class="text-base font-semibold text-slate-800 mb-4">{{ selectedRole.name }}</h3>
        <div v-if="selectedRole.isDefault" class="text-sm text-slate-400 italic">Role padrão — não editável.</div>
        <table v-else class="w-full text-xs">
          <thead>
            <tr>
              <th class="text-left py-1 text-slate-500">Recurso</th>
              <th v-for="a in actions" :key="a" class="py-1 text-slate-500 text-center">{{ a }}</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-slate-50">
            <tr v-for="r in resources" :key="r">
              <td class="py-1 text-slate-700">{{ r }}</td>
              <td v-for="a in actions" :key="a" class="text-center py-1">
                <input type="checkbox" class="rounded" />
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div v-else class="text-sm text-slate-400 text-center py-8">Selecione uma role para editar.</div>
    </div>
  </div>
</template>
